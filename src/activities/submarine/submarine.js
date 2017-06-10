/* GCompris - submarine.js
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
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
var processingAnswer

var tutorials = [
            [
                qsTr("Move the submarine to the other side of the screen."),
                qsTr("Increase or decrease the velocity of the submarine using the engine."),
                qsTr("Press the + button to increase the velocity, or the - button to decrease the velocity."),
            ],
            [
                qsTr("The Ballast tanks are used to sink or dive under water."),
                qsTr("If the ballast tanks are empty, the submarine will float. If the ballast tanks are full of water, the submarine will dive underwater."),
                qsTr("Press the ___ button to fill the tanks with water and ___ to empty the tanks."),
            ],
            [
                qsTr("The Rudders are used to rotate the submarine."),
                qsTr("Press the + and the - buttons to rotate the submarine accordingly."),
                qsTr("Grab the crown to open the gate."),
            ]
]

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
    processingAnswer = false

    /* Tutorial Levels, display tutorials */
    if (currentLevel < tutorials.length) {
        items.tutorial.visible = true
        items.tutorial.index = 0
        items.tutorial.intro = tutorials[currentLevel]
    } else {
        items.tutorial.visible = false
        items.physicalWorld.running = true
    }

    setUpLevelElements()
}

function setUpLevelElements() {
    /* Set up initial position and state of the submarine */
    items.submarine.resetSubmarine()
    items.submarine.x = items.submarine.initialPosition.x
    items.submarine.y = items.submarine.initialPosition.y

    if(items.ship.visible) {
        items.ship.reset()
    }

    if ( !items.crown.visible && items.upperGate.visible) {
        items.upperGate.openGate()
    }
}

function closeGate() {
    if (items.upperGate.visible) {
        items.upperGate.closeGate()
    }
}

function finishLevel(win) {
    if (processingAnswer)
        return
    if (win) {
        processingAnswer = true
        items.submarine.velocity = Qt.point(0,0)
        items.bonus.good("flower")
    } else {
        processingAnswer = true
        items.submarine.velocity = Qt.point(0,0)
        items.submarine.destroySubmarine()
        items.bonus.bad("flower")
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
    closeGate()

    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
