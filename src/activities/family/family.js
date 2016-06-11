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
                    {  edgelist:[
                                   [0.41,0.25,0.64,0.25],
                                   [0.53,0.25,0.53,0.50]
                                ],
                       nodePositions:[
                               [0.211,0.20],
                               [0.633,0.20],
                               [0.4,0.50]
                       ],
                       rationn:[80,80,80]
                    },

                    {  edgelist:[
                                  [0.41,0.25,0.64,0.25],
                                  [0.53,0.25,0.53,0.50]
                                ],
                      nodePositions:[
                                  [0.211,0.20],
                                  [0.633,0.20],
                                  [0.4,0.50]
                      ],
                      rationn:[80,80,80]
                    },

                    {  edgelist:[ [0.41,0.25,0.64,0.25],
                                  [0.53,0.25,0.44,0.50],
                                  [0.53,0.25,0.63,0.50]
                                ],
                       nodePositions:[
                                [0.211,0.20],
                                [0.633,0.20],
                                [0.33,0.50],
                                [0.55,0.50]
                       ],
                       rationn:[80,80,80]

                    },
                    {  edgelist:[ [0.41,0.25,0.64,0.25],
                                  [0.53,0.26,0.33,0.50],
                                  [0.53,0.25,0.53,0.50],
                                  [0.53,0.25,0.70,0.52]
                              ],
                      nodePositions:[
                                 [0.211,0.20],
                                 [0.633,0.20],
                                 [0.22,0.50],
                                 [0.43,0.50],
                                 [0.65,0.50]
                            ],
                      rationn:[80,80,80]

                     },

                     {  edgelist:[[0.41,0.25,0.64,0.25],
                                 [0.53,0.20,0.44,0.33],
                                 [0.53,0.25,0.59,0.33]],
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
                    },
                    /*
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
                 currentstate:["active","deactive","activeto"],
                 answer:["Father"],
                 optionss:[qsTr("Father"),qsTr("Grandfather"),qsTr("Uncle")]

              },
              {  nodeleave:["man3.svg","lady2.svg","boy1.svg"],
                 currentstate:["deactive","active","activeto",],
                 answer:[qsTr("Mother")],
                 optionss:[qsTr("Mother"),qsTr("GrandMother"),qsTr("Aunty")]

              },
              {  nodeleave:["man3.svg","lady2.svg","boy1.svg","boy2.svg"],
                 currentstate:["deactive","deactive","active","activeto"],
                 answer:[qsTr("Brother")],
                 optionss:[qsTr("Cousin"),qsTr("Brother"),qsTr("Sister")]
              },
              {  nodeleave:["man3.svg","lady2.svg","boy1.svg","girl1.svg","boy2.svg"],
                 currentstate:["deactive","deactive","active","activeto","deactive"],
                 answer:[qsTr("Sister")],
                 optionss:[qsTr("Cousion"),qsTr("Brother"),qsTr("Sister")]
              }

]

var numberOfLevel = 4;

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
    var test = treestructure[currentLevel]
    var test1 = dataset[currentLevel]
    items.nodecreator.model.clear();
    items.answerschoice.model.clear();
    items.edgecreator.model.clear();
    for(var i = 0 ; i < test.nodePositions.length; i++){
        items.nodecreator.model.append({
                       "xx": test.nodePositions[i][0],
                       "yy": test.nodePositions[i][1],
                       "nodee": test1.nodeleave[i],
                       "rationn": test.rationn[i],
                       "currentstate":test1.currentstate[i]
                     });
    }

    for(var j = 0;j <3; j++){
       items.answerschoice.model.append({
               "optionn": test1.optionss[j],
               "answer":test1.answer[0]
       });
    }

    for(var k =0 ; k < test.edgelist.length ; k++){
        items.edgecreator.model.append({
             "x1": test.edgelist[k][0],
             "y1": test.edgelist[k][1],
             "x22": test.edgelist[k][2],
             "y22": test.edgelist[k][3]

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
