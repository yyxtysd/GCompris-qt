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
    property var dataset: [
        {
        component: upperGate,
        levels: [
                {
                    visible: false,
                    y: -2,
                    width: background.width / 18,
                    height: background.height * (5 / 12),
                },
                {
                    visible: true,
                    y: -2,
                    width: background.width / 18,
                    height: background.height * (5 / 12),
                },
                {
                    visible: true,
                    y: -2,
                    width: background.width / 18,
                    height: background.height * (5 / 12),
                },
                {
                    visible: true,
                    y: -2,
                    width: background.width / 18,
                    height: background.height * (5 / 12),
                },
                {
                    visible: true,
                    y: -2,
                    width: background.width / 18,
                    height: background.height * (5 / 12),
                },
                {
                    visible: true,
                    y: -2,
                    width: background.width / 18,
                    height: background.height * (5 / 12),
                },
                {
                    visible: true,
                    y: -2,
                    width: background.width / 18,
                    height: background.height * (5 / 12),
                },
                {
                    visible: true,
                    y: -2,
                    width: background.width / 18,
                    height: background.height * (5 / 12),
                },
                {
                    visible: true,
                    y: -2,
                    width: background.width / 18,
                    height: background.height * (5 / 12),
                },
                {
                    visible: true,
                    y: -2,
                    width: background.width / 18,
                    height: background.height * (5 / 12),
                }
            ]
        },
        {
        component: lowerGate,
        levels: [
                {
                    visible: false,
                    y: upperGate.height + 3,
                    width: background.width / 18,
                    height: upperGate.height- subSchemaImage.height / 1.4,
                },
                {
                    visible: true,
                    y: upperGate.height + 3 ,
                    width: background.width / 18,
                    height: upperGate.height- subSchemaImage.height / 1.4,
                },
                {
                    visible: true,
                    y: upperGate.height + 3,
                    width: background.width / 18,
                    height: upperGate.height- subSchemaImage.height / 1.4,
                },
                {
                    visible: true,
                    y: upperGate.height + 3,
                    width: background.width / 18,
                    height: upperGate.height- subSchemaImage.height / 1.4,
                },
                {
                    visible: true,
                    y: upperGate.height + 3,
                    width: background.width / 18,
                    height: upperGate.height- subSchemaImage.height / 1.4,
                },
                {
                    visible: true,
                    y: upperGate.height + 3,
                    width: background.width / 18,
                    height: upperGate.height- subSchemaImage.height / 1.4,
                },
                {
                    visible: true,
                    y: upperGate.height + 3,
                    width: background.width / 18,
                    height: upperGate.height- subSchemaImage.height / 1.4,
                },
                {
                    visible: true,
                    y: upperGate.height + 3,
                    width: background.width / 18,
                    height: upperGate.height- subSchemaImage.height / 1.4,
                },
                {
                    visible: true,
                    y: upperGate.height + 3,
                    width: background.width / 18,
                    height: upperGate.height- subSchemaImage.height / 1.4,
                },
                {
                    visible: true,
                    y: upperGate.height + 3,
                    width: background.width / 18,
                    height: upperGate.height- subSchemaImage.height / 1.4,
                }
            ]
        }
    ]
}
