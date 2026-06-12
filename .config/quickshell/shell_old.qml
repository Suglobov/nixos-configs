// shell.qml
import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
	Variants {
		model: Quickshell.screens

		delegate: PanelWindow {
			id: panel
			required property var modelData
			readonly property var screenData: modelData

			readonly property int panelHeight: 30

			WlrLayershell.layer: WlrLayer.Bottom
			WlrLayershell.margins {
				top: -panelHeight
			}

			screen: screenData

			anchors.top: true
			anchors.left: true
			anchors.right: true

			implicitHeight: panelHeight
			color: Niri.keyboardLayoutIdx === 0 ? '#00cc00'
			     : Niri.keyboardLayoutIdx === 1 ? '#cccc00'
			     : "#ccc"

			// Плавное изменение цвета при переключении
			Behavior on color { 
				ColorAnimation { duration: 150 } 
			}

			Item {
				anchors.fill: parent
				// anchors.leftMargin: 6
				// anchors.rightMargin: 6

				Row {
					anchors.left: parent.left
					anchors.verticalCenter: parent.verticalCenter
					// height: 5
					// spacing: 6

					// WorkSpaces {
					// 	screenData: modelData
					// }

					// Lang {}
				}
			}
		}
	}
}
