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
    property var orGate: {
        'imageName': 'gateOr.svg',
        'componentSource': 'OrGate.qml',
        'width': 0.15,
        'height': 0.12,
        'toolTipText': qsTr("OR gate")
    }
    property var notGate: {
        'imageName': 'gateNot.svg',
        'componentSource': 'NotGate.qml',
        'width': 0.15,
        'height': 0.12,
        'toolTipText': qsTr("NOT gate")
    }
    // tutorial levels
    property var tutorialLevels: [
        // level 1
        {
            inputComponentList: [zero, one],
            playAreaComponentList: [digitalLight],
            determiningComponentsIndex: [0],
            wires: [],
            playAreaComponentPositionX: [0.4],
            playAreaComponentPositionY: [0.3],
            introMessage: [
                qsTr("The Digital light will glow when it's terminal is connected with an input of 1"),
                qsTr("Turn the Digital light on using the inputs provided")
            ]
        },
        // level 2
        {
            inputComponentList: [zero, one],
            playAreaComponentList: [andGate, digitalLight],
            determiningComponentsIndex: [1],
            wires: [ [0, 0, 1, 0] ], // from_component_index, from_terminal_no, to_component_index, to_terminal_no
            playAreaComponentPositionX: [0.4, 0.6],
            playAreaComponentPositionY: [0.3, 0.3],
            introMessage: [
                qsTr("The AND Gate produces an output of one when both of it's input terminal are of value 1"),
                qsTr("Turn the Digital light on using an AND gate and the inputs provided")
            ]
        },
        // level 3
        {
            inputComponentList: [zero, one],
            playAreaComponentList: [orGate, digitalLight],
            determiningComponentsIndex: [1],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.4, 0.6],
            playAreaComponentPositionY: [0.3, 0.3],
            introMessage: [
                qsTr("The OR Gate produces an output of 1  when at least one of the input terminal is of value 1"),
                qsTr("Turn the Digital light on using an AND gate and the inputs provided")
            ]
        },
        // level 4
        {
            inputComponentList: [zero],
            playAreaComponentList: [zero, one, orGate, andGate, digitalLight],
            determiningComponentsIndex: [4],
            wires: [ [0, 0, 2, 0], [2, 0, 3, 0], [3, 0, 4, 0]],
            playAreaComponentPositionX: [0.2, 0.3, 0.4, 0.6, 0.8],
            playAreaComponentPositionY: [0.1, 0.4, 0.3, 0.3, 0.4],
            introMessage: []
        },
        // level 5
        {
            inputComponentList: [zero],
            playAreaComponentList: [notGate, notGate,  orGate, orGate, andGate, digitalLight],
            determiningComponentsIndex: [5],
            wires: [ [4, 0, 5, 0], [2, 0, 4, 0], [3, 0, 4, 1]],
            playAreaComponentPositionX: [0.2, 0.2, 0.5, 0.5, 0.6, 0.8],
            playAreaComponentPositionY: [0.1, 0.4, 0.2, 0.6, 0.4, 0.4],
            introMessage: [
                qsTr("The NOT gate takes a single binary input and flips the value in the output")
            ]
        }
    ]
}
