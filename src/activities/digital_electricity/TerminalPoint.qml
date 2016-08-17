/* GCompris - TerminalPoint.qml
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import "digital_electricity.js" as Activity

import GCompris 1.0

Rectangle {
    id: terminalPoint

    property double posX
    property double posY
    property double size: parent.terminalSize
    property bool selected: false
    property string type
    property int value: -1
    property int index
    property int componentIndex
    property variant wireIndex: []

    width: size * parent.paintedHeight
    height: size * parent.paintedHeight
    radius: width / 2
    color: "Black"

    x: (parent.width - parent.paintedWidth) / 2 + posX * parent.paintedWidth - width / 2
    y: (parent.height - parent.paintedHeight) / 2 + posY * parent.paintedHeight - height / 2

    //property variant coord: parent.parent.mapFromItem(terminalPoint, terminalPoint.x + width / 2, terminalPoint.y + height / 2)

    property double xCenter: terminalPoint.parent.x + terminalPoint.x + width/2
    property double yCenter: terminalPoint.parent.y + terminalPoint.y + height/2
    //property double xCenterFromComponent: terminalPoint.parent.x + terminalPoint.parent.width / 2 - xCenter
    //property double yCenterFromComponent: terminalPoint.parent.y + terminalPoint.parent.height / 2 - yCenter
    property double xCenterFromComponent: terminalPoint.x + width/2 - terminalPoint.parent.width / 2
    property double yCenterFromComponent: terminalPoint.y + height/2 - terminalPoint.parent.height / 2

    Rectangle {
        id: boundary
        anchors.centerIn: terminalPoint
        width: terminalPoint.width * 1.4
        height: width
        visible: selected
        radius: width / 2
        color: "green"
        z: -1
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: {
            selected = true
            //console.log("Pressed Terminal",index,type,value)
            Activity.terminalPointSelected(index)
            //parent.parent.parent.moveFromX = parent.parent.x + mouseX
            //parent.parent.parent.moveFromY = parent.parent.y + mouseY
        }
        /*
        onPositionChanged: {
            parent.parent.parent.moveToX = parent.parent.x + mouseX
            parent.parent.parent.moveToY = parent.parent.y + mouseY
            //console.log(parent.parent.parent.moveToX,parent.parent.parent.moveToY)
            //console.log(parent.parent.x + mouseX,parent.parent.y + mouseY)
            parent.parent.parent.requestPaint()
        }*/
    }
}
