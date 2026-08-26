// Menu.qml
import QtQuick
import Quickshell
import QtQuick.Controls

Rectangle {
	id: root
	radius: 0
	border.color: '#ccc'
	border.width: 0
	color: 'transparent'

	implicitWidth: mainContainer.implicitWidth + 20
	implicitHeight: mainContainer.implicitHeight + 20

	property bool popupVisible: true

	// https://docs.rs/multibg-wayland-niri-ipc/latest/niri_ipc/enum.Action.html

	property var groupConfig: {
		"screenshot": {
			label: 'Screenshot',
			items: [
				{ name: 'ScreenshotWindow', command: 'screenshot-window -d false' }
			]
		}
	}

	// property var groupConfig: (() => {
	// 	return {
	// 		screenshot: {
	// 			label: 'Screenshot',
	// 			items: [
	// 				// { name: 'Screenshot', command: 'screenshot' },// Screenshot {show_pointer: bool,},
	// 				// { name: 'ScreenshotScreen', command: 'screenshot-screen -d false' },// ScreenshotScreen {write_to_disk: bool,show_pointer: bool,},
	// 				{ name: 'ScreenshotWindow', command: 'screenshot-window -d false' },// ScreenshotWindow {id: Option<u64>,write_to_disk: bool,},
	// 			]
	// 		},
	// 	}
	// })()

	property var actionsGroups: [
		// 'column',
		// 'columnFocus',
		// 'columnMove',
		// 'window',
		// 'windowFocus',
		// 'windowMove',
		// 'workspaceFocus',
		// 'workspaceMove',
		'screenshot',
	]

	Row {
		id: mainContainer
		// anchors.top: parent.top
		// anchors.left: parent.left
		// anchors.margins: 10
		spacing: 2
		Rectangle {
			implicitWidth: 30
    	implicitHeight: 30
			// color: '#ff222222'
			Text {
				anchors.fill: parent
				text: '☰'
				width: 30
    		height: 30
			}
			MouseArea {
				anchors.fill: parent
				hoverEnabled: true
				onClicked: () => {
					root.popupVisible = !root.popupVisible
					console.log('root.popupVisible:', root.popupVisible);
				}
			}
		}

		Repeater {
			model: root.actionsGroups

			Rectangle {
				id: groupWrapper
				readonly property var groupName: modelData
				readonly property var currentGroup: root.groupConfig[modelData]
				readonly property var label: root.groupConfig[modelData].label
				implicitWidth: groupContainer.implicitWidth + 5
				implicitHeight: groupContainer.implicitHeight + 5
				color: '#ffcccccc'
				radius: 2
				// anchors.margins: 10

				Column {
					id: groupContainer
					anchors.centerIn: parent
					
					spacing: 1

					Text {
						text: label
						font.bold: true
						font.pixelSize: 14
					}

					Repeater {
						model: currentGroup.items

						Row {

							Rectangle {
								id: item
								implicitWidth: textItem.implicitWidth + 10
								implicitHeight: textItem.implicitHeight + 5
								radius: 2
								color: itemMouseArea.containsMouse ? '#0000ff' : '#0088ff'
								Behavior on color { ColorAnimation { duration: 300 } }

								Text {
									id: textItem
									anchors.centerIn: parent
									text: modelData.name
									color: 'white'
									font.pixelSize: 12
								}

								MouseArea {
									id: itemMouseArea
									anchors.fill: parent
									hoverEnabled: true
									cursorShape: Qt.PointingHandCursor
									onClicked: (mouse) => {
										mouse.accepted = false
										Quickshell.execDetached(['niri', 'msg', 'action', ...modelData.command.split(' ')])
									}
								}
							}

							Rectangle {
								implicitWidth: myComboBox.implicitWidth + 10
								implicitHeight: myComboBox.implicitHeight + 5
								// Text {
								// 	id: tmp
								// 	anchors.centerIn: parent
								// 	text: modelData.name
								// 	color: '#000'
								// 	font.pixelSize: 12
								// }
								ComboBox {
									id: myComboBox
									textRole: 'title'
									valueRole: 'id'
									implicitWidth: 250
									implicitHeight: 45 
									model: Object.values(Niri.winById)
									currentIndex: Niri.winFocusedId

									delegate: MenuItem {
										width: myComboBox.width
										height: 40
										contentItem: Text {
											text: modelData.title
											font.pixelSize: 14
											verticalAlignment: Text.AlignVCenter
											elide: Text.ElideRight
										}
									}
									
									onCurrentIndexChanged: {
											console.log('Selected item:', displayText)
									}
								}
							}

						}

					}
				}
			}
		}
	}

	PopupWindow {
		visible: root.popupVisible
		anchor.window: root
		anchor.rect.x: root.width
		anchor.rect.y: root.height
		implicitWidth: 500
		implicitHeight: 500
		color: '#ffffcccc'

		Text {
			text: 'asdf'
		}
	}

}
