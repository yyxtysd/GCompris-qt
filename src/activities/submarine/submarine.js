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
    if (currentLevel < 3) {
        for (var i = 0;i < 3;i++) {
            if (currentLevel == i) {
                items.tutorials[i].visible = true
                items.tutorials[i].index = 0
            } else {
                items.tutorials[i].visible = false
            }
        }
    }
    setUpLevelElements()
}

function setUpLevelElements() {
    for (var i = 0;i < items.dataset.length;i++) {
        items.dataset[i].component.visible = items.dataset[i].levels[currentLevel].visible;

        if (items.dataset[i].component.visible == false) {
            /*
             * If this component is not required in this current level,
             * Do not apply the other changes
             */
            continue;
        }

        // Apply the component values, if it is defined in the dataset
        if (items.dataset[i].levels[currentLevel].x) {
            items.dataset[i].component.x = items.dataset[i].levels[currentLevel].x
        }

        if (items.dataset[i].levels[currentLevel].y) {
            items.dataset[i].component.y = items.dataset[i].levels[currentLevel].y
        }

        if (items.dataset[i].levels[currentLevel].width) {
            items.dataset[i].component.width = items.dataset[i].levels[currentLevel].width
        }

        if (items.dataset[i].levels[currentLevel].height) {
            items.dataset[i].component.height = items.dataset[i].levels[currentLevel].height
        }
    }
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
