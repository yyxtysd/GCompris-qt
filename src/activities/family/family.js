/* GCompris - family.js
 *
 * Copyright (C) 2016 RAJDEEP KAUR <rajdeep.kaur@kde.org>
 *
 * Authors:
 *   "RAJDEEP KAUR" <rajdeep.kaur@kde.org> (Qt Quick port)
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
var items
var url = "qrc:/gcompris/src/activities/family/resource/"
var treestructure = [
                    {  edgelist:[],
                       nodePositions:[
                               [0.211,0.20],
                               [0.633,0.20],
                               [0.4,0.50]
                       ],
                       rationn:[80,80,80]
                    },
                    {  edgelist:[],
                       nodePositions:[
                                    [0.180,0.09],
                                    [0.55,0.09],
                                    [0.08,0.35],
                                    [0.30,0.35],
                                    [0.50,0.35],
                                    [0.70,0.35],
                                    [0.01,0.65],
                                    [.21,0.65],
                                    [.41,0.65],
                                    [.61,0.65],
                                    [.81,0.65]
                       ]
                    },/*
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodePositions:[]
                    },
                    {  edgelist:[],
                       nodepositions:[]
                    }*/
]

var dataset = [
              {  nodeleave:["man3.svg","lady2.svg","boy1.svg"],
                 answer:["Father"],
                 optionss:["Father","Grandafather","Uncle"]

              },
              {  nodeleave:["man3.svg","lady2.svg","boy1.svg","boy2.svg","girl3.svg"],
                 answer:["Father"],
                 optionss:["Father","Brother","Grandfather","uncle"]
              },
              {  nodeleave:["grandpa.svg","old-lady.svg","man1.svg","lady2.svg","man2.svg","lady1.svg",
                   "boy1.svg","boy2.svg","girl2.svg","girl3.svg","girl4.svg"],
                 answer:["Father"],
                 optionss:["M"]
              }

]

var numberOfLevel = 2; 

var mode = "image";

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    var test = treestructure[0]
    var test1 = dataset[0]
    items.nodecreator.model.clear();
    for(var i =0;i<3;i++){
        items.nodecreator.model.append({
                       "xx":test.nodePositions[i][0],
                       "yy":test.nodePositions[i][1],
                       "nodee":test1.nodeleave[i],
                       "rationn":test.rationn[i]
                     });
    }

    for(var j = 0;j <3; j++){
       items.answerschoice.model.append({
               "optionn":test1.optionss[j]
       });
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
