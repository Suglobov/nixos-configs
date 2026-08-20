// shell.qml
import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
	Variants {
		model: Quickshell.screens

		PanelWindow {
			id: panel
			required property var modelData
			readonly property var screenData: modelData
			readonly property int panelHeight: 30

			screen: screenData

			// WlrLayershell.layer: WlrLayer.Top
			WlrLayershell.layer: WlrLayer.Bottom
			// WlrLayershell.layer: WlrLayer.Background
			// WlrLayershell.margins.top: -panelHeight
			WlrLayershell.namespace: 'lang-panel'
			WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
			WlrLayershell.exclusionMode: WlrLayershell.None

			anchors.top: true
			anchors.left: true
			anchors.right: true
			aboveWindows: false
			exclusiveZone: -panelHeight
			implicitHeight: panelHeight
			color: 'transparent'

			Rectangle {
				anchors.fill: parent
				radius: 0
				border.width: 0
				property var colors: [
					'#ff000055',
					'#ff00ff00',
				]
				// hex-формат (первые две цифры — прозрачность)
				color: colors[Niri.keyboardLayoutIdx] ?? '#ffcccccc'
				Behavior on color { ColorAnimation { duration: 300 } }
			}
		}
	}
}
