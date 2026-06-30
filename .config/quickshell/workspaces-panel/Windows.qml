// Windows.qml
import QtQuick
import Quickshell

Row {
	id: root
	required property var screenData
	property int radius1: 9
	property int radius2: 5
	spacing: 2
	height: parent.height

	Repeater {
		model: Niri.wsByOutput[screenData?.name]

		Rectangle {
			id: workspaceRect
			readonly property var wsId: modelData
			readonly property bool isFocused: Niri.focusedWsId === wsId
			readonly property bool isActive: Niri.activeWsIds.includes(wsId)
			readonly property bool isEmpty: (!Niri.winPosByWs[wsId] || Niri.winPosByWs[wsId].length === 0)
			 && (!Niri.winTileByWs[wsId] || Niri.winTileByWs[wsId].length === 0)
			anchors.verticalCenter: parent.verticalCenter
			radius: isEmpty ? radius1 : radius2;
			width: (windowsContainer?.implicitWidth ?? 0) + (isEmpty ? (parent.height * 0.6) : 6)
			height: (isEmpty ? parent.height * 0.6 : parent.height)
			color: 'transparent';
			border {
				width: 2
				color: isFocused ? '#ffffff00' : isActive ? '#ffff00ff' : '#8800ff00'
				Behavior on color { ColorAnimation { duration: 300 } }
			}

			// Text {
			// 	text: wsId
			// 	color: 'white'
			// }

			// Rectangle {
			// 	anchors.horizontalCenter: parent.horizontalCenter
			// 	anchors.top: parent.top
			// 	width: parent.width * 0.8
			// 	height: 2;
			// 	radius: 0
			// 	// color: 'transparent';
			// 	color: isFocused ? '#ffffff00' : '#8800ff00';
			// }

			Row {
				id: windowsContainer
				anchors.centerIn: parent
				height: parent.height
				spacing: 0
				z: 1

				Rectangle {
					id: floatingContainer
					readonly property var floatingWins: Niri.winTileByWs[wsId]
					visible: floatingWins !== undefined && floatingWins.length > 0
					width: visible ? (floatingRow.implicitWidth + 4) : 0
					height: workspaceRect.height - 6
					anchors.verticalCenter: parent.verticalCenter
					color: 'transparent'
					border.width: 2
					border.color: '#8800ff00'
					radius: radius2
					Row {
						id: floatingRow
        		anchors.centerIn: parent
						spacing: 1
						Repeater {
							model: Niri.winTileByWs[wsId]
							Item {
								readonly property var window: Niri.winById[modelData]
								readonly property bool isFocused: modelData ? Niri.focusedWinId === window.id : ''
								height: floatingContainer.height - 4
    						width: height
								Image {
									anchors.centerIn: parent
									height: parent.height
									width: height
									fillMode: Image.PreserveAspectFit
									smooth: true
									mipmap: true
									sourceSize.height: height
									sourceSize.width: width
									source: Quickshell.iconPath(window.app_id)
								}
								Rectangle {
									anchors.horizontalCenter: parent.horizontalCenter
									anchors.bottom: parent.bottom
									height: 5
									color: isFocused ? '#ff0' : 'transparent'
									width: parent.width * 0.3
									Behavior on color { ColorAnimation { duration: 300 } }
								}
							}
						}
					}
				}

				Repeater {
					model: Niri.winPosByWs[wsId]; // все колонки воркспейса

					Rectangle {
						id: columnRect
						readonly property var workspaceColumn: modelData
						anchors.verticalCenter: parent.verticalCenter
						width: (windowsColumn ? windowsColumn.implicitWidth : 0)
						height: workspaceRect.height - 4
						color: 'transparent'
						// border.width: modelData.length > 1 ? 2 : 0
						border.width: 0
						// border.color: '#0ff'
						// radius: radius2

						Rectangle {
							anchors.horizontalCenter: parent.horizontalCenter
							anchors.top: parent.top
							// anchors.left: parent.left
							// anchors.right: parent.right
							anchors.topMargin: 1
							width: parent.width * 0.8
							height: workspaceColumn.length > 1 ? 2 : 0;
							radius: 0
							// color: 'transparent';
							color: '#8800ff00'
						}

						Row {
							id: windowsColumn
							// property int rowIndex: index
							Repeater {
								// id: innerRepeater
								model: workspaceColumn // колонка с окнами

								Rectangle {
									id: windowRect
									readonly property var window: Niri.winById[modelData]
									readonly property bool isFocused: modelData ? Niri.focusedWinId === window.id : ''
									visible: modelData !== undefined
									width: columnRect.height
									height: columnRect.height
									color: 'transparent'
									
									Image {
										id: windowIcon
										anchors.centerIn: parent
										height: windowRect.height * 0.8
										width: height
										fillMode: Image.PreserveAspectFit
										smooth: true
										mipmap: true
										sourceSize.height: height
										sourceSize.width: width
										source: modelData ? Quickshell.iconPath(window.app_id.toLowerCase()) : ''
									}

									Rectangle {
										id: windowRectLine
										anchors.horizontalCenter: parent.horizontalCenter
										anchors.bottom: parent.bottom
										height: 5
										color: isFocused ? '#ff0' : 'transparent'
										width: parent.width * 0.3
										Behavior on color { ColorAnimation { duration: 300 } }
									}

									MouseArea {
										anchors.fill: parent
										cursorShape: Qt.PointingHandCursor
										// propagateComposedEvents: true
										onClicked: (mouse) => {
											mouse.accepted = false
											Quickshell.execDetached(["niri", "msg", "action", "focus-window", "--id", window.id])
										}
									}
								}
							}
						}
					}
				}
			}

			MouseArea {
				anchors.fill: parent
				cursorShape: Qt.PointingHandCursor
				onClicked: {
					var idx = Niri.wsById[wsId].idx
					Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", idx])
				}
			}
		}
	}
}
