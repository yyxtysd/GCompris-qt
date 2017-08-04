/* GCompris - Dataset.qml
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
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

QtObject {
    // tutorial levels
    property var tutorialLevels: [
        // level 1
        {
            totalComponents: 3,
            imageName: ["zero.svg", "one.svg", "DigitalLightOff.svg"],
            componentSource: ["Zero.qml", "One.qml", "DigitalLight.qml"],
            imgWidth: [0.12, 0.12, 0.12],
            imgHeight: [0.2, 0.2, 0.12],
            toolTipText: [
                qsTr("Zero input"),
                qsTr("One input"),
                qsTr("Digital Light")
            ]
        }
    ]
}
