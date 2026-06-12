// WorkSpaces.qml
import QtQuick
import Quickshell

Row {
	id: root
	required property var screenData
	spacing: 4

	Repeater {
		id: workspacesRepeater
		model: Niri.workspaces.filter((ws) => ws.output === screenData?.name).sort((a, b) => a.idx - b.idx)

		delegate: Rectangle {
			readonly property bool isFocused: Niri.focusedWorkspaceId === modelData.id

			width: isFocused ? 40 : 20
			height: 20
			radius: 2

			color: isFocused ? '#e7e6df' : '#555'
			border.width: 0

			Behavior on color { ColorAnimation { duration: 150 } }

			Text {
				anchors.centerIn: parent
				text: modelData.active_window_id == null ? '' : modelData.name ?? modelData.idx ?? modelData.id
				color: "#000"
				font.pixelSize: 12
				font.bold: true
			}

			MouseArea {
				anchors.fill: parent
				cursorShape: Qt.PointingHandCursor
				onClicked: {
					Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(modelData.name ?? modelData.idx ?? modelData.id)])
				}
			}
		}
	}
}
