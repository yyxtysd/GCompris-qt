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
    property var zero: {
        'imageName': 'zero.svg',
        'componentSource': 'Zero.qml',
        'width': 0.12,
        'height': 0.2,
        'toolTipText': qsTr("Zero input")
    }
    property var one: {
        'imageName': 'one.svg',
        'componentSource': 'One.qml',
        'width': 0.12,
        'height': 0.2,
        'toolTipText': qsTr("One input")
    }
    property var digitalLight: {
        'imageName': 'DigitalLightOff.svg',
        'componentSource': 'DigitalLight.qml',
        'width': 0.12,
        'height': 0.12,
        'toolTipText': qsTr("Digital Light")
    }
    property var andGate: {
        'imageName': 'gateAnd.svg',
        'componentSource': 'AndGate.qml',
        'width': 0.15,
        'height': 0.12,
        'toolTipText': qsTr("AND gate")
    }
    // tutorial levels
    property var tutorialLevels: [
        // level 1
        {
            totalInputComponents: 2,
            imageName: [zero.imageName, one.imageName, digitalLight.imageName],
            componentSource: [zero.componentSource, one.componentSource, digitalLight.componentSource],
            imgWidth: [zero.width, one.width, digitalLight.width],
            imgHeight: [zero.height, one.height, digitalLight.height],
            toolTipText: [zero.toolTipText, one.toolTipText, digitalLight.toolTipText],
            playAreaComponentPositionX: [-1, -1, 0.4],
            playAreaComponentPositionY: [-1, -1, 0.3],
            introMessage: [
                qsTr("The Digital light will glow when it's terminal is connected with an input of 1"),
                qsTr("Turn the Digital light on using the inputs provided")
            ]
        },
        // level 2
        {
            totalInputComponents: 2,
            imageName: [zero.imageName, one.imageName, andGate.imageName, digitalLight.imageName],
            componentSource: [zero.componentSource, one.componentSource, andGate.componentSource, digitalLight.componentSource],
            imgWidth: [zero.width, one.width, andGate.width, digitalLight.width],
            imgHeight: [zero.height, one.height, andGate.height, digitalLight.height],
            toolTipText: [zero.toolTipText, one.toolTipText, andGate.toolTipText, digitalLight.toolTipText],
            playAreaComponentPositionX: [-1, -1, 0.4, 0.6],
            playAreaComponentPositionY: [-1, -1, 0.3, 0.3],
            introMessage: [
                qsTr("The AND Gate"),
                qsTr("Turn the Digital light on using an AND gate and the inputs provided")
            ]
        }
    ]
}
