/* GCompris - Oware.qml
 *
 * Copyright (C) 2017 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Frederic Mazzarol (GTK+ version)
 *   Divyam Madaan <divyam3897@gmail.com> (Qt Quick port)
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
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "oware.js" as Activity

Image {
    id: playerScoreBox
    source: Activity.url + "/score.png"

    property int playerScore

    Flow {
        width: parent.width
        height: parent.height
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: parent.width * 0.15
            topMargin: parent.height * 0.15
            right: parent.right
            rightMargin: parent.width * 0.15
            bottom: parent.bottom
            bottomMargin: parent.height * 0.2
        }

        Repeater {
            id: playerScoreRepeater
            model: playerScore

            Image {
                id: playerSeedsImage
                source: Activity.url + "grain2.png"
                height: board.width * (1 / 7.25) * 0.17
                width: board.width * (1 / 7.25) * 0.17
            }
        }
    }

    GCText {
        id: playerScoreText
        color: "white"
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        fontSize: smallSize
        text: playerScore
        horizontalAlignment: Text.AlignHCenter
        rotation: (background.width > background.height) ? 0 : 270
        wrapMode: TextEdit.WordWrap
    }
}
