/* GCompris - DigitalLight.qml
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
import GCompris 1.0

ElectricalComponent {
    id: digitalLight
    imgWidth: 0.2
    imgHeight: 0.18
    imgSrc: "DigitalLightOff.svg"
    toolTipTxt: qsTr("Digital Light")
    terminalSize: 0.358
    noOfInputs: 1
    noOfOutputs: 1

    information: qsTr("Digital light is used to check the output of other digital components. It forwards " +
                      "its input to its output. If the input is 1, then the digital light will glow, else " +
                      "it will turn off.")

    truthTable: []

    property alias inputTerminals: inputTerminals
    property alias outputTerminals: outputTerminals

    Repeater {
        id: inputTerminals
        model: 1
        delegate: inputTerminal
        Component {
            id: inputTerminal
            TerminalPoint {
                posX: 0.066
                posY: 0.497
                type: "In"
            }
        }
    }

    Repeater {
        id: outputTerminals
        model: 1
        delegate: outputTerminal
        Component {
            id: outputTerminal
            TerminalPoint {
                posX: 0.934
                posY: 0.497
                type: "Out"
            }
        }
    }

    function updateOutput(wireVisited) {

        var terminal = outputTerminals.itemAt(0)
        terminal.value = inputTerminals.itemAt(0).value == 1 ? 1 : 0
        if(terminal.value == 1)
            imgSrc = "DigitalLightOn.svg"
        else
            imgSrc = "DigitalLightOff.svg"

        for(var i = 0 ; i < terminal.wires.length ; ++i)
            terminal.wires[i].to.value = terminal.value

        var componentVisited = []
        for(var i = 0 ; i < terminal.wires.length ; ++i) {
            var wire = terminal.wires[i]
            var component = wire.to.parent
            if(componentVisited[component] != true && wireVisited[wire] != true) {
                componentVisited[component] = true
                wireVisited[wire] = true
                component.updateOutput(wireVisited)
            }
        }
    }
}
