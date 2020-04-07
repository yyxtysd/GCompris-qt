﻿/* GCompris - hangman.qml
 *
 * Copyright (C) 2015 Rajdeep Kaur <rajdeep51994@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Rajdeep kaur<rajdeep51994@gmail.com> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0
import QtGraphicalEffects 1.0

import "../../core"
import "hangman.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    // Overload this in your activity to change it
    // Put you default-<locale>.json files in it
    property string dataSetUrl: "qrc:/gcompris/src/activities/hangman/resource/"

    onStart: focus = true
    onStop:  { }
    // When going on configuration, it steals the focus and re set it to the activity.
    // We need to set it back to the textinput item in order to have key events.
    onFocusChanged: {
        if(focus) {
            Activity.focusTextInput()
        }
    }

    pageComponent: Image {
        id: background
        source: activity.dataSetUrl + "background.svg"
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        sourceSize.width: Math.max(parent.width, parent.height)

        // system locale by default
        property string locale: "system"

        property bool englishFallback: false

        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property Item ourActivity: activity
            property alias bar: bar
            property alias bonus: bonus
            property alias keyboard: keyboard
            property alias hidden: hidden
            property alias guessedText: guessedText
            property alias textinput: textinput
            property alias wordImage: wordImage
            property alias score: score
            property alias parser: parser
            property alias locale: background.locale
            property alias ok: ok
            property int remainingLife
            property double maskThreshold
            property var goodWord
            property int goodWordIndex
            property bool easyMode: false
            property alias englishFallbackDialog: englishFallbackDialog

            function playWord() {
                var locale = ApplicationInfo.getVoicesLocale(items.locale)
                if(activity.audioVoices.append(
                            ApplicationInfo.getAudioFilePathForLocale(goodWord.voice, locale)))
                    bonus.interval = 2500
                else
                    bonus.interval = 500
            }
            onRemainingLifeChanged: {
                maskThreshold = 0.15 * remainingLife
                if(remainingLife == 3) {
                    playWord();
                }
            }
        }

        onStart: {
            focus = true
            Activity.start(items)
            Activity.focusTextInput()
        }

        onStop: {
            Activity.stop();
        }

        GCText {
            id: hidden
            fontSize: largeSize
            color: "#4d4d4d"
            font.letterSpacing: 0.5
            width: parent.width * 0.90 - score.width
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            anchors {
                right: score.left
                bottom: bar.top
                bottomMargin: 10 * ApplicationInfo.ratio
            }
            z: 11
        }

        GCText {
            id: guessedText
            fontSize: smallSize
            color: "#FFFFFF"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            width: parent.width - 2.1 * clock.width
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            z: 12
        }

        Rectangle {
            width: guessedText.width
            height: guessedText.height
            radius: 10
            border.width: 1
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            z: 11
        }

        TextInput {
            // Helper element to capture composed key events like french ô which
            // are not available via Keys.onPressed() on linux. Must be
            // disabled on mobile!
            id: textinput
            enabled: !ApplicationInfo.isMobile
            visible: false
            focus: true
            onTextChanged: {
                if (text != "") {
                    Activity.processKeyPress(text);
                    text = "";
                }
            }
            onAccepted: if(items.remainingLife === 0) Activity.nextSubLevel()
        }

        Item {
  		    id: imageframe
            width: Math.min(300 * ApplicationInfo.ratio,
                            background.width * 0.8,
                            hidden.y) - guessedText.height
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: guessedText.bottom
            y: 5 * ApplicationInfo.ratio
            z: 10
            opacity: items.easyMode ? 1 : 0
            Image {
		        id: wordImage
		        smooth: true
                visible: false

                anchors.fill: parent
                property string nextSource
                function changeSource(nextSource_) {
                    nextSource = nextSource_
                    animImage.start()
                }

                SequentialAnimation {
                    id: animImage
                    PropertyAnimation {
                        target: wordImage
                        property: "opacity"
                        to: 0
                        duration: 100
                    }
                    PropertyAction {
                        target: wordImage
                        property: "source"
                        value: wordImage.nextSource
                    }
                    PropertyAnimation {
                        target: wordImage
                        property: "opacity"
                        to: 1
                        duration: 100
                    }
                }
            }

            Image {
		        id: threshmask
                smooth: true
                visible: false
                width: 1.3*parent.width
                height: 1.2*parent.height
                source: dataSetUrl + "fog.png"
            }

            ThresholdMask {
                id: thresh
                anchors.fill: wordImage
                source: wordImage
                maskSource: threshmask
                spread: 0.4
                // remainingLife between 0 and 6 => threshold between 0 and 0.9
                threshold: items.maskThreshold
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home()
            }
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onLoadData: {
                if(activityData && activityData["activityLocale"]) {
                    background.locale = activityData["activityLocale"];
                }
                else {
                    background.locale = Core.resolveLocale(background.locale)
                }
                if(activityData && activityData["easyMode"]) {
                    items.easyMode = (activityData["easyMode"] === "true");
                }

            }
            onStartActivity: {
                background.stop()
                background.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Score {
            id: score
            height: 1.2 * internalTextComponent.height
            width: 1.3 * internalTextComponent.width
            anchors {
                bottom: keyboard.enabled ? keyboard.top : parent.bottom
                bottomMargin: keyboard.enabled ? 1.2 * bar.height : 0.55 * parent.height
                right: parent.right
                rightMargin: 0.025 * parent.width
            }
        }

        BarButton {
            id: ok
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg";
            sourceSize.width: Math.min(score.width, clock.width)
            visible: false
            anchors {
                bottom: score.top
                horizontalCenter: score.horizontalCenter
                bottomMargin: 5 * ApplicationInfo.ratio
            }
            onClicked: Activity.nextSubLevel()
        }

        JsonParser {
            id: parser
            onError: console.error("Hangman: Error parsing json: " + msg);
        }

        Image {
            id: clock
            anchors {
                left: parent.left
                top: parent.top
                margins: 10
            }
            sourceSize.width: 66 * bar.barZoom
            property int remainingLife: items.remainingLife
            onRemainingLifeChanged: if(remainingLife >= 0) clockAnim.restart()

            SequentialAnimation {
                id: clockAnim
                alwaysRunToEnd: true
                ParallelAnimation {
                    NumberAnimation {
                        target: clock; properties: "opacity";
                        to: 0; duration: 800; easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: clock; properties: "rotation"; from: 0; to: 180;
                        duration: 800; easing.type: Easing.OutCubic
                    }
                }
                PropertyAction {
                    target: clock; property: 'source';
                    value: "qrc:/gcompris/src/activities/reversecount/resource/" +
                           "flower" + items.remainingLife + ".svg"
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: clock; properties: "opacity";
                        to: 1; duration: 800; easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: clock; properties: "rotation"; from: 180; to: 0;
                        duration: 800; easing.type: Easing.OutCubic
                    }
                }
            }
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            onKeypress: Activity.processKeyPress(text);
            onError: console.log("VirtualKeyboard error: " + msg);
        }

        Bonus {
            id: bonus
            interval: 2000
            onLoose: ok.visible = true
            onWin: Activity.nextSubLevel()
        }

        Loader {
            id: englishFallbackDialog
            sourceComponent: GCDialog {
                parent: activity.main
                message: qsTr("We are sorry, we don't have yet a translation for your language.") + " " +
                         qsTr("GCompris is developed by the KDE community, you can translate GCompris by joining a translation team on <a href=\"%2\">%2</a>").arg("https://l10n.kde.org/") +
                         "<br /> <br />" +
                         qsTr("We switched to English for this activity but you can select another language in the configuration dialog.")
                onClose: background.englishFallback = false
            }
            anchors.fill: parent
            focus: true
            active: background.englishFallback
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
