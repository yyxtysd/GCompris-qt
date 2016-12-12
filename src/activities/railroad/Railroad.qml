/* GCompris - railroad.qml
 *
 * Copyright (C) 2016 YOUR NAME <xx@yy.org>
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

import "../../core"
import "railroad.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

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
            property alias sampleList: sampleList
            property alias listModel: listModel
            property alias displayList: displayList
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        //        GCText {
        //            anchors.centerIn: parent
        //            text: "UTKARSH TIWARI"
        //            fontSize: largeSize
        //        }

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
                                listModel.remove(index);
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
            }
            ListModel {
                id: listModel
            }
        }

        // Lower Sample Wagon Display Area
        Rectangle {
            id: railCollection
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
                                Activity.addWagon(index);
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
