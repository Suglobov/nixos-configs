import QtQuick
import Quickshell

ShellRoot {
	PanelWindow {
		id: panel
		property bool popupVisible: false
		anchors.top: true
		anchors.left: true
		implicitWidth: 30
		implicitHeight: 30
		margins.left: screen ? screen.width * 0.30 : 0
		margins.top: -implicitHeight
		color: '#fcc'

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
					// console.log('onClicked:1');
					panel.popupVisible = !panel.popupVisible
				}
			}
		}

		PanelWindow {
			id: areaToHidePopup
			visible: panel.popupVisible // Показываем только когда открыто меню
			color: 'transparent'
			anchors {
					top: true
					bottom: true
					left: true
					right: true
			}

			MouseArea {
					anchors.fill: parent
					hoverEnabled: true
					onClicked: () => {
						// console.log('onClicked:2');
						panel.popupVisible = false
					}
					// onEntered: panel.popupVisible = false // Закрытие при наведении
			}

			Rectangle {
				id: rec1
				property bool rec3Visible: false
				implicitWidth: 100
				implicitHeight: 100
				x: panel.screen ? panel.screen.width * 0.30 : 0
				// y: panel.implicitHeight 
				y: 0
				color: '#ffcccccc'
				// z: 1

				MouseArea {
					anchors.fill: parent
					propagateComposedEvents: false 
					onClicked: (mouse) => {
						console.log('mouse:', mouse);
						// mouse.accepted = true
					}
				}

				Rectangle {
					x: 10
					y: 10
					implicitWidth: 30
					implicitHeight: 30
					color: '#ffffffff'

					MouseArea {
						anchors.fill: parent
						propagateComposedEvents: false 
						onClicked: (mouse) => {
							rec1.rec3Visible = !rec1.rec3Visible
							// console.log('mouse:', mouse);
							// mouse.accepted = true
						}
					}

					Rectangle {
						visible: rec1.rec3Visible
						x: 0
						y: parent.height
						implicitWidth: 100
						implicitHeight: 100
						color: '#ff00ffff'

					}
				}

				

				

			}
			
		}
	}
}