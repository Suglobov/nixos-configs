//	Windows.qml
import	QtQuick
import	Quickshell

Row	{
	id:	root
	required	property	var	screenData
	property	int	radiusEmpty:	10
	property	int	radius2:	2
	spacing:	6
	height:	parent.height
	anchors.centerIn:	parent

	Repeater	{
		model:	Niri.wsByOutput[screenData?.name]
		delegate:	Ws {
			wsId: modelData
		}
	}
}
