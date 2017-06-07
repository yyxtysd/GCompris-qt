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
import QtQuick.Particles 2.0
import Box2D 2.0
import QtGraphicalEffects 1.0
import GCompris 1.0

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
            property alias crown: crown
            property alias gateOpenAnimation: gateOpenAnimation
            property alias gateCloseAnimation: gateCloseAnimation
            property var submarineCategory: Fixture.Category1
            property var crownCategory: Fixture.Category2
            property var whaleCategory: Fixture.Category3
            property var upperGatefixerCategory: Fixture.Category4
            property var lowerGatefixerCategory: Fixture.Category5
            property var datasetLevels: datasets.levels
            property alias tutorial: tutorial
            property alias upperGate: upperGate
            property alias ship: ship
            property alias physicalWorld: physicalWorld
        }

        Dataset {
            id: datasets
        }

        IntroMessage {
            id: tutorial
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
                tutorial.visible = false
            }
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
            visible: (bar.level > 1) ? true : false
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
                to: upperGate.height *  1 / 3
                duration: 1000
            }

            NumberAnimation {
                id: gateCloseAnimation
                target: upperGate
                properties: "height"
                from: upperGate.height
                to: background.height * (5 / 12)
                duration: 1000
            }
        }

        Rectangle {
            id: lowerGate
            visible: upperGate.visible
            width: background.width / 18
            height: background.height * (5 / 12) - subSchemaImage.height / 1.4
            y: background.height * (5 / 12)
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
            visible: (bar.level) > 2 ? true : false
            source: url + "crown.png"

            x: background.width / 2
            y: background.height - (subSchemaImage.height * 2)
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
            visible: (bar.level > 5) ? true : false
            source: url + "whale.png"

            y: (background.height - subSchemaImage.height)/2
            z: 1
            function hit() {
                whale.source = url + "whale_hit.png"
            }

            property bool movingLeft: true

            transform: Rotation {
                id: rotate;
                origin.x: whale.width / 2;
                origin.y: 0;
                axis { x: 0; y: 1; z: 0 } angle: 0
            }

            SequentialAnimation {
                id: rotateLeftAnimation
                loops: 1
                PropertyAnimation {
                    target: rotate
                    properties: "angle"
                    from: 0
                    to: 180
                    duration: 500
                }
            }

            SequentialAnimation {
                id: rotateRightAnimation
                loops: 1
                PropertyAnimation {
                    target: rotate
                    properties: "angle"
                    from: 180
                    to: 0
                    duration: 500
                }
            }

            onXChanged: {
                if (x <= 0) {
                    rotateLeftAnimation.start()
                    whale.movingLeft = false
                } else if (x >= background.width - whale.width - (upperGate.visible ? upperGate.width : 0)) {
                    rotateRightAnimation.start()
                    whale.movingLeft = true
                }
            }

            Loader {
                id: bubbleEffect
                anchors.fill: parent
                active: ApplicationInfo.hasShader
                sourceComponent: ParticleSystem {
                    anchors.fill: parent
                    Emitter {
                        x: parent.x
                        y: parent.y + parent.height / 2
                        width: 1
                        height: 1
                        emitRate: 0.5
                        lifeSpan: 1000
                        lifeSpanVariation: 2500
                        acceleration: PointDirection {
                            x: -10
                            xVariation: 10
                            y: -20
                            yVariation: 10
                        }
                        velocity: PointDirection {
                            x: 20
                            xVariation: 10
                            y: -20
                            yVariation: 10
                        }
                        size: 12
                        sizeVariation: 8
                    }

                    ImageParticle {
                        source: "qrc:/gcompris/src/activities/clickgame/resource/bubble.png"
                    }
                }
            }

            Body {
                id: whalebody
                target: whale
                bodyType: Body.Dynamic
                sleepingAllowed: true
                fixedRotation: true
                linearDamping: 0
                linearVelocity: Qt.point( (whale.movingLeft ? -1 : 1) , 0)

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

        Image {
            id: ship
            visible: (bar.level > 3) ? true : false
            source: url + "asw_frigate.png"
            y: background.height * 0.05
            z: 1

            property bool movingLeft: true
            property real initialXPosition: background.width - ship.width - (upperGate.visible ? upperGate.width : 0)

            transform: Rotation {
                id: rotateShip;
                origin.x: ship.width / 2;
                origin.y: 0;
                axis { x: 0; y: 1; z: 0 } angle: 0
            }

            SequentialAnimation {
                id: rotateShipLeft
                loops: 1
                PropertyAnimation {
                    target: rotateShip
                    properties: "angle"
                    from: 0
                    to: 180
                    duration: 500
                }
            }

            SequentialAnimation {
                id: rotateShipRight
                loops: 1
                PropertyAnimation {
                    target: rotateShip
                    properties: "angle"
                    from: 180
                    to: 0
                    duration: 500
                }
            }

            onXChanged: {
                if (x <= 0) {
                    rotateShipLeft.start()
                    movingLeft = false
                } else if (x >= background.width - ship.width - (upperGate.visible ? upperGate.width : 0)) {
                    rotateShipRight.start()
                    movingLeft = true
                }
            }

            Body {
                id: shipbody
                target: ship
                bodyType: Body.Dynamic
                sleepingAllowed: true
                fixedRotation: true
                linearDamping: 0
                linearVelocity: Qt.point((ship.movingLeft ? -1 : 1), 0)

                fixtures: Box {
                    id: shipfixer
//                    categories: items.shipCategory
                    collidesWith: items.submarineCategory
                    density: 1
                    friction: 0
                    restitution: 0
                }
            }
        }

        Image {
            id: rock2
            visible: (bar.level > 4) ? true : false
            anchors.bottom: crown.bottom
            anchors.left: crown.right
            source: "qrc:/gcompris/src/activities/mining/resource/stone2.svg"

            Body {
                id: rock2Body
                target: rock2
                bodyType: Body.Static
                sleepingAllowed: true
                linearDamping: 0

                fixtures: Box {
                    id: rock2Fixer
//                    categories: items.rock2Category
                    collidesWith: items.submarineCategory
                    density: 1
                    friction: 0
                    restitution: 0
                }
            }
        }

        Image {
            id: rock1
            visible: (bar.level > 6) ? true : false
            anchors.bottom: crown.bottom
            anchors.right: crown.left
            source: "qrc:/gcompris/src/activities/mining/resource/stone1.svg"

            Body {
                id: rock1Body
                target: rock1
                bodyType: Body.Static
                sleepingAllowed: true
                linearDamping: 0

                fixtures: Box {
                    id: rock1Fixer
//                    categories: items.rock2Category
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
