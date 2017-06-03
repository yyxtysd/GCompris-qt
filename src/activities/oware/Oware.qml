/* GCompris - Oware.qml
 *
 * Copyright (C) 2017 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Frederic Mazzarol (GTK+ version)
 *   Divyam Madaan <divyam3897@gmail.com> (Qt Quick port)
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
import "."

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
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
            property alias repeater: repeater
            property bool playerOneTurn: true
            property bool isTutorial: true
            property alias tutorialTxt: tutorialTxt.text
            property alias tutNum: tutorialTxt.tutNum
            property var playerOneScore: 0
            property var playerOneSeeds: 0
            property var playerTwoScore: 0
            property var playerTwoSeeds: 0
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Image {
            id: board
            source: Activity.url + "/owareBoard.png"
            anchors.centerIn: parent
            width: parent.width * 0.7
            height: width * 0.4
            visible: !items.isTutorial
        }

        Grid {
            id:boardGrid
            columns: 6
            rows: 2
            anchors.horizontalCenter: board.horizontalCenter
            anchors.top: board.top
            visible: !items.isTutorial

            Repeater {
                id:repeater
                model: 12

                Rectangle {
                    color: "transparent"
                    height: board.height/2
                    width: board.width * (1/6.25)
                    property var circleRadius: width
                    property var value: 4
                    GCText {
                        text: value
                        color: "white"
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
                    Repeater {
                        model: value
                        Image {
                            id: grain
                            source: Activity.url + "grain2.png"
                            height: circleRadius * 0.2
                            width: circleRadius * 0.2
                            x: circleRadius/2 + Activity.getX(circleRadius/6,index,value)
                            y: circleRadius/2 + Activity.getY(circleRadius/5,index,value)

                            //To move the seeds from one hole to other on button click. Not working :(
                            states: State {
                                name: "move"
                                when: buttonClick.containsPress
                                PropertyChanges {
                                    target: grain
                                    scale: 1.1
                                }
                            }
                        }
                    }
                }
            }
        }

        ListView {
            id: rowButton
            width: boardGrid.width
            height: boardGrid.height * 0.25
            orientation: ListView.Horizontal
            model: 6
            anchors.horizontalCenter: board.horizontalCenter
            anchors.top: board.bottom
            interactive: false
            visible: !items.isTutorial

            delegate: Item {
                height: parent.height
                width: boardGrid.width/6

                Image {
                    id: valueImage
                    source: Activity.url + "button" + (index + 1) + ".png"
                    anchors.fill: parent
                    MouseArea {
                        id: buttonClick
                        anchors.fill:parent
                        hoverEnabled: true
                            onClicked: {
//                                 Activity.sowSeeds(index);
                                items.playerOneTurn = (!items.playerOneTurn == true) ? false : true
                            }
                        onPressed: {
                            valueImage.source = Activity.url + "button" + (index + 1) + "Click.png";
                        }
                        onReleased: {
                            valueImage.source = Activity.url + "button" + (index + 1) + ".png";
                        }
                        onEntered: {
                            valueImage.source = Activity.url + "button" + (index + 1) + "Notify.png";
                        }
                        onExited: {
                            valueImage.source = Activity.url + "button" + (index + 1) + ".png";
                        }
                   }
                }
            }
        }

        ScoreItem {
            id: playerOneLevelScore
            player: 1
            height: Math.min(background.height/7, Math.min(background.width/7, bar.height * 1.05))
            width: height * 11/8
            visible: !items.isTutorial
            anchors {
                top: background.top
                topMargin: 5
                left: background.left
                leftMargin: 5
            }
            playerImageSource: Activity.url + "stone_1.svg"
            backgroundImageSource: Activity.url + "score_1.svg"
        }

        ScoreItem {
            id: playerTwoLevelScore
            player: 2
            height: Math.min(background.height/7, Math.min(background.width/7, bar.height * 1.05))
            width: height*11/8
            visible: !items.isTutorial
            anchors {
                top: background.top
                topMargin: 5
                right: background.right
                rightMargin: 5
            }
            playerImageSource: Activity.url + "stone_2.svg"
            backgroundImageSource: Activity.url + "score_2.svg"
        }

        Image {
            id: playerOneScoreBox
            height: board.height * 0.4
            width: height
            source:Activity.url+"/score.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: board.left
            visible: !items.isTutorial

            GCText {
                id: playerOneScoreText
                color: "white"
                anchors.centerIn: parent
                fontSize: smallSize
                text: items.playerOneScore
                horizontalAlignment: Text.AlignHCenter
                wrapMode: TextEdit.WordWrap
            }
        }

        Image {
            id: playerTwoScore
            height: board.height * 0.4
            width: height
            source:Activity.url+"/score.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: board.right
            visible: !items.isTutorial

            GCText {
                id: playerTwoScoreText
                color: "white"
                anchors.centerIn: parent
                fontSize: smallSize
                text: items.playerTwoScore
                horizontalAlignment: Text.AlignHCenter
                wrapMode: TextEdit.WordWrap
            }
        }

        Image {
            id: previousTutorial
            source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
            sourceSize.height: skipTutorial.height * 1.1
            visible: items.isTutorial && tutorialTxt.tutNum != 1
            anchors {
                top: parent.top
                topMargin: 5
                right: skipTutorialContainer.left
                rightMargin: 5
            }

            MouseArea {
                id: previousArea
                width: parent.width
                height: parent.height
                onClicked: {Activity.tutorialPrevious()}
            }
        }

        Image {
            id: nextTutorial
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            sourceSize.height: skipTutorial.height * 1.1
            visible: items.isTutorial && tutorialTxt.tutNum != 3
            anchors {
                top: parent.top
                topMargin: 5
                left: skipTutorialContainer.right
                leftMargin: 5
            }

            MouseArea {
                id: nextArea
                width: parent.width
                height: parent.height
                onClicked: {Activity.tutorialNext()}
            }
        }

        GCText {
            id: skipTutorial
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 5
            }
            fontSizeMode: Text.Fit
            minimumPixelSize: 10
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignHCenter
            width: Math.min(implicitWidth, 0.8 * parent.width )
            height: implicitHeight
            visible: items.isTutorial
            text: qsTr("Skip tutorial")
            z: 2
        }

        Rectangle {
            id: skipTutorialContainer
            anchors.top: skipTutorial.top
            anchors.horizontalCenter: skipTutorial.horizontalCenter
            width: skipTutorial.width + 10
            height: skipTutorial.height + 2
            opacity: 0.8
            radius: 10
            border.width: 2
            border.color: "black"
            visible: items.isTutorial
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
            MouseArea {
                id: skipArea
                hoverEnabled: true
                width: parent.width
                height: parent.height
                onEntered: {skipTutorialContainer.border.color = "#62db53"}
                onExited: {skipTutorialContainer.border.color = "black"}
                onClicked: {Activity.tutorialSkip()}
            }
        }

        GCText {
            id: tutorialTxt
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: skipTutorial.bottom
                topMargin: skipTutorial.height * 0.5
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
            property int tutNum: 1
        }

        Rectangle {
            id: tutorialTxtContainer
            anchors.top: tutorialTxt.top
            anchors.horizontalCenter: tutorialTxt.horizontalCenter
            width: tutorialTxt.width + 20
            height: tutorialTxt.height + 2
            opacity: 0.8
            radius: 10
            border.width: 6
            color: "white"
            border.color: "#87A6DD"
            visible: items.isTutorial
            /*
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }*/
        }

        Image {
            id: tutorialImage
            source: "qrc:/gcompris/src/activities/oware/resource/" + "tutorial" + tutorialTxt.tutNum + ".png"
            property int heightNeed: background.height - tutorialTxtContainer.height - bar.height -
                                     2 * skipTutorialContainer.height
            width: (sourceSize.width/sourceSize.height) > (0.9 * background.width / heightNeed) ?
                   0.9 * background.width : (sourceSize.width * heightNeed) / sourceSize.height
            fillMode: Image.PreserveAspectFit
            visible: items.isTutorial
            anchors {
                top: tutorialTxt.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
        }
        // Tutorial section ends

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
        }
    }
}
