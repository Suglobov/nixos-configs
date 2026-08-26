// Processes.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root
	property alias chooseWinToClose: chooseWinToClose
	property alias mouseProc: mouseProc

	property int mouseX: 0
	property int mouseY: 0
	property var mousePos: [mouseX, mouseY]

	Process {
		id: chooseWinToClose
		command: ['niri', 'msg', '--json', 'pick-window']
		running: false
		stdout: StdioCollector {
			onStreamFinished: {
				mouseProc.running = false
				if (this.text == 'null\n') {
					// console.log(this.text.length, this.text == 'null\n')
					return
				}
				var windowData = JSON.parse(this.text);
				Quickshell.execDetached(['niri',	'msg',	'action',	'close-window',	'--id',	windowData.id])
			}
		}
		stderr: StdioCollector { // ловим ошибки
			onStreamFinished: {
				if (this.text) {
					console.error('stderr:', this.text);
				}
			}
		}
	}

	Process {
		id: mouseProc
		command: ['niri', 'msg', '--json', 'cursor-position-stream']
		running: false
		stdout: SplitParser {
			onRead: (data) => {
				try {
					var coords = JSON.parse(data);
					root.mouseX = coords[0]
					root.mouseY = coords[1]
				} catch(error) {
					console.log("Ошибка парсинга JSON:", error)
				}
			}
		}
	}

}