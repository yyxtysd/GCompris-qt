/* GCompris - digital_electricity.js
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
.pragma library
.import QtQuick 2.0 as Quick

var currentLevel = 0
var numberOfLevel = 4
var items
var url = "qrc:/gcompris/src/activities/digital_electricity/resource/"
var components = []
var componentIndex = 0
var toolDelete
var deletedIndex = []
var selectedIndex
var animationInProgress

function start(items_) {
    items = items_
    currentLevel = 0
    items.availablePieces.model.append( {
        "imgName": "battery.svg",
        "imgWidth": 0.13,
        "imgHeight": 0.18,
        "toolTipText": qsTr("Battery")
    });
    items.availablePieces.model.append( {
        "imgName": "comparator.svg",
        "imgWidth": 0.3,
        "imgHeight": 0.25,
        "toolTipText": qsTr("Comparator")
    });
    items.availablePieces.model.append( {
        "imgName": "ledOff.svg",
        "imgWidth": 0.16,
        "imgHeight": 0.2,
        "toolTipText": qsTr("LED")
    });
    items.availablePieces.model.append( {
        "imgName": "switchOff.svg",
        "imgWidth": 0.18,
        "imgHeight": 0.15,
        "toolTipText": qsTr("Switch")
    });
    items.availablePieces.model.append( {
        "imgName": "BCDTo7Segment.svg",
        "imgWidth": 0.3,
        "imgHeight": 0.4,
        "toolTipText": qsTr("BCD To 7 Segment")
    });
    //*/
    items.availablePieces.model.append( {
        "imgName": "sevenSegmentDisplay.svg",
        "imgWidth": 0.18,
        "imgHeight": 0.4,
        "toolTipText": qsTr("7 Segment Display")
    });
    items.availablePieces.model.append( {
        "imgName": "gateAnd.svg",
        "imgWidth": 0.15,
        "imgHeight": 0.12,
        "toolTipText": qsTr("AND gate")
    });
    items.availablePieces.model.append( {
        "imgName": "gateNand.svg",
        "imgWidth": 0.15,
        "imgHeight": 0.12,
        "toolTipText": qsTr("NAND gate")
    });
    items.availablePieces.model.append( {
        "imgName": "gateNor.svg",
        "imgWidth": 0.15,
        "imgHeight": 0.12,
        "toolTipText": qsTr("NOR gate")
    });
    items.availablePieces.model.append( {
        "imgName": "gateNot.svg",
        "imgWidth": 0.15,
        "imgHeight": 0.12,
        "toolTipText": qsTr("Not gate")
    });
    items.availablePieces.model.append( {
        "imgName": "gateOr.svg",
        "imgWidth": 0.15,
        "imgHeight": 0.12,
        "toolTipText": qsTr("Or gate")
    });
    items.availablePieces.model.append( {
        "imgName": "gateXor.svg",
        "imgWidth": 0.15,
        "imgHeight": 0.12,
        "toolTipText": qsTr("Xor gate")
    });
    //*/
    //items.availablePieces.view.refreshLeftWidget()
    initLevel()
}

function stop() {
    for(var i = 0 ; i < components.length ; ++i) {
        var j
        for(j = 0 ; j < deletedIndex.length ; ++j) {
            if(deletedIndex[j] == i)
                break
        }
        if(j == deletedIndex.length)
            components[i].destroy()
    }
}

function initLevel() {
    items.availablePieces.view.currentDisplayedGroup = 0
    items.availablePieces.view.previousNavigation = 1
    items.availablePieces.view.nextNavigation = 1
    animationInProgress = false
    deselect()
    updateToolTip("")
}

function reset() {
    deselect()
    stop()
    initLevel()
}

function createComponent(x, y, src, imgWidth, imgHeight, toolTipTxt) {
    var electricComponent = Qt.createComponent("qrc:/gcompris/src/activities/digital_electricity/Component.qml")
    if (electricComponent.status == electricComponent.Error) {
        // Error Handling
        console.log("Error loading component:", electricComponent.errorString());
    }
    //console.log("Inside createComponent")
    x = x / items.backgroundContainer.width
    y = y / items.backgroundContainer.height
    //console.log("x",x,"y",y)
    var index
    if(deletedIndex.length > 0) {
        index = deletedIndex[deletedIndex.length - 1]
        deletedIndex.pop()
    }
    else
        index = components.length

    components[index] = electricComponent.createObject(
                        items.backgroundContainer, {
                            "index": index,
                            "posX": x,
                            "posY": y,
                            "imgSrc": src,
                            "imgWidth": imgWidth,
                            "imgHeight": imgHeight,
                            "toolTipTxt": toolTipTxt,
                            "initialAngle": 0,
                            "rotationAngle": 0
                        });
    //console.log("Error loading component:", electricComponent.errorString());
    componentSelected(index)
    //console.log("index",index,"toolTipTxt",toolTipTxt,components[index].toolTipTxt)
    //console.log("posX",x,"posX",components[components.length-1].posX)
}

function deselect() {
    items.availablePieces.toolDelete.state = "notSelected"
    items.availablePieces.rotateLeft.state = "canNotBeSelected"
    items.availablePieces.rotateRight.state = "canNotBeSelected"
    items.availablePieces.info.state = "canNotBeSelected"
    items.infoTxt.visible = false
    toolDelete = false
    selectedIndex = -1
}

function removeComponent(index) {
    components[index].destroy()
    deletedIndex.push(index)
}

function componentSelected(index) {
    selectedIndex = index
    items.availablePieces.rotateLeft.state = "canBeSelected"
    items.availablePieces.rotateRight.state = "canBeSelected"
    items.availablePieces.info.state = "canBeSelected"
}

function rotateLeft() {
    components[selectedIndex].rotationAngle = components[selectedIndex].initialAngle - 90
    //console.log("rotationAngle",components[selectedIndex].rotationAngle)
    components[selectedIndex].rotateComponent.start()
    components[selectedIndex].initialAngle = components[selectedIndex].rotationAngle == -360 ? 0 :
                                             components[selectedIndex].rotationAngle
}

function rotateRight() {
    components[selectedIndex].rotationAngle = components[selectedIndex].initialAngle + 90
    //console.log("rotationAngle",components[selectedIndex].rotationAngle)
    components[selectedIndex].rotateComponent.start()
    components[selectedIndex].initialAngle = components[selectedIndex].rotationAngle == 360 ? 0 :
                                             components[selectedIndex].rotationAngle
}

function displayInfo() {
    var componentName = components[selectedIndex].imgSrc
    deselect()
    items.infoTxt.visible = true
    //console.log(componentName,componentName=="battery.svg")
    if(componentName == "battery.svg") {
        items.infoTxt.text = qsTr("Battery is a power source of DC voltage. In analog electronics, the positive " +
                                  "terminal gives positive voltage, equal to the rating of battery and negative " +
                                  "terminal acts as ground (zero voltage). The battery can have different values " +
                                  "depending on its rating. In digital electronics, positive voltage is represented " +
                                  "by symbol ‘1’ and ground is represented by symbol ‘0’. Therefore in digital " +
                                  "electronics, there are only two states of voltage produced by battery – ‘1’ and ‘0’.")
        items.infoImage.source = ""
    }
    else if(componentName == "gateAnd.svg") {
        items.infoTxt.text = qsTr("AND gate takes 2 or more binary input in its input terminals and outputs a single " +
                                  "value. The output is 0 if any of the input is 0, else it is 1. In this activity, " +
                                  "a 2 input AND gate is shown. Truth table for 2 input AND gate is:")
        items.infoImage.source = url + "AndTruthTable.svg"
    }
    else if(componentName == "gateNand.svg") {
        items.infoTxt.text = qsTr("NAND gate takes 2 or more binary input in its input terminals and outputs a single " +
                                  "value. It is the complement of AND gate. In this activity, a 2 input NAND gate is " +
                                  "shown. Truth table for 2 input NAND gate is:")
        items.infoImage.source = url + "NandTruthTable.svg"
    }
    else if(componentName == "gateNor.svg") {
        items.infoTxt.text = qsTr("NOR gate takes 2 or more binary input in its input terminals and outputs a single " +
                                  "value. It is the complement of OR gate. In this activity, a 2 input NOR gate is " +
                                  "shown. Truth table for 2 input NOR gate is:")
        items.infoImage.source = url + "NorTruthTable.svg"
    }
    else if(componentName == "gateNot.svg") {
        items.infoTxt.text = qsTr("Not gate (also known as inverter) takes a binary input in its input terminal and " +
                                  "outputs a single value. The output is the complement of the input value, that is, it " +
                                  "is 0 if input is 1, and 1 if input is 0. Truth table for NOT gate is:")
        items.infoImage.source = url + "NotTruthTable.svg"
    }
    else if(componentName == "gateOr.svg") {
        items.infoTxt.text = qsTr("OR gate takes 2 or more binary input in its input terminals and outputs a single " +
                                  "value. The output is 1 if any of the input is 1, else it is 0. In this activity, a " +
                                  "2 input OR gate is shown. Truth table for 2 input OR gate is:")
        items.infoImage.source = url + "OrTruthTable.svg"
    }
    else if(componentName == "gateXor.svg") {
        items.infoTxt.text = qsTr("XOR gate takes 2 or more binary input in its input terminals and outputs a single " +
                                  "value. The output is 1 if number of '1' in input is odd, and 0 if number of '1' in " +
                                  "input is even. In this activity, a 2 input XOR gate is shown. Truth table for " +
                                  "2 input XOR gate is:")
        items.infoImage.source = url + "XorTruthTable.svg"
    }
    else if(componentName == "comparator.svg") {
        items.infoTxt.text = qsTr("Comparator takes 2 numbers as input, A and B. It compares them and outputs 3 " +
                                  "values. First value is true if A < B, else it is false. Second value is true " +
                                  "if A = B, else it is false. Third value is true if A > B, else it is false. " +
                                  "In digital electronics, true value is represented as 1, and false value is " +
                                  "represented as 0")
    }
    /*else if(componentName == "BCDTo7Segment.svg") {
        items.infoTxt.text = qsTr("BCD to 7 segment converter takes 4 binary inputs in its input terminals and gives " +
                                  "7 binary outputs. The 4 binary inputs represents a BCD number (binary-coded decimal). " +
                                  "The converter converts this BCD number to corresponding bits, which are used to " +
                                  "display the decimal number (represented by the BCD number) on the 7 segment display. " +
                                  "The truth table for BCD To 7 Segment converted is:")
        items.infoImage.source = url + "BCDTo7SegmentTruthTable.svg"
    }*/
    else if(componentName == "BCDTo7Segment.svg") {
        items.infoTxt.text = qsTr("BCD to 7 segment converter takes 4 binary inputs which represent a BCD number, " +
                                  "and convert them to 7 binary bits which represent corresponding number in 7 segment " +
                                  "format. The truth table is:")
        items.infoImage.source = url + "BCDTo7SegmentTruthTable.svg"
    }
    else if(componentName == "sevenSegmentDisplay.svg") {
        items.infoTxt.text = qsTr("7 segment display takes 7 binary inputs in its input terminals. The display " +
                                  "consists of 7 segments and each segment gets lighted according to the input. " +
                                  "By generating different combination of binary inputs, the display can be used to " +
                                  "display various different symbols. The diagram is:")
        items.infoImage.source = url + "7SegmentDisplay.svg"
    }
    else if(componentName == "ledOn.svg" || componentName == "ledOff.svg") {
        items.infoTxt.text = qsTr("LED (Light-emitting diode) is a two-lead semiconductor light source. It emits light " +
                                  "when activated. LED has 2 input terminals, the longer terminal is the positive " +
                                  "terminal (anode) and smaller terminal is the negative terminal (cathode). LED " +
                                  "is activated when anode has a higher potential than cathode. In digital electronics " +
                                  "LED can be used to check the output of the components. Connect the cathode of LED " +
                                  "to ground (negative terminal of battery) and anode of LED to the output of the " +
                                  "component. If output is 1, the LED will be activated (emit light), and if " +
                                  "output is 0, the LED will be deactivated.")
        items.infoImage.source = ""
    }
    else if(componentName == "switchOn.svg" || componentName == "switchOff.svg") {
        items.infoTxt.text = qsTr("Switch is used to maintain easy connection between two terminals. If the switch is " +
                                  "turned on, then the two terminals are connected and current can flow through the " +
                                  "switch. If the switch is turned off, then the connection between terminal is broken, " +
                                  "and current can not flow through it.")
        items.infoImage.source = ""
    }
    //console.log(items.infoTxt.text)
}

function updateToolTip(toolTipTxt) {
    items.toolTip.show(toolTipTxt)
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
