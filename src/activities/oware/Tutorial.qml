/* GCompris - Tutorial.qml
 *
 * Copyright (C) 2017 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
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
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "oware.js" as Activity

Image {
    id: tutorialSection
    anchors.fill: parent
    source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
    visible: items.isTutorial
    property alias tutorialText: tutorialText.text
    property alias tutorialNumber: tutorialText.tutorialNumber

    GCText {
        id: tutorialText
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 10
        }
        fontSizeMode: Text.Fit
        minimumPixelSize: 10
        color: "black"
        horizontalAlignment: Text.AlignHLeft
        width: Math.min(implicitWidth, 0.8 * parent.width )
        height: Math.min(implicitHeight, 0.25 * parent.height )
        wrapMode: TextEdit.WordWrap
        visible: items.isTutorial
        z: 2
        property int tutorialNumber: 1
    }

    Rectangle {
        id: tutorialTextContainer
        anchors.top: tutorialText.top
        anchors.horizontalCenter: tutorialText.horizontalCenter
        width: tutorialText.width + 20
        height: tutorialText.height + 2
        opacity: 0.8
        radius: 10
        border.width: 6
        color: "white"
        border.color: "#87A6DD"
        visible: items.isTutorial
    }

    Rectangle {
        id: previousButton
        width: 120
        height: 120
        color: "#d8ffffff"
        border.color: "#2a2a2a"
        border.width: 3
        radius: 8
        z: 5
        anchors.right: nextButton.left
        anchors.bottom: parent.bottom
        visible: items.isTutorial && tutorialText.tutorialNumber != 1

        GCText {
            id: previousButtonText
            anchors.centerIn: parent
            text: "Previous"
            wrapMode: Text.WordWrap
        }

        MouseArea {
            id: previousButtonArea
            anchors.fill: parent
            onClicked: {
                tutorialPrevious()
            }
        }
    states: [
        State {
            name: "notclicked"
            PropertyChanges {
                target: previousButton
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: previousButtonArea.pressed
            PropertyChanges {
                target: previousButton
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: previousButtonArea.containsMouse
            PropertyChanges {
                target: previousButton
                scale: 1.1
            }
        }
        ]
        Behavior on scale { NumberAnimation { duration: 70 } }
    }

    Rectangle {
        id: nextButton
        width: 120
        height: 120
        color: "#d8ffffff"
        border.color: "#2a2a2a"
        border.width: 3
        radius: 8
        z: 5
        anchors.right: skipButton.left
        anchors.bottom: parent.bottom
        visible: items.isTutorial && tutorialText.tutorialNumber != 3

        GCText {
            id: nextButtonText
            anchors.centerIn: parent
            text: "Next"
            wrapMode: Text.WordWrap
        }

        MouseArea {
            id: nextButtonArea
            anchors.fill: parent
            onClicked: {
                tutorialNext()
            }
        }
    states: [
        State {
            name: "notclicked"
            PropertyChanges {
                target: nextButton
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: button_area.pressed
            PropertyChanges {
                target: nextButton
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: nextButtonArea.containsMouse
            PropertyChanges {
                target: nextButton
                scale: 1.1
            }
        }
        ]
        Behavior on scale { NumberAnimation { duration: 70 } }
    }
    Rectangle {
        id: skipButton
        width: 120
        height: 120
        color: "#d8ffffff"
        border.color: "#2a2a2a"
        border.width: 3
        radius: 8
        z: 5
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.bottom: parent.bottom

        GCText {
            id: skipTutorial
            anchors.centerIn: parent
            text: "Skip"
            wrapMode: Text.WordWrap
        }

        MouseArea {
            id: skipButtonArea
            anchors.fill: parent
            onClicked: {
                tutorialSkip()
            }
        }
    states: [
        State {
            name: "notclicked"
            PropertyChanges {
                target: skipButton
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: skipButtonArea.pressed
            PropertyChanges {
                target: skipButton
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: skipButtonArea.containsMouse
            PropertyChanges {
                target: skipButton
                scale: 1.1
            }
        }
        ]
        Behavior on scale { NumberAnimation { duration: 70 } }
    }

    Image {
        id: tutorialImage
        source: "qrc:/gcompris/src/activities/oware/resource/" + "tutorial" + tutorialText.tutorialNumber + ".png"
        width: parent.width * 0.8
        fillMode: Image.PreserveAspectFit
        visible: items.isTutorial
        anchors {
            top: tutorialText.bottom
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
    }

    function tutorial() {
        items.isTutorial = true
        setTutorial(1)
    }

    function tutorialSkip() {
        items.isTutorial = false
        Activity.initLevel()
    }

    function tutorialNext() {
        setTutorial(++tutorialNumber)
    }

    function tutorialPrevious() {
        setTutorial(--tutorialNumber)
    }

    function setTutorial(tutorialNumber) {
        if(tutorialNumber == 1) {
            items.tutorialText = Activity.tutorialInstructions[0]
        }
        else if(tutorialNumber == 2) {
            items.tutorialText = Activity.tutorialInstructions[1]
        }
        else if(tutorialNumber == 3) {
            items.tutorialText = Activity.tutorialInstructions[2]
        }
    }
}
