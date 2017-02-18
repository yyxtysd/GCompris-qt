/* GCompris - railroad.qml
 *
 * Copyright (C) 2016  Utkarsh Tiwari <iamutkarshtiwari@kde.org>
 *
 * Authors:
 *   Pascal Georges (GTK+ version)
 *   Utkarsh Tiwari <iamutkarshtiwari@kde.org> (Qt Quick port)
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
import "railroad.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property variant barAtStart

    pageComponent: Image {
        id: background
        source: Activity.resourceURL + "railroad-bg.svg"
        height: activity.height / 2
        width: activity.width
        anchors.fill: parent

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
            property alias score: score
            property alias sampleList: sampleList
            property alias listModel: listModel
            property alias displayList: displayList
            property alias animateFlow: animateFlow
            property alias displayFlow: displayFlow
            property alias railCollection: railCollection
            property alias introMessage: introMessage
        }

        onStart: {
            Activity.start(items)
        }
        onStop: { Activity.stop() }

        // Top Display Area
        Rectangle {
            Flickable {
                id: flickTop
                width: background.width
                height: background.height
                contentWidth: displayFlow.width
                contentHeight: width
                flickableDirection: Flickable.HorizontalFlick
                x: 2
                y : background.height / 12.5
                Row {
                    id: displayFlow
                    x: flickTop.x
                    y: 0
                    width: childrenRect.width
                    spacing: background.width * 0.0025
                    rotation: 0

                    Repeater {
                        id: displayList
                        model: listModel
                        Image {
                            id: wagon
                            source: Activity.resourceURL + "loco1.svg"
                            height: background.height / 8.0
                            width: ((background.width > background.height) ? background.width : background.height) / 4.66
                            visible: true
                            rotation: displayFlow.rotation

                            MouseArea {
                                id: displayWagonMouseArea
                                hoverEnabled: true
                                enabled: introMessage.visible ? false : true
                                anchors.fill: parent

                                onClicked: {
                                    if (Activity.memoryMode == true) {
                                        listModel.remove(index);
                                        Activity.isAnswer();
                                    } else {
                                        animateFlow.stop();
                                        displayFlow.x = 2;
                                        listModel.clear();
                                        Activity.memoryMode = true;
                                        Activity.items.displayFlow.rotation = 180;
                                        Activity.items.railCollection.visible = true
                                    }
                                }
                            }
                            states: State {
                                name: "waganHover"
                                when: displayWagonMouseArea.containsMouse && (Activity.memoryMode === true)
                                PropertyChanges {
                                    target: wagon
                                    scale: 1.1
                                }
                            }
                        }
                    }
                    onXChanged: {
                        if (displayFlow.x >= background.width) {
                            animateFlow.stop();
                            displayFlow.x = 2;
                            listModel.clear();
                            Activity.memoryMode = true;
                            displayFlow.rotation = 180;
                            items.railCollection.visible = true;
                        }
                    }
                    PropertyAnimation {
                        id: animateFlow
                        target: displayFlow
                        properties: "x"
                        from: 2
                        to: background.width
                        duration: 14000
                        easing.type: Easing.InExpo
                        loops: 1
                    }
                }
                ListModel {
                    id: listModel
                }
            }
        }

        // Lower Sample Wagon Display Area
        Rectangle {
            id: railCollection
            color: "transparent"
            visible: false
            Repeater {
                id: sampleList
                model: 4
                Flickable {
                    x: 2
                    y: (background.height / 4.7) + (index * (background.height / 6.5))
                    height: background.height / 7.5
                    width: background.width
                    contentWidth:  railCarriages.childrenRect.width
                    contentHeight: height
                    flickableDirection: Flickable.HorizontalFlick
                    Row {
                        id: railCarriages
                        property real rowNo: index
                        anchors.margins: 1
                        anchors.bottomMargin: 10
                        spacing: background.width * 0.0025
                        y: 0
                        height: background.height / 7.5
                        width: childrenRect.width
                        Repeater {
                            id: eachRow
                            model: Activity.noOfCarriages[parent.rowNo]
                            Image {
                                id: loco
                                readonly property int uniqueID: Activity.sum(parent.rowNo) + index
                                source: Activity.resourceURL + "loco" + (uniqueID + 1) + ".svg"
                                height: background.height / 7.5
                                width: ((background.width > background.height) ? background.width : background.height) / 4.66
                                visible: true
                                MouseArea {
                                    id: mouseArea
                                    hoverEnabled: true
                                    enabled: true
                                    anchors.fill: parent
                                    onClicked: {
                                        Activity.addWagon(parent.uniqueID + 1);
                                        Activity.isAnswer();
                                    }
                                }
                                states: State {
                                    name: "carHover"
                                    when: mouseArea.containsMouse
                                    PropertyChanges {
                                        target: loco
                                        scale: 1.1
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Lower level wagons shelves
        Repeater {
            id: railSupporter
            model: 4
            Rectangle {
                x: 0
                y: (background.height / 2.9) + (index * (background.height / 6.5))
                width: background.width
                height: 5
                border.color: "#808180"
                color: "transparent"
                border.width: 5
            }
        }

        IntroMessage {
            id: introMessage
            y: (background.height / 4.7)
            anchors {
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            z: 100
            onIntroDone: {
                items.animateFlow.start();
            }
            intro: [
                qsTr("Swap left-right to view all the carriages outside display area!")
            ]
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Score {
            id: score
            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: undefined
            anchors.left: undefined
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: {
                Activity.reset()
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.advanceSubLevel)
        }
    }
}
