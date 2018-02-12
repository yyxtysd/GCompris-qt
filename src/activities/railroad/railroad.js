/* GCompris - railroad.js
 *
 * Copyright (C) 2016 Utkarsh Tiwari <iamutkarshtiwari@kde.org>
 *
 * Authors:
 *   <Pascal Georges> (GTK+ version)
 *   "Utkarsh Tiwari" <iamutkarshtiwari@kde.org> (Qt Quick port)
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
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris

var currentLevel = 0
var numberOfLevel = 10
var solutionArray = []
var backupListModel = []
var isNewLevel = true
var resourceURL = "qrc:/gcompris/src/activities/railroad/resource/"
var items
var uniqueId = []

/**
* Stores configuration for each level.
* 'noOfSampleWagons' contains no. of wagons to display in the sample zone(items.answerZone.model).
* 'WagonsInCorrectAnswers' contains no. of wagons in correct answer.
* 'memoryTime' contains time(in seconds) for memorizing the wagons.
* 'numberOfSubLevels' contains no. of sublevels in each level.
*/
var dataset = {
    "noOfSampleWagons": [12, 20, 12, 20, 12, 20, 12, 20, 12, 20],
    "WagonsInCorrectAnswers": [1, 1, 2, 2, 3, 3, 4, 4, 5, 5],
    "memoryTime": [4, 4, 6, 6, 7, 7, 8, 8, 10, 10],
    "numberOfSubLevels": 3
}

function start(items_) {
    items = items_
    currentLevel = 0
    items.score.numberOfSubLevels = dataset["numberOfSubLevels"];
    items.score.currentSubLevel = 1;
    initLevel()
}

function stop() {
}

function initLevel() {
    generateUniqueId();
    var index = 0;
    items.mouseEnabled = true;
    items.memoryMode = false;
    items.timer.stop();
    items.animateFlow.stop(); // Stops any previous animations
    items.listModel.clear();
    items.answerZone.currentIndex = 0;
    items.sampleList.currentIndex = 0;
    items.answerZone.selectedSwapIndex = -1;
    if(isNewLevel) {
        // Initiates a new level
        backupListModel = [];
        solutionArray = [];
        for(var i = 0; i < Math.ceil((currentLevel+1) / 2); i++) {
            if(i == currentLevel) {
                // Selects the last carriage
                do {
                    if(currentLevel % 2 == 0) {
                        index = Math.floor(Math.random() * 4) + 1;
                    }
                    else {
                        index = Math.floor(Math.random() * 9) + 1;
                    }
                } while (solutionArray.indexOf(index) != -1) // Ensures non-repeative wagons setup
            } else {
                // Selects the follow up wagons
                do {
                    if(currentLevel % 2 == 0) {
                        index = Math.floor(Math.random() * 8) + 11;
                    }
                    else {
                        index = Math.floor(Math.random() * 11) + 10;
                    }
                } while (solutionArray.indexOf(index) != -1)
            }
            solutionArray.push(index);
            
            addWagon(index, i);
        }
    } else {
        // Re-setup the same level
        for(var i = 0; i < solutionArray.length; i++) {
            addWagon(solutionArray[i], i);
        }
    }
    if(items.introMessage.visible === false && isNewLevel) {
        items.timer.start()
    }
    items.bar.level = currentLevel + 1;
    items.timer.interval = dataset["memoryTime"][currentLevel] * 1000
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    items.score.currentSubLevel = 1;
    isNewLevel = true;
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    items.score.currentSubLevel = 1;
    isNewLevel = true;
    initLevel();
}

function restoreLevel() {
    backupListModel = [];
    for (var index = 0; index < items.listModel.count; index++) {
        backupListModel.push(items.listModel.get(index).id);
    }
    isNewLevel = false;
    initLevel();
}

function nextSubLevel() {
    /* Sets up the next sublevel */
    items.score.currentSubLevel ++;
    if(items.score.currentSubLevel > dataset["numberOfSubLevels"]) {
        nextLevel();
    } else {
        isNewLevel = true;
        initLevel();
    }
}

function isAnswer() {
    /* Checks if the top level setup equals the solutions */
    if(items.listModel.count === solutionArray.length) {
        var isSolution = true;
        for (var index = 0; index < items.listModel.count; index++) {
            if(items.listModel.get(index).id != solutionArray[index]) {
                isSolution = false;
                break;
            }
        }
        if(isSolution == true) {
            items.mouseEnabled = false; // Disables the touch
            items.bonus.good("flower");
        }
    }
}

function addWagon(index, dropIndex) {
    /* Appends wagons to the display area */
    items.listModel.insert(dropIndex, {"id": index});
}

function getDropIndex(x) {
    var count = items.listModel.count;
    for (var index = 0; index < count; index++) {
        var xVal = items.answerZone.cellWidth * index
        var itemWidth = items.answerZone.cellWidth
        if(x < xVal && index == 0) {
            return 0;
        } else if((xVal + itemWidth + items.background.width * 0.0025) <= x && index == (count - 1)) {
            return count;
        } else if(xVal <= x && x < (xVal + itemWidth + items.background.width * 0.0025)) {
            return index + 1;
        }
    }
    return 0;
}

/** uniqueID stores image no. of wagons in sample region by which it is stored in resources/
  * When there are 20 wagons in sample list(i.e. all images are shown) then uniqueID.push(index)
  * in case 12 wagons are displyed then image no 5-10 are ignored(railroad/resources/loco+"uniqueId[index]".svg)
  * to skip these wagons uniqueID.push(index + 6) and first four wagons are same for all levels.
  */
function generateUniqueId() {
    uniqueId = [];
    var noOfWagons = dataset["noOfSampleWagons"][currentLevel];
    for(var index = 0; index < noOfWagons; index++) {
        var imageId = (noOfWagons === 20 || index < 4) ? index : index + 6;
        uniqueId.push(imageId);
    }
}
