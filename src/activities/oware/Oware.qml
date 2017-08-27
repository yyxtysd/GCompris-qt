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

    property bool twoPlayer: false
    property bool horizontalLayout: (background.width > background.height) ? true : false
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
            property alias boardModel: boardModel
            property bool computerTurn: false
            property int selectedIndexValue
            property bool gameEnded: false
            /* The grid starts from top, top houses are occupied by player two so start and end index for player two are 0 and 5 and start and end index for player one are 6 and 11 */
            readonly property int playerOneStartIndex: 6
            readonly property int playerOneEndIndex: 11
            readonly property int playerTwoStartIndex: 0
            readonly property int playerTwoEndIndex: 5
            readonly property int housesCount: 12
        }

        onStart: { Activity.start(items,twoPlayer) }
        onStop: { Activity.stop() }

        // Timer to trigger computer move
        Timer {
            id: trigComputerMove
            repeat: false
            interval: 2500
            onTriggered: {
                if(items.computerTurn)
                    Activity.computerMove()
            }
        }

        Item {
            id: boardModel
            width: parent.width * 0.7
            height: width * 0.4
            z: 2
            anchors.centerIn: parent
            rotation: horizontalLayout ? 0 : 90

            Image {
                id: board
                source: Activity.url + "/owareBoard.png"
                anchors.fill: parent
            }

            Rectangle {
                id: playerOneBorder
                height: 5
                width: parent.width/4
                color: "orange"
                anchors.top: board.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 6
            }

            Rectangle {
                id: playerTwoBorder
                height: 5
                width: parent.width/4
                color: "blue"
                anchors.bottom: board.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 5
            }

            // Grid of houses with 6 houses for each player
            Grid {
                id: boardGrid
                columns: 6
                rows: 2
                anchors.horizontalCenter: board.horizontalCenter
                anchors.top: board.top

                property int currentMove

                Repeater {
                    id: cellGridRepeater
                    model: 12

                    Rectangle {
                        id: house
                        color: "transparent"
                        height: board.height/2
                        width: board.width * (1/6.25)
                        property real circleRadius: width
                        property int numberOfSeedsInHouse
                        property string nextMove
                        property real scoreBoardX
                        property int previousIndex
                        property alias grainRepeater: grainRepeater
                        signal setHouseValues
                        signal scoreAnimationStarted
                        signal setScoreValues
                        signal changePlayer
                        property bool scoreAnimationsToBeStarted: true

                        GCText {
                            text: numberOfSeedsInHouse
                            color: "white"
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            z: 2
                            rotation: (background.width > background.height) ? 0 : 270
                            fontSize: smallSize
                        }

                        MouseArea {
                            id: buttonClick
                            anchors.fill: parent
                            onPressed: {
                                cellGridRepeater.itemAt(items.selectedIndexValue).z = 0
                                items.selectedIndexValue = index
                                boardGrid.currentMove = items.playerOneTurn ? (index - 6) : (11 - index)
                                var nextPlayer = items.playerOneTurn ? 1 : 0

                                if (!items.computerTurn && Activity.isValidMove(boardGrid.currentMove, nextPlayer, Activity.house)) {
                                    cellGridRepeater.itemAt(items.selectedIndexValue).z = 20
                                    firstMove()
                                    items.playerOneTurn = !items.playerOneTurn
                                }
                            }
                        }

                        function scoresAnimation(scoreDirection,seedsCount,currentScoreIndex) {
                            cellGridRepeater.itemAt(currentScoreIndex).numberOfSeedsInHouse = seedsCount
                            previousIndex = currentScoreIndex
                            scoreBoardX = cellGridRepeater.itemAt(currentScoreIndex).x
                            for(var i = 0; i < grainRepeater.count; i++) {
                                grainRepeater.itemAt(i).startScoreAnimation(scoreDirection)
                            }
                        }

                        function firstMove() {
                            items.boardModel.enabled = false
                            /* If the selectedIndexValue on which player has clicked is between 6 and 11 then the first move will be towards right. */
                            if(items.selectedIndexValue >= items.playerOneStartIndex && items.selectedIndexValue < items.playerOneEndIndex)
                                nextMove = "right"
                            /* Else if the selectedIndexValue on which player has clicked is 11 then first move will be up */
                            else if(items.selectedIndexValue == items.playerOneEndIndex)
                                nextMove = "up"
                            /* Similarly if the selectedIndexValue on which player has clicked is between 0 and 5 then first move will be left and if equal to 0 then it will be down. */
                            else if(items.selectedIndexValue > items.playerTwoStartIndex && items.selectedIndexValue <= items.playerTwoEndIndex)
                                nextMove = "left"
                            else if(items.selectedIndexValue == items.playerTwoStartIndex)
                                nextMove = "down"
                            for(var i = 0; i < grainRepeater.count; i++) {
                                grainRepeater.itemAt(i).startAnimation()
                            }
                        }

                        onSetHouseValues: {
                            for (var i = 6, j = 0; i < 12, j < 6; j++, i++) {
                                cellGridRepeater.itemAt(i).numberOfSeedsInHouse = Activity.house[j]
                            }
                            for (var i = 0, j = 11; i < 6, j > 5; j--, i++) {
                                cellGridRepeater.itemAt(i).numberOfSeedsInHouse = Activity.house[j]
                            }
                            scoreAnimationStarted()
                        }

                        onSetScoreValues: {
                            items.playerTwoScore = Activity.scoreHouse[1]
                            items.playerOneScore = Activity.scoreHouse[0]
                            changePlayer()
                        }

                        onChangePlayer: {
                            items.gameEnded = false
                            if(items.playerOneScore == 24 && items.playerTwoScore == 24)
                                items.bonus.good("flower")
                            else if (items.playerTwoScore >= 25) {
                                if(!twoPlayer)
                                    items.bonus.bad("flower")
                                else
                                    items.bonus.good("flower")
                                items.playerOneLevelScore.endTurn()
                                items.playerTwoLevelScore.endTurn()
                                items.playerTwoLevelScore.win()
                                items.boardModel.enabled = false
                                items.gameEnded = true
                            } else if (items.playerOneScore >= 25) {
                                items.playerOneLevelScore.win()
                                items.playerTwoLevelScore.endTurn()
                                items.boardModel.enabled = false
                                items.gameEnded = true
                            }
                            if (!items.playerOneTurn && !items.gameEnded) {
                                items.playerOneLevelScore.endTurn()
                                items.playerTwoLevelScore.beginTurn()
                                trigComputerMove.start()
                                items.boardModel.enabled = true
                            } else if (!items.gameEnded) {
                                items.playerTwoLevelScore.endTurn()
                                items.playerOneLevelScore.beginTurn()
                                items.boardModel.enabled = true
                            }
                        }

                        Timer {
                            id: moveSeedsTimer
                            repeat: false
                            interval: 500
                            onTriggered: {
                                setHouseValues()
                            }
                        }

                        onScoreAnimationStarted: {
                            if(Activity.capturedHousesIndex.length > 0 && scoreAnimationsToBeStarted) {
                                for(var i = 0; i < Activity.capturedHousesIndex.length; i++) {
                                    var capturedHouse = Activity.capturedHousesIndex[i]
                                    if(!items.playerOneTurn)
                                        cellGridRepeater.itemAt(capturedHouse.index).scoresAnimation("left",capturedHouse.seeds,capturedHouse.index)
                                    else
                                        cellGridRepeater.itemAt(capturedHouse.index).scoresAnimation("right",capturedHouse.seeds,capturedHouse.index)
                                }
                            }
                            else
                                setScoreValues()
                            scoreAnimationsToBeStarted = true
                        }

                        Repeater {
                            id: grainRepeater
                            model: numberOfSeedsInHouse

                            Image {
                                id: grain
                                source: Activity.url + "grain2.png"
                                height: circleRadius * 0.2
                                width: circleRadius * 0.2
                                x: circleRadius/2 + Activity.getX(circleRadius/6, index,numberOfSeedsInHouse)
                                y: circleRadius/2 + Activity.getY(circleRadius/5, index,numberOfSeedsInHouse)

                                property int currentIndex: index
                                property int currentSeeds: grainRepeater.count
                                property int totalSeeds: grainRepeater.count
                                // moveCount is the current index of the moving seed wrt board.
                                property int moveCount: items.selectedIndexValue
                                property int totalMoves: 0
                                signal checkAnimation

                                onCheckAnimation: {
                                    if(!currentSeeds && !items.gameEnded) {
                                        if(twoPlayer || !items.playerOneTurn) {
                                            var nextPlayer = items.playerOneTurn ? 1 : 0
                                            Activity.sowSeeds(boardGrid.currentMove, Activity.house, Activity.scoreHouse, nextPlayer)
                                        }
                                        moveSeedsTimer.start()
                                        if(!twoPlayer && !items.playerOneTurn)  {
                                            items.computerTurn = true
                                        }
                                    }
                                }

                                function startAnimation() {
                                    grainRepeater.itemAt(index).source = Activity.url + "grain.png"
                                    if(currentIndex >= 0 && currentSeeds > 0) {
                                        if(nextMove == "right")
                                            xRightAnimation.start()
                                        else if(nextMove == "up")
                                            yUpAnimation.start()
                                        else if(nextMove == "left")
                                            xLeftAnimation.start()
                                        else if(nextMove == "down")
                                            yDownAnimation.start()
                                    }
                                    checkAnimation()
                                }

                                function animation(playerEndIndex) {
                                    if(currentIndex >= 0 && currentSeeds > 0) {
                                        if(moveCount == playerEndIndex && totalMoves%items.housesCount == items.housesCount - 1) {
                                            // don't drop seed if it's in the starting house
                                        }
                                        else {
                                            currentSeeds--
                                            currentIndex--
                                        }
                                        totalMoves++
                                    }
                                }

                                function startScoreAnimation(scoreDirection) {
                                    if(scoreDirection == "left")
                                        scoreLeftAnimation.start()
                                    else if(scoreDirection == "right")
                                        scoreRightAnimation.start()
                                }

                                property var scoreLeftAnimation: SequentialAnimation {

                                    NumberAnimation {
                                        target: grain
                                        properties: "y"
                                        from: y; to: y - (board.height)/2
                                        duration: 1000
                                    }

                                    NumberAnimation {
                                        target: grain
                                        properties: "x"
                                        from: x ; to: x - (scoreBoardX * 1.3)
                                        duration: 2000
                                    }

                                    NumberAnimation {
                                        target: grain
                                        properties: "y"
                                        from: y; to: y + (board.height)/2
                                        duration: 2000
                                    }

                                    ScriptAction {
                                        script: {
                                            scoreAnimationsToBeStarted = false
                                            setHouseValues()
                                        }
                                    }
                                }

                                property var scoreRightAnimation: SequentialAnimation {

                                    NumberAnimation {
                                        target: grain
                                        properties: "y"
                                        from: y; to: y + (board.height)/2
                                        duration: 1000
                                    }

                                    NumberAnimation {
                                        target: grain
                                        properties: "x"
                                        from: x ; to: x + (board.width - scoreBoardX)
                                        duration: 2000
                                    }

                                    NumberAnimation {
                                        target: grain
                                        properties: "y"
                                        from: y; to: y - (board.height)/2
                                        duration: 2000
                                    }

                                    ScriptAction {
                                        script: {
                                            scoreAnimationsToBeStarted = false
                                            setHouseValues()
                                        }
                                    }
                                }

                                property var xLeftAnimation: NumberAnimation {
                                    target: grain
                                    properties: "x"
                                    from: x; to: x - (0.162 * board.width)
                                    duration: 450
                                    onStopped: {
                                        animation(items.selectedIndexValue + 1)
                                        moveCount--
                                        nextMove = (moveCount == items.playerTwoStartIndex) ? "down" : "left"
                                        startAnimation()
                                    }
                                }

                                property var xRightAnimation: NumberAnimation {
                                    target: grain
                                    properties: "x"
                                    from: x; to: x + (0.16 * board.width)
                                    duration: 450
                                    onStopped: {
                                        animation(items.selectedIndexValue - 1)
                                        moveCount++
                                        nextMove = (moveCount == items.playerOneEndIndex) ? "up" : "right"
                                        startAnimation()
                                    }
                                }

                                property var yUpAnimation: NumberAnimation {
                                    target: grain
                                    properties: "y"
                                    from: y; to: y - 0.5 * board.height
                                    duration: 350
                                    onStopped: {
                                        animation(items.playerOneEndIndex)
                                        moveCount = items.playerTwoEndIndex
                                        nextMove = "left"
                                        startAnimation()
                                    }
                                }

                                property var yDownAnimation: NumberAnimation {
                                    target: grain
                                    properties: "y"
                                    loops: 1
                                    from: y; to: y + 0.5 * board.height
                                    duration: 350
                                    onStopped: {
                                        animation(items.playerTwoStartIndex)
                                        moveCount = items.playerOneStartIndex
                                        nextMove = "right"
                                        startAnimation()
                                    }
                                }
                            }
                        }
                    }
                }
            }

            PlayerScoreBox {
                id: playerOneScoreBox
                height: board.height * 0.54
                width: height
                anchors.verticalCenter: horizontalLayout ? parent.verticalCenter : undefined
                anchors.horizontalCenter: horizontalLayout ? undefined : parent.horizontalCenter
                anchors.right: horizontalLayout ? board.left : undefined
                anchors.topMargin: horizontalLayout ? undefined : 50
                anchors.top: horizontalLayout ? undefined : board.bottom
                playerScore: items.playerOneScore
            }

            PlayerScoreBox {
                id: playerTwoScoreBox
                height: board.height * 0.54
                width: height
                anchors.verticalCenter: horizontalLayout ? parent.verticalCenter : undefined
                anchors.horizontalCenter: horizontalLayout ? undefined : parent.horizontalCenter
                anchors.bottomMargin: horizontalLayout ? undefined : 30
                anchors.bottom: horizontalLayout ? undefined : board.top
                anchors.left: horizontalLayout ? board.right : undefined
                playerScore: items.playerTwoScore
            }
        }

        Image {
            id: tutorialImage
            source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
            anchors.fill: parent
            z: 5
            visible: twoPlayer ? false : true
            Tutorial {
                id:tutorialSection
                tutorialDetails: Activity.tutorialInstructions
                onSkipPressed: {
                    Activity.initLevel()
                    tutorialImage.visible = false
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
            content: BarEnumContent {
                value: twoPlayer ? (help | home | reload) :
                                   (tutorialSection.visible ? (help | home) : (help | home | level | reload)) }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.reset()
        }

        Bonus {
            id: bonus
        }
    }
}
