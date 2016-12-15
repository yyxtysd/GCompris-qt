/* GCompris - railroad.js
 *
 * Copyright (C) 2016 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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

var currentLevel = 0
var numberOfLevel = 4
var noOfCarriages = [4, 5, 4, 4, 5]
var railWidthArray = [5, 4, 3.8, 3.8, 5, 6.5, 6.5, 3.8, 6.5, 4, 4,
                      4, 4.5, 4, 4, 4.5, 4, 5, 5.5, 6.5, 6.5, 3.8]
var memoryMode = false
var backupArray = []
var isReset = false
var resourceURL = "qrc:/gcompris/src/activities/railroad/resource/"
var items

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    var index = 0;
    memoryMode = false;
    items.animateFlow.stop(); // Stops any previous animations
    items.listModel.clear();
    items.displayList.model = items.listModel;
    if (isReset == false) {
        // Initiates a new level
        backupArray = [];
        for (var i = 0; i < currentLevel + 2; i++) {
            if (i == (currentLevel + 1)) {
                // Selects the last carriage
                do {
                    index = Math.floor(Math.random() * 9) + 1;
                } while (backupArray.indexOf(index) != -1) // Ensures non-repeative wagons setup

            } else {
                // Selects the follow up wagons
                do {
                    index = Math.floor(Math.random() * 12) + 10;
                } while (backupArray.indexOf(index) != -1)
            }
            backupArray.push(index);
            items.listModel.append({"name" : index});
            (items.displayList.itemAt(items.listModel.count - 1)).source = resourceURL + "loco" + (index) + ".svg";
            (items.displayList.itemAt(items.listModel.count - 1)).width = items.background.width / (railWidthArray[index - 1] + 1);

        }
    } else {
        // Re-setup the same level
        for ( var i = 0; i < backupArray.length; i++) {
            items.listModel.append({"name" : backupArray[i]});
            (items.displayList.itemAt(items.listModel.count - 1)).source = resourceURL + "loco" + (backupArray[i]) + ".svg";
            (items.displayList.itemAt(items.listModel.count - 1)).width = items.background.width / (railWidthArray[backupArray[i] - 1] + 1);
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
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function reset() {
    isReset = true;
    initLevel();
}

function addWagon(index) {
    /* Appends wagons to the display area */
    items.listModel.append({"name" : index});
    (items.displayList.itemAt(items.listModel.count - 1)).source = resourceURL + "loco" + (index + 1) + ".svg";
    (items.displayList.itemAt(items.listModel.count - 1)).width = items.background.width / (railWidthArray[index] + 1);
}
