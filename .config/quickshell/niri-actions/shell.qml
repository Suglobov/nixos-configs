import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
	id: root
	property var activeScreen: null
	property var panelVisible: false
	Variants {
		model: Quickshell.screens
		delegate: Item {
			required property var modelData
			PanelWindow {
				id: panel
				screen: modelData
				anchors.top: true
				anchors.left: true
				implicitWidth: 30
				implicitHeight: 30
				margins.left: screen ? screen.width * 0.30 : 0
				margins.top: -implicitHeight
				color: '#fcc'

				Component.onCompleted: {
					// console.log(Date.now(), JSON.stringify(panel.screen, null, 2))
				}

				Rectangle {
					implicitWidth: 30
					implicitHeight: 30
					color: '#ffff8800'
					Text {
						anchors.fill: parent
						text: '☰'
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
					}

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						onClicked: () => {
							if (activeScreen !== panel.screen) {
								activeScreen = panel.screen
								root.panelVisible = true
							} else {
								root.panelVisible = !root.panelVisible
							}
						}
						// onEntered: () => {
						// 	root.panelVisible = true
						// }
					}
				}

			}
			PanelWindow {
				id: areaToHidePopup
				screen: modelData
				visible: root.panelVisible
				color: 'transparent'
				anchors.top: true
				anchors.bottom: true
				anchors.left: true
				anchors.right: true

				MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						onClicked: () => {
							root.panelVisible = false
						}
						// onEntered: root.panelVisible = false // Закрытие при наведении
				}

				Rectangle {
					visible: activeScreen === panel.screen && root.panelVisible
					width: myGrid.width + 20
					height: myGrid.height + 20
					x: panel.screen ? panel.screen.width * 0.30 : 0
					y: 0
					color: '#ffcccccc'

					Grid {
						id: myGrid
						anchors.centerIn: parent
						columns: 2
						spacing: 0

						Rectangle {
							id: closeWinRect
							width: closeWinText.width + 20
							height: closeWinText.height + 20
							color: closeWinMouseArea.containsMouse ? '#0000ff' : '#0088ff'

							Text {
								id: closeWinText
								text: '❌🪟'
								anchors.centerIn: parent
								horizontalAlignment: Text.AlignHCenter
								verticalAlignment: Text.AlignVCenter
								font.pixelSize: 20
							}

							MouseArea {
								id: closeWinMouseArea
								anchors.fill: parent
								cursorShape: Qt.PointingHandCursor
								hoverEnabled: true
								onClicked: {
									if (!Processes.chooseWinToClose.running) {
										root.panelVisible = false
										Processes.chooseWinToClose.running = true
										Processes.mouseProc.running = true
									}
								}
							}
						}
					}

				}

			}

			PanelWindow {
				id: cross
				visible: Processes.mouseProc.running
				screen: modelData
				anchors.top: true
				anchors.bottom: true
				anchors.left: true
				anchors.right: true
				exclusionMode: ExclusionMode.Ignore
				mask: Region {}
				color: 'transparent'
				property var min: [screen?.x ?? 0, screen?.y ?? 0]
				property var max: [min[0] + screen?.width ?? 0, min[1] + screen?.height ?? 0]
				property var screenMousePos: [Processes.mousePos[0] - min[0], Processes.mousePos[1] - min[1]]
				property int crossWidth: 100
				property int crossHeight: 20
				property var crossColor: '#ffff0000'
				property var crossRadius: 10

				Rectangle {
					width: cross.crossWidth
					height: cross.crossHeight
					x: cross.screenMousePos[0] - cross.crossWidth / 2
					y: cross.screenMousePos[1] - cross.crossHeight / 2
					color: cross.crossColor
					radius: cross.crossRadius
					opacity: 1
					transform: Rotation {
						angle: 45
						origin.x: cross.crossWidth / 2
						origin.y: cross.crossHeight / 2
					}
				}
				Rectangle {
					width: cross.crossWidth
					height: cross.crossHeight
					x: cross.screenMousePos[0] - cross.crossWidth / 2
					y: cross.screenMousePos[1] - cross.crossHeight / 2
					color: cross.crossColor
					radius: cross.crossRadius
					opacity: 1
					transform: Rotation {
						angle: -45
						origin.x: cross.crossWidth / 2
						origin.y: cross.crossHeight / 2
					}
				}
			}

		}
	}
}