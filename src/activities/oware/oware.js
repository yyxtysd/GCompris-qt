/* GCompris - oware.js
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
.import QtQuick 2.6 as Quick

var currentLevel = 0
var numberOfLevel = 4
var items
var url = "qrc:/gcompris/src/activities/oware/resource/"
function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
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

function sowSeeds(index) {
    var nbSeeds = items.repeater.itemAt(index).value
    if(nbSeeds == 0)
        return;
    items.repeater.itemAt(index).value = 0;
    var last,j,seeds;
    seeds = nbSeeds
    print(index)
    for (j = 1, last = (index + 1) % 12 ; j <= nbSeeds; j++) {
    items.repeater.itemAt(last).value += 1
    last = (last + 1) % 12
    seeds -= 1
        if(seeds == 0 && items.repeater.itemAt(last).value != 0) {
        seeds = items.repeater.itemAt(last).value
        sowSeeds(last)
    }
  }
}
