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

/*
 * To check if the level elements are already initialised or not
 * = -1 = levels are not yet initialised
 * = 1 = levels are currently being initialised
 * = 0 = levels are fully initialised
 */
var levelsBeingInitialised = -1

function start(items_) {
    items = items_
    currentLevel = 0
    barAtStart = GCompris.ApplicationSettings.isBarHidden;
    GCompris.ApplicationSettings.isBarHidden = true;
    initLevel()
}

function stop() {
    levelsBeingInitialised = -1
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
    levelsBeingInitialised = 1
    setUpLevelElements()
}

function setUpLevelElements() {
    /*
      // NOT Working
    var levelComponents = items.datasetLevels[currentLevel].items
    for (var i = 0; i < (levelComponents).length;i++) {
        var object = levelComponents[i].component
        var objectProperty = levelComponents[i]

        if (levelsBeingInitialised == 1) {
            object.visible = objectProperty.visible
        }

        if (object.visible == false) {
            continue
        }

        if (objectProperty.width) {
            object.width = objectProperty.width
        }

        if (objectProperty.height) {
            object.height = objectProperty.height
        }

        if (objectProperty.x) {
            object.x = objectProperty.x
        }

        if (objectProperty.y) {
            object.y = objectProperty.y
        }
    }
    */
    for (var i = 0;i < (items.datasetLevels[currentLevel]).items.length;i++) {
        (items.datasetLevels[currentLevel]).items[i].component.visible = (items.datasetLevels[currentLevel]).items[i].visible

        /* Do not reinitialise visibility on screen change (useful for crowns) */
        if ((items.datasetLevels[currentLevel]).items[i].visible == false && levelsBeingInitialised == 1) {
            continue
        }

        if ((items.datasetLevels[currentLevel]).items[i].x) {
            (items.datasetLevels[currentLevel]).items[i].component.x = (items.datasetLevels[currentLevel]).items[i].x
        }

        if ((items.datasetLevels[currentLevel]).items[i].y) {
            (items.datasetLevels[currentLevel]).items[i].component.y = (items.datasetLevels[currentLevel]).items[i].y
        }

        if ((items.datasetLevels[currentLevel]).items[i].width) {
            (items.datasetLevels[currentLevel]).items[i].component.width = (items.datasetLevels[currentLevel]).items[i].width
        }

        if ((items.datasetLevels[currentLevel]).items[i].height) {
            (items.datasetLevels[currentLevel]).items[i].component.height = (items.datasetLevels[currentLevel]).items[i].height
        }
    }

    if ( !items.crown.visible && items.upperGate.visible) {
        items.gateOpenAnimation.start()
    }
}

function resizeElements() {
    /* Do not call the first time when the level is created */
    if (levelsBeingInitialised == -1 ) {
        return
    }
    levelsBeingInitialised = 0
    setUpLevelElements()
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
