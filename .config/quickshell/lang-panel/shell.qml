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
			readonly property int panelHeight: 30

			WlrLayershell.layer: WlrLayer.Bottom
			WlrLayershell.margins.top: -panelHeight

			anchors.top: true
			anchors.left: true
			anchors.right: true

			implicitHeight: panelHeight
			color: Niri.keyboardLayoutIdx === 0 ? '#00f'
				: Niri.keyboardLayoutIdx === 1 ? '#0f0'
				: "#ccc"

			Behavior on color {
				ColorAnimation { duration: 150 }
			}
		}
	}
}
