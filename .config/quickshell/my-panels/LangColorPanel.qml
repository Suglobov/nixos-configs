// LangColorPanel.qml
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
	required property var screenData
  screen: screenData

	property int panelHeight: 32

	aboveWindows: false
	WlrLayershell.layer: WlrLayer.Bottom
	WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

	anchors.top: true
	anchors.left: true
	anchors.right: true

	exclusiveZone: -panelHeight
	implicitHeight: panelHeight

	property var colors: [
		'#ff000055',
		'#ff00ff00',
	]
	color: colors[Niri.keyboardLayoutIdx] ?? '#ffcccccc'
	Behavior on color { ColorAnimation { duration: 200 } }
}
