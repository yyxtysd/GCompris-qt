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
            property alias answerZone: answerZone
            property alias animateFlow: animateFlow
            property alias introMessage: introMessage
            property bool memoryMode: false
            property bool mouseEnabled: true
            property string currentKeyZone: "sampleGrid"
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }
        Keys.enabled: !timer.running && !animateFlow.running
        Keys.onPressed: (items.currentKeyZone === "answerRow") ? answerZone.handleKeys(event) : sampleList.handleKeys(event)


        // Countdown timer
        Timer {
            id: timer
            repeat: false
            interval: 4000
            onTriggered: {
                items.animateFlow.start()
                activity.audioEffects.play(Activity.resourceURL + 'sounds/train.wav')
            }
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
                qsTr("Observe and remember the train before the timer ends and then drag the items to set up a similar train.")
            ]
        }

        // Top Display Area
        Rectangle {
            id: topDisplayArea
            width: background.width
            height: background.height / 4.5
            y: background.height / 12.7
            color: 'transparent'
            z: 1

            GridView {
                id: answerZone
                readonly property int levelCellWidth: (background.width > background.height) ? background.width / (listModel.count > 5 ? 7.2 : 5.66) :
                                                                                               background.height / ((listModel.count > 5) ? 8.8 : 6.2)
                readonly property int levelCellHeight: background.height / 8
                width: parent.width
                height: background.height / 8
                cellWidth: levelCellWidth
                cellHeight: levelCellHeight
                x: parent.x
                interactive: false
                model: listModel
                delegate: Image {
                    id: wagon
                    source: Activity.resourceURL + "loco" + (modelData) + ".svg"
                    height: answerZone.levelCellHeight
                    width: answerZone.levelCellWidth
                    sourceSize.width: width
                    function checkDrop(dragItem) {
                        // Checks the drop location of this wagon
                        var globalCoordinates = dragItem.mapToItem(answerZone, 0, 0)
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
                            activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
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
                            //skips memorization time.
                            if(!items.memoryMode) {
                                bar.hintClicked()
                            }
                            else {
                                items.currentKeyZone = "answerRow"
                                answerZone.currentIndex = index
                            }

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

                onXChanged: {
                    if(answerZone.x >= background.width) {
                        timer.stop()
                        animateFlow.stop();
                        answerZone.x = 2;
                        listModel.clear();
                        items.memoryMode = true;
                    }
                }

                PropertyAnimation {
                    id: animateFlow
                    target: answerZone
                    properties: "x"
                    from: answerZone.x
                    to: background.width
                    duration: 4000
                    easing.type: Easing.InExpo
                    loops: 1
                    onStopped: answerZone.x = 2;
                }

                function handleKeys(event) {
                    // Switch zones via tab key.
                    if(event.key === Qt.Key_Tab) {
                        items.currentKeyZone = "sampleGrid"
                        sampleList.currentIndex = 0
                        answerZone.currentIndex = -1
                    }
                    if(event.key === Qt.Key_Down) {
                        items.currentKeyZone = "sampleGrid"
                        answerZone.currentIndex = -1
                        sampleList.currentIndex = 0
                    }
                    if(event.key === Qt.Key_Up) {
                        items.currentKeyZone = "sampleGrid"
                        answerZone.currentIndex = -1
                        sampleList.currentIndex = 0
                    }
                    if(event.key === Qt.Key_Left) {
                        items.currentKeyZone = "answerRow"
                        answerZone.moveCurrentIndexLeft()
                    }
                    if(event.key === Qt.Key_Right) {
                        items.currentKeyZone = "answerRow"
                        answerZone.moveCurrentIndexRight()
                    }
                    // Remove a wagon via Delete/Return key.
                    if(event.key === Qt.Key_Delete || event.key === Qt.Key_Return) {
                        activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
                        listModel.remove(answerZone.currentIndex)
                        Activity.isAnswer();
                    }
                    // Swaps two wagons with help of Space/Enter keys.
                    if(event.key === Qt.Key_Space || event.key === Qt.Key_Enter && listModel.count > 1) {
                        if(swapMode === false) {
                            swapIndex1 = answerZone.currentIndex;
                            swapHighlight.x = answerZone.currentItem.x;
                            swapHighlight.y = answerZone.currentItem.y;
                            swapHighlight.visible = true;
                            swapMode = true;
                        }
                        else {
                            swapIndex2 = answerZone.currentIndex;
                            var min = Math.min(swapIndex1, swapIndex2);
                            var max = Math.max(swapIndex1, swapIndex2);
                            listModel.move(min, max, 1);
                            listModel.move(max-1, min, 1);
                            swapMode = false;
                            swapHighlight.visible = false;
                            Activity.isAnswer();
                        }
                    }
                }
                // variables for storing the index of wagons to be swaped via key navigations.
                property int swapIndex1: 0
                property int swapIndex2: 0

                // Boolean for checking whether swaping wagons via key navigation is in progress or not.
                //     Set to true when one of the wagon is already selected for swapping.
                property bool swapMode: false

                Keys.enabled: true
                focus: true
                keyNavigationWraps: true
                highlightRangeMode: GridView.ApplyRange
                highlight: Rectangle {
                    width: answerZone.cellWidth
                    height: answerZone.cellHeight
                    color: "blue"
                    opacity: 0.3
                    radius: 5
                    visible: (items.currentKeyZone === "answerRow") && (!timer.running && !animateFlow.running)
                    x: visible ? answerZone.currentItem.x : 0
                    y: visible ? answerZone.currentItem.y : 0
                    Behavior on x {
                        SpringAnimation {
                            spring: 3
                            damping: 0.2
                        }
                    }
                    Behavior on y {
                        SpringAnimation {
                            spring: 3
                            damping: 0.2
                        }
                    }
                }
                highlightFollowsCurrentItem: false
            }

            // Used to highlight a wagon selected for swaping via key navigations.
            Rectangle {
                id: swapHighlight
                width: answerZone.cellWidth
                height: answerZone.cellHeight
                visible: false
                color: "#AA41AAC4"
                opacity: 0.8
                radius: 5
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
            readonly property int wagonsInEachRow: 5
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
                    var globalCoordinates = loco.mapToItem(answerZone, 0, 0)
                    // checks if the wagon is dropped in correct zone and no. of wagons in answer row are less than
                    //    total no. of wagons in correct answer + 2, before dropping the wagon.
                    if(globalCoordinates.y <= (background.height / 12.5) &&
                            listModel.count <= Activity.currentLevel + 2) {
                        activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
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
                    onClicked: {
                        items.currentKeyZone = "sampleGrid"
                        sampleList.currentIndex = index
                    }
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

            function handleKeys(event) {
                if(event.key === Qt.Key_Tab) {
                    if(listModel.count > 0) {
                        items.currentKeyZone = "answerRow"
                        sampleList.currentIndex = -1
                        answerZone.currentIndex = 0
                    }
                }
                if(event.key === Qt.Key_Up) {
                    items.currentKeyZone = "sampleGrid"
                    // Checks if current highlighted element is in first row of the grid.
                    if(sampleList.currentIndex < wagonsInEachRow && listModel.count > 0) {
                        items.currentKeyZone = "answerRow"
                        answerZone.currentIndex = 0
                        sampleList.currentIndex = -1
                    }
                    else {
                        sampleList.moveCurrentIndexUp()
                    }
                }
                if(event.key === Qt.Key_Down) {
                    items.currentKeyZone = "sampleGrid"
                    sampleList.moveCurrentIndexDown()
                }
                if(event.key === Qt.Key_Left) {
                    items.currentKeyZone = "sampleGrid"
                    sampleList.moveCurrentIndexLeft()
                }
                if(event.key === Qt.Key_Right) {
                    items.currentKeyZone = "sampleGrid"
                    sampleList.moveCurrentIndexRight()
                }
                if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
                    // At most (current level + 2) wagons are allowed in answer row at a time.
                    if(listModel.count <= Activity.currentLevel + 2) {
                        activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
                        Activity.addWagon(sampleList.currentIndex + 1, listModel.count);
                        Activity.isAnswer();
                    }
                }
            }

            Keys.enabled: true
            focus: true
            keyNavigationWraps: true
            highlightRangeMode: GridView.ApplyRange
            highlight: Rectangle {
                width: sampleList.cellWidth
                height: sampleList.cellHeight
                color: "#AA41AAC4"
                opacity: 0.8
                radius: 5
                visible: items.currentKeyZone === "sampleGrid"
                x: (sampleList.currentIndex >= 0) ? sampleList.currentItem.x : 0
                y: (sampleList.currentIndex >= 0) ? sampleList.currentItem.y : 0
                Behavior on x {
                    SpringAnimation {
                        spring: 3
                        damping: 0.2
                    }
                }
                Behavior on y {
                    SpringAnimation {
                        spring: 3
                        damping: 0.2
                    }
                }
            }
            highlightFollowsCurrentItem: false
        }

        // Lower level wagons shelves
        Repeater {
            id: railSupporter
            model: 4
            Rectangle {
                x: 0
                y: sampleList.y + ((index + 1) * (background.height / 7.5)) + (index * 5)
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
            fontSize: background.width > background.height ? internalTextComponent.smallSize : internalTextComponent.tinySize
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
