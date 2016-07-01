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
import "../../core"
import "family.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "back.svg"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop
        property bool horizontalLayout:background.width > background.height

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias nodecreator:nodecreator
            property alias answerschoice: answerschoice
            property alias edgecreator: edgecreator
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Item {
            id: partition
            width: background.width
            height: background.height
            Rectangle {
                id: tree
                color: "transparent"
                width: background.horizontalLayout ? background.width*0.65 : background.width
                height: background.horizontalLayout ? background.height : background.height*0.65
                border.color: "black"
                border.width: 5
                Item {
                    id: treestructure
                    Repeater {
                        id: nodecreator
                        model: ListModel{}
                        delegate:
                            Tree {
                            id: currentpointer
                            x: xx*tree.width
                            y: yy*tree.height
                            width: tree.width/5
                            height: tree.width/5
                            recwidth: currentpointer.width
                            recheight: currentpointer.height
                            searchitem: 3
                            nodeimagesource: Activity.url+nodee
                            bordercolor: "black"
                            borderwidth: 4
                            colorr: "transparent"
                            radius: recwidth/2
                            state:currentstate

                            MouseArea {
                                id: nodemousearea
                                anchors.fill: parent

                            }

                            states: [
                               State {
                                     name: "active"
                                     PropertyChanges {
                                         target: currentpointer
                                         bordercolor: "blue"
                                     }
                               },
                               State {
                                      name: "deactive"
                                      PropertyChanges {
                                          target: currentpointer

                                      }
                               },
                               State {
                                    name: "activeto"
                                    PropertyChanges {
                                        target: currentpointer
                                        bordercolor: "red"
                                    }
                               }

                            ]

                            SequentialAnimation {
                                id: anim
                                running: currentpointer.state === "active" || currentpointer.state === "activeto"
                                loops: Animation.Infinite
                                alwaysRunToEnd: true
                                NumberAnimation {
                                    target: currentpointer
                                    property: "rotation"
                                    from: 0; to: 10
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: currentpointer
                                    property: "rotation"
                                    from: 10; to: -10
                                    duration: 400
                                    easing.type: Easing.InOutQuad
                                }
                                NumberAnimation {
                                    target: currentpointer
                                    property: "rotation"
                                    from: -10; to: 0
                                    duration: 200
                                    easing.type: Easing.InQuad
                                }
                            }
                        }
                    }

                   GCText {
                        id: me
                        text:qsTr("Me")
                        visible: Activity.treestructure[bar.level-1].captions[0] !== undefined
                        x: Activity.treestructure[bar.level-1].captions[0][0]*tree.width
                        y: Activity.treestructure[bar.level-1].captions[0][1]*tree.height
                        width: tree.width/12
                        height: tree.height/14
                    }

                    Image {
                        id: questionmark
                        source: Activity.url + "questionmark.svg"
                        visible: Activity.treestructure[bar.level-1].captions[1] !== undefined
                        x: Activity.treestructure[bar.level-1].captions[1][0]*tree.width
                        y: Activity.treestructure[bar.level-1].captions[1][1]*tree.height
                    }

                    Repeater {
                        id: edgecreator
                        model: ListModel{}
                        delegate: Rectangle {
                            id: edge
                            opacity: 1
                            antialiasing: true
                            state: edgestate
                            transformOrigin: Item.TopLeft
                            x: x1*tree.width
                            y: y1*tree.height
                            property var x2: x22*tree.width
                            property var y2: y22*tree.height
                            width: Math.sqrt(Math.pow(x - x2, 2) + Math.pow(y- y2, 2))
                            height: 4 * ApplicationInfo.ratio
                            rotation: (Math.atan((y2 - y)/(x2-x)) * 180 / Math.PI) + (((y2-y) < 0 && (x2-x) < 0) * 180) + (((y2-y) >= 0 && (x2-x) < 0) * 180)

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

                            states:[
                                State {
                                    name: "married"
                                    PropertyChanges {
                                        target: edge
                                        color: "#F1C40F"
                                    }
                                },
                                State {
                                    name: "siblings"
                                    PropertyChanges {
                                         target:edge
                                         color:"#28B463"
                                    }
                                },
                                State {
                                  name: "others"
                                  PropertyChanges {
                                      target: edge
                                      color:"black"
                                  }
                                }
                            ]
                        }

                    }
                }
            }

            Rectangle {
                id: answers
                color: "transparent"
                width: background.horizontalLayout ? background.width*0.35 : background.width
                height: background.horizontalLayout ? background.height : background.height*0.35
                anchors.left: background.horizontalLayout ?  tree.right : partition.left
                anchors.top: background.horizontalLayout ? partition.top: tree.bottom
                border.color: "black"
                border.width: 5
                Image {
                    width: parent.width * 0.99
                    height: parent.height * 0.99
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Activity.url + "answerarea.svg"
                    Grid {
                        columns: 1
                        rowSpacing: 20
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        Repeater {
                            id: answerschoice
                            model: ListModel{}
                            delegate:
                                AnswerButton {
                                    id: options
                                    width: answers.width*0.70
                                    height: answers.height*Activity.answerbuttonheight
                                    textLabel: optionn
                                    isCorrectAnswer: textLabel === answer
                                    onCorrectlyPressed: bonus.good("lion")
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
