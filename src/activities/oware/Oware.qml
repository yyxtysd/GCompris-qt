
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
            property int playerOneScore: 0
            property int playerTwoScore: 0
            property alias playerOneLevelScore: playerOneLevelScore
            property alias playerTwoLevelScore: playerTwoLevelScore
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Item {
            id: boxModel
            width: parent.width * 0.7
            height: width * 0.4
            z: 2
            anchors.centerIn: parent
            rotation:  (background.width > background.height) ? 0 : 90

            Image {
                id: board
                source: Activity.url + "/owareBoard.png"
                anchors.fill: parent
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
                        id: house
                        color: "transparent"
                        height: board.height/2
                        width: board.width * (1/6.25)
                        property real circleRadius: width
                        property int value
                        property int indexValue: index

                        GCText {
                            text: index
                            color: "white"
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            z: 2
                            rotation:  (background.width > background.height) ? 0 : 270
                            fontSize: smallSize
                        }
//                         property alias seedsAnimation: grainRepeater.seedsAnimation
                        MouseArea {
                            id: buttonClick
                            anchors.fill: parent
                            onClicked: {
                                if(items.playerOneTurn && Activity.house[index - 6] != 0 && (index - 6) >= 0 && (index - 6) <= 5) {
                                    items.playerOneTurn = !items.playerOneTurn
                                    if(Activity.playerSideEmpty)
                                        Activity.checkHunger(index - 6)
                                    else {
                                        Activity.sowSeeds(index,index - 6)
                                    }
                                }
                                else if(!items.playerOneTurn && Activity.house[11-index] != 0 && (11 - index) >= 6 && (11 - index) <= 11) {
                                    items.playerOneTurn = !items.playerOneTurn
                                    if(Activity.playerSideEmpty)
                                        Activity.checkHunger(11 - index)
                                    else {
                                        Activity.sowSeeds(index,11 - index)
                                    }
                                }
                            }
                        }

                            function startAnim() {
                                    print("val",indexValue)
                                    seedsAnimation.start()
                                }

                                SequentialAnimation {
                                    id: seedsAnimation
                                    NumberAnimation {
                                        target: grainRepeater.itemAt(indexValue)
                                        to: 500
                                        property: "x"
                                        easing.type: Easing.OutInQuad
                                        duration: 500
                                    }
                                    NumberAnimation {
                                        target: grainRepeater.itemAt(indexValue)
                                        to: 500
                                        property: "y"
                                        duration: 500
                                    }
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

                            }
                        }
                    }
                }
            }

            Image {
                id: playerOneScoreBox
                height: board.height * 0.4
                width: height
                source:Activity.url+"/score.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: boxModel.left

                GCText {
                    id: playerOneScoreText
                    color: "white"
                    anchors.centerIn: parent
                    fontSize: smallSize
                    text: items.playerOneScore
                    horizontalAlignment: Text.AlignHCenter
                    rotation:  (background.width > background.height) ? 0 : 270
                    wrapMode: TextEdit.WordWrap
                }
            }

            Image {
                id: playerTwoScore
                height: board.height * 0.4
                width: height
                source:Activity.url+"/score.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: boxModel.right

                GCText {
                    id: playerTwoScoreText
                    color: "white"
                    anchors.centerIn: parent
                    fontSize: smallSize
                    text: items.playerTwoScore
                    horizontalAlignment: Text.AlignHCenter
                    rotation:  (background.width > background.height) ? 0 : 270
                    wrapMode: TextEdit.WordWrap
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
                    playerOneLevelScore.beginTurn()
                }
            }
        }

        ScoreItem {
            id: playerOneLevelScore
            player: 1
            height: Math.min(background.height/7, Math.min(background.width/7, bar.height * 1.05))
            width: height * 11/8
            playerScore: 0
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
            playerScore: 0
            anchors {
                top: background.top
                topMargin: 5
                right: background.right
                rightMargin: 5
            }
            playerImageSource: "qrc:/gcompris/src/activities/align4-2players/resource/player_2.svg"
            backgroundImageSource: "qrc:/gcompris/src/activities/align4-2players/resource/score_2.svg"
            playerScaleOriginX: playerTwoLevelScore.width
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: tutorialSection.visible ? (help | home) : (help | home | reload)}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
        }

        Bonus {
            id: bonus
        }
    }
}
