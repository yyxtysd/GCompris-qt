/* GCompris - Controls.qml
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

import "../../core"

Item {
    id: controls

    /* Engine Controller Properties */
    property point enginePositon
    property int engineWidth
    property int engineHeight
    property int submarineHorizontalSpeed

    /* Ballast tanks Controller Properties */
    property bool leftTankVisible
    property point leftBallastTankPosition
    property int leftBallastTankWidth
    property int leftBallastTankHeight

    property bool centralTankVisible
    property point centralBallastTankPosition
    property int centralBallastTankWidth
    property int centralBallastTankHeight

    property bool rightTankVisible
    property point rightBallastTankPosition
    property int rightBallastTankWidth
    property int rightBallastTankHeight

    /* Diving Plane Controller properties */
    property bool divingPlaneVisible
    property point divingPlanePosition
    property int divingPlaneWidth
    property int divingPlaneHeight

    function reset() {
        leftBallastFill.resetVanne()
        centralBallastFill.resetVanne()
        rightBallastFill.resetVanne()

        leftBallastFlush.resetVanne()
        centralBallastFlush.resetVanne()
        rightBallastFlush.resetVanne()
    }

    Rectangle {
        id: controlBackground
        width: background.width
        height: background.height * 0.35

        color: "grey"

        y: background.height - height
    }

    Item {
        Rectangle {
            id: engine

            x: enginePositon.x
            y: enginePositon.y

            width: engineWidth
            height: engineHeight

            radius: 10

            color: "black"

            GCText {
                id: engineValues
                text: submarineHorizontalSpeed
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                color: "green"
            }
        }
        Image {
            id: incSpeed
            source: url + "up.png"

            x: engine.x - width * 1.5
            y: engine.y - engine.height * 0.1

            MouseArea {
                anchors.fill: parent

                onClicked: submarine.increaseHorizontalVelocity(1)
            }
        }

        Image {
            id: downSpeed
            source: url + "down.png"

            x: engine.x - width * 1.5
            y: engine.y + engine.height * 0.9

            MouseArea {
                anchors.fill: parent

                onClicked: submarine.decreaseHorizontalVelocity(1)
            }
        }
    }

    // 3 Ballast Tanks

    Item {
        id: leftBallastTankController
        visible: leftTankVisible
        Rectangle {
            id: leftBallastTankDisplay
            x: leftBallastTankPosition.x
            y: leftBallastTankPosition.y
            width: leftBallastTankWidth
            height: leftBallastTankHeight

            radius: 10

            color: "black"

            Rectangle {
                width: leftBallastTankWidth * 0.9
                height: (leftBallastTank.waterLevel / leftBallastTank.maxWaterLevel) * leftBallastTankHeight
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }

                color: "green"

                Behavior on height {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }
        }

        Image {
            id: leftBallastFill
            source: url + "vanne.svg"

            x: leftBallastTankDisplay.x - width * 1.5
            y: leftBallastTankDisplay.y - leftBallastTankDisplay.height * 0.1

            transform: Rotation {
                id: rotateLeftTank;
                origin.x: leftBallastFill.width / 2;
                origin.y: leftBallastFill.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 0
            }

            function pushVanne() {
                if (rotateLeftTank.angle == 0) {
                    rotateLeftTank.angle = 90
                } else {
                    rotateLeftTank.angle = 0
                }

                leftBallastTank.fillBallastTanks()
            }

            function resetVanne() {
                rotateLeftTank.angle = 0
            }

            MouseArea {
                anchors.fill: parent

                onClicked: leftBallastFill.pushVanne()
            }
        }

        Image {
            id: leftBallastFlush
            source: url + "vanne.svg"

            x: leftBallastTankDisplay.x - width * 1.5
            y: leftBallastTankDisplay.y + leftBallastTankDisplay.height * 0.9

            transform: Rotation {
                id: rotateLeftTankFlush;
                origin.x: leftBallastFill.width / 2;
                origin.y: leftBallastFill.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 0
            }

            function pushVanne() {
                if (rotateLeftTankFlush.angle == 0) {
                    rotateLeftTankFlush.angle = 90
                } else {
                    rotateLeftTankFlush.angle = 0
                }

                leftBallastTank.flushBallastTanks()
            }

            function resetVanne() {
                rotateLeftTank.angle = 0
            }

            MouseArea {
                anchors.fill: parent

                onClicked: leftBallastFlush.pushVanne()
            }
        }
    }


    Item {
        id: centralBallastTankController
        visible: centralTankVisible
        Rectangle {
            id: centralBallastTankDisplay
            x: centralBallastTankPosition.x
            y: centralBallastTankPosition.y
            width: centralBallastTankWidth
            height: centralBallastTankHeight

            radius: 10

            color: "black"

            Rectangle {
                width: centralBallastTankWidth * 0.9
                height: (centralBallastTank.waterLevel / centralBallastTank.maxWaterLevel) * centralBallastTankHeight
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }

                color: "green"

                Behavior on height {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }
        }
        Image {
            id: centralBallastFill
            source: url + "vanne.svg"

            x: centralBallastTankDisplay.x - width * 1.5
            y: centralBallastTankDisplay.y - centralBallastTankDisplay.height * 0.1

            transform: Rotation {
                id: rotateCentralTank;
                origin.x: centralBallastFill.width / 2;
                origin.y: centralBallastFill.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 0
            }

            function pushVanne() {
                if (rotateCentralTank.angle == 0) {
                    rotateCentralTank.angle = 90
                } else {
                    rotateCentralTank.angle = 0
                }

                centralBallastTank.fillBallastTanks()
            }

            function resetVanne() {
                rotateCentralTank.angle = 0
            }

            MouseArea {
                anchors.fill: parent

                onClicked: centralBallastFill.pushVanne()
            }
        }

        Image {
            id: centralBallastFlush
            source: url + "vanne.svg"

            x: centralBallastTankDisplay.x - width * 1.5
            y: centralBallastTankDisplay.y + centralBallastTankDisplay.height * 0.9

            transform: Rotation {
                id: rotateCentralTankFlush;
                origin.x: centralBallastFill.width / 2;
                origin.y: centralBallastFill.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 0
            }

            function pushVanne() {
                if (rotateCentralTankFlush.angle == 0) {
                    rotateCentralTankFlush.angle = 90
                } else {
                    rotateCentralTankFlush.angle = 0
                }

                centralBallastTank.flushBallastTanks()
            }

            function resetVanne() {
                rotateCentralTank.angle = 0
            }

            MouseArea {
                anchors.fill: parent

                onClicked: centralBallastFlush.pushVanne()
            }
        }
    }

    Item {
        id: rightBallastTankController
        visible: rightTankVisible
        Rectangle {
            id: rightBallastTankDisplay
            x: rightBallastTankPosition.x
            y: rightBallastTankPosition.y
            width: rightBallastTankWidth
            height: rightBallastTankHeight

            radius: 10

            color: "black"

            Rectangle {
                width: rightBallastTankWidth * 0.9
                height: (rightBallastTank.waterLevel / rightBallastTank.maxWaterLevel) * rightBallastTankHeight
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }

                color: "green"

                Behavior on height {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }
        }
        Image {
            id: rightBallastFill
            source: url + "vanne.svg"

            x: rightBallastTankDisplay.x - width * 1.5
            y: rightBallastTankDisplay.y - rightBallastTankDisplay.height * 0.1

            transform: Rotation {
                id: rotateRightTank;
                origin.x: rightBallastFill.width / 2;
                origin.y: rightBallastFill.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 0
            }

            function pushVanne() {
                if (rotateRightTank.angle == 0) {
                    rotateRightTank.angle = 90
                } else {
                    rotateRightTank.angle = 0
                }

                rightBallastTank.fillBallastTanks()
            }

            function resetVanne() {
                rotateRightTank.angle = 0
            }

            MouseArea {
                anchors.fill: parent

                onClicked: rightBallastFill.pushVanne()
            }
        }

        Image {
            id: rightBallastFlush
            source: url + "vanne.svg"

            x: rightBallastTankDisplay.x - width * 1.5
            y: rightBallastTankDisplay.y + rightBallastTankDisplay.height * 0.9

            transform: Rotation {
                id: rotateRightTankFlush;
                origin.x: rightBallastFill.width / 2;
                origin.y: rightBallastFill.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 0
            }

            function pushVanne() {
                if (rotateRightTankFlush.angle == 0) {
                    rotateRightTankFlush.angle = 90
                } else {
                    rotateRightTankFlush.angle = 0
                }

                rightBallastTank.flushBallastTanks()
            }

            function resetVanne() {
                rotateRightTank.angle = 0
            }

            MouseArea {
                anchors.fill: parent

                onClicked: rightBallastFlush.pushVanne()
            }
        }
    }

    Item {
        id: divingPlaneController
        visible: divingPlaneVisible

        property int maxRotationAngle: 30

        Image {
            id: divingPlanesImage
            source: url + "rudder.png"

            width: divingPlaneWidth
            height: divingPlaneHeight

            x: divingPlanePosition.x
            y: divingPlanePosition.y

            transform: Rotation {
                id: rotateDivingPlanes;
                origin.x: divingPlanesImage.width;
                origin.y: divingPlanesImage.height / 2
                axis { x: 0; y: 0; z: 1 } angle: (submarine.wingsAngle / submarine.maxWingsAngle) * divingPlaneController.maxRotationAngle
            }
        }

        Image {
            id: divingPlanesRotateUp
            source: url + "up.png"

            x: divingPlanePosition.x + divingPlaneWidth - divingPlanesRotateUp.width / 2
            y: divingPlanePosition.y - divingPlanesImage.height * 1.1

            MouseArea {
                anchors.fill: parent

                onClicked: submarine.increaseWingsAngle(1)
            }
        }

        Image {
            id: divingPlanesRotateDown
            source: url + "down.png"

            x: divingPlanePosition.x + divingPlaneWidth - divingPlanesRotateUp.width / 2
            y: divingPlanePosition.y + divingPlanesImage.height * 1.1

            MouseArea {
                anchors.fill: parent

                onClicked: submarine.decreaseWingsAngle(1)
            }
        }
    }
}
