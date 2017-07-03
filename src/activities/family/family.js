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
var answerButtonRatio = 0;

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = items.dataset.levelElements.length
    barAtStart = GCompris.ApplicationSettings.isBarHidden;
    GCompris.ApplicationSettings.isBarHidden = true;
    initLevel()
}

function stop() {
    GCompris.ApplicationSettings.isBarHidden = barAtStart;
}

function initLevel() {
    items.bar.level = currentLevel + 1
    var levelTree = items.dataset.levelElements[currentLevel]
    answerButtonRatio = 1/(levelTree.optionss.length+4);
    items.nodeCreator.model.clear();
    items.answersChoice.model.clear();
    items.edgeCreator.model.clear();
    items.wringcreator.model.clear();
    for(var i = 0 ; i < levelTree.nodePositions.length ; i++) {
        items.nodeCreator.model.append({
                       "xx": levelTree.nodePositions[i][0],
                       "yy": levelTree.nodePositions[i][1],
                       "nodee": levelTree.nodeleave[i],
                       "currentstate": levelTree.currentstate[i]
                     });
    }

    for(var j = 0 ; j <levelTree.optionss.length ; j++) {
       items.answersChoice.model.append({
               "optionn": levelTree.optionss[j],
               "answer": levelTree.answer[0]
       });
    }

    for(var k = 0 ; k < levelTree.edgeList.length ; k++) {
        items.edgeCreator.model.append({
             "x1": levelTree.edgeList[k][0],
             "y1": levelTree.edgeList[k][1],
             "x22": levelTree.edgeList[k][2],
             "y22": levelTree.edgeList[k][3],
             "edgeState": levelTree.edgeState[k]

        });
    }

    for(var l = 0 ; l < levelTree.edgeState.length ; l++) {
        if(levelTree.edgeState[l] === "married") {
            var xcor = (levelTree.edgeList[l][0]+levelTree.edgeList[l][2]-0.04)/2;
            var ycor =  levelTree.edgeList[l][3] -0.02
            items.wringcreator.model.append({
                "ringx": xcor,
                "ringy": ycor
            });
        }
    }
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
