import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

ShellRoot {
	id: root

	property int mouseX: 0
	property int mouseY: 0
	property bool isCalibrated: false

	// ================= АВТОМАТИЧЕСКИЙ ПОТОК LIBINPUT =================
Process {
	command: ["libinput", "debug-events"]
	running: root.isCalibrated
	
	stdout: SplitParser {
		onRead: (line) => {
			if (!line || !line.includes("POINTER_MOTION")) return;

			// Универсальная регулярка: \s одинаково хорошо ловит и табы, и пробелы из вывода libinput.
			// Группы 1 и 2 — это dx и dy, которые мы ищем.
			var regex = /\s+([0-9.-]+)\/\s*([0-9.-]+)\s+\(\s*([0-9.+-]+)\/\s*([0-9.+-]+)\)/;
			var match = line.match(regex);

			if (match && match.length >= 5) {
				// Извлекаем ускоренные значения, которые соответствуют движению курсора
				var dx = parseFloat(match[1]);
				var dy = parseFloat(match[2]);

				// Рассчитываем новые координаты перекрестия
				var newX = root.mouseX + dx;
				var newY = root.mouseY + dy;

				// Ограничиваем движение в пределах видимой панели
				root.mouseX = Math.max(0, Math.min(panel.width, newX));
				root.mouseY = Math.max(0, Math.min(panel.height, newY));
			}
		}
	}
}


	// ================= ОКНО ОВЕРЛЕЯ НА ВЕСЬ ЭКРАН =================
	PanelWindow {
		id: panel
		
		anchors.top: true
		anchors.bottom: true
		anchors.left: true
		anchors.right: true

		WlrLayershell.layer: WlrLayer.Overlay
		color: 'transparent'
		
		// НАДЕЖНАЯ ДИНАМИЧЕСКАЯ МАСКА:
		// До калибровки — ловит ховер на весь экран.
		// После калибровки — сжимается в 0, полностью освобождая экран для кликов.
		mask: Region {
			x: 0
			y: 0
			width: root.isCalibrated ? 0 : panel.width
			height: root.isCalibrated ? 0 : panel.height
		}

		MouseArea {
			anchors.fill: parent
			hoverEnabled: !root.isCalibrated
			acceptedButtons: Qt.NoButton 

			onPositionChanged: (mouse) => {
				if (!root.isCalibrated) {
					root.mouseX = mouse.x;
					root.mouseY = mouse.y;
					root.isCalibrated = true;
					console.log("Стартовая позиция поймана: X=" + mouse.x + " Y=" + mouse.y);
				}
			}
		}

		// ================= ГРАФИКА НАПРАВЛЯЮЩИХ (БЕЗ СГЛАЖИВАНИЯ) =================

		Rectangle {
			id: horizontalLine
			width: panel.width
			height: 1 
			color: "#00ffcc"
			opacity: 0.4 
			x: 0
			y: root.mouseY
		}

		Rectangle {
			id: verticalLine
			width: 1
			height: panel.height
			color: "#00ffcc"
			opacity: 0.4
			x: root.mouseX
			y: 0
		}

		Rectangle {
			width: 6
			height: 6
			radius: 3
			color: "#00ffcc"
			opacity: 0.7
			x: root.mouseX - 3
			y: root.mouseY - 3
		}
	}
}
