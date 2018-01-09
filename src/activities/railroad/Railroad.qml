/* GCompris - railroad.qml
 *
 * Copyright (C) 2016 Utkarsh Tiwari <iamutkarshtiwari@kde.org>
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
            property alias timer: timer
            property alias sampleList: sampleList
            property alias listModel: listModel
            property alias displayList: displayList
            property alias animateFlow: animateFlow
            property alias displayRow: displayRow
            property alias introMessage: introMessage
            property bool memoryMode: false
            property bool mouseEnabled: true
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        // Swipe message
        GCText {
            id: swipe
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            text: qsTr("<<== Swipe here ==>>")
            fontSize: smallSize
            font.weight: Font.DemiBold
            color: "black"
        }

        // Countdown timer
        Timer {
            id: timer
            repeat: false
            interval: 4000
            onTriggered: items.animateFlow.start()
        }

        // Intro message
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
                timer.start()
            }
            intro: [
                qsTr("Swap left-right to view all the carriages outside display area. Memorize them before the timer ends!")
            ]
        }

        // Top Display Area
        Rectangle {
            id: topDisplayArea
            width: background.width
            height: background.height / 4.5
            color: 'transparent'
            z: 1

            Flickable {
                id: flickTop
                width: parent.width
                height: parent.height
                contentWidth: displayRow.width * 1.2
                contentHeight: displayRow.height
                flickableDirection: Flickable.HorizontalFlick
                anchors.fill: parent
                interactive: !animateFlow.running

                Row {
                    id: displayRow
                    x: parent.x
                    y: background.height / 12.7
                    width: childrenRect.width
                    height: childrenRect.height
                    spacing: background.width * 0.0025

                    Repeater {
                        id: displayList
                        model: listModel
                        delegate: Image {
                            id: wagon
                            source: Activity.resourceURL + "loco1.svg"
                            height: background.height / 8.0
                            width: (background.width > background.height) ? background.width / (listModel.count > 5 ? 7.2 : 5.66) :
                                                                            background.height / ((listModel.count > 5) ? 8.2 : 6.2)
                            sourceSize.width: width
                            function checkDrop(dragItem) {
                                // Checks the drop location of this wagon
                                var globalCoordinates = dragItem.mapToItem(displayList, 0, 0)
                                if(globalCoordinates.y <= ((background.height / 12.5) + (background.height / 8))) {
                                    var dropIndex = Activity.getDropIndex(globalCoordinates.x)

                                    if(dropIndex > (listModel.count - 1)) {
                                        // Handles index overflow
                                        dropIndex = listModel.count - 1
                                    }
                                    listModel.move(listModel.count - 1, dropIndex, 1)
                                    opacity = 1
                                }
                                if(globalCoordinates.y > (background.height / 8)){
                                    // Remove it if dropped in the lower section
                                    listModel.remove(listModel.count - 1)
                                }
                            }

                            function createNewItem() {
                                var component = Qt.createComponent("Loco.qml");
                                if(component.status === Component.Ready) {
                                    var newItem = component.createObject(parent, {"x":x, "y":y, "z": 10 ,"imageIndex": listModel.get(index).id});
                                }
                                return newItem
                            }

                            MouseArea {
                                id: displayWagonMouseArea
                                hoverEnabled: true
                                enabled: (introMessage.visible ? false : true) && items.mouseEnabled
                                anchors.fill: parent

                                onPressed: {
                                    if(items.memoryMode == true) {
                                        drag.target = parent.createNewItem();
                                        parent.opacity = 0
                                        listModel.move(index, listModel.count - 1, 1)
                                    }
                                }
                                onReleased: {
                                    if(items.memoryMode == true) {
                                        var dragItem = drag.target
                                        parent.checkDrop(dragItem)
                                        dragItem.destroy();
                                        parent.Drag.cancel()
                                        Activity.isAnswer()
                                    }
                                }

                                onClicked: {
                                    bar.hintClicked()
                                }
                            }
                            states: State {
                                name: "wagonHover"
                                when: displayWagonMouseArea.containsMouse && (items.memoryMode === true)
                                PropertyChanges {
                                    target: wagon
                                    scale: 1.1
                                }
                            }
                        }
                    }
                    onXChanged: {
                        if(displayRow.x >= background.width) {
                            timer.stop()
                            animateFlow.stop();
                            displayRow.x = 2;
                            listModel.clear();
                            items.memoryMode = true;
                        }
                    }
                    PropertyAnimation {
                        id: animateFlow
                        target: displayRow
                        properties: "x"
                        from: 2
                        to: background.width
                        duration: 4000
                        easing.type: Easing.InExpo
                        loops: 1
                        onStopped: displayRow.x = 2;
                    }
                }
            }

            ListModel {
                id: listModel
            }
        }

        // Lower Sample Wagon Display Area
        GridView {
            id: sampleList
            visible: items.memoryMode
            y: (background.height / 4.7)
            z: 5
            width: background.width
            height: background.height - topDisplayArea.height
            anchors.margins: 20
            cellWidth: width / 5
            cellHeight: background.height / 7
            model: 20
            interactive: false
            delegate: Image {
                id: loco
                readonly property int uniqueID: index
                property real originX
                property real originY
                source: Activity.resourceURL + "loco" + (uniqueID + 1) + ".svg"
                height: background.height / 7.5
                width: ((background.width > background.height) ? background.width/5.66 : background.height/6.2)
                sourceSize.width: width
                visible: true

                function initDrag() {
                    originX = x
                    originY = y
                }

                function replace() {
                    x = originX
                    y = originY
                }

                function checkDrop() {
                    // Checks the drop location of this wagon
                    var globalCoordinates = loco.mapToItem(displayList, 0, 0)
                    // checks if the wagon is dropped in correct zone and no. of wagons in answer row are less than
                    //    total no. of wagons in correct answer + 2, before dropping the wagon.
                    if(globalCoordinates.y <= (background.height / 12.5) &&
                            listModel.count <= Activity.currentLevel + 2) {
                        var dropIndex = Activity.getDropIndex(globalCoordinates.x)
                        Activity.addWagon(uniqueID + 1, dropIndex);
                    }
                    Activity.isAnswer()
                }

                MouseArea {
                    id: mouseArea
                    hoverEnabled: true
                    anchors.fill: parent
                    drag.target: parent
                    drag.axis: (parent.y >= 0 && parent.y <= background.height / 7.5) ? Drag.YAxis : Drag.XAndYAxis
                    enabled: items.mouseEnabled
                    onPressed: {
                        parent.initDrag()
                    }
                    onReleased: {
                        parent.Drag.cancel()
                        parent.checkDrop()
                        parent.replace()
                    }
                }

                Component.onCompleted: initDrag();

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

        // Lower level wagons shelves
        Repeater {
            id: railSupporter
            model: 4
            Rectangle {
                x: 0
                y: sampleList.y + ((index+1) * (background.height / 7.5)) + (index*5)
                z: 1
                width: background.width
                height: 6
                border.color: "#808180"
                color: "transparent"
                border.width: 4
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
            content: BarEnumContent { value: help | home | level | hint }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onHintClicked: {
                if(!introMessage.visible && items.mouseEnabled) {
                    if(items.memoryMode == false) {
                        timer.stop()
                        animateFlow.stop();
                        displayRow.x = 2;
                        listModel.clear();
                        for(var index = 0; index < Activity.backupListModel.length; index++) {
                            Activity.addWagon(Activity.backupListModel[index], index);
                        }
                        items.memoryMode = true;
                    } else {
                        Activity.restoreLevel();
                    }
                }
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }
}
