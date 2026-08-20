// CLHelp.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root
	property var mousePos: [0, 0]

	property var outputs: {}
	property bool isOutputsReady: false

	property var dot: [null, null]
	property var dotHintVisible: false

	Process {
		command: ['niri', 'msg', '--json', 'outputs']
		running: true
		stdout: SplitParser {
				onRead: (data) => {
						root.outputs = JSON.parse(data);
						root.isOutputsReady = true
				}
		}
	}

	Process {
		command: ['niri', 'msg', '--json', 'cursor-position-stream']
		running: true
		
		stdout: SplitParser {
			onRead: (data) => {
				var coords = JSON.parse(data);
				root.mousePos = coords.map((item) => Math.round(item));
			}
		}
	}

	Timer {
		id: dotVisibleTimer
		interval: 500
		running: false
		repeat: false
		triggeredOnStart: false
		onTriggered: root.dotHintVisible = true
	}

	Process {
		command: ['libinput', 'debug-events', '--show-keycodes']
		running: true
		stdout: SplitParser {
			onRead: (line) => {
				var isLeftPressed = line.includes('BTN_LEFT (272) pressed, seat count: 1');
				if (isLeftPressed) {
					root.dot = root.mousePos
					dotVisibleTimer.restart()
					return
				}

				var isLeftReleased = line.includes('BTN_LEFT (272) released, seat count: 0');
				if (isLeftReleased) {
					root.dot = [null, null]
					dotVisibleTimer.stop()
					root.dotHintVisible = false
				}
			}
		}
	}
}
