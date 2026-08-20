// Niri.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root
	property var wsById: Object.create(null)
	property var wsByOutput: Object.create(null)
	property var wsFocusedId: -1
	property var wsActiveIds: new Set()
	property var wsUrgentIds: new Set()

	property var winById: Object.create(null)
	property var winPosByWs: Object.create(null)
	property var winTileByWs: Object.create(null)
	property var winFocusedId: -1
	property var winUrgentIds: new Set()

	property var keyboardLayouts: []
	property var keyboardLayoutIdx: -1

	property var createPos: (win) => {
		var ws_id = win.workspace_id
		var id = win.id
		var pos = win.layout.pos_in_scrolling_layout
		if (!pos) {
			root.winTileByWs[ws_id] = root.winTileByWs[ws_id] ?? []
			root.winTileByWs[ws_id].push(id)
			return
		}
		var [col, row] = pos.map((item) => item - 1)
		root.winPosByWs[ws_id] = root.winPosByWs[ws_id] ?? []
		root.winPosByWs[ws_id][col] = root.winPosByWs[ws_id][col] ?? []
		root.winPosByWs[ws_id][col][row] = id
	}

	property var refreshWinPosByWs: () => {
		root.winPosByWs = Object.create(null)
		root.winTileByWs = Object.create(null)
		var wins = Object.values(root.winById)
		for(var i = 0; i < wins.length; i += 1) {
			root.createPos(wins[i])
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
		root.winTileByWsChanged()
		root.winPosByWsChanged()
	}

	property var refreshWsObject: (ws_id) => {
		var wins = Object.values(root.winById)
		root.winPosByWs[ws_id] = []
		root.winTileByWs[ws_id] = []
		for (var i = 0; i < wins.length; i += 1) {
			var win = wins[i]
			if (win.workspace_id === ws_id) {
				root.createPos(win)
			}
		}
		root.winTileByWsChanged()
		root.winPosByWsChanged()
	}

	Process {
		// https://docs.rs/niri-ipc/latest/niri_ipc/enum.Event.html

 		// "WorkspaceActiveWindowChanged"
 		// "WindowFocusTimestampChanged"
 		// "OverviewOpenedOrClosed"
 		// "ConfigLoaded"
 		// "ScreenshotCaptured"
 		// "CastsChanged"
 		// "CastStartedOrChanged"
 		// "CastStopped"

		command: ["niri", "msg", "--json", "event-stream"]
		running: true

		stdout: SplitParser {
			onRead: (data) => {
				if (!data) return

				try {

					var event = JSON.parse(data)
					// console.log(Date.now(), JSON.stringify(Object.keys(event)[0], null, 0))

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
						root.winFocusedId = -1
						var winUrgentIds = new Set()
						var winById = Object.create(null)
						event.WindowsChanged.windows.forEach((win) => {
							var wsId = win.workspace_id
							var id = win.id 
							winById[win.id] = win
							if (win.is_focused) {
								root.winFocusedId = win.id
							}
							if (win.is_urgent) {
								winUrgentIds.add(win.id)
							}
						})
						root.winUrgentIds = winUrgentIds
						root.winById = winById
						root.refreshWinPosByWs()
					}

					if (event.WindowOpenedOrChanged) {
						var win = event.WindowOpenedOrChanged.window
						var ws_id = win.workspace_id
						if (win.is_focused) {
							root.winFocusedId = win.id
						}
						if (win.is_urgent && !root.winUrgentIds.has(win.id)) {
							var set = new Set(root.winUrgentIds)
							set.add(win.id)
							root.winUrgentIds = set
						} 
						if (!win.is_urgent && root.winUrgentIds.has(win.id)) {
							var set = new Set(root.winUrgentIds)
							set.delete(win.id)
							root.winUrgentIds = set
						}
						var old_ws_id = root.winById[win.id]?.workspace_id
						root.winById[win.id] = win
						root.refreshWsObject(ws_id)
						if (old_ws_id && ws_id !== old_ws_id) {
							root.refreshWsObject(old_ws_id)
						}
					}

					if (event.WindowClosed) {
						var id = event.WindowClosed.id
						var ws_id = root.winById[id].workspace_id
						delete root.winById[id]
						root.refreshWsObject(ws_id)
					}


					if (event.WindowUrgencyChanged) {
						var { id, urgent } = event.WindowUrgencyChanged
						var set = new Set(root.winUrgentIds)
						urgent ? (set.add(id)) : (set.delete(id))
						root.winUrgentIds = set
					}

					if (event.WorkspaceUrgencyChanged) {
						var { id, urgent } = event.WorkspaceUrgencyChanged
						var set = new Set(root.wsUrgentIds)
						urgent ? (set.add(id)) : (set.delete(id))
						root.wsUrgentIds = set
					}


					if (event.WindowFocusChanged) {
						root.winFocusedId = event.WindowFocusChanged.id
					}


					if (event.WorkspacesChanged) {
						var workspaces = event.WorkspacesChanged.workspaces
						root.wsFocusedId = -1
						var wsActiveIds = new Set()
						var wsById = Object.create(null)
						var wsByOutput = Object.create(null)
						var wsUrgentIds = new Set()
						workspaces.forEach((ws) => {
							wsById[ws.id] = ws
							if (!wsByOutput[ws.output]) {
								wsByOutput[ws.output] = []
							}
							wsByOutput[ws.output][ws.idx - 1] = ws.id
							if (ws.is_focused) {
								root.wsFocusedId = ws.id
							}
							if (ws.is_active) {
								wsActiveIds.add(ws.id)
							}
							if (ws.is_urgent) {
								wsUrgentIds.add(ws.id)
							}
						})
						root.wsActiveIds = wsActiveIds
						root.wsById = wsById
						root.wsByOutput = wsByOutput
						root.wsUrgentIds = wsUrgentIds
					}

					if (event.WorkspaceActivated) {
						var { id, focused } = event.WorkspaceActivated
						var activeIds = new Set(root.wsActiveIds)
						if (!activeIds.has(id)) {
							// если раньше не была активна ws, то удаляем ранее сфокусированное ws
							activeIds.delete(root.wsFocusedId)
							activeIds.add(id)
						}
						if (focused) {
							root.wsFocusedId = id
						}
						root.wsActiveIds = activeIds
					}


					// {"KeyboardLayoutsChanged":{"keyboard_layouts":{"names":["English (US)","Russian"],"current_idx":0}}}
					if (event.KeyboardLayoutsChanged) {
						root.keyboardLayouts = event.KeyboardLayoutsChanged.keyboard_layouts.names
						root.keyboardLayoutIdx = event.KeyboardLayoutsChanged.keyboard_layouts.current_idx
					}
					if (event.KeyboardLayoutSwitched) {
						root.keyboardLayoutIdx = event.KeyboardLayoutSwitched.idx
					}

				} catch (error) {
					console.error(error)
				}
			}
		}
	}
}
