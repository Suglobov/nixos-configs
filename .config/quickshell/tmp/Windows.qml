// Windows.qml
import QtQuick
import Quickshell

Row {
	id: root
	required property var screenData
	spacing: 8
	height: parent.height

	Repeater {
		id: workspacesRepeater
		model: Niri.workspaces
			.filter((ws) => ws.output === screenData?.name)
			.sort((a, b) => a.idx - b.idx);

		delegate: Rectangle {
			id: rect
			readonly property bool isFocused: Niri.focusedWorkspaceId === modelData.id
			readonly property bool isActive: Niri.activeWorkspacesIds.includes(modelData.id)
			readonly property bool isEmpty: modelData.active_window_id === null
			readonly property int currentWorkspaceId: modelData.id
			anchors.verticalCenter: parent.verticalCenter
			radius: isEmpty ? 2 : 6;
			width: (window ? window.implicitWidth : 0) + (isEmpty ? (parent.height * 0.7) : 10)
			height: (isEmpty ? parent.height * 0.7 : parent.height)
			// color: 'transparent';
			color: isFocused ? '#55aaaaaa' : 'transparent';
			border.width: 1;
			border.color: '#8800ff00';
			Behavior on color { ColorAnimation { duration: 150 } }

			Rectangle {
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: parent.top
				// anchors.left: parent.left
				// anchors.right: parent.right
				// anchors.topMargin: 2
				width: parent.width * 0.8
				height: 2;
				radius: 3
				color: 'transparent';
				// color: isFocused ? '#fff59b' : 'transparent';
					// : isActive ? '#a9aefe'
					// : !isEmpty ? '#a9aefe'
					// : 'transparent';
		}

			Row {
				id: window
				anchors.centerIn: parent
				spacing: 4
				z: 1

				Repeater {
					model: Niri.windows
						.filter((win) => win.workspace_id === rect.currentWorkspaceId)
						.sort((a, b) => {
							if (a.layout.pos_in_scrolling_layout[0] - b.layout.pos_in_scrolling_layout[0] !== 0) {
								return a.layout.pos_in_scrolling_layout[0] - b.layout.pos_in_scrolling_layout[0]
							}
							return a.layout.pos_in_scrolling_layout[1] - b.layout.pos_in_scrolling_layout[1]
						})

					delegate: Rectangle {
						id: iconRect
						readonly property bool isFocused: Niri.focusedWindowId === modelData.id
						width: rect.height
						height: rect.height
						color: 'transparent'
						border.width: 0;

						Image {
							id: windowIcon
							anchors.centerIn: parent
							height: rect.height - 5
							width: height
							fillMode: Image.PreserveAspectFit
							smooth: true
							mipmap: true
							sourceSize.height: height
							sourceSize.width: width
							source: Quickshell.iconPath(modelData.app_id)
						}

						Rectangle {
							anchors.horizontalCenter: parent.horizontalCenter
							anchors.bottom: parent.bottom
							height: 5
							color: iconRect.isFocused ? '#ff0' : 'transparent'
							width: parent.width * 0.3
							Behavior on color { ColorAnimation { duration: 150 } }
						}

						MouseArea {
							anchors.fill: parent
							cursorShape: Qt.PointingHandCursor
							// propagateComposedEvents: true
							onClicked: (mouse) => {
								mouse.accepted = false
								Quickshell.execDetached(["niri", "msg", "action", "focus-window", "--id", modelData.id])
							}
						}
					}
				}
			}

			MouseArea {
				anchors.fill: parent
				cursorShape: Qt.PointingHandCursor
				onClicked: {
					Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", modelData.id])
				}
			}
		}
	}
}
