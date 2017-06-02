/* GCompris - submarine.qml
 *
 * Copyright (C) 2017 RUDRA NIL BASU <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin (bruno.coudoin@gcompris.net) (GTK+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
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
import Box2D 2.0
import QtGraphicalEffects 1.0

import "../../core"
import "submarine.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string url: "qrc:/gcompris/src/activities/submarine/resource/"

    pageComponent: Image {
        id: background
        source: url + "background.svg"
        anchors.fill: parent

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
            property var tutorials: [engineTutorial, ballastTutorial, ruddersTutorial]
            property var submarineCategory: Fixture.Category1
            property var crownCategory: Fixture.Category2
            property var whaleCategory: Fixture.Category3
            property var upperGatefixerCategory: Fixture.Category4
            property var lowerGatefixerCategory: Fixture.Category5
            property var dataset: datasets.dataset
        }

        Dataset {
            id: datasets
        }

        IntroMessage {
            id: engineTutorial
            visible: false
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            z: 100
            onIntroDone: {
                physicalWorld.running = true
                engineTutorial.visible = false
            }
            intro: [
                qsTr("Move the submarine to the other side of the screen"),
                qsTr("Increase of decrease the velocity of the submarine using the engine"),
                qsTr("Press the + button to increase the velocity, or the - button to decrease the velocity"),
            ]
        }

        IntroMessage {
            id: ballastTutorial
            visible: false
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            z: 100
            onIntroDone: {
                physicalWorld.running = true
                ballastTutorial.visible = false
            }
            intro: [
                qsTr("The Ballast tanks are used to sink or dive under water"),
                qsTr("If the ballast tanks are empty, the submarine will sink. If the ballast tanks are full of water, the submarine will dive underwater"),
                qsTr("Press the ___ button "),
            ]
        }

        IntroMessage {
            id: ruddersTutorial
            visible: false
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            z: 100
            onIntroDone: {
                physicalWorld.running = true
                ruddersTutorial.visible = false
            }
            intro: [
                qsTr("The Rudders are used to rotate the submarine"),
                qsTr("Press the + and the - buttons to rotate the submarine accordingly"),
            ]
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        World {
            id: physicalWorld
            running: false
            gravity: Qt.point(0,0)
            autoClearForces: false
        }

        Item {
            id: submarine

            Image {
                id: submarineImage
                source: url + "submarine.png"
                width: background.width / 9
                height: background.height / 9

                function broken() {
                    source = url + "submarine-broken.png"
                }

                function reset() {
                    source = url + "submarine.png"
                }
            }

            Body {
                id: submarineBody
                target: submarine
                bodyType: Body.Dynamic
                fixedRotation: true
                linearDamping: 0
                fixtures: Box {
                    id: submarineFixer
                    categories: items.submarineCategory
                    collidesWith: items.crowCategory | items.whaleCategory
                    density: 1
                    friction: 0
                    restitution: 0
                }
            }
        }

        Rectangle {
            id: upperGate
            width: background.width / 18
            height: background.height * (5 / 12)
            y: -2
            color: "#848484"
            border.color: "black"
            border.width: 3
            anchors.right: background.right

            Body {
                id: upperGateBody
                target: upperGate
                bodyType: Body.Static
                sleepingAllowed: true
                fixedRotation: true
                linearDamping: 0

                fixtures: Box {
                    id: upperGatefixer
                    categories: items.upperGatefixerCategory
                    collidesWith: items.submarineCategory
                    density: 1
                    friction: 0
                    restitution: 0
                }
            }

            NumberAnimation {
                id: gateOpenAnimation
                target: upperGate
                properties: "height"
                from: upperGate.height
                to: upperGate.height / 2
                duration: 1000
            }
        }

        Rectangle {
            id: lowerGate
            width: background.width / 18
            height: upperGate.height- subSchemaImage.height / 1.4
            y: upperGate.height + 3
            color: "#848484"
            border.color: "black"
            border.width: 3
            anchors.right:background.right

            Body {
                id: lowerGateBody
                target: lowerGate
                bodyType: Body.Static
                sleepingAllowed: true
                fixedRotation: true
                linearDamping: 0

                fixtures: Box {
                    id: lowerGatefixer
                    categories: items.lowerGatefixerCategory
                    collidesWith: items.submarineCategory
                    density: 1
                    friction: 0
                    restitution: 0
                }
            }
        }

        Item {
            id: subSchemaItems

            Image {
                id: subSchemaImage
                source: url + "sub_schema.svg"
                width: background.width/1.3
                height: background.height/4
                x: background.width/9
                y: background.height/1.5
            }
        }

        Image {
            id: crown
            source: url + "crown.png"
            z: 1
            Body {
                id: crownbody
                target: crown
                bodyType: Body.Static
                sleepingAllowed: true
                fixedRotation: true
                linearDamping: 0

                fixtures: Box {
                    id: crownfixer
                    categories: items.crownCategory
                    collidesWith: items.submarineCategory
                    density: 1
                    friction: 0
                    restitution: 0
                }
            }
        }

        Image {
            id: whale
            source: url + "whale.png"
            z: 1
            function hit() {
                whale.source = url + "whale_hit.png"
            }

            Body {
                id: whalebody
                target: whale
                bodyType: Body.Static
                sleepingAllowed: true
                fixedRotation: true
                linearDamping: 0

                fixtures: Box {
                    id: whalefixer
                    categories: items.whaleCategory
                    collidesWith: items.submarineCategory
                    density: 1
                    friction: 0
                    restitution: 0
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
