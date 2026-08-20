// Win.qml
import QtQuick
import Quickshell
import "../"

Rectangle	{
	id:	winRect
	property	int	winId
	property	int	winHeight

	readonly	property	var	window:	Niri.winById[winId]
	readonly	property	bool	isFocused:	Niri.winFocusedId	===	window.id
	readonly	property	bool	isUrgent:	Niri.winUrgentIds.has(window.id)
	visible:	!!winId
	width:	winHeight
	height:	winHeight
	color:	'transparent'
	// border.width: 1
	border.color: 'transparent'
	
	Image	{
		id:	windowIcon
		anchors.centerIn:	parent
		height:	winRect.height	*	0.9
		width:	height
		fillMode:	Image.PreserveAspectFit
		smooth:	true
		mipmap:	true
		sourceSize.height:	height
		sourceSize.width:	width
		source:	Quickshell.iconPath(window.app_id.toLowerCase())
	}

	Rectangle	{
		id:	winRectLine
		anchors.horizontalCenter:	parent.horizontalCenter
		anchors.bottom:	parent.bottom
		width:	parent.width	*	0.23
		height:	width
		color:	isFocused	?	'#ff0'	:	isUrgent	?	'#f00'	:	'transparent'
		Behavior	on	color	{	ColorAnimation	{	duration:	300	}	}
	}

	MouseArea	{
		anchors.fill:	parent
		cursorShape:	Qt.PointingHandCursor
		//	propagateComposedEvents:	true
		onClicked:	(mouse)	=>	{
			mouse.accepted	=	false
			Quickshell.execDetached(["niri",	"msg",	"action",	"focus-window",	"--id",	window.id])
		}
	}
}
