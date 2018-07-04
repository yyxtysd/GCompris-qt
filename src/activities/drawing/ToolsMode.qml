/* GCompris - ToolsMode.qml
 *
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
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
import QtQuick 2.6
import QtQuick.Controls 1.5
import GCompris 1.0
import "../../core"
import "drawing.js" as Activity

Item {
    id: toolsMode
    width: parent.width
    height: parent.height

    anchors.centerIn: parent
    property alias modesModel: modes.model
    property alias pencilModes: pencilModes
    property alias geometricModes: geometricModes
    property alias opacitySliderValue: opacitySlider.value

    ListModel {
        id: pencilModes
        ListElement { name: "pencil";
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/pencil.png" }
        ListElement { name: "dot";
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/pattern1.png" }
        ListElement { name: "pattern2";
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/pattern3.png" }
        ListElement { name: "pattern3";
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/pattern3.png" }
        ListElement { name: "spray";
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/spray.png" }
        ListElement { name: "brush3";
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/brush3.png" }
        ListElement { name: "brush4";
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/brush4.png" }
        ListElement { name: "brush5";
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/brush5.png" }
        ListElement { name: "blur";
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/blur.png" }
    }

    ListModel {
        id: geometricModes
        ListElement { name: "rectangle";
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/rectangle.png" }
        ListElement { name: "circle";
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/circle.png" }
        ListElement { name: "lineShift";
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/line_straight.svg" }
        ListElement { name: "line"
            imgSource: "qrc:/gcompris/src/activities/drawing/resource/line_free.png" }
    }

    GridView {
        id: modes
        width: parent.width * 0.50
        height: parent.height * 0.85
        cellWidth: width / 4.2
        cellHeight: height / 3.2
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 40
        model: pencilModes
        delegate: modesComponent
    }

    Component {
        id: modesComponent
        Rectangle {
            width: modes.cellWidth
            height: modes.cellHeight
            color: items.toolSelected == name ? "lightblue" : "transparent"
            radius: 10
            Image {
                source: imgSource
                width: parent.width * 0.80
                height: parent.height * 0.80
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    items.toolSelected = name
                    items.lastToolSelected = name
                    background.hideExpandedTools()
                    console.log("Click on " + name)

                    // make the hover over the canvas false
                    area.hoverEnabled = false

                    // change the selectBrush tool
                    timer.index = 0
                    timer.start()
                    background.reloadSelectedPen()
                    Activity.selectMode(name)
                }
            }
        }
    }

    ToolsSize {
        id: toolsTipSize
        anchors.left: modes.right
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.leftMargin: 30
    }

    GCSlider {
        id: opacitySlider
        width: toolsTipSize.width
        anchors.top: toolsTipSize.bottom
        anchors.horizontalCenter: toolsTipSize.horizontalCenter
        anchors.topMargin: 30
        value: 1.0
        minimumValue: 0.0
        maximumValue: 1.0
        stepSize: 0.1
        onValueChanged: {
            items.globalOpacityValue = value
            items.canvas.getContext('2d').globalAlpha = value
        }
    }

    GCText {
        width: background.width > background.height ? opacitySlider.width / 3 : opacitySlider.width / 2
        anchors.horizontalCenter: opacitySlider.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.top: opacitySlider.bottom
        anchors.topMargin: 10
        fontSize: tinySize
        color: "white"
        text: "Opacity"
    }
}