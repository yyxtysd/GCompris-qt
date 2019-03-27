/* GCompris - GCSlider.qml
 *
 * Copyright (C) 2018 Alexis Breton <alexis95150@gmail.com>
 * Copyright (C) 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Alexis Breton <alexis95150@gmail.com>
 *   Holger Kaelberer <holger.k@elberer.de>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import QtQuick.Controls 2.0
import GCompris 1.0

/**
  * A Slider component with GCompris' style.
  * @ingroup components
  *
  * @inherit QtQuick.Controls.Slider
  */
Slider {
    id: control

    focusPolicy: Qt.NoFocus
    snapMode: Slider.SnapAlways
    stepSize: 1

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 2 * radius
        implicitHeight: 2 * radius
        radius: 13
        color: control.pressed ? "#f0f0f0" : "#f6f6f6"
        border.color: "#bdbebf"
    }

	background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
		radius: height / 2
        width: control.availableWidth
        height: implicitHeight
        implicitWidth: 250 * ApplicationInfo.ratio
        implicitHeight: 8 * ApplicationInfo.ratio
        anchors.verticalCenter: parent.verticalCenter
        border.width: 1
        border.color: "#888"
        gradient: Gradient {
            GradientStop { color: "#bbb" ; position: 0 }
            GradientStop { color: "#ccc" ; position: 0.6 }
            GradientStop { color: "#ccc" ; position: 1 }
        }

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            border.color: Qt.darker("#f8d600", 1.2)
            radius: height/2
            gradient: Gradient {
                GradientStop { color: "#ffe85c"; position: 0 }
                GradientStop { color: "#f8d600"; position: 1.4 }
            }
        }
    }
}
