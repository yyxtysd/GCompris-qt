/* GCompris - Component.qml
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

Image {
    id: electricalComponent
    property QtObject pieceParent
    property string imgSrc
    property double posX
    property double posY
    property double imgWidth
    property double imgHeight
    property int index
    property string toolTipTxt
    property int rotationAngle
    property int initialAngle
    property int output

    property alias rotateComponent: rotateComponent

    x: posX * parent.width
    y: posY * parent.height
    width: imgWidth * parent.width
    height: imgHeight * parent.height
    fillMode: Image.PreserveAspectFit
    state: "Initial"
    opacity: 1.0
    source: Activity.url + imgSrc
    z: 2

    onPaintedWidthChanged: {updateDragConstraints()}

    //SequentialAnimation {
        //id: rotateComponent
        //loops: Animation.Infinite
        PropertyAnimation {
            id: rotateComponent
            target: electricalComponent
            property: "rotation"
            from: initialAngle; to: rotationAngle
            duration: 750
            onStarted:{Activity.animationInProgress = true}
            onStopped: {
                Activity.animationInProgress = false
                updateDragConstraints()
            }
            easing.type: Easing.InOutQuad
        }
    //}

    function updateDragConstraints() {
        if(rotationAngle == 0 || rotationAngle == 180 || rotationAngle == 360 || rotationAngle == -360
           || rotationAngle == -180) {
            mouseArea.drag.minimumX = (electricalComponent.paintedWidth - electricalComponent.width)/2
            mouseArea.drag.minimumY = (electricalComponent.paintedHeight - electricalComponent.height)/2

            mouseArea.drag.maximumX = electricalComponent.parent.width -
                                      (electricalComponent.width + electricalComponent.paintedWidth)/2
            mouseArea.drag.maximumY = electricalComponent.parent.height -
                                      (electricalComponent.height + electricalComponent.paintedHeight)/2
        }
        else {
            mouseArea.drag.minimumX = (electricalComponent.paintedHeight - electricalComponent.width)/2
            mouseArea.drag.minimumY = (electricalComponent.paintedWidth - electricalComponent.height)/2

            mouseArea.drag.maximumX = electricalComponent.parent.width -
                                      (electricalComponent.width + electricalComponent.paintedHeight)/2
            mouseArea.drag.maximumY = electricalComponent.parent.height -
                                      (electricalComponent.height + electricalComponent.paintedWidth)/2
        }
        //console.log("mouseArea",mouseArea.drag.minimumX,mouseArea.drag.minimumY)
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: electricalComponent
        //drag.minimumX: 0
        //drag.maximumX: electricalComponent.parent.width - (electricalComponent.width + electricalComponent.paintedWidth)/2
        //drag.minimumY: 0
        //drag.maximumY: (!parent && !parent.parent) ? (parent.parent.height - parent.height) : 0
        onPressed: {
            if(Activity.toolDelete) {
                Activity.updateToolTip("")
                Activity.removeComponent(index)
            }
            else {
                Activity.updateToolTip(toolTipTxt)
                Activity.componentSelected(index)
            }
        }
        onReleased: {
            /*
            console.log(parent.y, parent.height,parent.width,parent.height - parent.width/2)
            console.log(parent.paintedHeight,parent.paintedWidth)
            console.log("mouseArea",mouseArea.drag.minimumX,mouseArea.drag.minimumY)
            if(initialAngle == 0 || initialAngle == 180) {
                if ((parent.parent.height - parent.y > parent.paintedHeight) &&
                    (parent.parent.width - parent.x > parent.paintedWidth) && parent.x > 0 && parent.y > 0) {
                    parent.posX = parent.x / parent.parent.width
                    parent.posY = parent.y / parent.parent.height
                }
            }
            else if ((parent.parent.height - parent.y > parent.paintedHeight/2) &&
                     (parent.parent.width - parent.x > parent.paintedWidth/2) &&
                      parent.x > (parent.paintedHeight/2 - parent.paintedWidth/2) && parent.y > 0)  {
                parent.posX = parent.x / parent.parent.width
                parent.posY = parent.y / parent.parent.height
            }
            */
            parent.posX = parent.x / parent.parent.width
            parent.posY = parent.y / parent.parent.height
            parent.x = Qt.binding(function() { return parent.posX * parent.parent.width })
            parent.y = Qt.binding(function() { return parent.posY * parent.parent.height })
            Activity.updateToolTip("")
        }
    }
}
