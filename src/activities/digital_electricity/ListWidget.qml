/* gcompris - ListWidget.qml
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
import QtQuick 2.1
import GCompris 1.0
import "../../core"
import "digital_electricity.js" as Activity

Item {
    id: listWidget
    anchors.fill: parent
    anchors.topMargin: 5 * ApplicationInfo.ratio
    anchors.leftMargin: 5 * ApplicationInfo.ratio
    z: 10

    property bool vert
    property alias model: mymodel
    property alias view: view
    property alias repeater: repeater
    property alias toolDelete: toolDelete
    property alias rotateLeft: rotateLeft
    property alias rotateRight: rotateRight
    property alias info: info

    ListModel {
        id: mymodel
    }

    Grid {
        id: view
        width: listWidget.vert ? leftWidget.width : 2 * bar.height
        height: listWidget.vert ? background.height - 2 * bar.height : bar.height
        spacing: 5
        z: 20
        columns: listWidget.vert ? 1 : nbItemsByGroup + 2

        property int currentDisplayedGroup: 0
        property int setCurrentDisplayedGroup: 0
        property int nbItemsByGroup:
            listWidget.vert ?
                parent.height / iconSize - 2 :
                parent.width / iconSize - 2

        property int nbDisplayedGroup: Math.ceil(model.count / nbItemsByGroup)
        property int iconSize: 80 * ApplicationInfo.ratio
        property int previousNavigation: 1
        property int nextNavigation: 1

        onNbDisplayedGroupChanged: {
            view.setCurrentDisplayedGroup = 0
            refreshLeftWidget()
        }

        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
            NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
        }

        move: Transition {
            NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBounce }
        }

        //For setting navigation buttons
        function setNextNavigation() {
            nextNavigation = 0
            //console.log("setNextNavigation",nextNavigation)
            if(currentDisplayedGroup + 1 < nbDisplayedGroup)
                nextNavigation = 1
            //console.log("setNextNavigation",nextNavigation)
        }

        function setPreviousNavigation() {
            previousNavigation = 0
            if(currentDisplayedGroup > 0)
                previousNavigation = 1
            //console.log("setPreviousNavigation",previousNavigation)
        }

        function refreshLeftWidget() {
            //console.log("refreshLeftWidget")
            availablePieces.view.currentDisplayedGroup = availablePieces.view.setCurrentDisplayedGroup
            availablePieces.view.setNextNavigation()
            availablePieces.view.setPreviousNavigation()
        }

        Column {
            id: toolButtons
            width: listWidget.vert ? listWidget.width : listWidget.height
            height: listWidget.vert ? listWidget.width : listWidget.height
            spacing: 10
            //z: 20

            Row {
                spacing: view.iconSize * 0.20

                Image {
                    id: toolDelete
                    state: "notSelected"
                    sourceSize.width: view.iconSize * 0.35
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            toolDelete.state = "selected"
                            Activity.toolDelete = true
                            //console.log("state",toolDelete.state)
                        }
                    }
                    states: [
                        State {
                            name: "selected"
                            PropertyChanges{
                                target: toolDelete
                                source: Activity.url + "tool-del_on.png"
                            }
                        },
                        State {
                            name: "notSelected"
                            PropertyChanges {
                                target: toolDelete
                                source: Activity.url + "tool-del.png"
                            }
                        }
                    ]
                }

                Image {
                    id: info
                    source: Activity.url + "Info.svg"
                    sourceSize.width: view.iconSize * 0.35
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(!Activity.animationInProgress && parent.state == "canBeSelected") {
                                //console.log("rotateLeft clicked")
                                Activity.displayInfo()
                            }
                        }
                    }
                    states: [
                        State {
                            name: "canBeSelected"
                            PropertyChanges{
                                target: info
                                source: Activity.url + "Info.svg"
                            }
                        },
                        State {
                            name: "canNotBeSelected"
                            PropertyChanges {
                                target: info
                                source: Activity.url + "InfoOff.svg"
                            }
                        }
                    ]
                }
            }

            Row {
                spacing: view.iconSize * 0.20

                Image {
                    id: rotateLeft
                    //source: Activity.url + "rotateLeft.svg"
                    sourceSize.width: view.iconSize * 0.35
                    fillMode: Image.PreserveAspectFit
                    state: "CanNotBeSelected"
                    MouseArea {
                        anchors.fill: parent
                        //enabled: parent.state == "canBeSelected"
                        onClicked: {
                            if(!Activity.animationInProgress && parent.state == "canBeSelected") {
                                //console.log("rotateLeft clicked")
                                Activity.rotateLeft()
                            }
                        }
                    }
                    states: [
                        State {
                            name: "canBeSelected"
                            PropertyChanges{
                                target: rotateLeft
                                source: Activity.url + "rotateLeft.svg"
                            }
                        },
                        State {
                            name: "canNotBeSelected"
                            PropertyChanges {
                                target: rotateLeft
                                source: Activity.url + "rotateLeftOff.svg"
                            }
                        }
                    ]
                }

                Image {
                    id: rotateRight
                    //source: Activity.url + "rotateRight.svg"
                    sourceSize.width: view.iconSize * 0.35
                    fillMode: Image.PreserveAspectFit
                    state: "CanNotBeSelected"
                    MouseArea {
                        anchors.fill: parent
                        //enabled: parent.state == "canBeSelected"
                        onClicked: {
                            if(!Activity.animationInProgress && parent.state == "canBeSelected") {
                                //console.log("rotateRight clicked")
                                Activity.rotateRight()
                            }
                        }
                    }
                    states: [
                        State {
                            name: "canBeSelected"
                            PropertyChanges{
                                target: rotateRight
                                source: Activity.url + "rotateRight.svg"
                            }
                        },
                        State {
                            name: "canNotBeSelected"
                            PropertyChanges {
                                target: rotateRight
                                source: Activity.url + "rotateRightOff.svg"
                            }
                        }
                    ]
                }
            }
        }

        Repeater {
            id: repeater
            property int currentIndex
            width: 100
            /*onCurrentIndexChanged: {
                for(var i = 0; i < mymodel.count; i++) {
                    if(currentIndex != i)
                        repeater.itemAt(i).selected = false
                    else
                        repeater.itemAt(i).selected = true
                }
                if(currentIndex == -1)
                    toolTip.opacity = 0
            }*/
            DragListItem {
                id: contactsDelegate
                z: 1
                heightInColumn: view.iconSize * 0.75//listWidget.vert ? view.iconSize * 0.75 : view.iconSize * 0.9
                widthInColumn: view.iconSize * 0.85//listWidget.vert ? view.iconSize * 0.9 : view.iconSize * 0.75
                tileWidth: view.iconSize//listWidget.vert ? view.iconSize : view.iconSize * 0.85
                tileHeight: view.iconSize * 0.85//listWidget.vert ? view.iconSize * 0.85 : view.iconSize
                visible: view.currentDisplayedGroup * view.nbItemsByGroup <= index &&
                         index <= (view.currentDisplayedGroup+1) * view.nbItemsByGroup-1

                onPressed: repeater.currentIndex = index
            }

            clip: true
            model: mymodel

            onModelChanged: repeater.currentIndex = -1
        }

        Row {
            spacing: view.iconSize * 0.20
            Image {
                id: previous
                opacity: (model.count > view.nbItemsByGroup &&
                          view.previousNavigation != 0 && view.currentDisplayedGroup != 0) ? 1 : 0
                source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
                sourceSize.width: view.iconSize * 0.30
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        repeater.currentIndex = -1
                        if(previous.opacity == 1) {
                            view.setCurrentDisplayedGroup = view.currentDisplayedGroup - view.previousNavigation
                            view.refreshLeftWidget()
                        }
                    }
                }
            }

            Image {
                id: next
                visible: model.count > view.nbItemsByGroup && view.nextNavigation != 0 && view.currentDisplayedGroup <
                         view.nbDisplayedGroup - 1
                source: "qrc:/gcompris/src/core/resource/bar_next.svg"
                sourceSize.width: view.iconSize * 0.30
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        repeater.currentIndex = -1
                        view.setCurrentDisplayedGroup = view.currentDisplayedGroup + view.nextNavigation
                        view.refreshLeftWidget()
                    }
                }
            }
        }
    }
}
