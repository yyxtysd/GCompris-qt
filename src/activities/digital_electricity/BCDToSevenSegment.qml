/* GCompris - BCDToSevenSegment.qml
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
    id: bcdTosevenSegment
    property variant code
    height: parent.height
    width: parent.width

    Image {
        source: Activity.url + (code[0] == 1 ? "BCDTo7SegmentA_red.svgz" : "BCDTo7SegmentA_black.svgz")
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
        mipmap: true
        antialiasing: true
    }

    Image {
        source: Activity.url + (code[1] == 1 ? "BCDTo7SegmentB_red.svgz" : "BCDTo7SegmentB_black.svgz")
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
        mipmap: true
        antialiasing: true
    }

    Image {
        source: Activity.url + (code[2] == 1 ? "BCDTo7SegmentC_red.svgz" : "BCDTo7SegmentC_black.svgz")
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
        mipmap: true
        antialiasing: true
    }

    Image {
        source: Activity.url + (code[3] == 1 ? "BCDTo7SegmentD_red.svgz" : "BCDTo7SegmentD_black.svgz")
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
        mipmap: true
        antialiasing: true
    }

    Image {
        source: Activity.url + (code[4] == 1 ? "BCDTo7SegmentE_red.svgz" : "BCDTo7SegmentE_black.svgz")
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
        mipmap: true
        antialiasing: true
    }

    Image {
        source: Activity.url + (code[5] == 1 ? "BCDTo7SegmentF_red.svgz" : "BCDTo7SegmentF_black.svgz")
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
        mipmap: true
        antialiasing: true
    }

    Image {
        source: Activity.url + (code[6] == 1 ? "BCDTo7SegmentG_red.svgz" : "BCDTo7SegmentG_black.svgz")
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
        mipmap: true
        antialiasing: true
    }
}
