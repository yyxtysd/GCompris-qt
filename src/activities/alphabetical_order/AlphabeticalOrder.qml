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
            property var missingLetters
            property alias listModel: listModel
            property alias listModel2: listModel2
            property alias repeater: repeater
            property alias solutionRepeater: solutionRepeater
            property alias locale: background.locale
            property alias wordlist: wordlist
            property bool gameFinished: false
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
            id: listModel2
        }

        function computeWidth(repeater) {
            if (repeater == null)
                return 0
            var sum = 0
            for (var i = 0; i < repeater.count; i++) {
                sum += repeater.itemAt(i).width
            }
            return sum
        }

        Timer {
            id: finishAnimation
            interval: 100
            repeat: true

            property int index: 0
            property int delay: 3

            onTriggered: {
                if (index < items.repeater.count) {
                    items.gameFinished = true
                    items.repeater.itemAt(index).particleLoader.item.burst(40)
                    index++
                } else if (index < items.repeater.count + delay) {
                    index++
                } else {
                    stop()
                    bonus.good("tux")
                }
            }
        }

        Image {
            id: board
            sourceSize.height: parent.height * 0.8
            sourceSize.width: parent.width * 0.8
            width: parent.width * 0.8
            height: parent.height * 0.8

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -50

            source: "resource/blackboard.svg"

            Rectangle {
                id: topRectangle
                width: background.computeWidth(items.repeater) + guessArea.spacing * (items.repeater.count - 0.5)
                height: board.height / 2

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: - height / 2

                color: "transparent"

                Flow {
                    id: guessArea

                    spacing: background.width / (listModel.count * 1.8)
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
                                    /* use mouse's coordinates (x and y) to compare to the "guessArea"'s repeater items */
                                    var modified = mapToItem(background,mouse.x,mouse.y)
                                    //print("mouse x: ",modified.x,"  mouse y: ",modified.y)

                                    //search through the "repeater"'s items to find if THIS item can replace it
                                    for (var i=0; i<items.repeater.count; i++) {
                                        var item = items.repeater.itemAt(i)
                                        var guess = items.repeater.parent.mapToItem(background,item.x,item.y)
                                        //print("dimensions: ",guess.x,guess.x+item.width,guess.y,guess.y+item.height)


                                        if (modified.x > guess.x && modified.x < guess.x + item.width &&
                                                modified.y > guess.y && modified.y < guess.y + item.height * 2) {

                                            var textAux = items.listModel.get(i).letter
                                            items.listModel.setProperty(i,"letter",letter.text)
                                            items.listModel.setProperty(index,"letter",textAux)


                                            if (index != i) {
                                                if (Activity.solution[i] == items.repeater.itemAt(i).text) {
                                                    if (Activity.solution[index] == letter.text) {
                                                        if (!Activity.checkCorectness()) {
                                                            items.repeater.itemAt(i).particleLoader.item.burst(40)
                                                            letter.particleLoader.item.burst(40)
                                                        }
                                                    } else {
                                                        items.repeater.itemAt(i).particleLoader.item.burst(40)
                                                        if (items.repeater.itemAt(index).text != '_')
                                                            items.repeater.itemAt(index).failureAnimation.start()
                                                    }
                                                } else {
                                                    if (Activity.solution[index] == letter.text) {
                                                        letter.particleLoader.item.burst(40)
                                                        if (items.repeater.itemAt(i).text != '_')
                                                            items.repeater.itemAt(i).failureAnimation.start()
                                                    }
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

                                    //search through the "solutionRepeater"'s items to find if THIS item can replace it
                                    for (i=0; i<items.solutionRepeater.count; i++) {
                                        var item1 = items.solutionRepeater.itemAt(i)
                                        var guess1 = items.solutionRepeater.parent.mapToItem(background,item1.x,item1.y)
                                        if (modified.x > guess1.x && modified.x < guess1.x + item1.width &&
                                                modified.y > guess1.y && modified.y < guess1.y + item1.height * 2) {
                                            var textAux1 = items.listModel2.get(i).letter
                                            if (textAux1 != '_' && letter.text != '_') {
                                                items.listModel2.setProperty(i,"letter",letter.text)
                                                items.listModel.setProperty(index,"letter",textAux1)
                                                break
                                            }

                                        }
                                    }

                                    letter.x = letter._x
                                    letter.y = letter._y

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

                //TODO: on 3 or more letters (on bottom row of letter), only 2 are shown; have to handle width better
                width: background.computeWidth(items.solutionRepeater) + solutionArea.spacing + (items.solutionRepeater.count - 0.5)
                height: parent.height / 2.1

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: height / 2

                color: "transparent"

                Flow {
                    id: solutionArea

                    width: parent.width
                    height: parent.height

                    spacing: board.width / (listModel2.count + 1)
                    anchors.centerIn: parent


                    Repeater {
                        id: solutionRepeater
                        model: listModel2


                        GCText {
                            id: missingLetter
                            text: listModel2.get(index) ? listModel2.get(index).letter : ""
                            fontSize: hugeSize
                            color: "white"


                            property var _x
                            property var _y
                            property alias mouseArea: mouseArea


                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                drag.target: parent
                                enabled: items.gameFinished ? false : true

                                onPressed: {
                                    missingLetter._x = missingLetter.x
                                    missingLetter._y = missingLetter.y
                                }

                                onReleased: {
                                    /* use mouse's coordinates (x and y) to compare to the "guessArea"'s repeater items */
                                    var modified = mapToItem(background,mouse.x,mouse.y)

                                    //search through the "repeater"'s items to find if THIS item should replace it
                                    for (var i=0; i<items.repeater.count; i++) {
                                        var item = items.repeater.itemAt(i)
                                        var guess = items.repeater.parent.mapToItem(background,item.x,item.y)
                                        if (modified.x > guess.x && modified.x < guess.x + item.width &&
                                                modified.y > guess.y && modified.y < guess.y + item.height) {
                                            //print("belongs to: ",i)
                                            var textAux = items.listModel.get(i).letter

                                            if (textAux == '_') {
                                                items.listModel.setProperty(i,"letter",missingLetter.text)
                                                items.listModel2.setProperty(index,"letter",'_')
                                                items.solutionRepeater.itemAt(index).opacity = 0
                                                parent.enabled = false

                                            } else {
                                                items.listModel.setProperty(i,"letter",missingLetter.text)
                                                items.listModel2.setProperty(index,"letter",textAux)
                                            }

                                            //if the letter is placed in the correct spot, the particle is activated
                                            if (Activity.solution[i] == items.listModel.get(i).letter) {
                                                if (!Activity.checkCorectness())
                                                    items.repeater.itemAt(i).particleLoader.item.burst(40)
                                            } else
                                                items.repeater.itemAt(i).failureAnimation.start()

                                            break
                                        }
                                    }

                                    missingLetter.x = missingLetter._x
                                    missingLetter.y = missingLetter._y

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
