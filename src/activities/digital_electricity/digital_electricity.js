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
//var componentIndex = 0
var toolDelete
var selectedIndex
var animationInProgress
var selectedTerminal
var mapSrc = {}
var terminals = []
var deletedIndex = []
var components = []
var componentsInfo = []
var wires = []
var connected = []
var deletedWireIndex = []
var colors = ["red","green","blue","blueviolet","silver"]
var sevenSegmentDisplay = []

function start(items_) {
    items = items_
    currentLevel = 0
    var filename = url + "ElectricalComponents.qml"
    items.dataset.source = filename
    var componentsData = items.dataset.item
    var componentsDataLength = componentsData.components.length

    for(var i = 0 ; i < componentsDataLength ; ++i) {
        var component = componentsData.components[i]

        items.availablePieces.model.append( {
            "imgName": component.imgName,
            "imgWidth": component.imgWidth,
            "imgHeight": component.imgHeight,
            "toolTipText": component.toolTipText,
            "terminalSize": component.terminalSize,
        });


        mapSrc[component.imgName] = i
        if(component.imgName == "ledOff.svg")
            mapSrc["ledOn.svg"] = i
        else if(component.imgName == "switchOff.svg")
            mapSrc["switchOn.svg"] = i

        componentsInfo[i] = []
        componentsInfo[i][0] = component.imgWidth
        componentsInfo[i][1] = component.imgHeight
        componentsInfo[i][2] = component.toolTipText
        componentsInfo[i][3] = component.terminalSize

        componentsInfo[i][4] = []
        var inputs = component.inputTerminals
        for(var j = 0 ; j < inputs.length ; ++j) {
            componentsInfo[i][4][j] = []
            var input = inputs[j]
            componentsInfo[i][4][j][0] = input.posX
            componentsInfo[i][4][j][1] = input.posY
            componentsInfo[i][4][j][2] = input.value == undefined ? -1 : input.value
        }

        componentsInfo[i][5] = []
        var outputs = component.outputTerminals
        //console.log("outputs.length",outputs.length)
        for(var j = 0 ; j < outputs.length ; ++j) {
            componentsInfo[i][5][j] = []
            var output = outputs[j]
            componentsInfo[i][5][j][0] = output.posX
            componentsInfo[i][5][j][1] = output.posY
            componentsInfo[i][5][j][2] = output.value == undefined ? -1 : output.value
        }

        componentsInfo[i][6] = component.information
        componentsInfo[i][7] = component.truthTable
    }

    /*items.availablePieces.model.append( {
        "imgName": "zero.svg",
        "imgWidth": 0.12,
        "imgHeight": 0.2,
        "toolTipText": qsTr("Zero input"),
        "terminalSize": 0.205
    });
    items.availablePieces.model.append( {
        "imgName": "one.svg",
        "imgWidth": 0.12,
        "imgHeight": 0.2,
        "toolTipText": qsTr("One input"),
        "terminalSize": 0.218
    });
    /*items.availablePieces.model.append( {
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
        "toolTipText": qsTr("LED"),
        "terminalSize": 0.111
    });
    /*items.availablePieces.model.append( {
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
    items.availablePieces.model.append( {
        "imgName": "sevenSegmentDisplay.svg",
        "imgWidth": 0.18,
        "imgHeight": 0.4,
        "toolTipText": qsTr("7 Segment Display"),
        "terminalSize": 0.097
    });
    items.availablePieces.model.append( {
        "imgName": "gateAnd.svg",
        "imgWidth": 0.15,
        "imgHeight": 0.12,
        "toolTipText": qsTr("AND gate"),
        "terminalSize": 0.246
    });
    /*items.availablePieces.model.append( {
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
        if(j == deletedIndex.length) {
            if(components[i].imgSrc == "sevenSegmentDisplay.svg")
                sevenSegmentDisplay[i].destroy()
            components[i].destroy()
        }
    }

    /*for(var i = 0 ; i < terminals.length ; ++i) {
        terminals[i].destroy();
    }*/

    for(var i = 0 ; i < wires.length ; ++i) {
        var j
        for(j = 0 ; j < deletedWireIndex.length ; ++j) {
            if(deletedWireIndex[j] == i)
                break
        }
        if(j == deletedWireIndex.length)
            wires[i].destroy()
    }
}

function initLevel() {
    items.availablePieces.view.currentDisplayedGroup = 0
    items.availablePieces.view.previousNavigation = 1
    items.availablePieces.view.nextNavigation = 1
    terminals = []
    deletedIndex = []
    components = []
    wires = []
    connected = []
    deletedWireIndex = []
    sevenSegmentDisplay = []
    animationInProgress = false
    deselect()
    toolDelete = false
    updateToolTip("")
}

function reset() {
    deselect()
    stop()
    initLevel()
}

function createComponent(x, y, src, imgWidth, imgHeight, toolTipTxt, terminalSize) {
    var electricComponent = Qt.createComponent("qrc:/gcompris/src/activities/digital_electricity/ElectricalComponent.qml")
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

    var componentInfo = componentsInfo[mapSrc[src]]
    components[index] = electricComponent.createObject(
                        items.backgroundContainer, {
                            "index": index,
                            "posX": x,
                            "posY": y,
                            "imgSrc": src,
                            "imgWidth": componentInfo[0],
                            "imgHeight": componentInfo[1],
                            "toolTipTxt": componentInfo[2],
                            "terminalSize": componentInfo[3]
                        });

    var electricComponentCreated = components[index]
    var terminalComponent = Qt.createComponent("qrc:/gcompris/src/activities/digital_electricity/TerminalPoint.qml")
    //console.log("Error loading component:", terminalComponent.errorString())
    var terminalIndex = terminals.length
    //console.log("terminalIndex",terminalIndex)

    if(src == "sevenSegmentDisplay.svg") {
        var sevenSegmentComponent = Qt.createComponent("qrc:/gcompris/src/activities/digital_electricity/SevenSegment.qml")
        sevenSegmentDisplay[index] = sevenSegmentComponent.createObject(
                                     electricComponentCreated, {
                                         "code": [0,0,0,0,0,0]
                                     });
        sevenSegmentDisplay[index].anchors.centerIn = electricComponentCreated
    }

    var inputs = componentInfo[4]
    for(var i = 0 ; i < inputs.length ; ++i) {
        var input = inputs[i]
        electricComponentCreated.inputs.push(terminalIndex)
        terminals[terminalIndex++] = terminalComponent.createObject(
                                     electricComponentCreated, {
                                         "posX": input[0],
                                         "posY": input[1],
                                         "index": terminalIndex - 1,
                                         "type": "In",
                                         "componentIndex": index,
                                         "value": input[2]
                                     });
         //console.log("posX",input[0])
    }

    var outputs = componentInfo[5]
    //console.log("outputs.length",outputs.length)
    for(var i = 0 ; i < outputs.length ; ++i) {
        var output = outputs[i]
        electricComponentCreated.outputs.push(terminalIndex)
        terminals[terminalIndex++] = terminalComponent.createObject(
                                     electricComponentCreated, {
                                         "posX": output[0],
                                         "posY": output[1],
                                         "index": terminalIndex - 1,
                                         "type": "Out",
                                         "componentIndex": index,
                                         "value": output[2]
                                     });
    }

    componentSelected(index)
}

function terminalPointSelected(index) {

    if(selectedTerminal == -1 || selectedTerminal == index)
        selectedTerminal = index
    else if((terminals[index].type != terminals[selectedTerminal].type) &&
             terminals[index].componentIndex != terminals[selectedTerminal].componentIndex) {
        var inIndex = terminals[index].type == "In" ? index : selectedTerminal
        var outIndex = terminals[index].type == "Out" ? index : selectedTerminal
        //console.log("in, connected[inIndex]",connected[inIndex],"inIndex",inIndex)
        if(connected[inIndex] == undefined || connected[inIndex] == -1) {
            //console.log("in2")
            var wireComponent = Qt.createComponent("qrc:/gcompris/src/activities/digital_electricity/Wire.qml")

            var index
            if(deletedWireIndex.length > 0) {
                index = deletedWireIndex[deletedWireIndex.length - 1]
                deletedWireIndex.pop()
            }
            else
                index = wires.length

            var colorIndex = Math.floor(Math.random() * colors.length)
            //console.log("colorIndex",colorIndex)
            wires[index] = wireComponent.createObject(
            items.backgroundContainer, {
                "from": outIndex,
                "to": inIndex,
                "wireColor": colors[colorIndex],
                "index": index
            });
            terminals[inIndex].value = terminals[outIndex].value
            terminals[inIndex].wireIndex.push(index)
            terminals[outIndex].wireIndex.push(index)
            updateWires(terminals[inIndex].componentIndex)
            updateWires(terminals[outIndex].componentIndex)
            updateComponent(terminals[inIndex].componentIndex)
            connected[inIndex] = outIndex
        }
        deselect()
    }
    else {
        //console.log("else")
        deselect()
        selectedTerminal = index
        terminals[index].selected = true
    }
}

function updateComponent(index) {

    var visited = []
    updateComponentUtility(index, visited)
}

function updateComponentUtility(index, visited) {

    //console.log("index",index,"components[index].imgSrc",components[index].imgSrc)
    if(visited[index] != undefined) // To prevent infinite loop because of bad connection
        return
    visited[index] = true

    var component = components[index]
    if(component.imgSrc == "ledOff.svg") {
        if(terminals[component.inputs[0]].value == 1 &&  terminals[component.inputs[1]].value == 0)
            component.source = url + "ledOn.svg"
        else
            component.source = url + "ledOff.svg"
        //console.log("component.source",component.source)
        return
    }
    else if(component.imgSrc == "sevenSegmentDisplay.svg") {
        var code = []
        for(var i = 0 ; i < 7 ; ++i) {
            var value = terminals[component.inputs[i]].value
            if(value == -1) {
                for(var j = 0 ; j < 7 ; ++j) code[j] = 0
            }
            code[i] = value
        }
        sevenSegmentDisplay[index].code = code
        return
    }
    else if(component.imgSrc == "switchOff.svg") {
        terminals[component.outputs[0]].value = -1
    }
    else if(component.imgSrc == "switchOn.svg") {
        terminals[component.outputs[0]].value = terminals[component.inputs[0]].value
    }
    else if(component.imgSrc == "comparator.svg") {
        var firstInput = terminals[component.inputs[0]].value
        var secondInput = terminals[component.inputs[1]].value
        if(firstInput != -1 && secondInput != -1) {
            terminals[component.outputs[0]].value = firstInput < secondInput ? 1 : 0
            terminals[component.outputs[1]].value = firstInput == secondInput ? 1 : 0
            terminals[component.outputs[2]].value = firstInput > secondInput ? 1 : 0
        }
        else {
            terminals[component.outputs[0]].value = -1
            terminals[component.outputs[1]].value = -1
            terminals[component.outputs[2]].value = -1
        }
    }
    else {
        var inputSet = false
        var compnentInfo = componentsInfo[mapSrc[component.imgSrc]]
        var truthTable = compnentInfo[7]
        var i
        var input = component.inputs
        for(i = 1 ; i < truthTable.length ; ++i) {
            var j
            for(j = 0 ; j < input.length; ++j) {
                if(terminals[input[j]].value != truthTable[i][j])
                    break
            }
            if(j == input.length)
                break
        }
        var output = component.outputs
        if(i == truthTable.length) {
            for(var j = 0 ; j < output.length ; ++j)
                terminals[output[j]].value = -1
        }
        else {
            for(var j = 0 ; j < output.length ; ++j)
                terminals[output[j]].value = truthTable[i][j + input.length]
        }
    }

    for(var i = 0 ; i < component.outputs.length ; ++i) {
        var terminal = terminals[component.outputs[i]]
        for(var j = 0 ; j < terminal.wireIndex.length ; ++j) {
            terminals[wires[terminal.wireIndex[j]].to].value = terminal.value
        }
    }

    for(var i = 0 ; i < component.outputs.length ; ++i) {
        var terminal = terminals[component.outputs[i]]
        //console.log("terminal index",terminal.index)
        for(var j = 0 ; j < terminal.wireIndex.length ; ++j) {
            //console.log("wires[terminal.wireIndex[j]].to",wires[terminal.wireIndex[j]].to)
            updateComponentUtility(terminals[wires[terminal.wireIndex[j]].to].componentIndex,visited)
        }
    }
}

function updateWires(index) {

    var component = components[index]
    if(component == undefined || component.inputs == undefined || component.outputs == undefined)
        return

    var rotatedAngle = component.initialAngle * Math.PI / 180
    for(var i = 0 ; i < component.inputs.length ; ++i) {
        var terminal = terminals[component.inputs[i]]
        if(terminal.wireIndex.length != 0) {
            var wire = wires[terminal.wireIndex[0]]
            var otherAngle = components[terminals[wire.from].componentIndex].initialAngle * Math.PI / 180
            var x = terminals[wire.from].xCenterFromComponent
            var y = terminals[wire.from].yCenterFromComponent
            var x1 = terminals[wire.from].xCenter - x + x * Math.cos(otherAngle) - y * Math.sin(otherAngle)
            var y1 = terminals[wire.from].yCenter - y + x * Math.sin(otherAngle) + y * Math.cos(otherAngle)
            //console.log(otherComponentAngle,x,y,x1,y1)

            x = terminal.xCenterFromComponent
            y = terminal.yCenterFromComponent
            var x2 = terminal.xCenter - x + x * Math.cos(rotatedAngle) - y * Math.sin(rotatedAngle)
            var y2 = terminal.yCenter - y + x * Math.sin(rotatedAngle) + y * Math.cos(rotatedAngle)

            /*if((rotatedAngle > 0 && rotatedAngle <= 90) || rotatedAngle == -270) {
                x2 = component.x + component.width / 2 + (terminal.yCenterFromComponent * rotatedAngle) / 90
                y2 = component.y + component.height / 2 - (terminal.xCenterFromComponent * rotatedAngle) / 90
            }
            else if(rotatedAngle == 180 || rotatedAngle == -180) {
                x2 = x2 + terminal.xCenterFromComponent * 2
                y2 = y2 + terminal.yCenterFromComponent * 2
            }
            else if(rotatedAngle == 270 || rotatedAngle == -90) {
                x2 = component.x + component.width / 2 - terminal.yCenterFromComponent
                y2 = component.y + component.height / 2 + terminal.xCenterFromComponent
            }*/

            var width = Math.pow((Math.pow(x1 - x2, 2) +  Math.pow(y1 - y2, 2)),0.5) + 2
            var angle = (180/Math.PI)*Math.atan((y2-y1)/(x2-x1))
            if(x2 - x1 < 0) angle = angle - 180
            wire.x = x1
            wire.y = y1
            wire.width = width
            wire.rotation = angle
            //wire.rotateAngle = angle
        }
    }
    //console.log("component index",component.index,"component.outputs.length",component.outputs.length)
    for(var i = 0 ; i < component.outputs.length ; ++i) {
        var terminal = terminals[component.outputs[i]]
        //console.log("terminal index",terminal.index,"component.outputs[i]",component.outputs[i])
        for(var j = 0 ; j < terminal.wireIndex.length ; ++j) {
            var x = terminal.xCenterFromComponent
            var y = terminal.yCenterFromComponent
            var x1 = terminal.xCenter - x + x * Math.cos(rotatedAngle) - y * Math.sin(rotatedAngle)
            var y1 = terminal.yCenter - y + x * Math.sin(rotatedAngle) + y * Math.cos(rotatedAngle)

            var wire = wires[terminal.wireIndex[j]]
            var otherAngle = components[terminals[wire.to].componentIndex].initialAngle * Math.PI / 180
            x = terminals[wire.to].xCenterFromComponent
            y = terminals[wire.to].yCenterFromComponent
            var x2 = terminals[wire.to].xCenter - x + x * Math.cos(otherAngle) - y * Math.sin(otherAngle)
            var y2 = terminals[wire.to].yCenter - y + x * Math.sin(otherAngle) + y * Math.cos(otherAngle)

            /*if(rotatedAngle == 90 || rotatedAngle == -270) {
                x1 = component.x + component.width / 2 + terminal.yCenterFromComponent
                y1 = component.y + component.height / 2 - terminal.xCenterFromComponent
            }
            else if(rotatedAngle == 180 || rotatedAngle == -180) {
                x1 = x1 + terminal.xCenterFromComponent * 2
                y1 = y1 + terminal.yCenterFromComponent * 2
            }
            else if(rotatedAngle == 270 || rotatedAngle == -90) {
                x1 = component.x + component.width / 2 - terminal.yCenterFromComponent
                y1 = component.y + component.height / 2 + terminal.xCenterFromComponent
            }*/

            var width = Math.pow((Math.pow(x1 - x2, 2) +  Math.pow(y1 - y2, 2)),0.5) + 2
            var angle = (180/Math.PI)*Math.atan((y2-y1)/(x2-x1))
            if(x2 - x1 < 0) angle = angle - 180
            //wire.posX1 = x1
            //wire.posY1 = y1
            //wire.posX2 = x2
            //wire.posY2 = y2
            wire.x = x1
            wire.y = y1
            wire.width = width
            wire.rotation = angle
            //wire.rotateAngle = angle
        }
    }
}

function deselect() {

    //items.availablePieces.toolDelete.state = "notSelected"
    items.availablePieces.rotateLeft.state = "canNotBeSelected"
    items.availablePieces.rotateRight.state = "canNotBeSelected"
    items.availablePieces.info.state = "canNotBeSelected"
    items.infoTxt.visible = false
    //toolDelete = false
    selectedIndex = -1
    selectedTerminal = -1
    for(var i = 0 ; i < terminals.length ; ++i) {
        terminals[i].selected = false
    }
}

function removeComponent(index) {

    var component = components[index]
    if(component.src == "sevenSegmentDisplay.svg")
        sevenSegmentDisplay[index].destroy()
    for(var i = 0 ; i < component.inputs.length ; ++i) {
        var terminal = terminals[component.inputs[i]]
        if(terminal.wireIndex.length != 0) // Input Terminal can have only 1 wire
            removeWire(terminal.wireIndex[0])
    }
    for(var i = 0 ; i < component.outputs.length ; ++i) {
        var terminal = terminals[component.outputs[i]]
        //console.log("Remove terminal.wireIndex.length",terminal.wireIndex.length)
        while (terminal.wireIndex.length != 0) {
            //console.log("terminal.wireIndex[j]",terminal.wireIndex[j])
            removeWire(terminal.wireIndex[0]) // Output Terminal can have more than 1 wire
        }
    }
    components[index].destroy()
    deletedIndex.push(index)
    deselect()
}

function removeWire(index) {

    var wire = wires[index]
    var inTerminal = terminals[wire.to]
    var outTerminal = terminals[wire.from]

    var removeIndex = inTerminal.wireIndex.indexOf(index)
    inTerminal.wireIndex.splice(removeIndex,1)
    removeIndex = outTerminal.wireIndex.indexOf(index)
    outTerminal.wireIndex.splice(removeIndex,1)
    //removeIndex = connected.indexOf(wire.to)
    //connected.splice(wire.to,1)
    connected[wire.to] = -1

    inTerminal.value = -1
    wires[index].destroy()
    deletedWireIndex.push(index)
    updateComponent(inTerminal.componentIndex)
}

function componentSelected(index) {

    selectedIndex = index
    items.availablePieces.rotateLeft.state = "canBeSelected"
    items.availablePieces.rotateRight.state = "canBeSelected"
    items.availablePieces.info.state = "canBeSelected"
}

function rotateLeft() {
    components[selectedIndex].rotationAngle = -2//components[selectedIndex].initialAngle - 90
    //console.log("rotationAngle",components[selectedIndex].rotationAngle)
    components[selectedIndex].rotateComponent.start()
    /*components[selectedIndex].initialAngle = components[selectedIndex].rotationAngle == -360 ? 0 :
                                             components[selectedIndex].rotationAngle*/
}

function rotateRight() {
    components[selectedIndex].rotationAngle = 2//components[selectedIndex].initialAngle + 90
    //console.log("rotationAngle",components[selectedIndex].rotationAngle)
    components[selectedIndex].rotateComponent.start()
    /*components[selectedIndex].initialAngle = components[selectedIndex].rotationAngle == 360 ? 0 :
                                             components[selectedIndex].rotationAngle*/
}

function displayInfo() {

    var src = components[selectedIndex].imgSrc
    var component = componentsInfo[mapSrc[src]]
    deselect()
    items.infoTxt.visible = true
    items.infoTxt.text = component[6]
    if(component[7].length == 0)
        items.displayTruthTable = false
    else {
        items.displayTruthTable = true
        var truthTable = items.truthTablesModel
        truthTable.clear()
        truthTable.rows = component[7].length
        truthTable.columns = component[7][0].length
        truthTable.inputs = component[4].length
        truthTable.outputs = component[5].length
        for(var i = 0 ; i < component[7].length ; ++i)
            for(var j = 0 ; j < component[7][i].length ; ++j)
                truthTable.append({'value': component[7][i][j]})
    }
    if(src == "sevenSegmentDisplay.svg") {
        items.infoImage.imgVisible = true
        items.infoImage.source = url + "7SegmentDisplay.svg"
    }
    else {
        items.infoImage.imgVisible = false
        items.infoImage.source = ""
    }


    //console.log(componentName,componentName=="battery.svg")
    /*if(componentName == "battery.svg") {
        items.infoTxt.text = qsTr("Battery is a power source of DC voltage. In analog electronics, the positive " +
                                  "terminal gives positive voltage, equal to the rating of battery and negative " +
                                  "terminal acts as ground (zero voltage). The battery can have different values " +
                                  "depending on its rating. In digital electronics, positive voltage is represented " +
                                  "by symbol ‘1’ and ground is represented by symbol ‘0’. Therefore in digital " +
                                  "electronics, there are only two states of voltage produced by battery – ‘1’ and ‘0’.")
        //items.infoImage.source = ""
    }*/



    /*if(componentName == "one.svg" || componentName == "zero.svg") {
        items.infoTxt.text = qsTr("Digital electronics is a branch of electronics that handle digital signals " +
                                  "(i.e discrete signals instead of continous signals). Therefore all values within " +
                                  "a range or band represent the same numeric value. In most cases, the number of " +
                                  "these states is two and they are represented by two voltage bands: one near a " +
                                  "reference value (typically termed as 'ground' or zero volts), and other value near " +
                                  "the supply voltage. These correspond to the 'false' ('0') and 'true' ('1') values " +
                                  "of the Boolean domain respectively (named after its inventor, George Boole). " +
                                  "In this activity, you can give '0' and '1' as input to other logical devices, " +
                                  "and see their output through an output device.")
        //items.infoImage.source = ""
    }
    else if(componentName == "gateAnd.svg") {
        items.infoTxt.text = qsTr("AND gate takes 2 or more binary input in its input terminals and outputs a single " +
                                  "value. The output is 0 if any of the input is 0, else it is 1. In this activity, " +
                                  "a 2 input AND gate is shown. Truth table for 2 input AND gate is:")
        //items.infoImage.source = url + "AndTruthTable.svg"
        items.truthTablesModel.rows = 1
        items.truthTablesModel.columns = 3
        items.truthTablesModel.inputs = 2
        items.truthTablesModel.outputs = 1
        items.truthTablesModel.append({'value': "A"})
        items.truthTablesModel.append({'value': "B"})
        items.truthTablesModel.append({'value': "C"})

    }
    else if(componentName == "gateNand.svg") {
        items.infoTxt.text = qsTr("NAND gate takes 2 or more binary input in its input terminals and outputs a single " +
                                  "value. It is the complement of AND gate. In this activity, a 2 input NAND gate is " +
                                  "shown. Truth table for 2 input NAND gate is:")
        //items.infoImage.source = url + "NandTruthTable.svg"
    }
    else if(componentName == "gateNor.svg") {
        items.infoTxt.text = qsTr("NOR gate takes 2 or more binary input in its input terminals and outputs a single " +
                                  "value. It is the complement of OR gate. In this activity, a 2 input NOR gate is " +
                                  "shown. Truth table for 2 input NOR gate is:")
        //items.infoImage.source = url + "NorTruthTable.svg"
    }
    else if(componentName == "gateNot.svg") {
        items.infoTxt.text = qsTr("Not gate (also known as inverter) takes a binary input in its input terminal and " +
                                  "outputs a single value. The output is the complement of the input value, that is, it " +
                                  "is 0 if input is 1, and 1 if input is 0. Truth table for NOT gate is:")
        //items.infoImage.source = url + "NotTruthTable.svg"
    }
    else if(componentName == "gateOr.svg") {
        items.infoTxt.text = qsTr("OR gate takes 2 or more binary input in its input terminals and outputs a single " +
                                  "value. The output is 1 if any of the input is 1, else it is 0. In this activity, a " +
                                  "2 input OR gate is shown. Truth table for 2 input OR gate is:")
        //items.infoImage.source = url + "OrTruthTable.svg"
    }
    else if(componentName == "gateXor.svg") {
        items.infoTxt.text = qsTr("XOR gate takes 2 or more binary input in its input terminals and outputs a single " +
                                  "value. The output is 1 if number of '1' in input is odd, and 0 if number of '1' in " +
                                  "input is even. In this activity, a 2 input XOR gate is shown. Truth table for " +
                                  "2 input XOR gate is:")
        //items.infoImage.source = url + "XorTruthTable.svg"
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
        //items.infoImage.source = url + "BCDTo7SegmentTruthTable.svg"
    }
    else if(componentName == "BCDTo7Segment.svg") {
        items.infoTxt.text = qsTr("BCD to 7 segment converter takes 4 binary inputs which represent a BCD number, " +
                                  "and convert them to 7 binary bits which represent corresponding number in 7 segment " +
                                  "format. The truth table is:")
        //items.infoImage.source = url + "BCDTo7SegmentTruthTable.svg"
    }
    else if(componentName == "sevenSegmentDisplay.svg") {
        items.infoTxt.text = qsTr("7 segment display takes 7 binary inputs in its input terminals. The display " +
                                  "consists of 7 segments and each segment gets lighted according to the input. " +
                                  "By generating different combination of binary inputs, the display can be used to " +
                                  "display various different symbols. The diagram is:")
        //items.infoImage.source = url + "7SegmentDisplay.svg"
    }
    else if(componentName == "ledOn.svg" || componentName == "ledOff.svg") {
        items.infoTxt.text = qsTr("LED (Light-emitting diode) is a two-lead semiconductor light source. It emits " +
                                  "light when activated. LED has 2 input terminals, the longer terminal is the " +
                                  "positive terminal (anode) and smaller terminal is the negative terminal (cathode)" +
                                  ". LED is activated when anode has a higher potential than cathode. In digital " +
                                  "electronics LED can be used to check the output of the components. Connect " +
                                  "the cathode of LED to ground ('0') and anode of LED to the output of the " +
                                  "component. If output is 1, the LED will be activated (emit light), and if " +
                                  "output is 0, the LED will be deactivated.")
        //items.infoImage.source = ""
    }
    else if(componentName == "switchOn.svg" || componentName == "switchOff.svg") {
        items.infoTxt.text = qsTr("Switch is used to maintain easy connection between two terminals. If the switch is " +
                                  "turned on, then the two terminals are connected and current can flow through the " +
                                  "switch. If the switch is turned off, then the connection between terminal is broken, " +
                                  "and current can not flow through it.")
        //items.infoImage.source = ""
    }*/
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
