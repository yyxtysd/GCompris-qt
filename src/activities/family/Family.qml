/* GCompris - family.qml
 *
 * Copyright (C) 2016 RAJDEEP KAUR <rajdeep.kaur@kde.org>
 *
 * Authors:
 *
 *   RAJDEEP KAUR <rajdeep.kaur@kde.org>
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
import QtQuick 2.1
import GCompris 1.0
import QtGraphicalEffects 1.0
import "../../core"
import "family.js" as Activity

ActivityBase {
    id: activity

    property string mode: "normal"

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "back.svg"
        sourceSize.width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        property bool horizontalLayout: background.width > background.height

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        property real treeAreaWidth: background.horizontalLayout ? background.width * 0.65 : background.width
        property real treeAreaHeight: background.horizontalLayout ? background.height : background.height * 0.65

        property real nodeWidth: (0.8 * treeAreaWidth) / 5
        property real nodeHeight: (0.8 * treeAreaWidth) / 5

        property real nodeWidthRatio: nodeWidth / treeAreaWidth
        property real nodeHeightRatio: nodeHeight / treeAreaHeight

        onWidthChanged: loadDatasetDelay.start()
        onHeightChanged: if (!loadDatasetDelay.running) {
                            loadDatasetDelay.start()
                         }

        /*
         * Adding a delay before reloading the datasets
         * needed for fast width / height changes
         */
        Timer {
            id: loadDatasetDelay
            running: false
            repeat: false
            interval: 100
            onTriggered: Activity.loadDatasets()
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias nodeCreator: nodeCreator
            property alias answersChoice: answersChoice
            property alias edgeCreator: edgeCreator
            property alias wringcreator: wringcreator
            property alias dataset: dataset
            property string mode: activity.mode
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Dataset {
            id: dataset
        }

        Item {
            id: selectedPairs
            property bool nodePreviouslySelected: false
            property int firstNodeValue
            property int secondNodeValue
            property var firstNodePointer
            property var secondNodePointer

            function deactivatePairs() {
                if (firstNodePointer && secondNodePointer) {
                    firstNodePointer.changeState("deactive")
                    secondNodePointer.changeState("deactive")
                }
            }

            function checkResult() {
                if (firstNodeValue == (secondNodeValue * -1) && firstNodeValue != 0) {
                    return true
                } else {
                    return false
                }
            }

            function selectNode(node_) {
                if(!nodePreviouslySelected) {
                    nodePreviouslySelected = true
                    firstNodePointer = node_
                    firstNodeValue = node_.weight
                    firstNodePointer.changeState("active")
                } else {
                    secondNodePointer = node_
                    secondNodeValue = node_.weight
                    secondNodePointer.changeState("activeTo")

                    // checking results
                    if (checkResult()) {
                        bonus.good("lion")
                    } else {
                        bonus.bad("lion")
                        deactivatePairs()
                    }

                    nodePreviouslySelected = false
                }
            }
        }

        Item {
            id: partition
            width: background.width
            height: background.height
            Rectangle {
                id: treeArea
                color: "transparent"
                width: background.treeAreaWidth
                height: background.treeAreaHeight
                border.color: "black"
                border.width: 5
                Item {
                    id: treeItem
                    Repeater {
                        id: nodeCreator
                        model: ListModel{}
                        delegate:
                            Node {
                            id: currentPointer
                            x: xPosition * treeArea.width
                            y: yPosition * treeArea.height
                            width: treeArea.width / 5
                            height: treeArea.width / 5
                            nodeWidth: currentPointer.width
                            nodeHeight: currentPointer.height
                            nodeImageSource: Activity.url + nodeValue
                            borderColor: "black"
                            borderWidth: 4
                            color: "transparent"
                            radius: nodeWidth / 2
                            state:  currentState
                            weight: nodeWeight

                            states: [
                               State {
                                     name: "active"
                                     PropertyChanges {
                                         target: currentPointer
                                         borderColor: "blue"
                                     }
                               },
                               State {
                                      name: "deactive"
                                      PropertyChanges {
                                          target: currentPointer
                                      }
                               },
                               State {
                                    name: "activeTo"
                                    PropertyChanges {
                                        target: currentPointer
                                        borderColor: "red"
                                    }
                               }
                            ]
                        }
                    }

                    Rectangle {
                        id: me
                        visible: dataset.levelElements[bar.level-1].captions[0] !== undefined && activity.mode == "normal"
                        x: dataset.levelElements[bar.level-1].captions[0][0]*treeArea.width
                        y: dataset.levelElements[bar.level-1].captions[0][1]*treeArea.height

                        width: treeArea.width/12
                        height: treeArea.height/14

                        radius: 5
                        border.color: "black"
                        GCText {
                            id: meLabel
                            text: qsTr("Me")
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }
                        }
                    }

                    Image {
                        id: questionmark
                        source: Activity.url + "questionmark.svg"
                        visible: dataset.levelElements[bar.level-1].captions[1] !== undefined && activity.mode == "normal"
                        x: dataset.levelElements[bar.level-1].captions[1][0]*treeArea.width
                        y: dataset.levelElements[bar.level-1].captions[1][1]*treeArea.height
                    }

                    Repeater {
                        id: edgeCreator
                        model: ListModel {}
                        delegate: Rectangle {
                            id: edge
                            opacity: 1
                            antialiasing: true
                            transformOrigin: Item.TopLeft
                            x: x1*treeArea.width
                            y: y1*treeArea.height
                            property var x2: x22*treeArea.width
                            property var y2: y22*treeArea.height
                            width: Math.sqrt(Math.pow(x - x2, 2) + Math.pow(y- y2, 2))
                            height: 4 * ApplicationInfo.ratio
                            rotation: (Math.atan((y2 - y)/(x2-x)) * 180 / Math.PI) + (((y2-y) < 0 && (x2-x) < 0) * 180) + (((y2-y) >= 0 && (x2-x) < 0) * 180)
                            color: "black"
                            Behavior on height {
                                NumberAnimation {
                                    duration: 2000
                                    easing.type: Easing.OutExpo
                                }
                            }

                            Behavior on width {
                                NumberAnimation {
                                    duration: 2000
                                    easing.type: Easing.OutExpo
                                }
                            }
                        }
                    }

                    Repeater {
                        id: wringcreator
                        model: ListModel{}
                        delegate: Image {
                            id: wring
                            source: Activity.url + "rings.svg"
                            width: treeArea.width*0.04
                            height: treeArea.width*0.04
                            x: ringx*treeArea.width
                            y: ringy*treeArea.height
                        }
                    }
                }
            }

            Rectangle {
                id: answers
                color: "transparent"
                width: background.horizontalLayout ? background.width*0.35 : background.width
                height: background.horizontalLayout ? background.height : background.height*0.35
                anchors.left: background.horizontalLayout ? treeArea.right : partition.left
                anchors.top: background.horizontalLayout ? partition.top: treeArea.bottom
                border.color: "black"
                border.width: 5
                Rectangle {
                    width: parent.width * 0.99
                    height: parent.height * 0.99
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "transparent"

                    GCText {
                        id: question
                        visible: activity.mode == "expert" ? true : false
                        width: parent.width
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        text: qsTr("Select the pair which denote the following relation: %1").arg(dataset.levelElements[bar.level - 1].answer[0])

                        Rectangle {
                            anchors.fill: parent
                            z: parent.z - 1
                            radius: 10
                            border.width: 1

                            color: "white"
                            opacity: 0.8
                        }
                    }

                    Grid {
                        visible: activity.mode == "normal" ? true : false
                        columns: 1
                        rowSpacing: 20
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        Repeater {
                            id: answersChoice
                            model: ListModel {}
                            delegate:
                                AnswerButton {
                                    id: options
                                    width: answers.width*0.75
                                    height: answers.height*Activity.answerButtonRatio
                                    textLabel: optionn
                                    isCorrectAnswer: textLabel === answer
                                    onCorrectlyPressed: bonus.good("lion")
                                    onIncorrectlyPressed: bonus.bad("lion")
                            }
                        }
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
