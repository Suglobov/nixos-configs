// Windows.qml
import QtQuick
import Quickshell

Row {
	id: root
	required property var screenData
	spacing: 6 // Шаг между самими воркспейсами
	height: parent.height

	Repeater {
		id: workspace
		property int countNotEmpty: 0
		property var notEmptyIds: []
		model: {
			var screenWorkspaces = Niri.workspaces
				.filter((ws) => ws.output === screenData?.name)
				.sort((a, b) => a.idx - b.idx);
			workspace.notEmptyIds = screenWorkspaces
				.filter(ws => ws.active_window_id !== null)
				.map(ws => ws.id);
			return screenWorkspaces;
		}

		delegate: Rectangle {
			id: rect
			readonly property bool isFocused: Niri.focusedWorkspaceId === modelData.id
			readonly property bool isActive: Niri.activeWorkspacesIds.includes(modelData.id)
			readonly property bool isEmpty: modelData.active_window_id === null
			readonly property int currentWorkspaceId: modelData.id
			readonly property int notEmptyIndex: workspace.notEmptyIds.indexOf(modelData.id)
			readonly property int stepY: 6
			readonly property int maxShift: (workspace.notEmptyIds.length - 1) * stepY

			anchors.verticalCenter: parent.verticalCenter
			radius: 2

			width: (windowsLayout ? windowsLayout.implicitWidth : 0)
				+ (isEmpty ? (parent.height * 0.5) : 0)

			height: isEmpty ? (parent.height * 0.5)
				: (parent.height - rect.maxShift);

			color: "transparent"

			border.width: 1
			border.color: isFocused ? '#fff59b'
				: isActive ? '#a9aefe'
				: !isEmpty ? '#a9aefe'
				: '#363793';

			Behavior on color { ColorAnimation { duration: 150 } }
			Behavior on width { NumberAnimation { duration: 150 } }
			Behavior on height { NumberAnimation { duration: 150 } }

			transform: Translate {
				// Центрированный каскад: первый уходит вверх, последний уходит вниз, пустые — строго в 0
				y: isEmpty ? 0 : (rect.notEmptyIndex * rect.stepY) - (rect.maxShift / 2)

				// (rect.notEmptyIndex * rect.stepY) - (rect.maxShift / 2)
				Behavior on y { NumberAnimation { duration: 150 } }
			}

			Row {
				id: windowsLayout
				anchors.centerIn: parent
				spacing: 2 // Отступ между иконками окон внутри одной плашки

				Repeater {
					model: Niri.windows
						.filter((win) => win.workspace_id === rect.currentWorkspaceId)
						.sort((a, b) => {
							if (a.layout.pos_in_scrolling_layout[0] - b.layout.pos_in_scrolling_layout[0] !== 0) {
								return a.layout.pos_in_scrolling_layout[0] - b.layout.pos_in_scrolling_layout[0]
							}
							return a.layout.pos_in_scrolling_layout[1] - b.layout.pos_in_scrolling_layout[1]
						})

					delegate: Image {
						id: windowIcon
						// Высота иконки подстраивается под высоту родительского прямоугольника с отступом
						// height: rect.height - (rect.border.width * 1)
						height: rect.height
						width: height
						fillMode: Image.PreserveAspectFit

						smooth: true
						mipmap: true

						sourceSize.height: height
						sourceSize.width: width

						source: Quickshell.iconPath(modelData.app_id)
					}
				}
			}

			MouseArea {
				anchors.fill: parent
				cursorShape: Qt.PointingHandCursor
				onClicked: {
					rect.notEmptyIndex
					console.log('', (rect.notEmptyIndex * rect.stepY), rect.maxShift, rect.height);
					// Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(modelData.name ?? modelData.idx ?? modelData.id)])
				}
			}
		}
	}
}
