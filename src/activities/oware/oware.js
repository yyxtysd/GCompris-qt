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
var maxDiff = [20, 15, 10, 5, 0]
var depth
var heuristicValue
var lastMove
var finalMove
var twoPlayer
var capturedHousesIndex
var tutorialInstructions = [{
        "instruction": qsTr("<h5><b>Introduction: </b></h5><ul><li>Each player has 6 houses with 4 seeds each.</li><li>Lower 6 houses are for player 1.</li><li>Upper 6 houses are for player 2.</li></ul>"),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial1.png"
    },
    {
        "instruction": qsTr("<h4><b>Sowing: </b></h4><ul><li>Chose any house from your set of houses. </li> <li>All seeds from that house will be picked and dropped in each house counter-clockwise</li></ul>"),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial2.png"
    },
    {
        "instruction": qsTr("<h5><b>Example: </b></h5>If player 1 choses second house, blue seeds from the second house below are picked and dropped in next houses (yellow seeds represent the dropped seeds)."),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial2.png"
    },
    {
        "instruction": qsTr("<li>If the number of seeds in the chosen house is >= 12, seed is not dropped in that house while sowing. </li><li><b>Example: </b>If player 1 choses second house with 14 seeds, seed will not be dropped in that house.</li>"),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial3.png"
    },
    {
        "instruction": qsTr("<h6><b>Capturing:</b></h6> The seeds are captured when all below conditions are true:<ul> <li> Last seed is dropped into the opponent's house. <li>Total number of seeds in that house are now two or three </li><li><b>Those seeds will go to your scoring box.</b></li></ul>"),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial4.png"
    },
    {
        "instruction": qsTr("If all the houses of one player are <b>empty</b>, the other player has to take such a move that it gives one or more seeds to the other player to continue the game.<li><b>Example: </b>Player 1 has no more seeds left, so player 2 needs to give seeds to player 1 in next move.</li>"),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial5.png"
    },
    {
        "instruction": qsTr("<ul><li>The player who gets 25 seeds first wins the game.</li><li>If the current player is unable to give any seed then he keeps all the seeds of his houses and the game ends.</li> <li><b>Example:</b> Player 1 has no seeds, neither player 2 can give any so player 2 will take the seed and game ends.</b></li></ul>"),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial6.png"
    }
]

function start(items_, twoPlayer_) {
    items = items_
    twoPlayer = twoPlayer_
    currentLevel = 0
    reset()
}

function stop() {}

// Function to reload the activity.
function reset() {
    for (var i = 0; i < 12; i++)
        items.cellGridRepeater.itemAt(i).numberOfSeedsInHouse = 0
    items.playerOneLevelScore.endTurn()
    items.playerTwoLevelScore.endTurn()
    items.playerOneLevelScore.beginTurn()
    items.playerOneTurn = true
    items.gameEnded = false
    items.computerTurn = false
    initLevel()
}

function initLevel() {
    items.boardModel.enabled = true
    items.bar.level = currentLevel + 1
    var initialSeedsNumber = 4
    for (var i = 11; i >= 0; i--) {
        house[i] = initialSeedsNumber
        items.cellGridRepeater.itemAt(i).numberOfSeedsInHouse = initialSeedsNumber
    }
    items.playerOneScore = 0
    items.playerTwoScore = 0
    scoreHouse = [0, 0]
    depth = currentLevel
}

function nextLevel() {
    if (numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    reset()
}

function previousLevel() {
    if (--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
    reset()
}

// Function to get the x position of seeds.
function getX(radius, index, numberOfSeedsInHouse) {
    var step = (2 * Math.PI) * index / numberOfSeedsInHouse;
    return radius * Math.cos(step);
}

// Function to get the y position of seeds.
function getY(radius, index, numberOfSeedsInHouse) {
    var step = (2 * Math.PI) * index / numberOfSeedsInHouse;
    return radius * Math.sin(step);
}

function computerMove() {
    if (items.playerOneScore - items.playerTwoScore >= maxDiff[currentLevel]) {
        var houseClone = house.slice()
        var scoreClone = scoreHouse.slice()
        var heuristicValue
        var index = alphaBeta(4, -200, 200, houseClone, scoreClone, 0, lastMove, heuristicValue)
        finalMove = index[0]
    }
    else {
        randomMove()
    }
    sowSeeds(finalMove, house, scoreHouse, 1)
    items.cellGridRepeater.itemAt(items.selectedIndexValue).z = 0
    items.selectedIndexValue = 11 - finalMove
    if(!items.gameEnded) {
        items.cellGridRepeater.itemAt(items.selectedIndexValue).z = 20
        items.cellGridRepeater.itemAt(items.selectedIndexValue).firstMove()
        items.playerOneTurn = !items.playerOneTurn
        items.computerTurn = false
    }
}

// Random moves are made when the difference between scores is less than maxDiff[levelNumber]
function randomMove() {
    do {
        var move = Math.floor(Math.random() * (12 - 6) + 6)
        finalMove = move
    }
    while(house[move] == 0 || !isValidMove(move, 0, house))
}

function gameOver(board, score) {
    if (score[0] > 24 || score[1] > 24)
        return true
    return false
}

function alphaBeta(depth, alpha, beta, board, score, nextPlayer, lastMove,heuristicValue) {
    var childHeuristics
    var bestMove
    if (depth == 0 || gameOver(board, score)) {
        heuristicValue = heuristicEvaluation(score)
//         print("heauristic value,alpha,beta",heuristicValue,alpha,beta);
        return [-1, heuristicValue]
    }
    for (var move = 0; move < 12; move++) {
        if (!isValidMove(move, nextPlayer, board))
            continue
        var currentBoard = board.slice()
        var currentScore = score.slice()
        var lastMoveAI = sowSeeds(move, currentBoard, currentScore, nextPlayer)
//         print("last move", JSON.stringify(lastMoveAI),depth)
        var out = alphaBeta(depth - 1, alpha, beta, lastMoveAI.board, lastMoveAI.scoreHouse, lastMoveAI.nextPlayer, lastMoveAI.lastMove,childHeuristics)
//         print("out",out)
        childHeuristics = out[1]
        if (nextPlayer) {
            if (beta > childHeuristics) {
                beta = childHeuristics
                bestMove = move
            }
            if (alpha >= childHeuristics)
                break;
        } else {
            if (alpha < childHeuristics) {
                alpha = childHeuristics
                bestMove = move
            }
            if (beta <= childHeuristics)
                break;
        }
    }
    heuristicValue = nextPlayer ? beta : alpha
//     print("bestMove,heuristicValue,alpha,beta",bestMove,depth,heuristicValue,alpha,beta);
    return [bestMove, heuristicValue]
}

function heuristicEvaluation(score) {
    var playerScores = [];
    for (var i = 0; i < 2; i++) {
        playerScores[i] = score[i]
        if (playerScores[i] > 24)
            playerScores[i] += 100
    }
    return playerScores[0] - playerScores[1]
}

function isValidMove(move, nextPlayer, board) {
    if (move < 0 || !board[move])
        return false
    if ((nextPlayer && move >= 6) || (!nextPlayer && move < 6))
        return false
    if(board[move] >= 12)
        return true
    // if the opponent does not have any seed, the current player has to give him if possible
    var sum = 0;
    for (var j = nextPlayer * 6; j < (nextPlayer * 6 + 6); j++)
        sum += board[j];
    if (sum == 0 && ((!nextPlayer && board[move] % 12 < 12 - move) || (nextPlayer && board[move] % 12 < 6 - move)))
        return false
    else
        return true
}

function sowSeeds(index, board, scoreHouse, nextPlayer) {
    var currentPlayer = (nextPlayer + 1) % 2
    var nextIndex = index
    lastMove = index
    capturedHousesIndex = []
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
                scoreHouse[nextPlayer] = scoreHouse[nextPlayer] + board[j]
                if(!nextPlayer)
                    capturedHousesIndex.push({ "index": 11 - j,"seeds": board[j] })
                else
                    capturedHousesIndex.push({ "index": 6 + j, "seeds": board[j] })
                board[j] = 0;
            }
        }
    }
    var playerSideEmpty = true
    for (var j = nextPlayer * 6; j < (nextPlayer * 6 + 6); j++) {
	if (board[j]) {
	    playerSideEmpty = false;
	    break;
        }
    }

    if (playerSideEmpty) {
        var canGiveSeeds = false;
	for (var j = currentPlayer * 6; j < (currentPlayer * 6 + 6); j++) {
	    if ((board[j] >= 6 - j) || (board[j] > 12)) {
		canGiveSeeds = true;
		break;
	    }
	}

	// If opponent can't give seeds, remaining seeds go to the opponent
	if (!canGiveSeeds) {
	    for (var j = currentPlayer * 6; j < (currentPlayer * 6 + 6); j++) {
		scoreHouse[currentPlayer] += board[j];
		board[j] = 0;
	    }
     }
    }
    var obj = {
        board: board,
        scoreHouse: scoreHouse,
        nextPlayer: nextPlayer,
        lastMove: lastMove
    }
    nextPlayer = currentPlayer
    return obj
}
