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
var scoreHouse = [0,0]
var nextPlayer
var tutorialInstructions = [
            {
               "instruction": qsTr("At the beginning of the game four seeds are placed in each house. Players take turns by moving the seeds"),
               "instructionImage" : "qrc:/gcompris/src/activities/oware/resource/tutorial1.png"
            },
            {
                "instruction": qsTr("In each turn, a player chooses one of the six houses under his or her control. The player removes all seeds from this house, and distributes them, dropping one in each house counter-clockwise from the original house, in a process called sowing."),
                "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial2.png"
            },
            {   "instruction": qsTr("After a turn, if the last seed was placed into an opponent's house and brought its total to two or three, all the seeds in that house are captured and placed in the player's scoring house (or set aside if the board has no scoring houses). If the previous-to-last seed also brought the total seeds in an opponent's house to two or three, these are captured as well, and so on."),
                "instructionImage": "qrc:/gcompris/src/activities/oware/resource/tutorial3.png"
            }
       ]

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    for(var i = 11; i >= 0; i--)
        house[i] = 4
    setValues()
    items.bar.level = currentLevel + 1
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function getX(radius,index,value){
    var step=(2 * Math.PI) * index/value;
    return radius * Math.cos(step);
}

function getY(radius,index,value){
    var step = (2 * Math.PI) * index/value;
    return radius * Math.sin(step);
}

function setValues() {/*
    print("after..")
	for(var i = 0; i < house.length; i++) {
        print(house[i])
    }*/
    for(var i = 6, j = 0; i < 12, j < 6; j++, i++)
        items.cellGridRepeater.itemAt(i).value = house[j]
    for(var i = 0, j = 11; i < 6, j > 5; j--, i++)
        items.cellGridRepeater.itemAt(i).value = house[j]
}

function sowSeeds(index) {
    var currentPlayer = items.playerOneTurn ? 1 : 0
    var nextIndex = index

    // The seeds are sown until the picked seeds are equal to zero
    while(house[index]) {
        nextIndex = (nextIndex + 1)%12
        // If there are more than or equal to 12 seeds than we don't sow the in the pit from where we picked the seeds.
        if(index == nextIndex) {
            nextIndex = (nextIndex + 1)%12
        }
        // Decrement the count of seeds and sow it in the nextIndex
        house[index]--;
        house[nextIndex]++;
    }

  //  The nextIndex now contains the seeds in the last pit sown.
    var capture = [];
    // The opponent's seeds are captured if they are equal to 2 or 3
    print(currentPlayer)
    print("index",nextIndex)
    if (((house[nextIndex] == 2 || house[nextIndex] == 3) ) && ((currentPlayer == 1 && nextIndex > 5 && nextIndex < 12) || (currentPlayer == 0 && nextIndex >= 0 && nextIndex < 6))) {
		capture[nextIndex%6] = true;
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
	/* Now we check if all the seeds in opponents houses are captured or not. If any of the house is left with seeds we
        allSeedsCaptured as false */
    for (var j = currentPlayer * 6; j < (currentPlayer * 6 + 6); j++) {
		if (!capture[j % 6] && house[j])
			allSeedsCaptured = false;
	}

    // Now capture the seeds for the houses for which capture[houseIndex] = true if all seeds are not captured
	if (!allSeedsCaptured) {
		for (var j = currentPlayer * 6; j < (currentPlayer * 6 + 6); j++) {
			/* If opponent's houses capture is true we set the no of seeds in that house as 0 and give the seeds to the opponent. */
            if (capture[j%6]) {
				scoreHouse[nextPlayer] = scoreHouse[nextPlayer] + house[j];
				house[j] = 0;
			}
		}
	}
    items.playerTwoScore = (nextPlayer == 1) ? scoreHouse[1] : items.playerTwoScore
    items.playerOneScore = (nextPlayer == 0) ? scoreHouse[0] : items.playerOneScore
//
// 	// Now we check if the player has any more seeds or not
//     var playerSideEmpty = true;
// 	for (var j = nextPlayer * 6; j < (nextPlayer * 6 + 6); j++) {
//         // If any of the pits in house is not empty we set playerSideEmpty as false
// 		if (house[j]) {
// 			playerSideEmpty = false;
// 			break;
// 		}
// 	}
// 	print(scoreHouse[nextPlayer])
	nextPlayer = currentPlayer
	setValues()
}
