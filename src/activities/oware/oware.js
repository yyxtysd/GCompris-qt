/* GCompris - oware.js
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
.pragma library
.import QtQuick 2.6 as Quick

var currentLevel = 0
var numberOfLevel = 5
var items
var url = "qrc:/gcompris/src/activities/oware/resource/"
// house variable is used for storing the count of all the seeds as we play.
var house = []
var scoreHouse = [0, 0]
var nextPlayer = 1
var playerSideEmpty = false;
var maxDiff = [20, 15, 10, 5, 0]
var depth
var heuristicValue
var lastMove
var tutorialInstructions = [
    {
        "instruction": qsTr("At the beginning of the game four seeds are placed in each house. Each player has 6 houses. The first 6 houses starting from the bottom left belong to one player and the upper 6 houses  belong to the other player."),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial1.png"
            },
    {
        "instruction": qsTr("In each turn, a player chooses one of their 6 houses. All seeds from that house are picked and dropped one in each house counter-clockwise from the house they chose, in a process called sowing. However if the number of seeds in the house chosen is equal or more than 12, then seed is not dropped in the house from which the player picked up the seeds."),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial2.png"
            },
    {
        "instruction": qsTr("After a turn, if the last seed was placed into the opponent's house and brought the total number of seeds in that house to two or three, all the seeds in that house are captured and added to player's scoring house. If the previous-to-last seed dropped also brought the total seeds in an opponent's house to two or three, these are captured as well, and so on."),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial3.png"
            },
    {
        "instruction": qsTr("If all the houses of one player are empty, the other player has to take such a move that it gives one or more seeds to the other player to continue the game."),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial4.png"
            },
    {
        "instruction": qsTr("However, if the current player is unable to give any seed to the opponent, then the current player keeps all the seeds in the houses of his side and the game ends."),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial5.png"
            }
       ]

function start(items_) {
    items = items_
    currentLevel = 0
    reset()
}

function stop() {}

function reset() {
    items.boxModel.enabled = true
    items.playerOneLevelScore.endTurn()
    items.playerTwoLevelScore.endTurn()
    items.playerOneLevelScore.beginTurn()
    items.playerOneTurn = true
    initLevel()
}

function initLevel() {
    items.bar.level = currentLevel + 1
    var singleHouseSeeds = 4
    for (var i = 11; i >= 0; i--)
        house[i] = singleHouseSeeds
    items.playerOneScore = 0
    items.playerTwoScore = 0
    scoreHouse = [0, 0]
    depth = currentLevel
    setValues(house)
}

function nextLevel() {
    if (numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if (--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function getX(radius, index, value) {
    var step = (2 * Math.PI) * index / value;
    return radius * Math.cos(step);
}

function getY(radius, index, value) {
    var step = (2 * Math.PI) * index / value;
    return radius * Math.sin(step);
}

function computerMove() {
    var finalMove
    var validMove = false
    if (items.playerOneScore - items.playerTwoScore >= maxDiff[currentLevel]) {
        var houseClone = house.slice()
        var scoreClone = scoreHouse.slice()
        var lastMoveClone = lastMove
        var index = alphaBeta(4, -200, 200, house, scoreHouse, 1, lastMove)
        house = houseClone.slice()
        scoreHouse = scoreClone.slice()
        finalMove = index[0]
        if(house[finalMove])
            validMove = true
    } else if(!validMove && items.playerOneScore - items.playerTwoScore < maxDiff[currentLevel]){
         var move = Math.floor(Math.random() * (12 - 6) + 6);
        if (house[move] && isValidMove(move,1,house)) {
            validMove = true
            finalMove = move
        }
        else
            computerMove()
    }
    if(validMove) {
        sowSeeds(finalMove, house, scoreHouse, 1)
        items.playerTwoLevelScore.endTurn()
        items.playerOneLevelScore.beginTurn()
    }
}

function gameOver(board,score) {
    if(score[0] > 24 || score[1] > 24)
        return true
    return false
}

function alphaBeta(depth, alpha, beta, board, score, nextPlayer, lastMove) {
    var heuristicValue
    var childHeuristics
    var bestMove
    if (depth == 0 || gameOver(board, score)) {
        heuristicValue = heuristicEvaluation(score)
        return [-1, heuristicValue]
    }
    for (var move = 0; move < 12; move++) {
        if (!isValidMove(move,nextPlayer,board))
            continue
        var lastMoveAI = sowSeeds(move, board, score, nextPlayer)
        var out = alphaBeta(depth - 1, alpha, beta, lastMoveAI.board, lastMoveAI.scoreHouse, lastMoveAI.nextPlayer, lastMoveAI.lastMove);
        childHeuristics = out[1]
        if (nextPlayer) {
            if (beta > childHeuristics) {
                beta = childHeuristics
                bestMove = lastMoveAI.lastMove
            }
            if (alpha >= childHeuristics)
                break;
        } else {
            if (alpha < childHeuristics) {
                alpha = childHeuristics
                bestMove = lastMoveAI.lastMove
            }
            if (beta <= childHeuristics)
                break;
        }
    }
    heuristicValue = nextPlayer ? beta : alpha
    return [bestMove, heuristicValue]
}

function heuristicEvaluation(score) {
    var playerScores = [];
    for(var i = 0; i < 2; i++) {
        playerScores[i] = score[i]
        if(playerScores[i] > 24)
            playerScores[i] += 100
    }
    return playerScores[0] - playerScores[1]
}

function isValidMove(move,next,board) {
    if((next * 6 > move) || (move >= (next * 6 + 6)))
        return false
    if(!board[move])
        return false
    var sum = 0;
    for (var j = next * 6; j < (next * 6 + 6); j++)
        sum += board[j];
    if (sum == 0 && (board[move] % 12 < 11 - move))
        return false
    else
        return true
}

function setValues(board) {
    for (var i = 6, j = 0; i < 12, j < 6; j++, i++)
        items.cellGridRepeater.itemAt(i).value = board[j]
    for (var i = 0, j = 11; i < 6, j > 5; j--, i++)
        items.cellGridRepeater.itemAt(i).value = board[j]
}

function checkHunger(index) {
    var currentPlayer = items.playerOneTurn ? 1 : 0
    var canGive = false
    // First it's checked if the current player can satisfy the hunger of opponent.
    for (var j = currentPlayer * 6; j < (currentPlayer * 6 + 6); j++) {
        if (items.playerOneTurn && house[j] % 12 > 11 - j) {
            canGive = true
            break;
        } else if (!items.playerOneTurn && house[j] % 12 > 5 - j) {
            canGive = true;
            break;
        }
    }
    // If the player can give seeds, then the seeds are sown only when the hunger is satisfied.
    if (canGive && (items.playerOneTurn && house[index] % 12 > 11 - index) || (!items.playerOneTurn && house[index] % 12 > 5 - index)) {
        sowSeeds(index)
    } else if (canGive) {
        items.playerOneTurn = !items.playerOneTurn
    }
    // If the player cannot satisfy the hunger all the seeds in the territory are captured and game ends.
    else if (!canGive) {
        for (j = currentPlayer * 6; j < (currentPlayer * 6 + 6); j++) {
            scoreHouse[currentPlayer] += house[j];
            house[j] = 0;
            items.playerTwoScore = (nextPlayer == 1) ? scoreHouse[1] : items.playerTwoScore
            items.playerOneScore = (nextPlayer == 0) ? scoreHouse[0] : items.playerOneScore
            setValues()
        }
    }
}

function sowSeeds(index, board, scoreHouse, nextPlayer) {
    var currentPlayer = (nextPlayer + 1) % 2
    var nextIndex = index
    playerSideEmpty = false;
    lastMove = index

    if (!playerSideEmpty) {
        // The seeds are sown until the picked seeds are equal to zero
        while (board[index]) {
            nextIndex = (nextIndex + 1) % 12
            // If there are more than or equal to 12 seeds than we don't sow the in the pit from where we picked the seeds.
            if (index == nextIndex) {
                nextIndex = (nextIndex + 1) % 12
            }
            // Decrement the count of seeds and sow it in the nextIndex
            board[index]--;
            board[nextIndex]++;
        }

        //  The nextIndex now contains the seeds in the last pit sown.
        var capture = [];
        // The opponent's seeds are captured if they are equal to 2 or 3
        if (((board[nextIndex] == 2 || board[nextIndex] == 3)) && ((currentPlayer == 1 && nextIndex > 5 && nextIndex < 12) || (currentPlayer == 0 && nextIndex >= 0 && nextIndex < 6))) {
            capture[nextIndex % 6] = true;
        }
        /* The seeds previous to the captured seeds are checked. If they are equal to 2 or 3 then they are captured until a
            pit arrives which has more than 3 seeds or 1 seed. */
        while (capture[nextIndex % 6] && nextIndex % 6) {
            nextIndex--;
            if (board[nextIndex] == 2 || board[nextIndex] == 3) {
                capture[nextIndex % 6] = true;
            }
        }

        var allSeedsCaptured = true;
        /* Now we check if all the seeds in opponents houses which were to be captured are captured or not. If any of the house is not yet captured we set allSeedsCaptured as false */
        for (var j = currentPlayer * 6; j < (currentPlayer * 6 + 6); j++) {
            if (!capture[j % 6] && board[j])
                allSeedsCaptured = false;
        }
        // Now capture the seeds for the houses for which capture[houseIndex] = true if all seeds are not captured
        if (!allSeedsCaptured) {
            for (var j = currentPlayer * 6; j < (currentPlayer * 6 + 6); j++) {
                /* If opponent's houses capture is true we set the no of seeds in that house as 0 and give the seeds to the opponent. */
                if (capture[j % 6]) {
                    scoreHouse[nextPlayer] = scoreHouse[nextPlayer] + board[j];
                    board[j] = 0;
                }
            }
        }
    }
    // Now we check if the player has any more seeds or not
    for (var j = nextPlayer * 6; j < (nextPlayer * 6 + 6); j++) {
        // If any of the pits in house is not empty we set playerSideEmpty as false
        if (board[j]) {
            playerSideEmpty = false;
            break;
        } else
            playerSideEmpty = true
    }
    nextPlayer = currentPlayer
    setValues(board)
    var obj = {
        board: board,
        scoreHouse: scoreHouse,
        nextPlayer: nextPlayer,
        lastMove: lastMove
    }
    return obj
}
