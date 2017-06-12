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
            property alias cellGridRepeater: cellGridRepeater
            property bool playerOneTurn: true
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
            z: 2
            width: parent.width * 0.7
            height: width * 0.4
        }

        Grid {
            id: boardGrid
            columns: 6
            rows: 2
            anchors.horizontalCenter: board.horizontalCenter
            anchors.top: board.top
            z: 2

            Repeater {
                id: cellGridRepeater
                model: 12

                Rectangle {
                    color: "transparent"
                    height: board.height/2
                    width: board.width * (1/6.25)
                    property var circleRadius: width
                    property var value
                    GCText {
                        text: index
                        color: "white"
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Repeater {
                        id: grainRepeater
                        model: value
                        Image {
                            id: grain
                            source: Activity.url + "grain2.png"
                            height: circleRadius * 0.2
                            width: circleRadius * 0.2
                            x: circleRadius/2 + Activity.getX(circleRadius/6, index,value)
                            y: circleRadius/2 + Activity.getY(circleRadius/5, index,value)

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
            z: 2

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
                            if(items.playerOneTurn)
                                Activity.sowSeeds(index)
                            else
                                Activity.sowSeeds(11 - index)
                            items.playerOneTurn = !items.playerOneTurn
                        }
                    }
                }
            }
        }

        Image {
            id: tutorialImage
            source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
            anchors.fill: parent
            z: 5
            Tutorial {
                id:tutorialSection
                tutorialDetails: Activity.tutorialInstructions
                onSkipPressed: {
                    Activity.initLevel()
                    tutorialImage.z = 0
                }
            }
        }

        ScoreItem {
            id: playerOneLevelScore
            player: 1
            height: Math.min(background.height/7, Math.min(background.width/7, bar.height * 1.05))
            width: height * 11/8
            anchors {
                top: background.top
                topMargin: 5
                left: background.left
                leftMargin: 5
            }
            playerImageSource: "qrc:/gcompris/src/activities/align4-2players/resource/player_1.svg"
            backgroundImageSource: "qrc:/gcompris/src/activities/align4-2players/resource/score_1.svg"
        }

        ScoreItem {
            id: playerTwoLevelScore
            player: 2
            height: Math.min(background.height/7, Math.min(background.width/7, bar.height * 1.05))
            width: height * 11/8
            anchors {
                top: background.top
                topMargin: 5
                right: background.right
                rightMargin: 5
            }
            playerImageSource: "qrc:/gcompris/src/activities/align4-2players/resource/player_2.svg"
            backgroundImageSource: "qrc:/gcompris/src/activities/align4-2players/resource/score_2.svg"
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
                anchors.centerIn: parent
                fontSize: smallSize
                text: items.playerTwoScore
                horizontalAlignment: Text.AlignHCenter
                wrapMode: TextEdit.WordWrap
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: tutorialSection.visible ? (help | home) : (help | home | level | reload)}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked:
                Activity.initLevel()
        }

        Bonus {
            id: bonus
        }
    }
}
