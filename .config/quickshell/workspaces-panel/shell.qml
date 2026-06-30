// shell.qml
//@ pragma IconTheme Papirus
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

			anchors.top: true
			screen: screenData

			// WlrLayershell.layer: WlrLayer.Overlay
			WlrLayershell.layer: WlrLayer.Top
			WlrLayershell.margins {
				top: -panelHeight
			}

			implicitWidth: contentContainer.width
			implicitHeight: panelHeight
			color: 'transparent'

			Item {
				id: contentContainer
				anchors.centerIn: parent
				height: parent.height
				width: childrenRect.width + 2

				Row {
					id: contentRow
					anchors.left: parent.left
					anchors.verticalCenter: parent.verticalCenter
					// spacing: 0
					height: parent.height

					Windows {
						screenData: modelData
					}
				}
			}

			MouseArea {
				anchors.fill: parent
				hoverEnabled: true
				acceptedButtons: Qt.NoButton
				property real ignoreUntil: 0
				readonly property int throttleInterval: 500
				// onWheel: (wheel) => {
				// 	// Используем scope-переменную wheel.item или контекст для обхода ошибки id
				// 	console.log('wheel.timestamp:', wheel.timestamp);
				// 	if (wheel.timestamp < ignoreUntil) return;

				// 	if (wheel.angleDelta.y > 0) {
				// 		Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"]);
				// 	} else if (wheel.angleDelta.y < 0) {
				// 		Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]);
				// 	}

				// 	ignoreUntil = wheel.timestamp + throttleInterval;
				// }

				// onWheel: (wheel) => {
				// 	if (wheel.angleDelta.y > 0) {
				// 		Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"])
				// 	} else if (wheel.angleDelta.y < 0) {
				// 		Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"])
				// 	}
				// }
			}
		}
	}
}
