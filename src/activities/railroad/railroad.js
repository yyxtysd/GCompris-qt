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
var numberOfLevel = 4
var noOfCarriages = [5, 6, 5, 6]
var rowWidth = [0.95, 0.1, 0.1, 0.1]
//var rowWidth = [[1.3, 1.80], [1.16, 0.99], [1.12, 0.97], [1.14, 0.99]]
//var rowWidth = [2000, 1000, 1000, 1000]
//var railWidthArray = [5, 4, 3.8, 3.8, 5, 6.0, 6.0, 3.8, 6.0, 4, 4,
//                      4, 4.5, 4, 4, 4.5, 4, 5, 5.5, 6.0, 6.0, 3.8]
var memoryMode = false
var solutionArray = []
var isReset = false
var resourceURL = "qrc:/gcompris/src/activities/railroad/resource/"
var maxSubLevel = 3
var sampleIsVisible = false
var items

function start(items_) {
    items = items_
    currentLevel = 0
    items.score.numberOfSubLevels = maxSubLevel;
    items.score.currentSubLevel = 1;
    initLevel()
}

function stop() {
}

function initLevel() {
    var index = 0;
    memoryMode = false;
    items.railCollection.visible = false;
    items.animateFlow.stop(); // Stops any previous animations
    items.listModel.clear();
    items.displayList.model = items.listModel;
    if (isReset == false) {
        // Initiates a new level
        solutionArray = [];
        for (var i = 0; i < currentLevel + 2; i++) {
            if (i == (currentLevel + 1)) {
                // Selects the last carriage
                do {
                    index = Math.floor(Math.random() * 9) + 1;
                } while (solutionArray.indexOf(index) != -1) // Ensures non-repeative wagons setup

            } else {
                // Selects the follow up wagons
                do {
                    index = Math.floor(Math.random() * 12) + 10;
                } while (solutionArray.indexOf(index) != -1)
            }
            solutionArray.push(index);
            items.listModel.append({"id" : index});
            (items.displayList.itemAt(items.listModel.count - 1)).source = resourceURL + "loco" + (index) + ".svg";

        }
    } else {
        // Re-setup the same level
        for ( var i = 0; i < solutionArray.length; i++) {
            items.listModel.append({"id" : solutionArray[i]});
            (items.displayList.itemAt(items.listModel.count - 1)).source = resourceURL + "loco" + (solutionArray[i]) + ".svg";
        }
        isReset = false;
    }
    items.animateFlow.start()
    items.bar.level = currentLevel + 1;
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    items.score.currentSubLevel = 1;
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    items.score.currentSubLevel = 1;
    initLevel();
}

function reset() {
    isReset = true;
    initLevel();
}

function advanceSubLevel() {
    /* Sets up the next sublevel */
    items.score.currentSubLevel++;
    if (items.score.currentSubLevel > maxSubLevel) {
        nextLevel();
        items.score.currentSubLevel = 1;
    } else {
        initLevel();
    }
}

function isAnswer() {
    /* Checks if the top level setup equals the solutions */
    if (items.listModel.count === solutionArray.length) {
        var flag = true;
        for (var index = 0; index < items.listModel.count; index++) {
            if (items.listModel.get(index).id != solutionArray[index]) {
                flag = false;
                break;
            }
        }
        if (flag == true) {
            items.bonus.good("flower");
        }
    }
}

function sum(index) {
    /* Returns the sum up till the specified index */
    var total = 0
    for (var i = 0; i <index; i++)
        total += noOfCarriages[i];
    return total;
}

function addWagon(index) {
    /* Appends wagons to the display area */
    items.listModel.append({"id" : index});
    (items.displayList.itemAt(items.listModel.count - 1)).source = resourceURL + "loco" + (index) + ".svg";
}
