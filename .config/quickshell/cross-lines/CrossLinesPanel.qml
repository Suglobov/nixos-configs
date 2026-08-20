// CrossLinesPanel.qml
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

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

  property var logical: CLHelp.outputs?.[screenData.name]?.logical ?? {}

  property var min: [logical?.x ?? 0, logical?.y ?? 0]
  property var max: [min[0] + logical?.width ?? 0, min[1] + logical?.height ?? 0]

  property var screenMousePos: [CLHelp.mousePos[0] - min[0], CLHelp.mousePos[1] - min[1]]

  property var screenDot: CLHelp.dot.includes(null) ? CLHelp.dot
    : [CLHelp.dot[0] - min[0], CLHelp.dot[1] - min[1]]

  visible: min[0] <= CLHelp.mousePos[0] && CLHelp.mousePos[0] <= max[0] && min[1] <= CLHelp.mousePos[1] && CLHelp.mousePos[1] <= max[1]

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
  property string coordinateRectColor: '#555'
  property var coordinateRectOpacity: 0.7
  property int rectPadding: 5
  property int textIndent: 60

  Rectangle { // horizontal short
    width: textIndent
    height: lineWidth
    x: screenMousePos[0] - textIndent / 2
    y: screenMousePos[1]
    color: lineColor
    opacity: lineOpacity
  }
  Rectangle { // vertical short
    width: lineWidth
    height: textIndent
    x: screenMousePos[0]
    y: screenMousePos[1] - textIndent / 2
    color: lineColor
    opacity: lineOpacity
  }

  Rectangle { // возле цента повернутый
    width: coordinateTextX.width + rectPadding
    height: coordinateTextX.height + rectPadding
    x: screenMousePos[0] + height >= logical?.width ? screenMousePos[0] - height : screenMousePos[0]
    y: screenMousePos[1] - textIndent - width <= 0 ? screenMousePos[1] + textIndent * 2 : screenMousePos[1] - textIndent
    color: coordinateRectColor
    opacity: coordinateRectOpacity
    radius: 4
    transform: Rotation { angle: -90 }
    Text {
      id: coordinateTextX
      text: `${screenMousePos[0]}`
      color: coordinateTextColorX
      anchors.centerIn: parent
    }
  }

  Rectangle { // возле центра не повернутый
    width: coordinateTextY.width + rectPadding
    height: coordinateTextY.height + rectPadding
    x: screenMousePos[0] + textIndent + width >= logical?.width ? screenMousePos[0] - width - textIndent : screenMousePos[0] + textIndent
    y: screenMousePos[1] - height <= 0 ? screenMousePos[1] : screenMousePos[1] - height
    color: coordinateRectColor
    opacity: coordinateRectOpacity
    radius: 4
    Text {
      id: coordinateTextY
      text: `${screenMousePos[1]}`
      color: coordinateTextColorY
      anchors.centerIn: parent
    }
  }


  /* ++++++++++ Линии и текст выделения прямоугольника */
  Rectangle { // vertical
    visible: !screenDot.includes(null)
    width: lineWidth
    height: screenMousePos[1] > screenDot[1] ? screenMousePos[1] - screenDot[1] : screenDot[1] - screenMousePos[1]
    x: screenDot[0]
    y: screenMousePos[1] > screenDot[1] ? screenDot[1] : screenMousePos[1]
    color: lineColor
    opacity: lineOpacity
  }
  Rectangle { // horizontal
    visible: !screenDot.includes(null)
    width: screenMousePos[0] > screenDot[0] ? screenMousePos[0] - screenDot[0] : screenDot[0] - screenMousePos[0]
    height: lineWidth
    x: screenMousePos[0] > screenDot[0] ? screenDot[0] : screenMousePos[0]
    y: screenDot[1]
    color: lineColor
    opacity: lineOpacity
  }
  Rectangle { // расстояние до от dot до курсора в прямой подсказке
    visible: CLHelp.dotHintVisible
    width: dotHint.width + rectPadding
    height: dotHint.height + rectPadding
    x: screenMousePos[0] > screenDot[0] ? screenDot[0] : screenDot[0] - width
    y: screenMousePos[1] > screenDot[1] ? screenDot[1] - height : screenDot[1]
    color: coordinateRectColor
    opacity: coordinateRectOpacity
    radius: 4
    Text {
      id: dotHint
      anchors.centerIn: parent
      text: `${Math.abs(screenMousePos[1] - screenDot[1])}`
      color: coordinateTextColorY
    }
  }
  Rectangle { // расстояние до от dot до курсора в повернутой подсказке
    visible: CLHelp.dotHintVisible
    width: dotHintAngle.width + rectPadding
    height: dotHintAngle.height + rectPadding
    x: screenMousePos[0] > screenDot[0] ? screenDot[0] - height : screenDot[0]
    y: screenMousePos[1] > screenDot[1] ? screenDot[1] + width : screenDot[1]
    color: coordinateRectColor
    opacity: coordinateRectOpacity
    radius: 4
    transform: Rotation { angle: -90 }
    Text {
      id: dotHintAngle
      anchors.centerIn: parent
      text: `${Math.abs(screenMousePos[0] - screenDot[0])}`
      color: coordinateTextColorX
    }
  }
  /* ---------- */

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
  // 		// 	NumberAnimation { target: cursorCircle; property: "width"; from: 500; to: 0; duration: 2000 }
  // 		// 	NumberAnimation { target: cursorCircle; property: "height"; from: 500; to: 0; duration: 2000 }
  // 		// }
  // 		ParallelAnimation {
  // 			NumberAnimation { target: cursorCircle; property: "width"; from: 0; to: 1000; duration: 2000 }
  // 			NumberAnimation { target: cursorCircle; property: "height"; from: 0; to: 1000; duration: 2000 }
  // 		}
  // 	}
  // }
  
}
