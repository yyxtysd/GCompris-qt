/* GCompris - family.js
 *
 * Copyright (C) 2016 RAJDEEP KAUR <rajdeep.kaur@kde.org>
 *
 * Authors:
 *   RAJDEEP KAUR <rajdeep.kaur@kde.org>
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
var items;
var barAtStart;
var url = "qrc:/gcompris/src/activities/family/resource/"

var numberOfLevel
var shuffledLevelIndex = []
var levelToLoad
var answerButtonRatio = 0;

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = items.dataset.levelElements.length
    barAtStart = GCompris.ApplicationSettings.isBarHidden;
    GCompris.ApplicationSettings.isBarHidden = true;

    shuffle()

    initLevel()
}

function stop() {
    GCompris.ApplicationSettings.isBarHidden = barAtStart;
}

function initLevel() {
    items.bar.level = currentLevel + 1

    levelToLoad = getCurrentLevelIndex()

    loadDatasets()
}

function loadDatasets() {
    if (!items) {
        return
    }

    var levelTree = items.dataset.levelElements[levelToLoad]
    answerButtonRatio = 1 / (levelTree.options.length + 4);

    items.nodeRepeater.model.clear();
    items.answersChoice.model.clear();
    items.edgeRepeater.model.clear();
    items.wringcreator.model.clear();

    for(var i = 0 ; i < levelTree.nodePositions.length ; i++) {
        items.nodeRepeater.model.append({
                       "xPosition": levelTree.nodePositions[i][0],
                       "yPosition": levelTree.nodePositions[i][1],
                       "nodeValue": levelTree.nodeleave[i],
                       "currentState": items.mode == "normal" ? levelTree.currentState[i] : "deactive",
                       "nodeWeight": levelTree.nodeWeights[i]
                     });
    }

    for(var i = 0 ; i <levelTree.options.length ; i++) {
       items.answersChoice.model.append({
               "optionn": levelTree.options[i],
               "answer": levelTree.answer[0]
       });
    }

    for(var i = 0 ; i < levelTree.edgeList.length ; i++) {
        items.edgeRepeater.model.append({
             "x1": levelTree.edgeList[i][0],
             "y1": levelTree.edgeList[i][1],
             "x22": levelTree.edgeList[i][2],
             "y22": levelTree.edgeList[i][3],
             "edgeState": levelTree.edgeState[i]

        });
    }

    for(var i = 0 ; i < levelTree.edgeState.length ; i++) {
        if(levelTree.edgeState[i] === "married") {
            var xcor = (levelTree.edgeList[i][0]+levelTree.edgeList[i][2]-0.04)/2;
            var ycor =  levelTree.edgeList[i][3] -0.02
            items.wringcreator.model.append({
                "ringx": xcor,
                "ringy": ycor
            });
        }
    }

    items.questionTopic = levelTree.answer[0]
}

function shuffle() {
    if (items.mode == "normal") {
        // not required for normal mode
        return
    }

    for (var i = 0;i < numberOfLevel;i++) {
        shuffledLevelIndex[i] = i
    }

    var currentIndex = shuffledLevelIndex.length, tmp, randomIndex

    while (currentIndex != 0) {
        randomIndex = Math.floor(Math.random() * currentIndex)
        currentIndex -= 1

        tmp = shuffledLevelIndex[currentIndex]
        shuffledLevelIndex[currentIndex] = shuffledLevelIndex[randomIndex]
        shuffledLevelIndex[randomIndex] = tmp
    }
}

function getCurrentLevelIndex() {
    if (!items) {
        return
    }

    return items.mode == "normal" ? currentLevel : shuffledLevelIndex[currentLevel]
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
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
