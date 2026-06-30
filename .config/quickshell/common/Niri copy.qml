// // Niri.qml
// pragma Singleton
// import QtQuick
// import Quickshell
// import Quickshell.Io

// Singleton {
// 	id: root
// 	property var workspaces: []
// 	property var workspacesById: Object.create(null)
// 	property var workspacesIdxByOutput: Object.create(null)
// 	property var focusedWorkspaceId: -1
// 	property var activeWorkspacesIds: []
// 	property var urgentWorkspacesIds: []

// 	// property var windows: []
// 	property var windowsById: Object.create(null)
// 	property var windowsPosByWs: Object.create(null)
// 	property var focusedWindowId: -1
// 	property var activeWindowsIds: []
// 	property var urgentWindowsIds: []

// 	property var keyboardLayouts: []
// 	property var keyboardLayoutIdx: -1

// 	property var createPos: (window) => {
// 		var workspace_id = window.workspace_id;
// 		var pos = window.layout.pos_in_scrolling_layout;
// 		var col = pos[0] - 1;
// 		var row = pos[1] - 1;
// 		if (!root.windowsPosByWs[workspace_id]) {
// 			root.windowsPosByWs[workspace_id] = [];
// 		}
// 		if (!root.windowsPosByWs[workspace_id][col]) {
// 			root.windowsPosByWs[workspace_id][col] = [];
// 		}
// 		root.windowsPosByWs[workspace_id][col][row] = window.id;
// 		// console.log('createPos', window.id, workspace_id, col, row);
// 		// console.log('createPos\n', JSON.stringify(root.windowsPosByWs, null, 0));
// 	}

// 	property var removePos: (window) => {
// 		var workspace_id = window.workspace_id;
// 		var pos = window.layout.pos_in_scrolling_layout;
// 		var col = pos[0] - 1;
// 		var row = pos[1] - 1;
// 		console.log('removePos', window.id, workspace_id, col, row);
// 		var cols = root.windowsPosByWs[workspace_id];
// 		var rows = root.windowsPosByWs[workspace_id][col];
// 		if (rows.length > 1) {
// 			root.windowsPosByWs[workspace_id][col].splice(row, 1);
// 			console.log('rows.length > 1', JSON.stringify(root.windowsPosByWs[workspace_id], null, 0));
// 			return;
// 		}
// 		if (cols.length > 1) {
// 			root.windowsPosByWs[workspace_id].splice(col, 1);
// 			console.log('cols.length > 1', JSON.stringify(root.windowsPosByWs[workspace_id], null, 0));
// 			return;
// 		}
// 		delete root.windowsPosByWs[workspace_id];
// 		console.log('root.windowsPosByWs[workspace_id]', JSON.stringify(root.windowsPosByWs[workspace_id], null, 0));
// 	}

// 	property var refreshWindowsPosByWs: () => {
// 		root.windowsPosByWs = Object.create(null);
// 		var keys = Object.keys(root.windowsById);
// 		// console.log('refreshWindowsPosByWs', JSON.stringify(keys, null, 0));
// 		var length = keys.length;
// 		for(var i = 0; i < length; i += 1) {
// 			var id = keys[i];
// 			var window = root.windowsById[id];
// 			root.createPos(window);
// 		}
// 		root.windowsPosByWsChanged();
// 	}

// 	Process {
// 		command: ["niri", "msg", "--json", "event-stream"]
// 		running: true

// 		stdout: SplitParser {
// 			onRead: (data) => {
// 				if (!data) return;

// 				try {

// 					let event = JSON.parse(data);
// 					console.log(JSON.stringify(Object.keys(event)[0], null, 0));

// 					if (event.WindowsChanged) {
// 						root.focusedWindowId = -1;
// 						var activeWindowsIds = [];
// 						var urgentWindowsIds = [];
// 						var windowsById = Object.create(null);
// 						// root.windowsPosByWs = Object.create(null);
// 						event.WindowsChanged.windows.forEach((window) => {
// 							windowsById[window.id] = window;
// 							if (window.is_focused) {
// 								root.focusedWindowId = window.id
// 							}
// 							if (window.is_active) {
// 								activeWindowsIds.push(window.id);
// 							}
// 							if (window.is_urgent) {
// 								urgentWindowsIds.push(window.id);
// 							}
// 							// root.createPos(window);
// 						});
// 						root.activeWindowsIds = activeWindowsIds;
// 						root.urgentWindowsIds = urgentWindowsIds;
// 						root.windowsById = windowsById;
// 						root.refreshWindowsPosByWs();
// 						// console.log('WindowsChanged\n', JSON.stringify(root.windowsPosByWs, null, 0));
// 						// root.windowsPosByWsChanged();
// 					}

// 					if (event.WindowOpenedOrChanged) {
// 						var window = event.WindowOpenedOrChanged.window;
// 						if (window.is_focused) {
// 							root.focusedWindowId = window.id;
// 						}
// 						// var isOpen = root.windowsById[window.id] === undefined;
// 						root.windowsById[window.id] = window;
// 						// if (isOpen) {
// 						// 	console.log('isOpen');
// 						// 	// root.createPos(window);
// 						// }
// 						root.refreshWindowsPosByWs();
// 						// root.windowsPosByWsChanged();
// 						// console.log('WindowOpenedOrChanged\n', JSON.stringify(root.windowsPosByWs, null, 0));
// 					}

// 					if (event.WindowLayoutsChanged) {
// 						var changes = event.WindowLayoutsChanged.changes;
// 						for (var i = 0; i < changes.length; i += 1) {
// 							// console.log('WindowLayoutsChanged\n', JSON.stringify(changes[i], null, 0));
// 							var windowId = changes[i][0];
// 							var newLayout = changes[i][1];
// 							var window = root.windowsById[windowId];
// 							// console.log('pos before remove\n', id, JSON.stringify(window.layout.pos_in_scrolling_layout, null, 0));
// 							// root.removePos(window);
// 							window.layout = newLayout;
// 							// console.log('pos after remove\n', id, JSON.stringify(window.layout.pos_in_scrolling_layout, null, 0));
// 						}
						
// 						// for (var i = 0; i < changes.length; i += 1) {
// 						// 	var window = root.windowsById[changes[i][0]];
// 						// 	root.createPos(window);
// 						// }
// 						// console.log('WindowLayoutsChanged', JSON.stringify(root.windowsPosByWs[win.workspace_id], null, 1));
						
// 						root.refreshWindowsPosByWs();
// 						// root.windowsPosByWsChanged();
// 						// console.log('WindowLayoutsChanged\n', JSON.stringify(root.windowsPosByWs, null, 0));
// 					}

// 					if (event.WorkspaceActiveWindowChanged) {
// 						// console.log(JSON.stringify(event, null, 1));
// 					}

// 					if (event.WindowFocusChanged) {
// 						root.focusedWindowId = event.WindowFocusChanged.id
// 					}

// 					if (event.WindowFocusTimestampChanged) {
// 						// console.log(JSON.stringify(event, null, 1));
// 					}

// 					if (event.WindowClosed) {
// 						var id = event.WindowClosed.id;
// 						delete root.windowsById[id];
// 						root.refreshWindowsPosByWs();
// 					}


// 					if (event.WorkspacesChanged) {
// 						root.workspaces = event.WorkspacesChanged.workspaces;
// 						root.focusedWorkspaceId = -1;
// 						var activeWorkspacesIds = [];
// 						var urgentWorkspacesIds = [];
// 						var workspacesById = Object.create(null);
// 						var workspacesIdxByOutput = Object.create(null);
// 						root.workspaces.forEach((ws) => {
// 							workspacesById[ws.id] = ws;
// 							if (!workspacesIdxByOutput[ws.output]) {
// 								workspacesIdxByOutput[ws.output] = [];
// 							}
// 							workspacesIdxByOutput[ws.output][ws.idx - 1] = ws.id
// 							if (ws.is_focused) {
// 								root.focusedWorkspaceId = ws.id;
// 							}
// 							if (ws.is_active) {
// 								activeWorkspacesIds.push(ws.id);
// 							}
// 							if (ws.is_urgent) {
// 								urgentWorkspacesIds.push(ws.id);
// 							}
// 						});
// 						root.activeWorkspacesIds = activeWorkspacesIds;
// 						root.urgentWorkspacesIds = urgentWorkspacesIds;
// 						root.workspacesById = workspacesById;
// 						root.workspacesIdxByOutput = workspacesIdxByOutput;
// 					}

// 					if (event.WorkspaceActivated) {
// 						var { id, focused } = event.WorkspaceActivated;
// 						var focusId = root.focusedWorkspaceId;
// 						var activeIds = root.activeWorkspacesIds;
// 						var len = root.activeWorkspacesIds.length;
// 						var isIdActive = false;
// 						var focusIdIndex = -1;
// 						// console.log(
// 						// 	JSON.stringify(event.WorkspaceActivated, null, 0),
// 						// 	JSON.stringify(activeIds, null, 0),
// 						// );
// 						for (var i = 0; i < len; i += 1) {
// 							if (activeIds[i] === id) {
// 								isIdActive = true;
// 							}
// 							if (activeIds[i] === focusId) {
// 								focusIdIndex = i;
// 							}
// 						}
// 						if (!isIdActive) {
// 							activeIds[focusIdIndex] = id;
// 						}
// 						root.activeWorkspacesIds = activeIds;
// 						root.focusedWorkspaceId = focused ? id : -1;
// 					}


// 					// {"KeyboardLayoutsChanged":{"keyboard_layouts":{"names":["English (US)","Russian"],"current_idx":0}}}
// 					if (event.KeyboardLayoutsChanged) {
// 						root.keyboardLayouts = event.KeyboardLayoutsChanged.keyboard_layouts.names;
// 						root.keyboardLayoutIdx = event.KeyboardLayoutsChanged.keyboard_layouts.current_idx;
// 					}
// 					if (event.KeyboardLayoutSwitched) {
// 						root.keyboardLayoutIdx = event.KeyboardLayoutSwitched.idx;
// 					}

// 				} catch (error) {
// 					console.error("Ошибка чтения niri IPC:", error);
// 				}
// 			}
// 		}
// 	}
// }
