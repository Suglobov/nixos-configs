// Lang.qml
import QtQuick
import Quickshell

Text {
	id: root

	// 1. Растягиваем по высоте родителя
	anchors.top: parent ? parent.top : undefined
	anchors.bottom: parent ? parent.bottom : undefined

	// 2. ВАЖНО: Задаем ширину по размеру букв, иначе ширина будет 0 и клик не сработает!
	width: implicitWidth

	text: {
		let layouts = Niri.keyboardLayouts;
		let idx = Niri.keyboardLayoutIdx;
		
		if (layouts && idx >= 0 && idx < layouts.length) {
			return layouts[idx];
		}
		return "..";
	}
	
	color: "#ffffff"
	font.pixelSize: 12
	font.bold: true
	verticalAlignment: Text.AlignVCenter

	MouseArea {
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		onClicked: {
      console.log('click');
			Quickshell.execDetached(["niri", "msg", "action", "switch-layout", "next"])
		}
	}
}
