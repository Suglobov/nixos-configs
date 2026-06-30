// Niri.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root
	property var wsById: Object.create(null)
	property var wsByOutput: Object.create(null)
	property var focusedWsId: -1
	property var activeWsIds: []
	property var urgentWsIds: []

	property var winById: Object.create(null)
	property var winPosByWs: Object.create(null)
	property var winTileByWs: Object.create(null)
	property var focusedWinId: -1
	property var urgentWinIds: []

	property var keyboardLayouts: []
	property var keyboardLayoutIdx: -1

	property var createPos: (win) => {
		var ws_id = win.workspace_id
		var id = win.id
		var pos = win.layout.pos_in_scrolling_layout;
		if (!pos) {
			root.winTileByWs[ws_id] = root.winTileByWs[ws_id] ?? []
			root.winTileByWs[ws_id].push(id)
			// console.log('0 root.winTileByWs', JSON.stringify(root.winTileByWs, null, 0));
			return;
		}
		var [col, row] = pos.map((item) => item - 1);
		root.winPosByWs[ws_id] = root.winPosByWs[ws_id] ?? [];
		root.winPosByWs[ws_id][col] = root.winPosByWs[ws_id][col] ?? [];
		root.winPosByWs[ws_id][col][row] = id;
	}

	property var refreshWinPosByWs: () => {
		// console.log('- root.winPosByWs', JSON.stringify(root.winPosByWs, null, 0));
		// console.log('- root.winTileByWs', JSON.stringify(root.winTileByWs, null, 0));
		root.winPosByWs = Object.create(null);
		root.winTileByWs = Object.create(null);
		var wins = Object.values(root.winById);
		for(var i = 0; i < wins.length; i += 1) {
			root.createPos(wins[i]);
		}
		var ws_ids = Object.keys(root.wsById)
		for(var i = 0; i < ws_ids.length; i += 1) {
			var ws_id = ws_ids[i]
			if (!root.winTileByWs[ws_id] || !root.winTileByWs[ws_id].length) continue
			root.winTileByWs[ws_id].sort((a, b) => {
				var winA = root.winById[a]
				var winB = root.winById[b]
				var [ta_1, ta_2] = winA.layout.tile_pos_in_workspace_view
				var [tb_1, tb_2] = winB.layout.tile_pos_in_workspace_view
				return ta_1 - tb_1 || ta_2 - tb_2
			})

		}
		console.log('- root.winPosByWs', JSON.stringify(root.winPosByWs, null, 0));
		// console.log('- root.winTileByWs', JSON.stringify(root.winTileByWs, null, 0));
		root.winTileByWsChanged();
		root.winPosByWsChanged();
	}

	property var refreshWsObject: (ws_id) => {
		var wins = Object.values(root.winById)
		root.winPosByWs[ws_id] = []
		root.winTileByWs[ws_id] = []
		// console.log('-- root.winPosByWs', JSON.stringify(root.winPosByWs, null, 0));
		for (var i = 0; i < wins.length; i += 1) {
			var win = wins[i]
			if (win.workspace_id === ws_id) {
				root.createPos(win)
			}
		}
		console.log('-- root.winPosByWs', JSON.stringify(root.winPosByWs, null, 0));
		root.winTileByWsChanged();
		root.winPosByWsChanged();
	}

	Process {
		// https://docs.rs/niri-ipc/latest/niri_ipc/enum.Event.html
		command: ["niri", "msg", "--json", "event-stream"]
		running: true

		stdout: SplitParser {
			onRead: (data) => {
				if (!data) return;

				try {

					let event = JSON.parse(data);
					console.log(Date.now(), JSON.stringify(Object.keys(event)[0], null, 0));

					if (event.WorkspaceActiveWindowChanged) {
						// console.log(JSON.stringify(event.WorkspaceActiveWindowChanged, null, 0));
					}

					if (event.WindowLayoutsChanged) {
						var changes = event.WindowLayoutsChanged.changes
						for (var i = 0; i < changes.length; i += 1) {
							var winId = changes[i][0]
							var layout = changes[i][1]
							root.winById[winId].layout = layout
						}
						root.refreshWsObject(root.winById[changes[0][0]].workspace_id)
					}

					if (event.WindowsChanged) {
						root.focusedWinId = -1;
						var urgentWinIds = [];
						var winById = Object.create(null);
						event.WindowsChanged.windows.forEach((win) => {
							console.log(
								'WindowsChanged',
								JSON.stringify(win.workspace_id, null, 0),
								'\t',
								JSON.stringify(win.id, null, 0),
								'\t',
								JSON.stringify(win.layout.pos_in_scrolling_layout, null, 0),
								'\t',
								JSON.stringify(win.layout.tile_pos_in_workspace_view, null, 0),
							);
							var wsId = win.workspace_id
							var id = win.id 
							winById[win.id] = win;
							if (win.is_focused) {
								root.focusedWinId = win.id
							}
							if (win.is_urgent) {
								urgentWinIds.push(win.id);
							}
						});
						root.urgentWinIds = urgentWinIds;
						root.winById = winById;
						root.refreshWinPosByWs();
					}

					if (event.WindowOpenedOrChanged) {
						var win = event.WindowOpenedOrChanged.window
						var ws_id = win.workspace_id
						if (win.is_focused) {
							root.focusedWinId = win.id
						}
						var old_ws_id = root.winById[win.id]?.workspace_id
						root.winById[win.id] = win
						root.refreshWsObject(ws_id)
						if (old_ws_id && ws_id !== old_ws_id) {
							root.refreshWsObject(old_ws_id)
						}
					}

					if (event.WindowClosed) {
						var id = event.WindowClosed.id;
						var ws_id = root.winById[id].workspace_id
						delete root.winById[id];
						root.refreshWsObject(ws_id)
					}

					if (event.WindowFocusChanged) {
						root.focusedWinId = event.WindowFocusChanged.id
					}


					if (event.WorkspacesChanged) {
						var workspaces = event.WorkspacesChanged.workspaces;
						root.focusedWsId = -1;
						var activeWsIds = [];
						var urgentWsIds = [];
						var wsById = Object.create(null);
						var wsByOutput = Object.create(null);
						workspaces.forEach((ws) => {
							wsById[ws.id] = ws;
							if (!wsByOutput[ws.output]) {
								wsByOutput[ws.output] = [];
							}
							wsByOutput[ws.output][ws.idx - 1] = ws.id
							if (ws.is_focused) {
								root.focusedWsId = ws.id;
							}
							if (ws.is_active) {
								activeWsIds.push(ws.id);
							}
							if (ws.is_urgent) {
								urgentWsIds.push(ws.id);
							}
						});
						root.activeWsIds = activeWsIds;
						root.urgentWsIds = urgentWsIds;
						root.wsById = wsById;
						root.wsByOutput = wsByOutput;
					}

					if (event.WorkspaceActivated) {
						var { id, focused } = event.WorkspaceActivated;
						var focusId = root.focusedWsId;
						var activeIds = root.activeWsIds;
						var isIdActive = false;
						var focusIdIndex = -1;
						for (var i = 0; i < activeIds.length; i += 1) {
							if (activeIds[i] === id) {
								isIdActive = true;
							}
							if (activeIds[i] === focusId) {
								focusIdIndex = i;
							}
						}
						if (!isIdActive) {
							activeIds[focusIdIndex] = id;
						}
						root.activeWsIds = activeIds;
						root.focusedWsId = focused ? id : -1;
						root.activeWsIdsChanged();
					}


					// {"KeyboardLayoutsChanged":{"keyboard_layouts":{"names":["English (US)","Russian"],"current_idx":0}}}
					if (event.KeyboardLayoutsChanged) {
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
