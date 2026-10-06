// CrossLinesPanel.qml
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../"

PanelWindow {
	id: crossLinesPanel
	required property var screenData
	screen: screenData
	anchors.top: true
	anchors.bottom: true
	anchors.left: true
	anchors.right: true
	WlrLayershell.layer: WlrLayer.Overlay
	exclusionMode: ExclusionMode.Ignore
	color: 'transparent'
	mask: Region {}

	property var min: [screenData?.x ?? 0, screenData?.y ?? 0]
	property var max: [min[0] + screenData?.width ?? 0, min[1] + screenData?.height ?? 0]

	property var screenMousePos: [CLHelp.mousePos[0] - min[0], CLHelp.mousePos[1] - min[1]]

	property var screenDot: CLHelp.dot.includes(null) ? CLHelp.dot
		: [CLHelp.dot[0] - min[0], CLHelp.dot[1] - min[1]]

	visible: min[0] <= CLHelp.mousePos[0] && CLHelp.mousePos[0] <= max[0] && min[1] <= CLHelp.mousePos[1] && CLHelp.mousePos[1] <= max[1]

	property string activeLang: Niri?.keyboardLayouts?.[Niri?.keyboardLayoutIdx] ?? ''
	property var langConfig: {
		'Russian': '🇷🇺',
		'English (US)': '🇺🇸',
	}
	property string lang: langConfig?.[activeLang] ?? ''
	property var colors: [
		'#0000ff',
		'#0f0',
	]
	property string langColor: colors[Niri.keyboardLayoutIdx] ?? '#000'

	property int lineWidth: 1
	property string lineColor: '#00ffff'
	property var lineOpacity: 0.5

	Rectangle { // horizontal
		visible: !screenDot.includes(null)
		width: crossLinesPanel.width
		height: lineWidth
		x: height / 2
		y: screenMousePos[1]
		color: lineColor
		opacity: lineOpacity
	}
	Rectangle { // vertical
		visible: !screenDot.includes(null)
		width: lineWidth
		height: crossLinesPanel.height
		x: screenMousePos[0]
		y: width / 2
		color: lineColor
		opacity: lineOpacity
	}

	property string coordinateTextColorX: '#ffff00'
	property string coordinateTextColorY: '#00ff00'
	property string coordinateRectColor: '#222'
	property var coordinateRectOpacity: 0.7
	property int rectPadding: 2
	property int textIndent: 60
	property int shortLineLength: 40
	property int fontPixelSize: 10

	Rectangle { // horizontal short
		width: shortLineLength
		height: lineWidth
		x: screenMousePos[0] - shortLineLength / 2
		y: screenMousePos[1]
		color: lineColor
		opacity: lineOpacity
	}
	Rectangle { // vertical short
		width: lineWidth
		height: shortLineLength
		x: screenMousePos[0]
		y: screenMousePos[1] - shortLineLength / 2
		color: lineColor
		opacity: lineOpacity
	}

	Rectangle { // возле цента повернутый
		visible: !screenDot.includes(null)
		width: coordinateTextX.width + rectPadding
		height: coordinateTextX.height + rectPadding
		x: screenMousePos[0] + height >= screenData?.width ? screenMousePos[0] - height : screenMousePos[0]
		y: screenMousePos[1] - textIndent - width <= 0 ? screenMousePos[1] + textIndent * 2 : screenMousePos[1] - textIndent
		color: coordinateRectColor
		opacity: coordinateRectOpacity
		radius: 4
		transform: Rotation { angle: -90 }
		Text {
			id: coordinateTextX
			text: `↓${screenMousePos[0]}`
			color: coordinateTextColorX
			font.pixelSize: fontPixelSize
			anchors.centerIn: parent
		}
	}

	Rectangle { // возле центра не повернутый
		visible: !screenDot.includes(null)
		width: coordinateTextY.width + rectPadding
		height: coordinateTextY.height + rectPadding
		x: screenMousePos[0] + textIndent + width >= screenData?.width ? screenMousePos[0] - width - textIndent : screenMousePos[0] + textIndent
		y: screenMousePos[1] - height <= 0 ? screenMousePos[1] : screenMousePos[1] - height
		color: coordinateRectColor
		opacity: coordinateRectOpacity
		radius: 4
		Text {
			id: coordinateTextY
			text: `↓${screenMousePos[1]}`
			color: coordinateTextColorY
			font.pixelSize: fontPixelSize
			anchors.centerIn: parent
		}
	}

	/* ********** land/ */

	// Rectangle { // lang
	// 	width: langText.width + rectPadding
	// 	height: langText.height + rectPadding
	// 	x: screenMousePos[0] + textIndent + width >= screenData?.width ? screenMousePos[0] - width - textIndent : screenMousePos[0] + textIndent
	// 	y: screenMousePos[1] - textIndent <= 0 ? screenMousePos[1] + textIndent : screenMousePos[1] - textIndent
	// 	color: langColor
	// 	opacity: 0.7
	// 	radius: 2
	// 	Text {
	// 		id: langText
	// 		anchors.centerIn: parent
	// 		text: `${lang}`
	// 		font.pixelSize: 10
	// 		color: '#fff'
	// 	}
	// }

	Rectangle { // lang 2
		id: langRect2
		property int indent: 50
		width: 17
		height: 17
		// color: langColor
		color: 'transparent'
		opacity: 0.7
		radius: 2
		property real arcAngle: -Math.PI * 0.25
		property real arcAngleFrom: -Math.PI * 0.28
		property real arcAngleTo: -Math.PI * 0.22
		property int duration: 1000
		Text {
			id: langText
			anchors.centerIn: parent
			text: `${lang}`
			font.pixelSize: 14
			font.weight: Font.Bold
			color: '#0ff'
		}
		// SequentialAnimation on arcAngle {
		// 	running: true
		// 	loops: Animation.Infinite
		// 	NumberAnimation { from: langRect2.arcAngleFrom; to: langRect2.arcAngleTo; duration: langRect2.duration; easing.type: Easing.Linear; }
		// 	NumberAnimation { from: langRect2.arcAngleTo; to: langRect2.arcAngleFrom; duration: langRect2.duration; easing.type: Easing.Linear; }
		// }
		x: screenMousePos[0] + indent + width >= screenData?.width
			? screenMousePos[0] - indent * Math.cos(arcAngle) - width / 2 : screenMousePos[0] + indent * Math.cos(arcAngle) - width / 2
		y: screenMousePos[1] - indent - height <= 0
			? screenMousePos[1] - indent * Math.sin(arcAngle) - height / 2 : screenMousePos[1] + indent * Math.sin(arcAngle) - height / 2
	}

	// Canvas {
	// 	id: langCanvas
	// 	width: 80
	// 	height: 80
	// 	property real arcAngle: 0
	// 	property real arcAngleFrom: -Math.PI / 2
	// 	property real arcAngleTo: 0
	// 	property real lineWidth: 2
	// 	property int duration: 3000
	// 	property color arcColor: langColor
	// 	property int indent: 50

	// 	Timer {
	// 			running: true
	// 			repeat: true
	// 			interval: 16
	// 			onTriggered: langCanvas.requestPaint()
	// 	}

	// 	SequentialAnimation on arcAngle {
	// 			running: true
	// 			loops: Animation.Infinite
	// 			NumberAnimation { from: langCanvas.arcAngleFrom; to: langCanvas.arcAngleTo; duration: langCanvas.duration; easing.type: Easing.Linear }
	// 			NumberAnimation { from: langCanvas.arcAngleTo; to: langCanvas.arcAngleFrom; duration: langCanvas.duration; easing.type: Easing.Linear }
	// 	}

	// 	onPaint: {
	// 			var cx = width / 2
	// 			var cy = height / 2
	// 			var indent = Math.min(width, height) / 2 - lineWidth / 2

	// 			getContext("2d").save()
	// 			getContext("2d").clearRect(0, 0, width, height)
	// 			getContext("2d").strokeStyle = arcColor
	// 			getContext("2d").lineWidth = lineWidth
	// 			getContext("2d").lineCap = "round"
	// 			getContext("2d").beginPath()
	// 			getContext("2d").arc(cx, cy, indent, arcAngleFrom, arcAngle)
	// 			// getContext("2d").arc(cx, cy, indent, arcAngleFrom, arcAngleTo)
	// 			getContext("2d").stroke()
	// 			getContext("2d").restore()
	// 	}

	// 	x: screenMousePos[0] - width / 2
	// 	y: screenMousePos[1] - height / 2
	// }

	/* ********** /lang */

	/* ++++++++++ Линии и текст выделения прямоугольника */
	// Rectangle { // vertical
	// 	visible: !screenDot.includes(null)
	// 	width: lineWidth
	// 	height: screenMousePos[1] > screenDot[1] ? screenMousePos[1] - screenDot[1] : screenDot[1] - screenMousePos[1]
	// 	x: screenDot[0]
	// 	y: screenMousePos[1] > screenDot[1] ? screenDot[1] : screenMousePos[1]
	// 	color: lineColor
	// 	opacity: lineOpacity
	// }
	// Rectangle { // horizontal
	// 	visible: !screenDot.includes(null)
	// 	width: screenMousePos[0] > screenDot[0] ? screenMousePos[0] - screenDot[0] : screenDot[0] - screenMousePos[0]
	// 	height: lineWidth
	// 	x: screenMousePos[0] > screenDot[0] ? screenDot[0] : screenMousePos[0]
	// 	y: screenDot[1]
	// 	color: lineColor
	// 	opacity: lineOpacity
	// }
	// Rectangle { // расстояние до от dot до курсора в прямой подсказке
	// 	visible: CLHelp.dotHintVisible
	// 	width: dotHint.width + rectPadding
	// 	height: dotHint.height + rectPadding
	// 	x: screenMousePos[0] > screenDot[0] ? screenDot[0] : screenDot[0] - width
	// 	y: screenMousePos[1] > screenDot[1] ? screenDot[1] - height : screenDot[1]
	// 	color: coordinateRectColor
	// 	opacity: coordinateRectOpacity
	// 	radius: 4
	// 	Text {
	// 		id: dotHint
	// 		anchors.centerIn: parent
	// 		text: `↕${Math.abs(screenMousePos[1] - screenDot[1])}`
	// 		color: coordinateTextColorY
	// 	}
	// }
	// Rectangle { // расстояние до от dot до курсора в повернутой подсказке
	// 	visible: CLHelp.dotHintVisible
	// 	width: dotHintAngle.width + rectPadding
	// 	height: dotHintAngle.height + rectPadding
	// 	x: screenMousePos[0] > screenDot[0] ? screenDot[0] - height : screenDot[0]
	// 	y: screenMousePos[1] > screenDot[1] ? screenDot[1] + width : screenDot[1]
	// 	color: coordinateRectColor
	// 	opacity: coordinateRectOpacity
	// 	radius: 4
	// 	transform: Rotation { angle: -90 }
	// 	Text {
	// 		id: dotHintAngle
	// 		anchors.centerIn: parent
	// 		text: `↕${Math.abs(screenMousePos[0] - screenDot[0])}`
	// 		color: coordinateTextColorX
	// 	}
	// }
	/* ---------- */

	// Rectangle { // cross
	// 	width: crossText.width + rectPadding
	// 	height: crossText.height + rectPadding
	// 	x: screenMousePos[0] - width / 2
	// 	y: screenMousePos[1] - height / 2
	// 	color: 'transparent'
	// 	Text {
	// 		id: crossText
	// 		anchors.centerIn: parent
	// 		text: `❌`
	// 		font.pixelSize: 100
		// 	}
	// }

	// круг
	// Rectangle {
	// 	visible: !screenDot.includes(null)
	// 	width: Math.abs(screenMousePos[0] - screenDot[0])
	// 	height: width
	// 	x: screenDot[0]
	// 	y: screenDot[1]
	// 	radius: 10000
	// 	color: 'transparent'
	// 	border.width: 1
	// 	border.color: lineColor
	// 	opacity: lineOpacity
	// }


	// Rectangle {
	// 	id: cursorCircle
	// 	width: 500
	// 	height: 500
	// 	radius: 1000
	// 	opacity: 0.5
	// 	border.width: 1
	// 	border.color: '#ffffff'
	// 	color: 'transparent'
	// 	x: CLHelp.mousePos[0] - crossLinesPanel.min[0] - width / 2
	// 	y: CLHelp.mousePos[1] - crossLinesPanel.min[1] - height / 2
	// }

	// Rectangle {
	// 	id: cursorCircle
	// 	// width: 1000
	// 	// height: 1000
	// 	radius: 1000
	// 	opacity: 0.1
	// 	border.width: 10
	// 	border.color: '#55ffffff'
	// 	color: 'transparent'

	// 	onWidthChanged: {
	// 		x = CLHelp.mousePos[0] - crossLinesPanel.min[0] - width / 2
	// 		y = CLHelp.mousePos[1] - crossLinesPanel.min[1] - height / 2
	// 	}
	// 	onHeightChanged: {
	// 		x = CLHelp.mousePos[0] - crossLinesPanel.min[0] - width / 2
	// 		y = CLHelp.mousePos[1] - crossLinesPanel.min[1] - height / 2
	// 	}

	// 	SequentialAnimation {
	// 		running: true
	// 		loops: Animation.Infinite

	// 		// ParallelAnimation {
	// 		// 	NumberAnimation { target: cursorCircle; property: 'width'; from: 500; to: 0; duration: 2000 }
	// 		// 	NumberAnimation { target: cursorCircle; property: 'height'; from: 500; to: 0; duration: 2000 }
	// 		// }
	// 		ParallelAnimation {
	// 			NumberAnimation { target: cursorCircle; property: 'width'; from: 0; to: 1000; duration: 2000 }
	// 			NumberAnimation { target: cursorCircle; property: 'height'; from: 0; to: 1000; duration: 2000 }
	// 		}
	// 	}
	// }

}
