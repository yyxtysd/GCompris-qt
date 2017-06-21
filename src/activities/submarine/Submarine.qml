/* GCompris - submarine.qml
 *
 * Copyright (C) 2017 RUDRA NIL BASU <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
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

        /* Testing purposes, A / Left Key => Reduces velocity, D / Right Key => Increases velocity */
        Keys.onPressed: {
            if ((event.key == Qt.Key_D || event.key == Qt.Key_Right) && submarine.velocity.x < submarine.maximumXVelocity) {
                submarine.increaseHorizontalVelocity(1)
            }
            if ((event.key == Qt.Key_A || event.key == Qt.Key_Left) && submarine.velocity.x > 0) {
                submarine.decreaseHorizontalVelocity(1)
            }
            if ((event.key == Qt.Key_W || event.key == Qt.Key_Up)) {
                centralBallastTank.fillBallastTanks()
            }
            if ((event.key == Qt.Key_S || event.key == Qt.Key_Down)) {
                centralBallastTank.flushBallastTanks()
            }
            if ((event.key == Qt.Key_X)) {
                submarine.increaseWingsAngle(1)
            }
            if ((event.key == Qt.Key_Z)) {
                submarine.decreaseWingsAngle(1)
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias crown: crown
            property alias whale: whale
            property var submarineCategory: Fixture.Category1
            property var crownCategory: Fixture.Category2
            property var whaleCategory: Fixture.Category3
            property var upperGatefixerCategory: Fixture.Category4
            property var lowerGatefixerCategory: Fixture.Category5
            property var shipCategory: Fixture.Category6
            property var rockCategory: Fixture.Category7
            property alias submarine: submarine
            property alias tutorial: tutorial
            property alias upperGate: upperGate
            property alias ship: ship
            property alias physicalWorld: physicalWorld
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
                physicalWorld.turnOn()
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

            function turnOff() {
                physicalWorld.running = false
            }

            function turnOn() {
                physicalWorld.running = true
            }

            function status() {
                return physicalWorld.running
            }
        }

        Item {
            id: submarine

            z: 1

            property point initialPosition: Qt.point(0,0)
            property bool isHit: false
            property int terminalVelocityIndex: 100
            property int resetVerticalSpeed: 500

            /* Maximum depth the submarine can dive when ballast tank is full */
            property real maximumDepthOnFullTanks: (background.height * 0.6) / 2

            /* Engine properties */
            property point velocity
            property int maximumXVelocity: 5

            /* Wings property */
            property int wingsAngle
            property int initialWingsAngle: 0
            property int maxWingsAngle: 2
            property int minWingsAngle: -2

            function destroySubmarine() {
                isHit = true
                submarineImage.broken()
            }

            function resetSubmarine() {
                isHit = false
                submarineImage.reset()

                leftBallastTank.resetBallastTanks()
                rightBallastTank.resetBallastTanks()
                centralBallastTank.resetBallastTanks()

                x = initialPosition.x
                y = initialPosition.y

                velocity = Qt.point(0,0)
                wingsAngle = initialWingsAngle
            }

            function increaseHorizontalVelocity(amt) {
                submarine.velocity.x += amt
            }

            function decreaseHorizontalVelocity(amt) {
                submarine.velocity.x -= amt
            }

            function increaseWingsAngle(amt) {
                if (wingsAngle + amt <= maxWingsAngle) {
                    wingsAngle += amt
                } else {
                    wingsAngle = maxWingsAngle
                }
                console.log("Wings angle is: "+wingsAngle)
            }

            function decreaseWingsAngle(amt) {
                if (wingsAngle - amt >= minWingsAngle) {
                    wingsAngle -= amt
                } else {
                    wingsAngle = minWingsAngle
                }
                console.log("Wings angle is: "+wingsAngle)
            }

            function changeVerticalVelocity() {
                /*
                 * Movement due to planes
                 * Movement is affected only when the submarine is moving forward
                 * When the submarine is on the surface, the planes cannot be used
                 */
                if (submarineImage.y > 0) {
                    submarine.velocity.y = (submarine.velocity.x) > 0 ? wingsAngle : 0
                } else {
                    submarine.velocity.y = 0
                }
                /* Movement due to Ballast tanks */
                if (wingsAngle == 0 || submarine.velocity.x == 0) {
                    var yPosition = submarineImage.currentWaterLevel / submarineImage.totalWaterLevel * submarine.maximumDepthOnFullTanks

                    speed.duration = submarine.terminalVelocityIndex * Math.abs(submarineImage.y - yPosition) // terminal velocity
                    submarineImage.y = yPosition
                    /*
                    if (submarineImage.y > yPosition) {
                        // move up
                        submarine.velocity.y = -0.5
                    } else if (submarineImage.y < yPosition) {
                        // move down
                        submarine.velocity.y = 0.5
                    } else {
                        // do not move
                        submarine.velocity.y = 0
                    }
                    */
                }
            }

            BallastTank {
                id: leftBallastTank

                initialWaterLevel: 0
                maxWaterLevel: 500
            }

            BallastTank {
                id: rightBallastTank

                initialWaterLevel: 0
                maxWaterLevel: 500
            }

            BallastTank {
                id: centralBallastTank

                initialWaterLevel: 0
                maxWaterLevel: 500
            }

            Image {
                id: submarineImage
                source: url + "submarine.png"

                property int currentWaterLevel: bar.level < 7 ? centralBallastTank.waterLevel : leftBallastTank.waterLevel + centralBallastTank.waterLevel + rightBallastTank.waterLevel
                property int totalWaterLevel: bar.level < 7 ? centralBallastTank.maxWaterLevel : leftBallastTank.maxWaterLevel + centralBallastTank.maxWaterLevel + rightBallastTank.maxWaterLevel

                width: background.width / 9
                height: background.height / 9

                function broken() {
                    source = url + "submarine-broken.png"
                }

                function reset() {
                    source = url + "submarine.png"
                    speed.duration = submarine.resetVerticalSpeed
                    x = submarine.initialPosition.x
                    y = submarine.initialPosition.y
                }

                Behavior on y {
                    NumberAnimation {
                        id: speed
                        duration: 500
                    }
                }

                onXChanged: {
                    if (submarineImage.x >= background.width) {
                        Activity.finishLevel(true)
                    }
                }
            }

            Body {
                id: submarineBody
                target: submarineImage
                bodyType: Body.Dynamic
                fixedRotation: true
                linearDamping: 0
                linearVelocity: submarine.isHit ? Qt.point(0,0) : submarine.velocity

                fixtures: Box {
                    id: submarineFixer
                    width: submarineImage.width
                    height: submarineImage.height
                    categories: items.submarineCategory
                    collidesWith: Fixture.All
                    density: 1
                    friction: 0
                    restitution: 0
                    onBeginContact: {
                        var collidedObject = other.getBody().target

                        if (collidedObject == whale) {
                            whale.hit()
                        }
                        if (collidedObject == crown) {
                            crown.captureCrown()
                        } else {
                            Activity.finishLevel(false)
                        }
                    }
                }
            }
            Timer {
                id: updateVerticalVelocity
                interval: 50
                running: true
                repeat: true

                onTriggered: submarine.changeVerticalVelocity()
            }
        }

        Rectangle {
            id: upperGate
            visible: (bar.level > 1) ? true : false
            width: background.width / 18
            height: background.height * (5 / 12)
            y: -2
            z: 1
            color: "#848484"
            border.color: "black"
            border.width: 3
            anchors.right: background.right

            property bool isGateOpen: false

            function openGate() {
                if (!isGateOpen) {
                    isGateOpen = true
                    gateOpenAnimation.start()
                }
            }

            function closeGate() {
                if (isGateOpen) {
                    isGateOpen = false
                    gateCloseAnimation.start()
                }
            }

            Body {
                id: upperGateBody
                target: upperGate
                bodyType: Body.Static
                sleepingAllowed: true
                fixedRotation: true
                linearDamping: 0

                fixtures: Box {
                    id: upperGatefixer
                    width: upperGate.width
                    height: upperGate.height
                    categories: items.upperGatefixerCategory
                    collidesWith: upperGate.visible ? items.submarineCategory : Fixture.None
                    density: 1
                    friction: 0
                    restitution: 0
                }
            }

            NumberAnimation {
                id: gateOpenAnimation
                target: upperGate
                properties: "height"
                from: background.height * (5 / 12)
                to: background.height * (5 / 36)
                duration: 1000
            }

            NumberAnimation {
                id: gateCloseAnimation
                target: upperGate
                properties: "height"
                from: background.height * (5 / 36)
                to: background.height * (5 / 12)
                duration: 1000
            }
        }

        Rectangle {
            id: lowerGate
            z: 1
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
                    width: lowerGate.width
                    height: lowerGate.height
                    categories: items.lowerGatefixerCategory
                    collidesWith: lowerGate.visible ? items.submarineCategory : Fixture.None
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

            property point originalPosition: Qt.point(background.width / 2, background.height - (subSchemaImage.height * 2))

            function captureCrown() {
                upperGate.openGate()
                crown.visible = false
            }

            function reset() {
                crown.x = originalPosition.x
                crown.y = originalPosition.y
                crownbody.linearVelocity = Qt.point(0,0)
                crown.visible = (bar.level) > 2 ? true : false
                upperGate.closeGate()
            }

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
                    width: crown.width
                    height: crown.height
                    sensor: true
                    categories: items.crownCategory
                    collidesWith: crown.visible ? items.submarineCategory : Fixture.None
                    density: 0.1
                    friction: 0
                    restitution: 0
                }
            }
        }

        Whale {
            id: whale
            visible: (bar.level > 5) ? true : false

            y: (background.height - subSchemaImage.height)/2
            z: 1

            leftLimit: 0
            rightLimit: background.width - whale.width - (upperGate.visible ? upperGate.width : 0)
        }

        Image {
            id: ship
            visible: (bar.level > 3) ? true : false
            source: url + "asw_frigate.png"
            x: initialXPosition
            y: background.height * 0.05
            z: 1

            property bool movingLeft: true
            property bool collided: false
            property real initialXPosition: background.width - ship.width - (upperGate.visible ? upperGate.width : 0)
            property real horizontalSpeed: 1

            function reset() {
                ship.collided = false
                ship.x = initialXPosition
            }

            function collide() {
                /* Add few visual effects */
                collided = true
            }

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
                linearVelocity: Qt.point( (ship.collided ? 0 : ((ship.movingLeft ? -1 : 1) * ship.horizontalSpeed)), 0)

                fixtures: Box {
                    id: shipfixer
                    width: ship.width
                    height: ship.height
                    categories: items.shipCategory
                    collidesWith: ship.visible ? items.submarineCategory : Fixture.None
                    density: 1
                    friction: 0
                    restitution: 0

                    onBeginContact: ship.collide()
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
                    categories: items.rockCategory
                    collidesWith: rock2.visible ? items.submarineCategory : Fixture.None
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
                    categories: items.rockCategory
                    collidesWith: rock1.visible ? items.submarineCategory : Fixture.None
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
            onLoose: Activity.initLevel()
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
        DebugDraw {
            id: debugDraw
            world: physicalWorld
            anchors.fill: parent
            opacity: 0.75
            visible: false
        }

        MouseArea {
            id: debugMouseArea
            anchors.fill: parent
            onPressed: debugDraw.visible = !debugDraw.visible
        }
    }

}
