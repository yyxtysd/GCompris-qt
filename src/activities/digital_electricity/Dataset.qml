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
    property variant zero: {
        'imageName': 'zero.svg',
        'componentSource': 'Zero.qml',
        'width': 0.12,
        'height': 0.2,
        'toolTipText': qsTr("Zero input")
    }
    property variant one: {
        'imageName': 'one.svg',
        'componentSource': 'One.qml',
        'width': 0.12,
        'height': 0.2,
        'toolTipText': qsTr("One input")
    }
    property variant digitalLight: {
        'imageName': 'DigitalLightOff.svg',
        'componentSource': 'DigitalLight.qml',
        'width': 0.12,
        'height': 0.12,
        'toolTipText': qsTr("Digital Light")
    }
    // tutorial levels
    property var tutorialLevels: [
        // level 1
        {
            totalComponents: 3,
            imageName: [zero.imageName, one.imageName, digitalLight.imageName],
            componentSource: [zero.componentSource, one.componentSource, digitalLight.componentSource],
            imgWidth: [zero.width, one.width, digitalLight.width],
            imgHeight: [zero.height, one.height, digitalLight.height],
            toolTipText: [zero.toolTipText, one.toolTipText, digitalLight.toolTipText],
            introMessage: [
                qsTr("The Digital light will glow when it's terminal is connected with an input of 1"),
                qsTr("Turn the Digital light on using the inputs provided")
            ]
        }
    ]
}
