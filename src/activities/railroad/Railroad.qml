/* GCompris - railroad.qml
 *
 * Copyright (C) 2016  <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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
            property alias railCollection: railCollection
        }

        onStart: {
            barAtStart = ApplicationSettings.isBarHidden;
            ApplicationSettings.isBarHidden = true;
            Activity.start(items)
        }
        onStop: { Activity.stop() }

        // Top Display Area
        Rectangle {
            Flow {
                id: displayFlow
                x: 2
                y: background.height / 12
                Repeater {
                    id: displayList
                    model: listModel
                    delegate: Image {
                        id: wagon
                        source: Activity.resourceURL + "loco1.svg"
                        height: background.height / 8.5
                        width: background.width / (Activity.railWidthArray[0] + 1)
                        visible: true

                        MouseArea {
                            id: displayWagonMouseArea
                            hoverEnabled: true
                            enabled: true
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
                                    Activity.items.railCollection.visible = true
                                    ApplicationSettings.isBarHidden = true;
                                }
                            }
                        }
                        states: State {
                            name: "waganHover"
                            when: displayWagonMouseArea.containsMouse
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
                        Activity.items.railCollection.visible = true;
                        ApplicationSettings.isBarHidden = true;
                    }
                }
                PropertyAnimation {
                    id: animateFlow
                    target: displayFlow
                    properties: "x"
                    from: 2
                    to: background.width
                    duration: 18000
                    easing.type: Easing.InExpo
                    loops: 1
                }
            }
            ListModel {
                id: listModel
            }
        }

        // Lower Sample Wagon Display Area
        Rectangle {
            id: railCollection
            visible: false
            Flow {
                id: railCarriages
                x: 2
                y: background.height / 4.7
                height: background.height - (background.height / 5)
                width: background.width
                anchors.margins: 1
                anchors.bottomMargin: 10
                spacing: 8
                flow: Flow.LeftToRight
                Repeater {
                    id: sampleList
                    model: 22

                    Image {
                        id: loco
                        source: Activity.resourceURL + "loco" + (index + 1) + ".svg"
                        height: background.height / 7.5
                        width: background.width / Activity.railWidthArray[index]
                        visible: true
                        MouseArea {
                            id: mouseArea
                            hoverEnabled: true
                            enabled: true
                            anchors.fill: parent
                            onClicked: {
                                Activity.addWagon(index + 1);
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
