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
function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
    tutorial()
}

function stop() {
}

function initLevel() {
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

function tutorial() {
    items.isTutorial = true
    setTutorial(1)
}

function setTutorial(tutNum) {

    if(tutNum == 1) {
        items.tutorialTxt = qsTr("At the beginning of the game four seeds are placed in each house. Players take turns by moving the seeds")
    }
    else if(tutNum == 2) {
        items.tutorialTxt = qsTr("In each turn, a player chooses one of the six houses under his or her control. The player removes all seeds from this house, and distributes them, dropping one in each house counter-clockwise from the original house, in a process called sowing.")
    }
    else if(tutNum == 3) {
        items.tutorialTxt = qsTr("After a turn, if the last seed was placed into an opponent's house and brought its total to two or three, all the seeds in that house are captured and placed in the player's scoring house (or set aside if the board has no scoring houses). If the previous-to-last seed also brought the total seeds in an opponent's house to two or three, these are captured as well, and so on.")
    }
}

function tutorialSkip() {
    items.isTutorial = false
    initLevel()
}

function tutorialNext() {
    setTutorial(++items.tutNum)
}

function tutorialPrevious() {
    setTutorial(--items.tutNum)
}

function sowSeeds(index) {
    var nbSeeds = items.repeater.itemAt(index).value
    if(nbSeeds == 0)
        return;
    var last,j,seeds;
    seeds = nbSeeds
    print(index)
    items.repeater.itemAt(index).value = 0;
    /*
    for (j = 1, last = (index + 1) % 12; j <= nbSeeds; j++) {
    items.repeater.itemAt(last).value += 1
    last = (last + 1) % 12
    seeds -= 1
        if(seeds == 0 && items.repeater.itemAt(last).value != 0) {
        seeds = items.repeater.itemAt(last).value
        sowSeeds(last)
    }*/
}
