import QtQuick 2.15
import QtQuick.Shapes 1.15
import Quickshell
import Quickshell.Wayland

PanelWindow {
	id: cursorOverlay
	
	anchors.top: true
	anchors.bottom: true
	anchors.left: true
	anchors.right: true
	
	color: "transparent"
	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

	property real mouseX: 0
	property real mouseY: 0

	mask: Region {
		item: clickHole
		intersection: Intersection.Xor
	}

	MouseArea {
		id: mouseTracker
		anchors.fill: parent
		hoverEnabled: true

		onPositionChanged: (mouse) => {
			cursorOverlay.mouseX = mouse.x
			cursorOverlay.mouseY = mouse.y
		}

		// 1. Скрытый маркер для вырезания сквозного отверстия под клики
		Item {
			id: clickHole
			width: 6
			height: 6
			x: cursorOverlay.mouseX - width / 2
			y: cursorOverlay.mouseY - height / 2
		}

		// 2. ВНУТРЕННЕЕ КОЛЬЦО (Мгновенное у мыши)
		Rectangle {
			id: staticInnerRing
			width: 14
			height: 14
			radius: 7
			color: "transparent"
			border.width: 1.5
			border.color: "#0db9d7"
			
			x: cursorOverlay.mouseX - width / 2
			y: cursorOverlay.mouseY - height / 2
		}

		// 3. ВНЕШНЕЕ КОЛЬЦО (С задержкой 160мс)
		Rectangle {
			id: dynamicOuterRing
			width: 26
			height: 26
			radius: 13
			color: "transparent"
			border.width: 1.5
			border.color: "#0db9d7"

			x: cursorOverlay.mouseX - width / 2
			y: cursorOverlay.mouseY - height / 2

			Behavior on x { PropertyAnimation { duration: 160; easing.type: Easing.OutCubic } }
			Behavior on y { PropertyAnimation { duration: 160; easing.type: Easing.OutCubic } }
		}

		// 4. ДИНАМИЧЕСКАЯ ЖИДКАЯ ПЕРЕМЫЧКА
		Shape {
			id: gooeyBridge
			anchors.fill: parent
			layer.enabled: true
			layer.samples: 4

			// Центры колец
			property real cx1: staticInnerRing.x + 7
			property real cy1: staticInnerRing.y + 7
			property real cx2: dynamicOuterRing.x + 13
			property real cy2: dynamicOuterRing.y + 13
			
			// Расстояние
			property real dist: Math.sqrt(Math.pow(cx2 - cx1, 2) + Math.pow(cy2 - cy1, 2))
			
			// Угол между центрами колец (Перенесено сюда для реактивности движка)
			property real angle: Math.atan2(cy2 - cy1, cx2 - cx1)

			// Точки соприкосновения на окружности 1 (Внутренней, r = 7)
			property real p1x: cx1 + 7 * Math.cos(angle + Math.PI / 2)
			property real p1y: cy1 + 7 * Math.sin(angle + Math.PI / 2)
			property real p2x: cx1 + 7 * Math.cos(angle - Math.PI / 2)
			property real p2y: cy1 + 7 * Math.sin(angle - Math.PI / 2)

			// Точки соприкосновения на окружности 2 (Внешней, r = 13)
			property real p3x: cx2 + 13 * Math.cos(angle - Math.PI / 2)
			property real p3y: cy2 + 13 * Math.sin(angle - Math.PI / 2)
			property real p4x: cx2 + 13 * Math.cos(angle + Math.PI / 2)
			property real p4y: cy2 + 13 * Math.sin(angle + Math.PI / 2)

			// Разрыв мембраны, если мышь улетела слишком далеко
			visible: dist < 60

			ShapePath {
				strokeColor: "#0db9d7"
				strokeWidth: 1.5
				fillColor: "transparent"

				// Привязка геометрии путей к реактивным свойствам родительского Shape
				startX: gooeyBridge.p1x
				startY: gooeyBridge.p1y

				PathLine { x: gooeyBridge.p2x; y: gooeyBridge.p2y }

				// Вогнутая дуга Безье к нижней точке внешнего кольца
				PathQuad {
					x: gooeyBridge.p3x
					y: gooeyBridge.p3y
					controlX: (gooeyBridge.p2x + gooeyBridge.p3x) / 2 - (gooeyBridge.dist * 0.15) * Math.sin(gooeyBridge.angle)
					controlY: (gooeyBridge.p2y + gooeyBridge.p3y) / 2 + (gooeyBridge.dist * 0.15) * Math.cos(gooeyBridge.angle)
				}

				PathLine { x: gooeyBridge.p4x; y: gooeyBridge.p4y }

				// Вогнутая дуга Безье обратно к стартовой точке
				PathQuad {
					x: gooeyBridge.p1x
					y: gooeyBridge.p1y
					controlX: (gooeyBridge.p4x + gooeyBridge.p1x) / 2 + (gooeyBridge.dist * 0.15) * Math.sin(gooeyBridge.angle)
					controlY: (gooeyBridge.p4y + gooeyBridge.p1y) / 2 - (gooeyBridge.dist * 0.15) * Math.cos(gooeyBridge.angle)
				}
			}
		}
	}
}
