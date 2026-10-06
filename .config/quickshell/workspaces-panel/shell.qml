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
			screen: screenData

			readonly property int panelHeight: 30

			anchors.top: true

			WlrLayershell.layer: WlrLayer.Top
			WlrLayershell.margins.top: -panelHeight

			implicitWidth: contentContainer.width
			implicitHeight: panelHeight
			color: 'transparent'

			Rectangle {
				id: contentContainer
				anchors.centerIn: parent
				height: parent.height
				width: childrenRect.width + 20
				color: '#cc000000'
				radius: 2

				Workspaces {
					screenData: modelData
				}
			}

			property bool scrollAllowed: true
			Timer {
				id: scrollTimer
				interval: 50
				running: false
				repeat: false
				onTriggered: panel.scrollAllowed = true
			}
			MouseArea {
				anchors.fill: parent
				hoverEnabled: true
				acceptedButtons: Qt.NoButton
				onWheel: (event) => {
					if (!panel.scrollAllowed) return

					panel.scrollAllowed = false
					scrollTimer.start()

					if (event.angleDelta.y > 0) {
						Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"]);
					} else if (event.angleDelta.y < 0) {
						Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]);
					}
				}
			}
		}
	}
}
