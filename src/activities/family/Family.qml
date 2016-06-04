/* GCompris - family.qml
 *
 * Copyright (C) 2016 RAJDEEP KAUR <rajdeep.kaur@kde.org>
 *
 * Authors:
 *
 *   RAJDEEP KAUR <rajdeep.kaur@kde.org> (Qt Quick port)
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
import QtQuick 2.1
import GCompris 1.0
import "../../core"
import "family.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source:"qrc:/gcompris/src/activities/lang/resource/imageid-bg.svg"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias nodecreator:nodecreator
            property alias answerschoice: answerschoice
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Item{
            id:partition
            width:background.width
            height:background.height
            Rectangle{
                id:tree
                color: "transparent"
                width: background.width*0.65
                height: background.height
                Item{
                  id:treestructure
                  Repeater{
                      id:nodecreator
                      model:ListModel{}
                      delegate:
                       Tree{
                         id: currentpointer
                         x: xx*tree.width
                         y: yy*tree.height
                         width: ApplicationInfo.ratio*55
                         height: ApplicationInfo.ratio*55
                         recwidth: currentpointer.width
                         recheight: currentpointer.height
                         searchitem: 3
                         nodeimagesource: Activity.url+nodee
                         nodetextvalue: "sad"
                         bordercolor: "black"
                         borderwidth:4
                         colorr: "transparent"
                         radius:recwidth/2

                      }

                  }
               }
            }

            Rectangle {
                id: answers
                color: "transparent"
                width: background.width*0.35
                height: background.height
                anchors.left: tree.right
                border.color:"black"
                border.width:5
                Grid{
                    columns:1
                    rowSpacing:10
                    Repeater{
                        id:answerschoice
                        model:ListModel{}
                        delegate:
                        AnswerButton {
                            id:options
                            width:answers.width*0.80
                            height:answers.width*0.25
                            textLabel:hh
                            onPressed:{
                                if(textLabel === answer){
                                       bonus.good("")
                                } else {
                                       bonus.bad("")
                                }
                            }
                        }
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
