// Ws.qml
import QtQuick
import Quickshell
import "../"

Rectangle	{
  id:	workspaceRect
  property	int	wsId
  readonly	property	bool	isFocused:	Niri.wsFocusedId	===	wsId
  readonly	property	bool	isActive:	Niri.wsActiveIds.has(wsId)
  readonly	property	bool	isUrgent:	Niri.wsUrgentIds.has(wsId)
  readonly	property	bool	isEmpty:	!Niri.winPosByWs[wsId]?.length	>	0	&&	!Niri.winTileByWs[wsId]?.length	>	0

  property	int	radiusEmpty:	10
	property	int	radius2:	2

  anchors.verticalCenter:	parent.verticalCenter
  radius:	isEmpty	?	radiusEmpty	:	radius2
  width:	(windowsContainer?.implicitWidth	??	0)	+	(isEmpty	?	(parent.height	*	0.5)	:	6)
  height:	(isEmpty	?	width	:	parent.height)
  //	color:	isFocused	?	'#88ffff00'	:	'transparent'
  color:	'transparent'
  border	{
    width:	isUrgent	?	2
      :	isFocused	?	2
      :	isActive	?	2
      :	1
    color:	isUrgent	?	'#f00'
      :	isFocused	?	'#ff0'
      :	isActive	?	'#ff00ffff'
      :	'#666'
    Behavior	on	color	{	ColorAnimation	{	duration:	300	}	}
  }

  MouseArea	{
    anchors.fill:	parent
    cursorShape:	Qt.PointingHandCursor
    onClicked:	{
      var	idx	=	Niri.wsById[wsId].idx
      Quickshell.execDetached(["niri",	"msg",	"action",	"focus-workspace",	idx])
    }
  }

  Row	{
    id:	windowsContainer
    anchors.centerIn:	parent
    height:	parent.height
    spacing:	0
    // z:	1

    Rectangle	{
      id:	floatingContainer
      readonly	property	var	floatingWins:	Niri.winTileByWs[wsId]
      visible:	floatingWins?.length	>	0
      width:	visible	?	(floatingRow.implicitWidth	+	4)	:	0
      height:	workspaceRect.height	-	6
      anchors.verticalCenter:	parent.verticalCenter
      color:	'transparent'
      border.width:	4
      border.color:	'#ff00ffff'
      radius:	radius2
      Row	{
        id:	floatingRow
        anchors.centerIn:	parent
        spacing:	1
        Repeater	{
          model:	Niri.winTileByWs[wsId]
          delegate:	Win	{
            winId:	modelData
            winHeight:	floatingContainer.height
          }
        }
      }
    }

    Repeater	{
      model:	Niri.winPosByWs[wsId]	//	не плавающие	колонки	воркспейса
      delegate:	Rectangle	{
        id:	columnRect
        readonly	property	var	workspaceColumn:	modelData
        anchors.verticalCenter:	parent.verticalCenter
        width:	(windowsColumn	?	windowsColumn.implicitWidth	:	0)
        height:	workspaceRect.height	-	4
        color:	'transparent'
        //	border.width:	modelData.length	>	1	?	2	:	0
        border.width:	0
        // border.color:	'#0ff'
        // radius:	radius2

        Rectangle	{
          anchors.horizontalCenter:	parent.horizontalCenter
          anchors.top:	parent.top
          //	anchors.left:	parent.left
          //	anchors.right:	parent.right
          anchors.topMargin:	1
          width:	parent.width	*	0.9
          // если в колонке больше 1 окна
          height:	workspaceColumn.length	>	1	?	2	:	0
          radius:	0
          //	color:	'transparent'
          color:	'#aa00ff00'
        }

        Row	{
          id:	windowsColumn
          //	property	int	rowIndex:	index
          Repeater	{
            model:	workspaceColumn	//	колонка	с	окнами
            delegate:	Win	{
              winId:	modelData
              winHeight:	columnRect.height
            }
          }
        }
      }
    }
  }
}