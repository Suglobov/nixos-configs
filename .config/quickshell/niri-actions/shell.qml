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
		}

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked: panel.popupVisible = !panel.popupVisible
		}

		PopupWindow {
			visible: panel.popupVisible
			anchor.window: panel
			anchor.rect.x: panel.width
			anchor.rect.y: panel.height
			implicitWidth: popupContent.implicitWidth + 10
			implicitHeight: popupContent.implicitHeight + 20
			color: '#ffcccccc'

			Item {
				anchors.fill: parent

				Row {
					id: popupContent
					anchors.centerIn: parent

					Menu {
						id: menu
					}
				}
			}
		}

		PanelWindow {
			id: areaToHidePopup
			visible: panel.popupVisible // Показываем только когда открыто меню
			anchors {
					top: true
					bottom: true
					left: true
					right: true
			}
			
			color: 'transparent'
			MouseArea {
					anchors.fill: parent
					hoverEnabled: true
					onClicked: panel.popupVisible = false
					// onEntered: panel.popupVisible = false // Закрытие при наведении
			}
		}
	}
}