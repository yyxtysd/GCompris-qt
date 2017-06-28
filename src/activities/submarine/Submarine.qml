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

        onWidthChanged: updateOnWidthReset.start()

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        /* Testing purposes, A / Left Key => Reduces velocity, D / Right Key => Increases velocity */
        Keys.onPressed: {
            if ((event.key == Qt.Key_D || event.key == Qt.Key_Right)) {
                submarine.increaseHorizontalVelocity(1)
            }
            if ((event.key == Qt.Key_A || event.key == Qt.Key_Left)) {
                submarine.decreaseHorizontalVelocity(1)
            }
            if ((event.key == Qt.Key_W || event.key == Qt.Key_Up)) {
                centralBallastTank.fillBallastTanks()
            }
            if ((event.key == Qt.Key_S || event.key == Qt.Key_Down)) {
                centralBallastTank.flushBallastTanks()
            }
            if ((event.key == Qt.Key_Plus)) {
                submarine.increaseWingsAngle(1)
            }
            if ((event.key == Qt.Key_Minus)) {
                submarine.decreaseWingsAngle(1)
            }

            if ((event.key == Qt.Key_R)) {
                leftBallastTank.fillBallastTanks()
            }
            if ((event.key == Qt.Key_F)) {
                leftBallastTank.flushBallastTanks()
            }

            if ((event.key == Qt.Key_T)) {
                rightBallastTank.fillBallastTanks()
            }
            if ((event.key == Qt.Key_G)) {
                rightBallastTank.flushBallastTanks()
            }
            if (event.key == Qt.Key_Plus) {
                console.log("plplpl")
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
            property var maxDepthCategory: Fixture.Category8
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
            id: waterLevel
            x: 0
            y: background.height / 15
        }

        Rectangle {
            id: maximumWaterDepth

            width: background.width
            height: 10
            color: "transparent"

            y: background.height * 0.65

            Body {
                id: maxDepthBody
                target: maximumWaterDepth
                bodyType: Body.Static
                sleepingAllowed: true
                linearDamping: 0

                fixtures: Box {
                    categories: items.maxDepthCategory
                    collidesWith: items.submarineCategory
                    width: maximumWaterDepth.width
                    height: maximumWaterDepth.height
                    density: 1
                    friction: 0
                    restitution: 0
                }
            }
        }

        Item {
            id: submarine

            z: 1

            property point initialPosition: Qt.point(0,0)
            property bool isHit: false
            property int terminalVelocityIndex: 75
            property int maxAbsoluteRotationAngle: 30

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
                if (submarine.velocity.x + amt <= submarine.maximumXVelocity) {
                    submarine.velocity.x += amt
                }
            }

            function decreaseHorizontalVelocity(amt) {
                if (submarine.velocity.x - amt >= 0) {
                    submarine.velocity.x -= amt
                }
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
                if (submarineImage.y == 0 || wingsAngle == 0 || submarine.velocity.x == 0) {
                    var yPosition = submarineImage.currentWaterLevel / submarineImage.totalWaterLevel * submarine.maximumDepthOnFullTanks
                    submarineImage.y = yPosition

                    if (bar.level >= 7) {
                        var finalAngle = ((leftBallastTank.waterLevel - rightBallastTank.waterLevel) / leftBallastTank.maxWaterLevel) * submarine.maxAbsoluteRotationAngle
                        submarineRotation.angle = finalAngle
                    }
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

                property int currentWaterLevel: bar.level < 7 ? centralBallastTank.waterLevel : leftBallastTank.waterLevel + rightBallastTank.waterLevel
                property int totalWaterLevel: bar.level < 7 ? centralBallastTank.maxWaterLevel : leftBallastTank.maxWaterLevel + rightBallastTank.maxWaterLevel

                width: background.width / 9
                height: background.height / 9

                function broken() {
                    source = url + "submarine-broken.png"
                }

                function reset() {
                    source = url + "submarine.png"
                    verticalMovementAnimation.enabled = false
                    x = submarine.initialPosition.x
                    y = submarine.initialPosition.y
                    verticalMovementAnimation.enabled = true
                }

                Behavior on y {
                    id: verticalMovementAnimation
                    SmoothedAnimation {
                        id: speed
                        velocity: 10
                        reversingMode: SmoothedAnimation.Immediate
                    }
                }

                onXChanged: {
                    if (submarineImage.x >= background.width) {
                        Activity.finishLevel(true)
                    }
                }

                transform: Rotation {
                    id: submarineRotation;
                    origin.x: submarineImage.width / 2;
                    origin.y: 0;
                    angle: 0;
                }

                Loader {
                    anchors.fill: parent
                    active: ApplicationInfo.hasShader && submarine.velocity.x > 0 && submarineImage.y > 0 && !submarine.isHit
                    sourceComponent: ParticleSystem {
                        anchors.fill: parent
                        Emitter {
                            x: parent.x
                            y: parent.y + parent.height / 1.75
                            width: 1
                            height: 1
                            emitRate: 0.8
                            lifeSpan: 800
                            lifeSpanVariation: 2500
                            acceleration: PointDirection {
                                x: -20
                                xVariation: 5
                                y: 0
                                yVariation: 0
                            }
                            velocity: PointDirection {
                                x: -20
                                xVariation: 10
                                y: 0
                                yVariation: 0
                            }
                            size: 12
                            sizeVariation: 8
                        }

                        ImageParticle {
                            source: "qrc:/gcompris/src/activities/clickgame/resource/bubble.png"
                        }
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

                fixtures: [
                    Box {
                        id: submarineFixer
                        y: submarineImage.height * 0.25
                        width: submarineImage.width
                        height: submarineImage.height * 0.75
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
                    },
                    Box {
                        id: submarine_periscope_Fixer
                        x: submarineImage.width * 0.55
                        width: submarineImage.width / 15
                        height: submarineImage.height * 0.25
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
                ]
            }

            Timer {
                id: updateVerticalVelocity
                interval: 50
                running: true
                repeat: true

                onTriggered: submarine.changeVerticalVelocity()
            }
        }

        Image {
            id: sparkle
            source: "qrc:/gcompris/src/activities/mining/resource/sparkle.svg"

            x: crown.x
            y: crown.y
            z: 1

            width: crown.width
            height: width * 0.7

            property bool isCaptured: false

            scale: isCaptured ? 1 : 0

            function createSparkle() {
                isCaptured = true

                removeSparkleTimer.start()
            }

            function removeSparkle() {
                isCaptured = false
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 100
                }
            }

            Timer {
                id: removeSparkleTimer
                interval: 3000
                repeat: false
                running: false

                onTriggered: sparkle.removeSparkle()
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

            width: submarineImage.width * 0.85
            height: width * 0.55

            visible: (bar.level) > 2 ? true : false
            source: url + "crown.png"

            function captureCrown() {
                upperGate.openGate()
                sparkle.createSparkle()
                crown.visible = false
            }

            function reset() {
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

            y: rock2.y - (rock2.height * 1.15)
            z: 1

            leftLimit: 0
            rightLimit: background.width - whale.width - (upperGate.visible ? upperGate.width : 0)
        }

        Image {
            id: ship

            width: background.width / 9
            height: width * 0.3

            visible: (bar.level > 3) ? true : false
            source: url + "asw_frigate.png"
            x: initialXPosition
            z: 1

            anchors.bottom: waterLevel.top

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
            width: background.width / 6
            height: width * 0.48

            visible: (bar.level > 4) ? true : false
            anchors.bottom: crown.bottom
            anchors.left: crown.right
            source: "qrc:/gcompris/src/activities/mining/resource/stone2.svg"

            transform: Rotation {
                origin.x: rock2.width / 2;
                origin.y: rock2.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 180
            }

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
                    x: rock2.width / 8
                    y: rock2.height / 12
                    width: rock2.width / 1.2
                    height: rock2.height / 1.5
                    density: 1
                    friction: 0
                    restitution: 0
                }
            }
        }

        Image {
            id: rock1
            width: rock2.width
            height: width * 0.46
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

                fixtures: [
                    Circle {
                        id: rock1Fixer
                        categories: items.rockCategory
                        collidesWith: rock1.visible ? items.submarineCategory : Fixture.None
                        x: rock1.width / 10
                        radius: rock1.width / 4
                        density: 1
                        friction: 0
                        restitution: 0
                    },Circle {
                        id: rock1Fixer_1
                        categories: items.rockCategory
                        collidesWith: rock1.visible ? items.submarineCategory : Fixture.None
                        x: rock1.width / 1.6
                        y: rock1.height / 4
                        radius: rock1.width / 6
                        density: 1
                        friction: 0
                        restitution: 0
                    }
                ]
            }
        }

        Timer {
            id: updateOnWidthReset
            repeat: false
            interval: 100
            running: false
            onTriggered: {
                whale.reset()
                ship.reset()
            }
        }

        Controls {
            id: controls
            enginePositon.x: background.width * 0.2
            enginePositon.y: background.height - bar.height - (engineHeight * 1.25)
            engineWidth: background.width / 8
            engineHeight: 100
            submarineHorizontalSpeed: submarine.velocity.x * 1000

            leftTankVisible: bar.level >= 7 ? true : false
            leftBallastTankPosition.x: background.width * 0.4
            leftBallastTankPosition.y: background.height - bar.height - (engineHeight * 1.25)
            leftBallastTankWidth: background.width / 8
            leftBallastTankHeight: 100

            centralTankVisible:  bar.level < 7 ? true : false
            centralBallastTankPosition.x: background.width * 0.5
            centralBallastTankPosition.y: background.height - bar.height - (engineHeight * 1.25)
            centralBallastTankWidth: background.width / 8
            centralBallastTankHeight: 100

            rightTankVisible:  bar.level >= 7 ? true : false
            rightBallastTankPosition.x: background.width * 0.6
            rightBallastTankPosition.y: background.height - bar.height - (engineHeight * 1.25)
            rightBallastTankWidth: background.width / 8
            rightBallastTankHeight: 100

            divingPlaneVisible: bar.level >= 3 ? true : false
            divingPlanePosition.x: background.width * 0.8
            divingPlanePosition.y: background.height - bar.height - engineHeight
            divingPlaneWidth: background.width / 8
            divingPlaneHeight: divingPlaneWidth * 0.2
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
        /*
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
        */
    }

}
