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
var numberOfLevel = 4
var items
var url = "qrc:/gcompris/src/activities/oware/resource/"
// house variable is used for storing the count of all the seeds as we play.
var house = []
var scoreHouse = [0, 0]
var nextPlayer = 0
var playerSideEmpty = false;
var tutorialInstructions = [
    {
        "instruction": qsTr("At the beginning of the game four seeds are placed in each house. Each player has 6 houses. The first 6 houses starting from the bottom left belong to one player and the upper 6 houses  belong to the other player."),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial1.png"
            },
    {
        "instruction": qsTr("In each turn, a player chooses one of their 6 houses. The player then removes all seeds from that house, and distributes them, dropping one in each house counter-clockwise from the house they chose, in a process called sowing. However if the number of seeds in the house chosen is equal or more than 12 than seed is not dropped in the house from which it was sown."),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial2.png"
            },
    {
        "instruction": qsTr("After a turn, if the last seed was placed into the opponent's house and brought the total number of seeds in that house to two or three, all the seeds in that house are captured and added to player's scoring house. If the previous-to-last seed also brought the total seeds in an opponent's house to two or three, these are captured as well, and so on."),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial3.png"
            },
    {
        "instruction": qsTr("If of all the houses of one player are empty. Then other player has to take such a move that it gives some seeds to the other player and continue the game."),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial4.png"
            },
    {
        "instruction": qsTr("However, if the player is unable to give any seeds to the oponent. Then the player keeps all the seeds in the houses of his side and the game ends."),
        "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial5.png"
            }
       ]

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {}

function initLevel() {
    var singleHouseSeeds = 4
    for (var i = 11; i >= 0; i--)
        house[i] = singleHouseSeeds
    items.playerOneScore = 0
    items.playerTwoScore = 0
    scoreHouse = [0, 0]
    setValues()
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

function setValues() {
    for (var i = 6, j = 0; i < 12, j < 6; j++, i++)
        items.cellGridRepeater.itemAt(i).value = house[j]
    for (var i = 0, j = 11; i < 6, j > 5; j--, i++)
        items.cellGridRepeater.itemAt(i).value = house[j]
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
            print(currentPlayer)
            scoreHouse[currentPlayer] += house[j];
            house[j] = 0;
            items.playerTwoScore = (nextPlayer == 1) ? scoreHouse[1] : items.playerTwoScore
            items.playerOneScore = (nextPlayer == 0) ? scoreHouse[0] : items.playerOneScore
            setValues()
            items.bonus.good("flower")
        }
    }
}

function sowSeeds(index) {
    var currentPlayer = items.playerOneTurn ? 0 : 1
    var nextIndex = index
    playerSideEmpty = false;

    if (!playerSideEmpty) {
        // The seeds are sown until the picked seeds are equal to zero
        while (house[index]) {
            nextIndex = (nextIndex + 1) % 12
            // If there are more than or equal to 12 seeds than we don't sow the in the pit from where we picked the seeds.
            if (index == nextIndex) {
                nextIndex = (nextIndex + 1) % 12
            }
            // Decrement the count of seeds and sow it in the nextIndex
            house[index]--;
            house[nextIndex]++;
        }

        //  The nextIndex now contains the seeds in the last pit sown.
        var capture = [];
        // The opponent's seeds are captured if they are equal to 2 or 3
        if (((house[nextIndex] == 2 || house[nextIndex] == 3)) && ((currentPlayer == 1 && nextIndex > 5 && nextIndex < 12) || (currentPlayer == 0 && nextIndex >= 0 && nextIndex < 6))) {
            capture[nextIndex % 6] = true;
        }
        /* The seeds previous to the captured seeds are checked. If they are equal to 2 or 3 then they are captured until a
            pit arrives which has more than 3 seeds or 1 seed. */
        while (capture[nextIndex % 6] && nextIndex % 6) {
            nextIndex--;
            if (house[nextIndex] == 2 || house[nextIndex] == 3) {
                capture[nextIndex % 6] = true;
            }
        }

        var allSeedsCaptured = true;
        /* Now we check if all the seeds in opponents houses which were to be captured are captured or not. If any of the house is not yet captured we set allSeedsCaptured as false */
        for (var j = currentPlayer * 6; j < (currentPlayer * 6 + 6); j++) {
            if (!capture[j % 6] && house[j])
                allSeedsCaptured = false;
        }
        // Now capture the seeds for the houses for which capture[houseIndex] = true if all seeds are not captured
        if (!allSeedsCaptured) {
            for (var j = currentPlayer * 6; j < (currentPlayer * 6 + 6); j++) {
                /* If opponent's houses capture is true we set the no of seeds in that house as 0 and give the seeds to the opponent. */
                if (capture[j % 6]) {
                    scoreHouse[nextPlayer] = scoreHouse[nextPlayer] + house[j];
                    house[j] = 0;
                }
            }
        }
    }
    // Now we check if the player has any more seeds or not
    for (var j = nextPlayer * 6; j < (nextPlayer * 6 + 6); j++) {
        // If any of the pits in house is not empty we set playerSideEmpty as false
        if (house[j]) {
            playerSideEmpty = false;
            break;
        } else
            playerSideEmpty = true
    }
    items.playerTwoScore = (nextPlayer == 1) ? scoreHouse[1] : items.playerTwoScore
    items.playerOneScore = (nextPlayer == 0) ? scoreHouse[0] : items.playerOneScore
    nextPlayer = currentPlayer
    setValues()
}
