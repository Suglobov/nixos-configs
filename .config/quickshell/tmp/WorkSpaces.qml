// WorkSpaces.qml
import QtQuick
import Quickshell

Row {
	id: root
	required property var screenData
	spacing: 4
	height: parent.height

	Repeater {
		id: workspacesRepeater
		model: Niri.workspaces.filter((ws) => ws.output === screenData?.name).sort((a, b) => a.idx - b.idx)

		delegate: Rectangle {
			id: rect
			readonly property bool isFocused: Niri.focusedWorkspaceId === modelData.id
			readonly property bool isActive: Niri.activeWorkspacesIds.includes(modelData.id)
			readonly property bool isEmpty: modelData.active_window_id === null

			anchors.verticalCenter: parent.verticalCenter
			radius: 1

			width: (text ? text.implicitWidth : 0) +
				isFocused && isEmpty ? 10
				: isFocused ? 20
				: isActive ? 20
				: !isEmpty ? 15
				: 10

			height: isFocused && isEmpty ? 10
				: isFocused ? 20
				: isActive ? 20
				: !isEmpty ? 15
				: 10

			color: isFocused && isEmpty ? '#a9aefe'
				: isFocused ? '#fff59b'
				: isActive ? '#a9aefe'
				: !isEmpty ? '#a9aefe'
				: '#363793'

			border.width: 0
			// border.width: isEmpty ? 1 : 0
			border.color: "#555"

			Behavior on color { ColorAnimation { duration: 150 } }
			Behavior on width { NumberAnimation { duration: 150 } }
			Behavior on height { NumberAnimation { duration: 150 } }
			Behavior on anchors.bottomMargin { NumberAnimation { duration: 150 } }

			// transform: Translate {
			// 	y: isFocused ? -4
			// 		: isActive ? -2
			// 		: !isEmpty ? -2
			// 		: 0
			// 	Behavior on y { NumberAnimation { duration: 150 } }
			// }

			Text {
				id: text
				anchors.centerIn: parent
				// text: isFocused ? 'F' : isActive ? 'A' : !isEmpty ? '!E' : 'e'
				// text: modelData.id
				// text: modelData.name ?? isEmpty ? '' : modelData.idx
				text: modelData.name ?? isEmpty ? '' : '•'
				color: "#000"
				font.pixelSize: 10
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
