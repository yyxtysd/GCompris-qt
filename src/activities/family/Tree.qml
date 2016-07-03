/* GCompris - Tree.qml
 *
 * Copyright (C) RAJDEEP KAUR <rajdeep.kaur@kde.org> (Qt Quick port)
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *   RAJDEEP KAUR <rajdeep.kaur@kde.org> (Qt Quick port)
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
import GCompris 1.0
import "../../core"
import "family.js" as Activity

Item {
    id: tree
    property int searchitem: -1
    property alias recwidth: content.width
    property alias recheight: content.height
    property string nodeimagesource: nodeimage.source
    property string bordercolor: content.border.color
    property real borderwidth: content.border.width
    property string colorr: content.color
    property alias radius: content.radius

    Rectangle {
        id: content
        color: colorr
        width: recwidth
        height: recheight
        border.color: bordercolor
        border.width: borderwidth
        radius: radius
        Image {
            id: nodeimage
            source: searchitem === -1 ? "qrc:/gcompris/src/activities/lang/resource/imageid-bg.svg" : nodeimagesource
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width*0.6
            height: parent.height*0.6

        }
    }
}
