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

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#fffae6"

        signal start
        signal stop

        // system locale by default
        property string locale: "system"

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
            property alias listModel: listModel
            property alias listModelInput: listModelInput
            property alias repeater: repeater
            property alias inputRepeater: inputRepeater
            property alias locale: background.locale
            property alias wordlist: wordlist
            property bool gameFinished: false
            property int delay: 6
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        onFocusChanged: {
            if(focus) {
                Activity.focusTextInput()
            }
        }

        ListModel {
            id: listModel
        }

        ListModel {
            id: listModelInput
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
                    // set the game to "finished"
                    items.gameFinished = true
                    // start the particles at index, then increment index
                    items.repeater.itemAt(index).particleLoader.item.burst(40)
                    index++
                } else if (index < items.repeater.count + delay) {
                    // wait for the dealy time to pass
                    index++
                } else {
                    // pass the level
                    stop()
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
                                PropertyAction { target: letter; property: "color"; value: "red" }
                                NumberAnimation { target: letter; property: "scale"; to: 2; duration: 400 }
                                NumberAnimation { target: letter; property: "scale"; to: 1; duration: 400 }
                                NumberAnimation { target: letter; property: "opacity"; to: 0; duration: 100 }
                                PropertyAction { target: letter; property: "color"; value: "white" }
                                NumberAnimation { target: letter; property: "opacity"; to: 1; duration: 400 }
                            }

                            MouseArea {
                                anchors.fill: parent
                                drag.target: parent
                                enabled: items.gameFinished ? false : true

                                onPressed: {
                                    letter._x = letter.x
                                    letter._y = letter.y
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
                                            items.listModel.setProperty(i,"letter",letter.text)
                                            items.listModel.setProperty(index,"letter",textAux)

                                            // animations & particles
                                            if (index != i) {
                                                if (Activity.solution[i] == items.repeater.itemAt(i).text) {
                                                    // both letters are in the right position
                                                    if (Activity.solution[index] == letter.text) {
                                                        // start the particle only if the solution is partially correct
                                                        if (!Activity.checkCorectness()) {
                                                            items.repeater.itemAt(i).particleLoader.item.burst(40)
                                                            items.repeater.itemAt(index).particleLoader.item.burst(40)
                                                        }

                                                    // only itemAt(i) is in the right position
                                                    } else {
                                                        items.repeater.itemAt(i).particleLoader.item.burst(40)
                                                        if (items.repeater.itemAt(index).text != '_')
                                                            // only start failureAnimation for letters, not '_'
                                                            items.repeater.itemAt(index).failureAnimation.start()
                                                    }

                                                // only itemAt(index), meaning only the current item is in the right position
                                                } else {
                                                    if (Activity.solution[index] == letter.text) {
                                                        letter.particleLoader.item.burst(40)
                                                        if (items.repeater.itemAt(i).text != '_')
                                                            items.repeater.itemAt(i).failureAnimation.start()
                                                    }

                                                    // both letters are in a wrong position
                                                    else {
                                                        if (items.repeater.itemAt(i).text != '_')
                                                            items.repeater.itemAt(i).failureAnimation.start()
                                                        if (items.repeater.itemAt(index).text != '_')
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
                                            if (textAux1 != '_' && letter.text != '_') {
                                                items.listModelInput.setProperty(i,"letter",letter.text)
                                                items.listModel.setProperty(index,"letter",textAux1)

                                                // stop searching for another item; only this one can match the mouse's coordinates
                                                break
                                            }

                                        }
                                    }

                                    // move the letter back to its initial position
                                    letter.x = letter._x
                                    letter.y = letter._y

                                    // if the solution is correct, start the finishAnimation
                                    if (Activity.checkCorectness()) {
                                        finishAnimation.index = 0
                                        finishAnimation.start()
                                    }
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

                            MouseArea {
                                anchors.fill: parent
                                drag.target: parent
                                enabled: items.gameFinished ? false : true

                                onPressed: {
                                    missingLetter._x = missingLetter.x
                                    missingLetter._y = missingLetter.y
                                }

                                onReleased: {
                                    /* use mouse's coordinates (x and y) to compare to the solutionArea's repeater items */
                                    var mouseMapped = mapToItem(background,mouse.x,mouse.y)

                                    //search through the repeater's items to find if THIS item should replace it
                                    for (var i=0; i<items.repeater.count; i++) {
                                        // map the itemAt(i)'s coordinates to background coordinates to match the mouse coordinates
                                        var item = items.repeater.itemAt(i)
                                        var itemMapped = items.repeater.parent.mapToItem(background,item.x,item.y)

                                        // if the mouse click is released in the repeater area
                                        if (mouseMapped.x > itemMapped.x && mouseMapped.x < itemMapped.x + item.width &&
                                                mouseMapped.y > itemMapped.y && mouseMapped.y < itemMapped.y + item.height) {

                                            var textAux = items.listModel.get(i).letter

                                            // if the letter at index i in the repeater is '_', then replace '_' with missingLetter.text
                                            if (textAux == '_') {
                                                items.listModel.setProperty(i,"letter",missingLetter.text)
                                                items.listModelInput.setProperty(index,"letter",'_')

                                                // set opacity to 0 and disable the MouseArea of missingLetter
                                                items.inputRepeater.itemAt(index).opacity = 0
                                                parent.enabled = false

                                            // else, the letter at intex i is a normal letter, so interchange it with missingLetter.text
                                            } else {
                                                items.listModel.setProperty(i,"letter",missingLetter.text)
                                                items.listModelInput.setProperty(index,"letter",textAux)
                                            }

                                            // if the letter is placed in the correct spot, the particle is activated for item at index i
                                            if (Activity.solution[i] == items.listModel.get(i).letter) {
                                                // start the particle only if the solution is partially correct
                                                if (!Activity.checkCorectness())
                                                    items.repeater.itemAt(i).particleLoader.item.burst(40)

                                            // else, the letter is placed in a wrong place; start the failureAnimation
                                            } else
                                                items.repeater.itemAt(i).failureAnimation.start()

                                            // stop searching for another item; only this one can match the mouse's coordinates
                                            break
                                        }
                                    }

                                    // move the missingLetter back to its initial position
                                    missingLetter.x = missingLetter._x
                                    missingLetter.y = missingLetter._y

                                    // if the solution is correct, start the finishAnimation
                                    if (Activity.checkCorectness()) {
                                        finishAnimation.index = 0
                                        finishAnimation.start()
                                    }

                                }
                            }
                        }
                    }
                }
            }
        }


        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias localeBox: localeBox
                    height: column.height

                    property alias availableLangs: langs.languages
                    LanguageList {
                        id: langs
                    }

                    Column {
                        id: column
                        spacing: 10
                        width: parent.width

                        Flow {
                            spacing: 5
                            width: dialogActivityConfig.width
                            GCComboBox {
                                id: localeBox
                                model: langs.languages
                                background: dialogActivityConfig
                                label: qsTr("Select your locale")
                            }
                        }
                        /* TODO handle this:
                        GCDialogCheckBox {
                            id: uppercaseBox
                            width: 250 * ApplicationInfo.ratio
                            text: qsTr("Uppercase only mode")
                            checked: true
                            onCheckedChanged: {
                                print("uppercase changed")
                            }
                        }
*/
                    }
                }
            }

            onClose: home()
            onLoadData: {
                if(dataToSave && dataToSave["locale"]) {
                    background.locale = dataToSave["locale"];
                }
            }
            onSaveData: {
                var oldLocale = background.locale;
                var newLocale = dialogActivityConfig.configItem.availableLangs[dialogActivityConfig.loader.item.localeBox.currentIndex].locale;
                // Remove .UTF-8
                if(newLocale.indexOf('.') != -1) {
                    newLocale = newLocale.substring(0, newLocale.indexOf('.'))
                }
                dataToSave = {"locale": newLocale}

                background.locale = newLocale;

                // Restart the activity with new information
                if(oldLocale !== newLocale) {
                    background.stop();
                    background.start();
                }
            }


            function setDefaultValues() {
                var localeUtf8 = background.locale;
                if(background.locale != "system") {
                    localeUtf8 += ".UTF-8";
                }

                for(var i = 0 ; i < dialogActivityConfig.configItem.availableLangs.length ; i ++) {
                    if(dialogActivityConfig.configItem.availableLangs[i].locale === localeUtf8) {
                        dialogActivityConfig.loader.item.localeBox.currentIndex = i;
                        break;
                    }
                }
            }
        }

        Wordlist {
            id: wordlist
            defaultFilename: Activity.dataSetUrl + "default-en.json"
            // To switch between locales: xx_XX stored in configuration and
            // possibly correct xx if available (ie fr_FR for french but dataset is fr.)
            useDefault: false
            filename: ""

            onError: console.log("Reading: Wordlist error: " + msg);
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
                dialogActivityConfig.setDefaultValues()
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

    }

}
