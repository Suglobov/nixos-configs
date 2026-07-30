import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
	id: root
	property string keyPressed: ""
	signal keyTriggered(string key)

	Process {
		command: ["evtest", "/dev/input/by-path/platform-i8042-serio-0-event-kbd"]
		running: true
		stdout: SplitParser {
			onRead: (line) => {
				if (!line) return;
				// console.log('line:', line);

				// const match = line.match(/\((KEY_[A-Z0-9_]+)\),\s*value\s*1/);
				// if (match && match[1]) {
				// 	var cleanKey = match[1].replace("KEY_", "");
				// 	root.keyTriggered(cleanKey);
				// }
				// return;
				var key = "";
				if (line.includes("(KEY_TAB), value 1")) key = "TAB"
				// else if (line.includes("(KEY_CAPSLOCK), value 1")) key = "CAPSLOCK"
				// else if (line.includes("(KEY_LEFTSHIFT), value 1")) key = "SHIFT"
				// else if (line.includes("(KEY_RIGHTSHIFT), value 1")) key = "SHIFT"
				// else if (line.includes("(KEY_LEFTCTRL), value 1")) key = "CTRL"
				// else if (line.includes("(KEY_RIGHTCTRL), value 1")) key = "CTRL"
				// else if (line.includes("(KEY_LEFTALT), value 1")) key = "ALT"
				// else if (line.includes("(KEY_RIGHTALT), value 1")) key = "ALT"
				// else if (line.includes("(KEY_LEFTMETA), value 1")) key = "META"
				// else if (line.includes("(KEY_RIGHTMETA), value 1")) key = "META"
				// else if (line.includes("(KEY_NUMLOCK), value 1")) key = "NUMLOCK"
				// else if (line.includes("(KEY_ESC), value 1")) key = "ESC"

				if (key !== "") {
					root.keyTriggered(key); // Отправляем сигнал
				}
			}
		}
	}

	Variants {
		model: Quickshell.screens
		PanelWindow {
			id: panel
			required property var modelData
			readonly property var screenData: modelData
			screen: screenData

			exclusiveZone: 0
			// anchors.top: true
			// anchors.left: true

			implicitWidth: 10
			implicitHeight: 10
			color: 'transparent'
			// color: '#ff00ff'
			anchors.bottom: true
			margins.bottom: screen ? (screen.height * 0.7) : 0
			mask: Region {}

			Component.onCompleted: {
				if (screen) {
					// console.log('screen:', JSON.stringify(screen, null, 0));
				} else {
					// console.log('screen еще не инициализирован');
				}
			}

			PopupWindow {
				id: popup
				visible: popupContent.opacity > 0
				// visible: true
				anchor.window: panel
				implicitWidth: popupContent.implicitWidth
				implicitHeight: popupContent.implicitHeight

				// implicitWidth: 50
				// implicitHeight: 50
				// anchor.rect.x: screen.width * 0.01
				anchor.rect.x: -implicitWidth / 2 + panel.implicitWidth / 2
				anchor.rect.y: -implicitHeight / 2 + panel.implicitHeight / 2
				color: 'transparent'
				// Делаем попап прозрачным для кликов мышью
				mask: Region {}

				Rectangle {
					id: popupContent
					property string currentText: ""
					implicitWidth: popupText.implicitWidth + 20
					implicitHeight: popupText.implicitHeight + 20

					// color: "#88ff0000"
					color: "#ff000000"
					radius: 20
					opacity: 0

					Text {
						id: popupText
						anchors.centerIn: parent
						text: popupContent.currentText
						color: "white"
						font.pixelSize: 100
						font.bold: true
						font.family: "monospace"
					}

					Connections {
						target: root
						function onKeyTriggered(key) {
							flashAndFadeAnimation.stop(); 
							popupContent.currentText = key;
							flashAndFadeAnimation.start();
						}
					}

					SequentialAnimation {
						id: flashAndFadeAnimation
						PropertyAction { 
								target: popupContent
								property: "opacity"
								value: 1.0 
						}
						NumberAnimation {
								target: popupContent
								property: "opacity"
								to: 0.0
								duration: 500
								easing.type: Easing.OutCubic
						}
					}

					// state: root.tabPressed ? "SHOW" : "HIDE"
					// states: [
					// 	State {
					// 		name: "SHOW"
					// 		PropertyChanges { target: popupContent; opacity: 1.0 }
					// 	},
					// 	State {
					// 		name: "HIDE"
					// 		PropertyChanges { target: popupContent; opacity: 0.0 }
					// 	}
					// ]

					// transitions: [
					// 	// При нажатии (переход в SHOW) — появление мгновенное (0 мс)
					// 	Transition {
					// 		from: "HIDE"; to: "SHOW"
					// 		NumberAnimation { 
					// 			properties: "opacity"
					// 			duration: 0 
					// 		}
					// 	},
					// 	// При отпускании (переход в HIDE) — исчезновение плавное (300 мс)
					// 	Transition {
					// 		from: "SHOW"; to: "HIDE"
					// 		NumberAnimation {
					// 			properties: "opacity"
					// 			duration: 500
					// 		}
					// 	}
					// ]

				}
			}

		}
	}
}
