// shell.qml
import QtQuick
import Quickshell
import Quickshell.Wayland
import "./workspaces_panel"
import "./cross_lines"

ShellRoot {
	Variants {
		model: Quickshell.screens
		delegate: Item {
			required property var modelData
			LangColorPanel {
				screenData: modelData
			}
			WorkspacesPanel {
				screenData: modelData
			}
			CrossLinesPanel {
				screenData: modelData
			}
		}
	}
}
