// Windows.qml
import QtQuick
import Quickshell

Row {
	id: root
	required property var screenData
	spacing: 0
	height: parent.height

	Repeater {
		id: workspaces
		model: Niri.workspacesIdxByOutput[screenData?.name]

		delegate: Rectangle {
			id: workspaceRect
			readonly property var workspaceId: modelData
			readonly property bool isFocused: Niri.focusedWorkspaceId === workspaceId
			readonly property bool isActive: Niri.activeWorkspacesIds.includes(workspaceId)
			readonly property bool isEmpty: Niri.workspacesById[workspaceId].active_window_id === null
			anchors.verticalCenter: parent.verticalCenter
			radius: isEmpty ? 9 : 20;
			width: (windowsRow ? windowsRow.implicitWidth : 0) + (isEmpty ? (parent.height * 0.6) : 6)
			height: (isEmpty ? parent.height * 0.6 : parent.height)
			color: 'transparent';
			border.width: 2;
			// border.color: '#8800ff00';
			border.color: isFocused ? '#ffffff00' : '#8800ff00';
			Behavior on color { ColorAnimation { duration: 150 } }

			// Rectangle {
			// 	id: workspaceLine
			// 	anchors.horizontalCenter: parent.horizontalCenter
			// 	anchors.top: parent.top
			// 	// anchors.left: parent.left
			// 	// anchors.right: parent.right
			// 	// anchors.topMargin: 2
			// 	width: parent.width * 0.8
			// 	height: 2;
			// 	radius: 0
			// 	color: 'transparent';
			// 	// color: isFocused ? '#fff59b' : 'transparent';
			// 		// : isActive ? '#a9aefe'
			// 		// : !isEmpty ? '#a9aefe'
			// 		// : 'transparent';
			// }

			Row {
				id: windowsRow
				anchors.centerIn: parent
				spacing: 0
				z: 1

				Repeater {
					id: windows
					// model: Niri.windowsPosByWs[workspaceId];
					model: Niri.windows
						.filter((win) => win.workspace_id === workspaceRect.workspaceId)
						.sort((a, b) => {
							if (a.layout.pos_in_scrolling_layout[0] - b.layout.pos_in_scrolling_layout[0] !== 0) {
								return a.layout.pos_in_scrolling_layout[0] - b.layout.pos_in_scrolling_layout[0]
							}
							return a.layout.pos_in_scrolling_layout[1] - b.layout.pos_in_scrolling_layout[1]
						})

					delegate: Rectangle {
						id: windowRect
						readonly property bool isFocused: Niri.focusedWindowId === modelData.id
						width: workspaceRect.height
						height: workspaceRect.height
						color: 'transparent'
						border.width: 0;

						Image {
							id: windowIcon
							anchors.centerIn: parent
							height: workspaceRect.height - 2
							width: height
							fillMode: Image.PreserveAspectFit
							smooth: true
							mipmap: true
							sourceSize.height: height
							sourceSize.width: width
							source: Quickshell.iconPath(modelData.app_id)
						}

						Rectangle {
							id: windowRectLine
							anchors.horizontalCenter: parent.horizontalCenter
							anchors.bottom: parent.bottom
							height: 5
							color: windowRect.isFocused ? '#ff0' : 'transparent'
							width: parent.width * 0.3
							Behavior on color { ColorAnimation { duration: 150 } }
						}

						MouseArea {
							anchors.fill: parent
							cursorShape: Qt.PointingHandCursor
							// propagateComposedEvents: true
							onClicked: (mouse) => {
								mouse.accepted = false
								Quickshell.execDetached(["niri", "msg", "action", "focus-window", "--id", modelData.id])
							}
						}
					}
				}
			}

			MouseArea {
				anchors.fill: parent
				cursorShape: Qt.PointingHandCursor
				onClicked: {
					Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", modelData.id])
				}
			}
		}
	}
}
