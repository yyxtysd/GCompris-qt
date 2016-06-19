/* GCompris - family.js
 *
 * Copyright (C) 2016 RAJDEEP KAUR <rajdeep.kaur@kde.org>
 *
 * Authors:
 *   "RAJDEEP KAUR" <rajdeep.kaur@kde.org>
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
//.import "engine.js" as Engine

var currentLevel = 0
var items
var url = "qrc:/gcompris/src/activities/family/resource/"
var treestructure = [
                    {  edgelist: [
                                   [0.41, 0.25, 0.64, 0.25],
                                   [0.53, 0.25, 0.53, 0.50]
                                ],
                       nodePositions: [
                               [0.211, 0.20],
                               [0.633, 0.20],
                               [0.40, 0.50]
                       ],
                       rationn: [80, 80, 80],
                       captions: [ [0.28, 0.60],
                                  [0.101, 0.25]
                                ],
                       nodeleave: ["man3.svg", "lady2.svg", "boy1.svg"],
                       currentstate: ["active", "deactive", "activeto"],
                       answer: [qsTr("Father")],
                       optionss: [qsTr("Father"), qsTr("Grandfather"), qsTr("Uncle")]

                    },

                    {  edgelist: [
                                  [0.41, 0.25, 0.64, 0.25],
                                  [0.53, 0.25, 0.53, 0.50]
                                ],
                      nodePositions: [
                                  [0.211, 0.20],
                                  [0.633, 0.20],
                                  [0.4, 0.50]
                      ],
                      rationn: [80, 80, 80],
                      captions: [  [0.28, 0.60],
                                  [0.8283, 0.24]
                               ],
                      nodeleave: ["man3.svg", "lady2.svg", "boy1.svg"],
                      currentstate: ["deactive", "active", "activeto"],
                      answer: [qsTr("Mother")],
                      optionss: [qsTr("Mother"), qsTr("GrandMother"), qsTr("Aunty")]

                    },

                    {  edgelist: [ [0.41, 0.25, 0.64, 0.25],
                                  [0.53, 0.257, 0.44, 0.50],
                                  [0.53, 0.257, 0.63, 0.50]
                                ],
                       nodePositions: [
                                [0.211, 0.20],
                                [0.633, 0.20],
                                [0.33, 0.50],
                                [0.55, 0.50]
                       ],
                       rationn: [80, 80, 80],
                       captions:[ [0.22, 0.605],
                                   [0.760, 0.605]
                                ],
                       nodeleave: ["man3.svg", "lady2.svg", "boy1.svg", "boy2.svg"],
                       currentstate: ["deactive", "deactive", "active", "activeto"],
                       answer: [qsTr("Brother")],
                       optionss: [qsTr("Cousin"), qsTr("Brother"), qsTr("Sister")]

                    },
                    {  edgelist: [ [0.41, 0.25, 0.64, 0.25],
                                  [0.53, 0.26, 0.33, 0.50],
                                  [0.53, 0.25, 0.53, 0.50],
                                  [0.53, 0.25, 0.70, 0.52]
                              ],
                      nodePositions: [
                                 [0.211, 0.20],
                                 [0.633, 0.20],
                                 [0.22, 0.50],
                                 [0.43, 0.50],
                                 [0.65, 0.50]
                            ],
                      rationn: [80, 80, 80],
                      captions: [ [0.281,0.77],
                                  [0.50,0.75]
                                ],
                      nodeleave: ["man3.svg", "lady2.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
                      currentstate: ["deactive", "deactive", "active", "activeto", "deactive"],
                      answer: [qsTr("Sister")],
                      optionss: [qsTr("Cousin"), qsTr("Brother"), qsTr("Sister")]

                   },
                   {  edgelist: [ [0.491, 0.17, 0.54, 0.17],
                                 [0.525, 0.17, 0.525, 0.45],
                                 [0.44, 0.45, 0.60, 0.45],
                                 [0.525, 0.45, 0.525, 0.65],
                                 [0.33, 0.65, 0.70, 0.65],
                                 [0.33, 0.65, 0.33, 0.70],
                                 [0.525, 0.65, 0.525, 0.70],
                                 [0.70, 0.65, 0.70, 0.725]
                               ],
                      nodePositions: [
                                 [0.311, 0.10],
                                 [0.533, 0.10],
                                 [0.251, 0.40],
                                 [0.588, 0.40],
                                 [0.22, 0.70],
                                 [0.43, 0.70],
                                 [0.65, 0.70]
                              ],
                      rationn: [80, 80, 80],
                      captions: [  [0.118,0.76],
                                   [0.22,0.17],
                                ],
                      nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "girl1.svg", "boy1.svg", "boy2.svg"],
                      currentstate: ["active", "deactive", "deactive", "deactive", "activeto", "deactive", "deactive"],
                      answer: [qsTr("Grand Father")],
                      optionss: [qsTr("Grand Daughter"), qsTr("Grand Son"), qsTr("Grand Father"), qsTr("Grand Mother")]
                     },
                     {  edgelist: [ [0.50, 0.17, 0.54, 0.17],
                                   [0.525, 0.17, 0.525, 0.45],
                                   [0.44, 0.45, 0.60, 0.45],
                                   [0.525, 0.45, 0.525, 0.65],
                                   [0.33, 0.65, 0.70, 0.65],
                                   [0.33, 0.65, 0.33, 0.70],
                                   [0.525, 0.65, 0.525, 0.70],
                                   [0.70, 0.65, 0.70, 0.725]
                            ],
                      nodePositions: [
                                   [0.311, 0.10],
                                   [0.533, 0.10],
                                   [0.251, 0.40],
                                   [0.588, 0.40],
                                   [0.22, 0.70],
                                   [0.43, 0.70],
                                   [0.65, 0.70],
                           ],
                      rationn: [80, 80, 80],
                      captions: [   [0.85,0.76],
                                    [0.743,0.16]
                                ],
                      nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
                      currentstate: ["deactive", "active", "deactive", "deactive", "deactive", "deactive", "activeto", "active"],
                      answer: [qsTr("Grand Mother")],
                      optionss: [qsTr("Grand Daughter"), qsTr("Grand Son"), qsTr("Grand Father"), qsTr("Grand Mother")],
                   },
                   {  edgelist: [ [0.50, 0.17, 0.54, 0.17],
                               [0.525, 0.17, 0.525, 0.45],
                               [0.44, 0.45, 0.60, 0.45],
                               [0.525, 0.45, 0.525, 0.65],
                               [0.33, 0.65, 0.70, 0.65],
                               [0.33, 0.65, 0.33, 0.70],
                               [0.525, 0.65, 0.525, 0.70],
                               [0.70, 0.65, 0.70, 0.725]
                          ],
                       nodePositions: [
                               [0.311, 0.10],
                               [0.533, 0.10],
                               [0.251, 0.40],
                               [0.588, 0.40],
                               [0.22, 0.70],
                               [0.43, 0.70],
                               [0.65, 0.70]
                         ],
                      rationn: [80, 80, 80],
                      captions: [  [0.22,0.17],
                                   [0.85,0.76]
                                ],
                      nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "boy2.svg","girl1.svg" ],
                      currentstate: ["activeto", "deactive", "deactive", "deactive", "deactive", "deactive", "active"],
                      answer: [qsTr("Grand Daughter")],
                      optionss: [qsTr("Grand Daughter"), qsTr("Grand Son"), qsTr("Grand Father"), qsTr("Grand Mother")]
                },
                {  edgelist: [ [0.50, 0.17, 0.54, 0.17],
                              [0.525, 0.17, 0.525, 0.45],
                              [0.44, 0.45, 0.60, 0.45],
                              [0.525, 0.45, 0.525, 0.65],
                              [0.33, 0.65, 0.70, 0.65],
                              [0.33, 0.65, 0.33, 0.70],
                              [0.525, 0.65, 0.525, 0.70],
                              [0.70, 0.65, 0.70, 0.725]
                   ],
                   nodePositions: [
                              [0.311, 0.10],
                              [0.533, 0.10],
                              [0.251, 0.40],
                              [0.588, 0.40],
                              [0.22, 0.70],
                              [0.43, 0.70],
                              [0.65, 0.70]
                  ],
                  rationn: [80, 80, 80],
                  captions: [ [0.743,0.16],
                              [0.85,0.76]
                            ],
                  nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
                  currentstate: ["deactive", "activeto", "deactive", "deactive", "deactive", "deactive", "active", "activeto"],
                  answer: [qsTr("Grand Son")],
                  optionss: [qsTr("Grand Daughter"), qsTr("Grand Son"), qsTr("Grand Father"), qsTr("Grand Mother")]
               },
               {  edgelist: [  [0.50, 0.17, 0.53, 0.17],
                              [0.525, 0.17, 0.525, 0.45],
                              [0.44, 0.45, 0.60, 0.45],
                              [0.22, 0.45, 0.254, 0.45],
                              [0.22, 0.45, 0.22, 0.72],
                              [0.22, 0.71, 0.25, 0.71]
                           ],
                  nodePositions: [
                              [0.311, 0.10],
                              [0.251, 0.40],
                              [0.588, 0.40],
                              [0.22, 0.70]

                  ],
                  rationn: [80, 80, 80],
                  captions: [   [0.118,0.76],
                                [0.83,0.45]
                            ],
                  nodeleave: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg"],
                  currentstate: ["deactive", "deactive", "active", "activeto"],
                  answer: [qsTr("Uncle")],
                  optionss: [qsTr("Uncle"), qsTr("Aunty"), qsTr("Nephew"), qsTr("Niece")]


               },
               {  edgelist: [  [0.50, 0.17, 0.53, 0.17],
                              [0.525, 0.17, 0.525, 0.45],
                              [0.44, 0.45, 0.60, 0.45],
                              [0.22, 0.45, 0.254, 0.45],
                              [0.22, 0.45, 0.22, 0.72],
                              [0.22, 0.71, 0.25, 0.71]
                        ],
                 nodePositions: [
                              [0.311, 0.10],
                              [0.251, 0.40],
                              [0.588, 0.40],
                              [0.22, 0.70]

                       ],
                 rationn: [80, 80, 80],
                 captions: [  [0.83,0.45],
                              [0.118,0.76],
                           ],
                 nodeleave: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg"],
                 currentstate: ["deactive", "deactive", "activeto", "active"],
                 answer: [qsTr("Nephew")],
                 optionss: [qsTr("Uncle"), qsTr("Aunty"), qsTr("Nephew"), qsTr("Niece")]

            },
            {  edgelist: [  [0.50, 0.17, 0.53, 0.17],
                           [0.525, 0.17, 0.525, 0.45],
                           [0.44, 0.45, 0.60, 0.45],
                           [0.22, 0.45, 0.254, 0.45],
                           [0.22, 0.45, 0.22, 0.72],
                           [0.22, 0.71, 0.25, 0.71]
                     ],
              nodePositions: [
                           [0.311, 0.10],
                           [0.533, 0.10],
                           [0.251, 0.40],
                           [0.588, 0.40],
                           [0.22, 0.70]

                    ],
              rationn: [80, 80, 80],
              captions: [  [0.118,0.76],
                           [0.83,0.45],
                        ],
              nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady1.svg", "babyboy.svg"],
              currentstate: ["deactive", "deactive", "deactive", "active", "activeto"],
              answer: [qsTr("Aunty")],
              optionss: [qsTr("Uncle"), qsTr("Aunty"), qsTr("Nephew"), qsTr("Niece")]

         },
         {  edgelist: [  [0.50, 0.17, 0.53, 0.17],
                           [0.525, 0.17, 0.525, 0.45],
                           [0.44, 0.45, 0.60, 0.45],
                           [0.22, 0.45, 0.254, 0.45],
                           [0.22, 0.45, 0.22, 0.72],
                           [0.22, 0.71, 0.25, 0.71]
              ],
            nodePositions: [
                           [0.311, 0.10],
                           [0.533, 0.10],
                           [0.251, 0.40],
                           [0.588, 0.40],
                           [0.22, 0.70]
               ],
              rationn: [80, 80, 80],
              captions: [  [0.83,0.45],
                           [0.118,0.76]
                        ],
              nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady1.svg", "babyboy.svg"],
              currentstate: ["deactive", "deactive", "deactive", "activeto", "active"],
              answer: [qsTr("Niece")],
              optionss: [qsTr("Uncle"), qsTr("Aunty"), qsTr("Nephew"), qsTr("Niece")]

         },
         {  edgelist: [     [0.65, 0.16, 0.745, 0.16],
                           [0.70, 0.16, 0.70, 0.70],
                           [0.70, 0.50, 0.58, 0.50],
                           [0.40, 0.52, 0.34, 0.52],
                           [0.69, 0.695, 0.75, 0.695]
            ],
            nodePositions: [
                          [0.463, 0.10],
                          [0.733, 0.10],
                          [0.400, 0.45],
                          [0.150, 0.45],
                          [0.733, 0.67]
            ],
            rationn: [80, 80, 80],
            captions: [   [0.02,0.51],
                          [0.32,0.16]
                      ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "man1.svg"],
            currentstate: ["active", "deactive", "deactive", "activeto", "deactive"],
            answer: [qsTr("Father-in-law")],
            optionss: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
         },
         {  edgelist: [     [0.65, 0.16, 0.745, 0.16],
                              [0.70, 0.16, 0.70, 0.70],
                              [0.70, 0.50, 0.58, 0.50],
                              [0.40, 0.52, 0.34, 0.52],
                              [0.69, 0.695, 0.75, 0.695]
               ],
            nodePositions: [
                           [0.463, 0.10],
                           [0.733, 0.10],
                           [0.400, 0.45],
                           [0.150, 0.45],
                           [0.733, 0.67]
              ],
             rationn: [80, 80, 80],
             captions: [  [0.02,0.51],
                          [0.80,0.365],
                       ],
             nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "man1.svg"],
             currentstate: ["deactive", "active", "deactive", "activeto", "deactive"],
             answer: [qsTr("Mother-in-law")],
             optionss: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
          },
          {  edgelist: [     [0.65, 0.16, 0.745, 0.16],
                            [0.70, 0.16, 0.70, 0.70],
                            [0.70, 0.50, 0.58, 0.50],
                            [0.40, 0.52, 0.34, 0.52],
                            [0.69, 0.695, 0.75, 0.695]
                  ],
             nodePositions: [
                            [0.463, 0.10],
                            [0.733, 0.10],
                            [0.400, 0.45],
                            [0.150, 0.45],
                            [0.733, 0.67]
                 ],
            rationn: [80, 80, 80],
            captions: [ [0.02,0.51],
                        [0.78,0.5340]
                      ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "man1.svg"],
            currentstate: ["deactive", "deactive", "deactive", "activeto", "active"],
            answer: [qsTr("Brother-in-law")],
            optionss: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
          },
          {  edgelist: [     [0.54, 0.16, 0.61, 0.16],
                            [0.58, 0.16, 0.58, 0.70],
                            [0.58, 0.50, 0.475, 0.50],
                            [0.310, 0.52, 0.235, 0.52],
                            [0.57, 0.695, 0.63, 0.695],
                            [0.615, 0.75, 0.50, 0.75]
                    ],
            nodePositions: [
                            [0.343, 0.10],
                            [0.603, 0.10],
                            [0.300, 0.45],
                            [0.040, 0.45],
                            [0.603, 0.67],
                            [0.30, 0.70]
                    ],
            rationn: [80, 80, 80],
            captions: [ [0.10,0.34],
                        [0.20,0.76]
                      ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "man1.svg", "lady1.svg"],
            currentstate: ["dective", "deactive", "deactive", "active", "deactive", "activeto"],
            answer: [qsTr("Sister-in-law")],
            optionss: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
          },
          {  edgelist: [     [0.65, 0.16, 0.745, 0.16],
                            [0.70, 0.16, 0.70, 0.70],
                            [0.70, 0.50, 0.58, 0.50],
                            [0.40, 0.52, 0.34, 0.52],
                            [0.69, 0.695, 0.75, 0.695]
                    ],
            nodePositions: [
                            [0.463, 0.10],
                            [0.733, 0.10],
                            [0.400, 0.45],
                            [0.150, 0.45],
                            [0.733, 0.67]
                   ],
             rationn: [80, 80, 80],
             captions: [ [0.32,0.15],
                         [0.05,0.50]
                       ],
             nodeleave: ["grandfather.svg", "old-lady.svg", "lady2.svg", "man3.svg", "man1.svg"],
             currentstate: ["active", "deactive", "deactive", "activeto", "deactive", "deactive"],
             answer: [qsTr("Son-in-law")],
             optionss: [qsTr("Son-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
            }
]

var numberOfLevel = treestructure.length;
var answerbuttonheight = 0 ;

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    var levelTree = treestructure[currentLevel]
    answerbuttonheight =  1/(levelTree.optionss.length+4);
    items.nodecreator.model.clear();
    items.answerschoice.model.clear();
    items.edgecreator.model.clear();
    for(var i = 0 ; i < levelTree.nodePositions.length ; i++) {
        items.nodecreator.model.append({
                       "xx": levelTree.nodePositions[i][0],
                       "yy": levelTree.nodePositions[i][1],
                       "nodee": levelTree.nodeleave[i],
                       "rationn": levelTree.rationn[i],
                       "currentstate": levelTree.currentstate[i]
                     });
    }

    for(var j = 0 ; j <levelTree.optionss.length ; j++) {
       items.answerschoice.model.append({
               "optionn": levelTree.optionss[j],
               "answer": levelTree.answer[0]
       });
    }

    for(var k =0 ; k < levelTree.edgelist.length ; k++) {
        items.edgecreator.model.append({
             "x1": levelTree.edgelist[k][0],
             "y1": levelTree.edgelist[k][1],
             "x22": levelTree.edgelist[k][2],
             "y22": levelTree.edgelist[k][3]

        });
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
