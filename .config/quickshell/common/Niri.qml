// Niri.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root
	property var workspaces: []
	property var focusedWorkspaceId: -1

	property var keyboardLayouts: []
	property var keyboardLayoutIdx: -1

	Process {
		command: ["niri", "msg", "--json", "event-stream"]
		running: true

		stdout: SplitParser {
			onRead: (data) => {
				if (!data) return;

				try {
					let event = JSON.parse(data);
					// console.log('event:', JSON.stringify(event, null, 0));

					if (event.WorkspacesChanged) {
						root.workspaces = event.WorkspacesChanged.workspaces;
						root.focusedWorkspaceId = -1;
						root.workspaces.forEach((item) => {
							if (item.is_focused) {
								root.focusedWorkspaceId = item.id;
							}
						});
					}
					if (event.WorkspaceActivated) {
						// console.log('event:', JSON.stringify(event, null, 2));
						root.focusedWorkspaceId = event.WorkspaceActivated.focused === true ? event.WorkspaceActivated.id : -1;
					}

					// {"KeyboardLayoutsChanged":{"keyboard_layouts":{"names":["English (US)","Russian"],"current_idx":0}}}
					if (event.KeyboardLayoutsChanged) {
						// console.log('event:', JSON.stringify(event, null, 0));
						root.keyboardLayouts = event.KeyboardLayoutsChanged.keyboard_layouts.names;
						root.keyboardLayoutIdx = event.KeyboardLayoutsChanged.keyboard_layouts.current_idx;
					}
					if (event.KeyboardLayoutSwitched) {
						root.keyboardLayoutIdx = event.KeyboardLayoutSwitched.idx;
					}
				} catch (error) {
					console.error("Ошибка чтения niri IPC:", error);
				}
			}
		}
	}
}
