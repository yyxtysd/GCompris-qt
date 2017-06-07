/* GCompris - submarine.js
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin (bruno.coudoin@gcompris.net) (GTK+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
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
.import GCompris 1.0 as GCompris
.import QtQuick 2.6 as Quick

var currentLevel = 0
var numberOfLevel = 10
var items
var barAtStart

function start(items_) {
    items = items_
    currentLevel = 0
    barAtStart = GCompris.ApplicationSettings.isBarHidden;
    GCompris.ApplicationSettings.isBarHidden = true;
    initLevel()
}

function stop() {
    GCompris.ApplicationSettings.isBarHidden = barAtStart;
}

function initLevel() {
    items.bar.level = currentLevel + 1

    /* Tutorial Levels, display tutorials */
    if (items.datasetLevels[currentLevel].intro) {
        items.tutorial.visible = true
        items.tutorial.index = 0
        items.tutorial.intro = items.datasetLevels[currentLevel].intro
    } else {
        items.tutorial.visible = false
        items.physicalWorld.running = true
    }
    setUpLevelElements()
}

function setUpLevelElements() {
    if(items.ship.visible) {
        items.ship.x = items.ship.initialXPosition
    }

    if ( !items.crown.visible && items.upperGate.visible) {
        items.gateOpenAnimation.start()
    }
}

function closeGate() {
    if (items.upperGate.visible) {
        items.gateCloseAnimation.start()
    }
}

function nextLevel() {
    closeGate()
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
