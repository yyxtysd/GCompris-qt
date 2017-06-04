/* GCompris
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
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

QtObject {
    property var levels: [
        {
            intro: [
                qsTr("Move the submarine to the other side of the screen"),
                qsTr("Increase or decrease the velocity of the submarine using the engine"),
                qsTr("Press the + button to increase the velocity, or the - button to decrease the velocity"),],
            items: [
                {component: upperGate, visible: false},
                {component: lowerGate, visible: upperGate.visible, y: upperGate.height + 3,height: upperGate.height- subSchemaImage.height / 1.4},
                {component: crown, visible: false},
                {component: whale, visible: false}
            ]
        },
        {
            intro: [
                qsTr("The Ballast tanks are used to sink or dive under water"),
                qsTr("If the ballast tanks are empty, the submarine will sink. If the ballast tanks are full of water, the submarine will dive underwater"),
                qsTr("Press the ___ button "),],
            items: [
                {component: upperGate, visible: true, height: background.height * (5 / 12)},
                {component: lowerGate, visible: upperGate.visible, y: upperGate.height + 3,height: upperGate.height- subSchemaImage.height / 1.4},
                {component: crown, visible: false},
                {component: whale, visible: false}
            ]
        },
        {
            intro: [
                qsTr("The Rudders are used to rotate the submarine"),
                qsTr("Press the + and the - buttons to rotate the submarine accordingly"),
            ],
            items: [
                {component: upperGate, visible: true, height: background.height * (5 / 12)},
                {component: lowerGate, visible: upperGate.visible, y: upperGate.height + 3,height: upperGate.height- subSchemaImage.height / 1.4},
                {component: crown, visible: true},
                {component: whale, visible: false}
            ]
        },
        {
            items: [
                {component: upperGate, visible: true, height: background.height * (5 / 12)},
                {component: lowerGate, visible: upperGate.visible, y: upperGate.height + 3,height: upperGate.height- subSchemaImage.height / 1.4},
                {component: crown, visible: true},
                {component: whale, visible: false}
            ]
        },
        {
            items: [
                {component: upperGate, visible: true, height: background.height * (5 / 12)},
                {component: lowerGate, visible: upperGate.visible, y: upperGate.height + 3,height: upperGate.height- subSchemaImage.height / 1.4},
                {component: crown, visible: true},
                {component: whale, visible: false}
            ]
        },
        {
            items: [
                {component: upperGate, visible: true, height: background.height * (5 / 12)},
                {component: lowerGate, visible: upperGate.visible, y: upperGate.height + 3,height: upperGate.height- subSchemaImage.height / 1.4},
                {component: crown, visible: true},
                {component: whale, visible: true, y: (background.height - subSchemaImage.height)/2}
            ]
        },
        {
            items: [
                {component: upperGate, visible: true, height: background.height * (5 / 12)},
                {component: lowerGate, visible: upperGate.visible, y: upperGate.height + 3,height: upperGate.height- subSchemaImage.height / 1.4},
                {component: crown, visible: true},
                {component: whale, visible: true, y: (background.height - subSchemaImage.height)/2}
            ]
        },
        {
            items: [
                {component: upperGate, visible: true, height: background.height * (5 / 12)},
                {component: lowerGate, visible: upperGate.visible, y: upperGate.height + 3,height: upperGate.height- subSchemaImage.height / 1.4},
                {component: crown, visible: true},
                {component: whale, visible: true, y: (background.height - subSchemaImage.height)/2}
            ]
        },
        {
            items: [
                {component: upperGate, visible: true, height: background.height * (5 / 12)},
                {component: lowerGate, visible: upperGate.visible, y: upperGate.height + 3,height: upperGate.height- subSchemaImage.height / 1.4},
                {component: crown, visible: true},
                {component: whale, visible: true, y: (background.height - subSchemaImage.height)/2}
            ]
        },
        {
            items: [
                {component: upperGate, visible: true, height: background.height * (5 / 12)},
                {component: lowerGate, visible: upperGate.visible, y: upperGate.height + 3,height: upperGate.height- subSchemaImage.height / 1.4},
                {component: crown, visible: true},
                {component: whale, visible: true, y: (background.height - subSchemaImage.height)/2}
            ]
        }
    ]
}
