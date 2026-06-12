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
			readonly property int panelHeight: 40

			screen: screenData

			WlrLayershell.layer: WlrLayer.Bottom
			WlrLayershell.margins.top: -panelHeight

			anchors.top: true
			anchors.left: true
			anchors.right: true

			implicitHeight: panelHeight
			color: "transparent"

			Behavior on color {
				ColorAnimation { duration: 150 }
			}

			Rectangle {
				anchors.fill: parent
				radius: 0
				border.width: 0
				// hex-формат (первые две цифры — прозрачность)
				color: Niri.keyboardLayoutIdx === 0 ? '#ff0000ff'
				: Niri.keyboardLayoutIdx === 1 ? '#ffff0000'
				: "#ccc"
			}
		}
	}
}
