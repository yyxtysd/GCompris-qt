/* GCompris - alphabetical_order.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
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
import "alphabetical_order.js" as Activity

ActivityBase {
    id: activity

    property string type: "letter"

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#fffae6"

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
            dialogActivityConfig.getInitialConfiguration()
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property GCAudio audioVoices: activity.audioVoices
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias listModel: listModel
            property alias listModelInput: listModelInput
            property alias repeater: repeater
            property alias inputRepeater: inputRepeater
            property alias message: message
            property bool gameFinished: false
            property int delay: 6
            property bool okBoxChecked: false
            property bool easyMode: false
            property bool playLetter: false
            property double startTime
            property bool passedLevel: false
        }

        onStart: { Activity.start(items,type) }
        onStop: { Activity.stop() }

        onFocusChanged: {
            if(focus) {
                Activity.focusTextInput()
            }
        }

        IntroMessage {
            id: message
            z: 1
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            intro: [
                qsTr("Drag and alphabetically order the letters from bottom to their place on top."),
                qsTr("You can press on the configuration button to select different options."),
                qsTr("If the OK button is activated, the level correctness will be checked only after pressing the OK button; else, if the answer is correct, the next level will be automatically loaded."),
                qsTr("If the 'easy mode' is activated, when dragging a letter to its right place, a sparkle effect will appear, otherwise the letter will glow in red."),
                qsTr("When pressing on a letter, a voice will spell it if the 'Play letter sound' is activated.")
            ]
            Behavior on opacity { PropertyAnimation { duration: 200 } }
        }

        ListModel {
            id: listModel
        }

        ListModel {
            id: listModelInput
        }

        property int delay: 20
        function resetTime(timeDelay) {
            items.startTime = Math.round(Activity.date.getTime() / 1000)
            background.delay = timeDelay
        }

        // checks if the user had not made a move in "background.delay" time and shows help
        Timer {
            interval: 2000; running: true; repeat: true
            onTriggered: {
                // reinitialize the date
                Activity.date = new Date()
                // check if "background.delay" time has passed since the last move
                if (Math.round(Activity.date.getTime() / 1000) - items.startTime > background.delay ) {
                    // on easyMode, show the first "good" move
                    if (items.easyMode) {
                        for (var i = 0; i < items.listModel.count; i++) {
                            var found = false
                            // letter at index i is in the wrong place
                            if (items.listModel.get(i).letter != Activity.solution[i]) {
                                // search for the good letter in the listModel
                                for (var j = 0; j < items.listModel.count; j++) {
                                    if (items.listModel.get(j).letter == Activity.solution[i]) {
                                        items.repeater.itemAt(i).failureAnimation.start()
                                        items.repeater.itemAt(j).failureAnimation.start()
                                        found = true
                                        break
                                    }
                                }
                                // search for the good letter in the listModelInput
                                if (!found) {
                                    for (j = 0; j < items.listModelInput.count; j++)
                                        if (items.listModelInput.get(j).letter == Activity.solution[i]) {
                                            items.repeater.itemAt(i).failureAnimation.start()
                                            items.inputRepeater.itemAt(j).failureAnimation1.start()
                                            break
                                        }
                                }
                                // found the first wrong => break
                                break
                            }
                        }

                    // if not easy mode, show all the wrong placed letters
                    } else {
                        for (i = 0; i < items.listModel.count; i++)
                            // letter at index i is in the wrong place
                            if (items.listModel.get(i).letter != Activity.solution[i])
                                items.repeater.itemAt(i).failureAnimation.start()
                    }

                    // repeat after 10 seconds
                    background.resetTime(10)
                }
            }
        }


        Timer {
            id: finishAnimation
            interval: 100
            repeat: true

            // repeater index of item to load the particles
            property int index: 0

            // how much the game should wait untill passing to next level
            property int delay: items.delay

            onTriggered: {
                if (index < items.repeater.count) {
                    // start the particles at index, then increment index
                    items.repeater.itemAt(index).particleLoader.item.burst(40)
                    index++
                } else if (index < items.repeater.count + delay) {
                    // wait for the dealy time to pass
                    index++
                } else {
                    // pass the level
                    stop()
                    items.passedLevel = true
                    bonus.good("tux")
                }
            }
        }

        Image {
            id: board
            source: "resource/blackboard.svg"
            sourceSize.height: parent.height * 0.8
            sourceSize.width: parent.width * 0.8
            width: parent.width * 0.8
            height: parent.height * 0.8
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: -50
            }

            Rectangle {
                id: topRectangle
                width: Activity.computeWidth(items.repeater) + solutionArea.spacing * (items.repeater.count - 0.5)
                height: board.height / 2
                color: "transparent"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: - height / 2
                }

                Flow {
                    id: solutionArea
                    spacing: (board.width- Activity.computeWidth(items.repeater)) / listModel.count
                    anchors.centerIn: parent

                    Repeater {
                        id: repeater
                        anchors.horizontalCenter: parent.horizontalCenter
                        model: listModel

                        GCText {
                            id: letter
                            text: listModel.get(index) ? listModel.get(index).letter : ""
                            fontSize: hugeSize
                            color: "white"

                            // store the initial coordinates
                            property var _x
                            property var _y

                            property alias particleLoader: particleLoader
                            property alias failureAnimation: failureAnimation

                            // Create a particle only for the strawberry
                            Loader {
                                id: particleLoader
                                anchors.fill: parent
                                active: true
                                sourceComponent: particle
                            }

                            Component {
                                id: particle
                                ParticleSystemStarLoader {
                                    id: particles
                                    clip: false
                                }
                            }

                            SequentialAnimation {
                                id: failureAnimation
                                PropertyAction  { target: letter; property: "color"; value: "red" }
                                NumberAnimation { target: letter; property: "scale"; to: 2; duration: 400 }
                                NumberAnimation { target: letter; property: "scale"; to: 1; duration: 400 }
                                NumberAnimation { target: letter; property: "opacity"; to: 0; duration: 100 }
                                PropertyAction  { target: letter; property: "color"; value: "white" }
                                NumberAnimation { target: letter; property: "opacity"; to: 1; duration: 400 }
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                drag.target: parent
                                enabled: items.gameFinished || letter.text == '_' ? false : true

                                onPressed: {
                                    letter._x = letter.x
                                    letter._y = letter.y
                                    if (items.playLetter)
                                        Activity.playLetter(letter.text)
                                    background.resetTime(20)
                                }
                                onReleased: {
                                    /* use mouse's coordinates (x and y) to compare to the solutionArea's repeater items */
                                    // map the mouse coordinates to background coordinates
                                    var mouseMapped = mapToItem(background,mouse.x,mouse.y)

                                    //search through the repeater's items to find if THIS item can replace it
                                    for (var i=0; i<items.repeater.count; i++) {
                                        // map the itemAt(i)'s coordinates to background coordinates to match the mouse coordinates
                                        var item = items.repeater.itemAt(i)
                                        var itemMapped = items.repeater.parent.mapToItem(background,item.x,item.y)

                                        // if the mouse click is released in the repeater area
                                        if (mouseMapped.x > itemMapped.x && mouseMapped.x < itemMapped.x + item.width &&
                                                mouseMapped.y > itemMapped.y && mouseMapped.y < itemMapped.y + item.height * 2) {

                                            // interchange the letters
                                            var textAux = items.listModel.get(i).letter
                                            var textAux2 = letter.text

                                            repeater.itemAt(i).text = textAux2
                                            repeater.itemAt(index).text = textAux

                                            items.listModel.setProperty(i,"letter",textAux2)
                                            items.listModel.setProperty(index,"letter",textAux)

                                            // animations & particles
                                            if (index != i) {
                                                if (Activity.solution[i] == items.repeater.itemAt(i).text) {
                                                    // both letters are in the right position
                                                    if (Activity.solution[index] == letter.text) {
                                                        // start the particle only if the solution is partially correct
                                                        if (!Activity.checkCorectness() && items.easyMode) {
                                                            items.repeater.itemAt(i).particleLoader.item.burst(40)
                                                            items.repeater.itemAt(index).particleLoader.item.burst(40)
                                                        }
                                                        if (items.okBoxChecked && items.easyMode) {
                                                            items.repeater.itemAt(i).particleLoader.item.burst(40)
                                                            items.repeater.itemAt(index).particleLoader.item.burst(40)
                                                        }

                                                    // only itemAt(i) is in the right position
                                                    } else {
                                                        if (items.easyMode)
                                                        items.repeater.itemAt(i).particleLoader.item.burst(40)
                                                        if (items.repeater.itemAt(index).text != '_' && items.easyMode)
                                                            // only start failureAnimation for letters, not '_'
                                                            items.repeater.itemAt(index).failureAnimation.start()
                                                    }

                                                // only itemAt(index), meaning only the current item is in the right position
                                                } else {
                                                    if (Activity.solution[index] == letter.text && items.easyMode) {
                                                        letter.particleLoader.item.burst(40)
                                                        if (items.repeater.itemAt(i).text != '_' && items.easyMode)
                                                            items.repeater.itemAt(i).failureAnimation.start()
                                                    }

                                                    // both letters are in a wrong position
                                                    else {
                                                        if (items.repeater.itemAt(i).text != '_' && items.easyMode)
                                                            items.repeater.itemAt(i).failureAnimation.start()
                                                        if (items.repeater.itemAt(index).text != '_' && items.easyMode)
                                                            items.repeater.itemAt(index).failureAnimation.start()
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    // search through the inputRepeater's items to find if THIS item can replace it
                                    for (i=0; i<items.inputRepeater.count; i++) {
                                        // map the itemAt(i)'s coordinates to background coordinates to match the mouse coordinates
                                        var item1 = items.inputRepeater.itemAt(i)
                                        var itemMapped1 = items.inputRepeater.parent.mapToItem(background,item1.x,item1.y)

                                        // if the mouse click is released in a repeater area
                                        if (mouseMapped.x > itemMapped1.x && mouseMapped.x < itemMapped1.x + item1.width &&
                                                mouseMapped.y > itemMapped1.y && mouseMapped.y < itemMapped1.y + item1.height * 2) {

                                            // interchange the letters
                                            var textAux1 = items.listModelInput.get(i).letter
                                            var textAux2 = letter.text

                                            if (textAux1 != '_' && textAux2 != '_') {
                                                inputRepeater.itemAt(i).text = textAux2
                                                items.listModelInput.setProperty(i,"letter",textAux2)

                                                repeater.itemAt(index).text = textAux1
                                                items.listModel.setProperty(index,"letter",textAux1)

                                                if (items.easyMode) {
                                                    if (textAux2 == Activity.model[index]) {
                                                        particleLoader.item.burst(40)
                                                    } else {
                                                        failureAnimation.start()
                                                    }
                                                }


                                                // stop searching for another item; only this one can match the mouse's coordinates
                                                break
                                            }

                                        }
                                    }

                                    // move the letter back to its initial position
                                    letter.x = letter._x
                                    letter.y = letter._y

                                    // if the solution is correct, start the finishAnimation
                                    if (!items.okBoxChecked && Activity.checkCorectness()) {
                                        items.gameFinished = true
                                        finishAnimation.index = 0
                                        finishAnimation.start()
                                    }

                                    background.resetTime(20)
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: bottomRectangle
                width: Activity.computeWidth(items.inputRepeater) + inputArea.spacing * (items.inputRepeater.count - 0.5)
                height: parent.height / 2.1
                color: "transparent"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: height / 2
                }

                Flow {
                    id: inputArea
                    spacing: (board.width - Activity.computeWidth(items.inputRepeater)) / listModelInput.count
                    anchors.centerIn: parent

                    Repeater {
                        id: inputRepeater
                        anchors.horizontalCenter: parent.horizontalCenter
                        model: listModelInput

                        GCText {
                            id: missingLetter
                            text: listModelInput.get(index) ? listModelInput.get(index).letter : ""
                            fontSize: hugeSize
                            color: "white"

                            // store the initial coordinates
                            property var _x
                            property var _y
                            property alias failureAnimation1: failureAnimation1

                            SequentialAnimation {
                                id: failureAnimation1
                                PropertyAction { target: missingLetter; property: "color"; value: "red" }
                                NumberAnimation { target: missingLetter; property: "scale"; to: 2; duration: 400 }
                                NumberAnimation { target: missingLetter; property: "scale"; to: 1; duration: 400 }
                                NumberAnimation { target: missingLetter; property: "opacity"; to: 0; duration: 100 }
                                PropertyAction { target: missingLetter; property: "color"; value: "white" }
                                NumberAnimation { target: missingLetter; property: "opacity"; to: 1; duration: 400 }
                            }

                            MouseArea {
                                id: mouseArea2
                                anchors.fill: parent
                                drag.target: parent
                                enabled: items.gameFinished ? false : true

                                onPressed: {
                                    missingLetter._x = missingLetter.x
                                    missingLetter._y = missingLetter.y
                                    if (items.playLetter)
                                        Activity.playLetter(missingLetter.text)
                                    background.resetTime(20)
                                }

                                onReleased: {
                                    /* use mouse's coordinates (x and y) to compare to the solutionArea's repeater items */
                                    var mouseMapped = mapToItem(background,mouse.x,mouse.y)

                                    // search through the repeater's items to find if THIS item should replace it
                                    for (var i = 0; i < items.repeater.count; i++) {
                                        // map the itemAt(i)'s coordinates to background coordinates to match the mouse coordinates
                                        var item = items.repeater.itemAt(i)
                                        var itemMapped = items.repeater.parent.mapToItem(background,item.x,item.y)

                                        // if the mouse click is released in the repeater area
                                        if (mouseMapped.x > itemMapped.x && mouseMapped.x < itemMapped.x + item.width &&
                                                mouseMapped.y > itemMapped.y && mouseMapped.y < itemMapped.y + item.height) {

                                            var textAux = items.listModel.get(i).letter
                                            var textAux2 = missingLetter.text

                                            // if the letter at index i in the repeater is '_', then replace '_' with missingLetter.text
                                            if (textAux == '_') {
                                                repeater.itemAt(i).text = textAux2
                                                items.listModel.setProperty(i,"letter",textAux2)
                                                items.listModelInput.setProperty(index,"letter",'_')

                                                // set opacity to 0 and disable the MouseArea of missingLetter
                                                items.inputRepeater.itemAt(index).opacity = 0
                                                parent.enabled = false

                                            // else, the letter at intex i is a normal letter, so interchange it with missingLetter.text
                                            } else {
                                                repeater.itemAt(i).text = textAux2
                                                items.listModel.setProperty(i,"letter",textAux2)

                                                inputRepeater.itemAt(index).text = textAux
                                                items.listModelInput.setProperty(index,"letter",textAux)
                                            }

                                            // if the letter is placed in the correct spot, the particle is activated for item at index i
                                            if (Activity.solution[i] == items.listModel.get(i).letter) {
                                                // start the particle only if the solution is partially correct
                                                if (!Activity.checkCorectness() && items.easyMode)
                                                    items.repeater.itemAt(i).particleLoader.item.burst(40)
                                                if (items.okBoxChecked && items.easyMode)
                                                    items.repeater.itemAt(i).particleLoader.item.burst(40)

                                            // else, the letter is placed in a wrong place; start the failureAnimation
                                            } else if (items.easyMode)
                                                items.repeater.itemAt(i).failureAnimation.start()

                                            // stop searching for another item; only this one can match the mouse's coordinates
                                            break
                                        }
                                    }

                                    // move the missingLetter back to its initial position
                                    missingLetter.x = missingLetter._x
                                    missingLetter.y = missingLetter._y

                                    // if the solution is correct, start the finishAnimation
                                    if (!items.okBoxChecked && Activity.checkCorectness()) {
                                        items.gameFinished = true
                                        finishAnimation.index = 0
                                        finishAnimation.start()
                                    }

                                    background.resetTime(20)
                                }
                            }
                        }
                    }
                }
            }
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: Math.min(66 * bar.barZoom, background.width / background.height * 100)
            visible: items.okBoxChecked
            enabled: items.gameFinished ? false : true

            anchors {
                bottom: bar.top
                left: parent.left
            }

            MouseArea {
                id: mouseAreaOk
                anchors.fill: parent
                property bool bad: false
                onClicked: {
                    if (Activity.checkCorectness()) {
                        // set the game to "finished"
                        items.gameFinished = true

                        // start the finishAnimation
                        finishAnimation.index = 0
                        finishAnimation.start()

                        // the level was won -> add 1 to progress
                        if (mouseAreaOk.bad == false) { //current level was not failed before
                            Activity.progress = Activity.progress.concat(1)
                        }
                        mouseAreaOk.bad = false
                    } else {
                        for (var i = 0; i < items.listModel.count; i++)
                            if  (Activity.solution[i] !== items.listModel.get(i).letter) { // letters are different => not correct
                                mouseAreaOk.bad = true
                                items.repeater.itemAt(i).failureAnimation.start()

                                // saving current state (model and modelAux) in a vector for using it again
                                var ok = true
                                for (var j = 0; j < Activity.badAnswers.length; j++)
                                    // current state already in the vetor
                                    if (Activity.badAnswers[j].model == Activity.model && Activity.badAnswers[j].modelAux == Activity.modelAux)
                                        ok = false

                                // ok == true only if the current state is not already in the vector
                                if (ok == true)
                                    // add current state to the vector
                                    Activity.badAnswers = Activity.badAnswers.concat({model: Activity.model, modelAux: Activity.modelAux, solution: Activity.solution})
                        }

                        // decrease the levelsPassed counter
                        if (mouseAreaOk.bad && Activity.levelsPassed >= 1) {
                            Activity.levelsPassed --
                        }

                        // the level was lost -> add 0 to progress
                        Activity.progress = Activity.progress.concat(0)
                    }
                    background.resetTime(20)
                }
            }
        }


        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    height: column.height

                    property alias availableLangs: langs.languages
                    LanguageList {
                        id: langs
                    }

                    Column {
                        id: column
                        spacing: 10
                        width: parent.width

                        GCDialogCheckBox {
                            id: okButtonBox
                            width: 250 * ApplicationInfo.ratio
                            text: qsTr("OK button active")
                            checked: items.okBoxChecked
                            onCheckedChanged: {
                                items.okBoxChecked = checked
                                okButton.visible = checked
                                print("okButtonBox: ",checked)

                                Activity.currentLevel = 0
                                Activity.progress = []
                                score.currentSubLevel = 1
                                Activity.initLevel()
                            }
                        }

                        GCDialogCheckBox {
                            id: easyModeBox
                            width: 250 * ApplicationInfo.ratio
                            text: qsTr("Easy mode")
                            checked: items.easyMode
                            onCheckedChanged: {
                                print("easyModeBox: ",checked)
                                items.easyMode = checked
                            }
                        }

                        GCDialogCheckBox {
                            id: playLetterBox
                            width: 250 * ApplicationInfo.ratio
                            text: qsTr("Play letter sound")
                            checked: items.playLetter
                            onCheckedChanged: {
                                print("playLetterBox: ",checked)
                                items.playLetter = checked
                            }
                        }
                    }
                }
            }

            onClose: home()
            onLoadData: {
                if(dataToSave) {
                    items.okBoxChecked = dataToSave["okButton"] === "true" ? true : false
                    items.easyMode = dataToSave["mode"] === "true" ? true : false
                    items.playLetter = dataToSave["play"] === "true" ? true : false
                }
            }
        }

        Score {
            id: score
            currentSubLevel: 1
            numberOfSubLevels: 5
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | config }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onConfigClicked: {
                dialogActivityConfig.active = true
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }
}
