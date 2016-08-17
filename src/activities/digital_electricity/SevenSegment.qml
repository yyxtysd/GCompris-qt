/* GCompris - SevenSegment.qml
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
import QtQuick 2.3
import "digital_electricity.js" as Activity

import GCompris 1.0

Item {
    id: sevenSegment
    property variant code
    height: parent.height
    width: parent.width

    Image {
        source: Activity.url + "sevenSegmentDisplayA.svg"
        visible: code[0] == 1
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
    }

    Image {
        source: Activity.url + "sevenSegmentDisplayB.svg"
        visible: code[1] == 1
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
    }

    Image {
        source: Activity.url + "sevenSegmentDisplayC.svg"
        visible: code[2] == 1
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
    }

    Image {
        source: Activity.url + "sevenSegmentDisplayD.svg"
        visible: code[3] == 1
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
    }

    Image {
        source: Activity.url + "sevenSegmentDisplayE.svg"
        visible: code[4] == 1
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
    }

    Image {
        source: Activity.url + "sevenSegmentDisplayF.svg"
        visible: code[5] == 1
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
    }

    Image {
        source: Activity.url + "sevenSegmentDisplayG.svg"
        visible: code[6] == 1
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
    }
}
