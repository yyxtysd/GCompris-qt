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
    property var xorGate: {
        'imageName': 'gateXor.svg',
        'componentSource': 'XorGate.qml',
        'width': 0.15,
        'height': 0.12,
        'toolTipText': qsTr("XOR gate")
    }
    property var nandGate: {
        'imageName': 'gateNand.svg',
        'componentSource': 'NandGate.qml',
        'width': 0.15,
        'height': 0.12,
        'toolTipText': qsTr("NAND gate")
    }
    property var norGate: {
        'imageName': 'gateNor.svg',
        'componentSource': 'NorGate.qml',
        'width': 0.15,
        'height': 0.12,
        'toolTipText': qsTr("NOR gate")
    }
    property var switchKey: {
        'imageName': 'switchOff.svg',
        'componentSource': 'Switch.qml',
        'width': 0.18,
        'height': 0.15,
        'toolTipText': qsTr("Switch")
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
                qsTr("The Digital light will glow when its terminal is connected with an input of 1"),
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
                qsTr("The OR Gate produces an output of 1 when at least one of the input terminal is of value 1"),
                qsTr("Turn the Digital light on using an OR gate and the inputs provided")
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
            introMessage: [
                qsTr("NOTE: You can draw multiple wires from the output terminal of a component.")
            ]
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
        },
        // level 6
        {
            inputComponentList: [zero, notGate, orGate, andGate],
            playAreaComponentList: [one, one, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [2, 3, 4],
            wires: [ ],
            playAreaComponentPositionX: [0.0, 0.0, 0.1, 0.1, 0.8],
            playAreaComponentPositionY: [0.0, 0.8, 0.3, 0.6, 0.4],
            introMessage: [
                qsTr("Light the bulb using both the switches such that the bulb will glow when only one of the switches are turned on")
            ]
        },
        // level 7
        {
            inputComponentList: [zero, one],
            playAreaComponentList: [nandGate, digitalLight],
            determiningComponentsIndex: [1],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.4, 0.8],
            playAreaComponentPositionY: [0.4, 0.4],
            introMessage: [
                qsTr("The NAND Gate takes two binary inputs and produces one binary output"),
                qsTr("The output of the NAND gate will be zero if the both the inputs are \"0\". Else, the output will be one."),
                qsTr("For a more detailed description about the gate, select it and click on the info button."),
                qsTr("Light the bulb using the NAND gate provided.")
            ]
        },
        // level 8
        {
            inputComponentList: [zero, one, andGate, orGate, nandGate],
            playAreaComponentList: [switchKey, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [0, 1, 2, 3],
            wires: [  ],
            playAreaComponentPositionX: [0.2, 0.2, 0.2, 0.8],
            playAreaComponentPositionY: [0.2, 0.5, 0.8, 0.5],
            introMessage: [
                qsTr("Light the bulb using the components provided such that the bulb will glow under the following two circumstances:"),
                qsTr("1. The first switch is turned ON, or"),
                qsTr("2. Both of the second and the third switches are turned on.")
            ]
        },
        // level 9
        {
            inputComponentList: [zero, one],
            playAreaComponentList: [xorGate, digitalLight],
            determiningComponentsIndex: [1],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.4, 0.8],
            playAreaComponentPositionY: [0.4, 0.4],
            introMessage: [
                qsTr("The XOR Gate takes two binary inputs and produces one binary output"),
                qsTr("The output of the XOR gate will be one if the number of \"1\" in the input is odd. Else, the output will be zero."),
                qsTr("Light the bulb using the XOR gate provided.")
            ]
        },
        // level 10
        {
            inputComponentList: [zero, one, xorGate],
            playAreaComponentList: [switchKey, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [0, 1, 2, 3],
            wires: [  ],
            playAreaComponentPositionX: [0.2, 0.2, 0.2, 0.8],
            playAreaComponentPositionY: [0.2, 0.4, 0.6, 0.4],
            introMessage: [
                qsTr("Light the bulb using the three switches such that the bulb glows when odd number of the switches are turned on")
            ]
        },
        // level 11
        {
            inputComponentList: [one, notGate],
            playAreaComponentList: [norGate, digitalLight],
            determiningComponentsIndex: [1],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.6, 0.8],
            playAreaComponentPositionY: [0.5, 0.5],
            introMessage: [
                qsTr("A NOR gate takes 2 binary input and outputs 1 if both of them are 0, otherwise produces an output of 1."),
                qsTr("For a more detailed description about the gate, select it and click on the info button."),
                qsTr("Light the bulb using the NOR gate provided.")
            ]
        },
        // level 12
        {
            inputComponentList: [nandGate],
            playAreaComponentList: [one, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2],
            wires: [ [0, 0, 1, 0] ],
            playAreaComponentPositionX: [0.1, 0.3, 0.8],
            playAreaComponentPositionY: [0.5, 0.5, 0.5],
            introMessage: [
                qsTr("Use the gates such that the bulb will glow only when the switch is turned off and remain off when the switch is turned on.")
            ]
        },
        // level 13
        {
            inputComponentList: [nandGate],
            playAreaComponentList: [one, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2, 3],
            wires: [ [0, 0, 1, 0], [0, 0, 2, 0] ],
            playAreaComponentPositionX: [0.0, 0.2, 0.2, 0.8],
            playAreaComponentPositionY: [0.5, 0.4, 0.6, 0.5],
            introMessage: [
                qsTr("Create a circuit using the components provided such that the bulb glows only when both of the switches are turned on.")
            ]
        },
        // level 14
        {
            inputComponentList: [nandGate],
            playAreaComponentList: [one, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2, 3],
            wires: [ [0, 0, 1, 0], [0, 0, 2, 0] ],
            playAreaComponentPositionX: [0.0, 0.2, 0.2, 0.8],
            playAreaComponentPositionY: [0.5, 0.4, 0.6, 0.5],
            introMessage: [
                qsTr("Create a circuit using the components provided such that the bulb glows when either of the switches are turned on.")
            ]
        },
        // level 15
        {
            inputComponentList: [nandGate],
            playAreaComponentList: [one, switchKey, switchKey, digitalLight],
            determiningComponentsIndex: [1, 2, 3],
            wires: [ [0, 0, 1, 0], [0, 0, 2, 0] ],
            playAreaComponentPositionX: [0.0, 0.2, 0.2, 0.8],
            playAreaComponentPositionY: [0.5, 0.4, 0.6, 0.5],
            introMessage: [
                qsTr("Create a circuit using the components provided such that the bulb glows only when both of the switches are turned off.")
            ]
        }
    ]
}
