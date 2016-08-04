/* GCompris - DigitalElectricity.qml
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
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
import "digital_electricity.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ffffb3"
        signal start
        signal stop

        property bool vert: background.width > background.height

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias backgroundContainer: backgroundContainer
            property alias bar: bar
            property alias bonus: bonus
            property alias availablePieces: availablePieces
            property alias toolTip: toolTip
            property alias infoTxt: infoTxt
            property alias infoImage: infoImage
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Rectangle {
            id: backgroundContainer

            color: "#ffffb3"
            x: background.vert ? 90 * ApplicationInfo.ratio : 0
            y: background.vert ? 0 : 90 * ApplicationInfo.ratio
            width: background.vert ?
                       background.width - 90 * ApplicationInfo.ratio : background.width
            height: background.vert ?
                       background.height - (bar.height * 1.1) :
                       background.height - (bar.height * 1.1) - 90 * ApplicationInfo.ratio
            //onHeightChanged: Activity.updateAllWires()
            //onWidthChanged: Activity.updateAllWires()
            MouseArea {
                anchors.fill: parent
                onClicked: Activity.deselect()
            }

            GCText {
                id: infoTxt
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: infoTxtContainer.top
                    topMargin: 2
                }
                fontSizeMode: Text.Fit
                minimumPixelSize: 10
                color: "white"
                style: Text.Outline
                styleColor: "black"
                horizontalAlignment: Text.AlignHLeft
                width: Math.min(implicitWidth, 0.90 * parent.width) //background.vert ? Math.min(implicitWidth, 0.95 * parent.width) :
                       //Math.min(implicitWidth, 0.85 * parent.width)
                height: infoImage.source == "" ? Math.min(implicitHeight, 0.9 * parent.height) :
                        Math.min(implicitHeight, 0.4 * parent.height)
                wrapMode: TextEdit.WordWrap
                visible: false
                z: 4
            }

            Rectangle {
                id: infoTxtContainer
                anchors.centerIn: parent
                width: infoTxt.width + 20
                height: infoTxt.height + infoImage.height + 8
                opacity: 0.8
                radius: 10
                border.width: 2
                border.color: "black"
                visible: infoTxt.visible
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#000" }
                    GradientStop { position: 0.9; color: "#666" }
                    GradientStop { position: 1.0; color: "#AAA" }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: infoTxt.visible = false
                }
                z: 3
            }

            Image {
                id: infoImage
                property int heightNeed: parent.height - infoTxt.height
                height: source == "" ? 0 : parent.height - infoTxt.height - 10
                width: source == "" ? 0 : parent.width - 10
                fillMode: Image.PreserveAspectFit
                visible: infoTxt.visible
                anchors {
                    top: infoTxt.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                z: 5
            }

        }

        Rectangle {
            id: leftWidget
            width: background.vert ?
                       90 * ApplicationInfo.ratio :
                       background.width
            height: background.vert ?
                        background.height :
                        90 * ApplicationInfo.ratio
            color: "#FFFF42"
            border.color: "#FFD85F"
            border.width: 4
            anchors.left: parent.left
            ListWidget {
                id: availablePieces
                vert: background.vert ? true : false
            }
        }

        Rectangle {
            id: toolTip
            anchors {
                bottom: bar.top
                bottomMargin: 10
                left: leftWidget.left
                leftMargin: 5
            }
            width: toolTipTxt.width + 10
            height: toolTipTxt.height + 5
            opacity: 1
            radius: 10
            z: 100
            border.width: 2
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
            property alias text: toolTipTxt.text
            Behavior on opacity { NumberAnimation { duration: 120 } }

            function show(newText) {
                if(newText) {
                    text = newText
                    opacity = 0.8
                } else {
                    opacity = 0
                }
            }

            GCText {
                id: toolTipTxt
                anchors.centerIn: parent
                fontSize: regularSize
                color: "white"
                style: Text.Outline
                styleColor: "black"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: TextEdit.WordWrap
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | reload}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.reset()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
