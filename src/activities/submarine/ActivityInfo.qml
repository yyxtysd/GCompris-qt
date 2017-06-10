/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "submarine/Submarine.qml"
  difficulty: 5
  icon: "submarine/submarine.svg"
  author: "Rudra Nil Basu &lt;rudra.nil.basu.1996@gmail.com&gt;"
  demo: true
  title: qsTr("Pilot a Submarine")
  description: qsTr("Drive the submarine to the end point")
  //intro: "Drive the submarine to the right end of the screen without colliding with any objects"
  goal: qsTr("Learn how to control a submarine")
  prerequisite: qsTr("Move and click using the mouse, physics basics")
  manual: qsTr("Control the various parts of the submarine (the engine, rudders and ballast tanks) to reach the end point")
  credit: ""
  section: "experimental"
  createdInVersion: 8000
}
