import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services

PanelWindow {
	id: clipMenu
	visible: true
	implicitWidth: 350

	anchors {
		right: true
		top: true
		bottom: true
	}
	color: "transparent"

	property var clipItems: []
	property var tempLines: []

	// Нативный рабочий сервис Quickshell 0.3.0 для трекинга буфера
	Connections {
		target: Clipboard
		function onTextChanged() {
			clipMenu.tempLines = [];
			cliphistList.running = false;
			cliphistList.running = true;
		}
	}

	Process {
		id: cliphistList
		command: ["cliphist", "list"]
		running: true

		stdout: SplitParser {
			onRead: (line) => {
				let tabIndex = line.indexOf("\t");
				if (tabIndex !== -1) {
					let id = line.substring(0, tabIndex);
					let text = line.substring(tabIndex + 1);
					clipMenu.tempLines.push({ "id": id, "preview": text });
				}
			}
		}

		onExited: (exitCode) => {
			clipMenu.clipItems = clipMenu.tempLines;
		}
	}

	Process {
		id: cliphistDecode
		command: ["sh", "-c", "cliphist decode | wl-copy"]
	}

	Rectangle {
		anchors.fill: parent
		color: "#1e1e2e"
		border.color: "#89b4fa"
		border.width: 1

		ColumnLayout {
			anchors.fill: parent
			anchors.margins: 10
			spacing: 8

			Text {
				text: "История буфера обмена"
				color: "#cdd6f4"
				font.bold: true
				font.pointSize: 14
				Layout.alignment: Qt.AlignHCenter
			}

			ScrollView {
				Layout.fillWidth: true
				Layout.fillHeight: true
				clip: true

				ListView {
					model: clipMenu.clipItems
					spacing: 4
					delegate: ItemDelegate {
						width: parent ? parent.width : 0
						height: 40
						background: Rectangle {
							color: hovered ? "#313244" : "#252538"
							radius: 4
						}
						contentItem: Text {
							text: modelData.preview
							color: hovered ? "#89b4fa" : "#cdd6f4"
							elide: Text.ElideRight
							verticalAlignment: Text.AlignVCenter
							leftPadding: 10
						}
						onClicked: {
							let fullRecord = modelData.id + "\t" + modelData.preview;
							cliphistDecode.write(fullRecord); 
							cliphistDecode.closeStdin();
						}
					}
				}
			}
		}
	}
}
