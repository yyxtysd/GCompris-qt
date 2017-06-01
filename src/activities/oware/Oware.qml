/* GCompris - Oware.qml
 *
 * Copyright (C) 2017 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
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
            property alias message: message
            property alias hintDialog: hintDialog
            property alias repeater: repeater
            property bool playerOne: true
            property var playerOneScore: 0
            property var playerOneSeeds: 0
            property var playerTwoScore: 0
            property var playerTwoSeeds: 0
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Image {
            id: board
            source: Activity.url + "/awele_board.png"
            anchors.centerIn: parent
            width: parent.width * 0.7
            height: width * 0.4
        }

        IntroMessage {
            id: message
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            z: 100
            intro: [
                qsTr("An oware board has two rows of 6 houses. Each player controls six houses. The game begins with 4 seeds in each house."),
                qsTr("Players take turns moving the seeds. On a turn, a player chooses one of the six houses under their control. The player removes all seeds from that house, and distributes them, dropping one in each house clockwise or counter clockwise from this house, in a process called <b>sowing</b>.") ,
                qsTr("When the dropped seeds make the number of seeds two or three in opponent's houses then they are <b>captured</b>. The players can capture seeds only from opponent's holes and never from their own holes.The player who captures the maximum seeds wins the game.")
            ]
        }

        Grid {
            id:boardGrid
            columns: 6
            rows: 2
            anchors.horizontalCenter: board.horizontalCenter
            anchors.top: board.top

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
                            source: Activity.url + "graine2.png"
                            height: circleRadius * 0.2
                            width: circleRadius * 0.2
                            x: circleRadius/2 + Activity.getX(circleRadius/6,index,value)
                            y: circleRadius/2 + Activity.getY(circleRadius/5,index,value)
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

            delegate: Item {
                height: parent.height
                width: boardGrid.width/6

                Image {
                    id: valueImage
                    source: Activity.url + "bouton" + (index + 1) + ".png"
                    anchors.fill: parent
                    MouseArea {
                        anchors.fill:parent
                        hoverEnabled: true
                            onClicked: {
                                Activity.sowSeeds(index);
                                items.playerOne = (items.playerOne == true) ? false : true
                            }
                        onPressed: {
                            valueImage.source = Activity.url + "bouton" + (index + 1) + "_clic.png";
                        }
                        onReleased: {
                            valueImage.source = Activity.url + "bouton" + (index + 1) + ".png";
                        }
                        onEntered: {
                            valueImage.source = Activity.url + "bouton" + (index + 1) + "_notify.png";
                        }
                        onExited: {
                            valueImage.source = Activity.url + "bouton" + (index + 1) + ".png";
                        }
                    }
                }
            }
        }

        ScoreItem {
            id: playerOneLevelScore
            player: 1
            height: Math.min(background.height/7, Math.min(background.width/7, bar.height * 1.05))
            width: height*11/8
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

            GCText {
                id: playerOneScoreText
                color: "white"
                property var textSource:Activity.playerTwoPoints
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

            GCText {
                id: playerTwoScoreText
                color: "white"
                property var textSource:Activity.playerTwoPoints
                anchors.centerIn: parent
                fontSize: smallSize
                text: items.playerTwoScore
                horizontalAlignment: Text.AlignHCenter
                wrapMode: TextEdit.WordWrap
            }
        }

        DialogBackground {
            id: hintDialog
            visible: false
            title: qsTr("Rules")
            textBody:  qsTr("An oware board has two rows of 6 houses. Each player controls six houses. The game begins with 4 seeds in each house. Players take turns moving the seeds. On a turn, a player chooses one of the six houses under their control. The player removes all seeds from that house, and distributes them, dropping one in each house clockwise or counter clockwise from this house, in a process called <b>sowing</b>. When the dropped seeds make the number of seeds two or three in opponent's houses then they are <b>captured</b>. The players can capture seeds only from opponent's holes and never from their own holes.The player who captures the maximum seeds wins the game.")
            onClose: home()
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | hint}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onHintClicked: displayDialog(hintDialog)
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
