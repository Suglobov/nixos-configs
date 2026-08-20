// WorkspacesPanel.qml
import QtQuick
import Quickshell
import Quickshell.Wayland
import "../"

PanelWindow {
	id: workspacesPanel
	required property var screenData
	screen: screenData

	property int panelHeight: 31

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
		width: workspaces.width + 20
		color: '#cc000000'
		radius: 2

		Row	{
			id: workspaces
			spacing:	6
			height:	parent.height
			anchors.centerIn:	parent
			Repeater	{
				model:	Niri.wsByOutput[screenData?.name]
				delegate:	Ws {
					wsId: modelData
				}
			}
		}
	}

	property bool scrollAllowed: true
	Timer {
		id: scrollTimer
		interval: 50
		running: false
		repeat: false
		onTriggered: workspacesPanel.scrollAllowed = true
	}
	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		acceptedButtons: Qt.NoButton
		onWheel: (event) => {
			if (!workspacesPanel.scrollAllowed) return

			workspacesPanel.scrollAllowed = false
			scrollTimer.start()

			if (event.angleDelta.y > 0) {
				Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"]);
			} else if (event.angleDelta.y < 0) {
				Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]);
			}
		}
	}

}
