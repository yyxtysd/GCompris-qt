/* GCompris - Data.qml
 *
 * Copyright (C) 2018 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
import GCompris 1.0

Data {
    objective: qsTr("Numbers between 1 and 8")
    difficulty: 1
    data: [
    {
        "minNumber": 1,
        "maxNumber": 1, /* Max number on each domino side */
        "numberOfFish": 3
    },
    {
        "minNumber": 1,
        "maxNumber": 2,
        "numberOfFish": 4
    },
    {
        "minNumber": 1,
        "maxNumber": 3,
        "numberOfFish": 5
    },
    {
        "minNumber": 1,
        "maxNumber": 4,
        "numberOfFish": 5
    }
    ]
}
