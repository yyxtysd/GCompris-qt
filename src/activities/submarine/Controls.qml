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
                axis { x: 0; y: 0; z: 1 } angle: leftBallastTank.waterFilling ? 90 : 0
            }

            MouseArea {
                anchors.fill: parent

                onClicked: leftBallastTank.fillBallastTanks()
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
                axis { x: 0; y: 0; z: 1 } angle: leftBallastTank.waterFlushing ? 90 : 0
            }

            MouseArea {
                anchors.fill: parent

                onClicked: leftBallastTank.flushBallastTanks()
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
                axis { x: 0; y: 0; z: 1 } angle: centralBallastTank.waterFilling ? 90 : 0
            }

            MouseArea {
                anchors.fill: parent

                onClicked: centralBallastTank.fillBallastTanks()
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
                axis { x: 0; y: 0; z: 1 } angle:centralBallastTank.waterFlushing ? 90 : 0
            }

            MouseArea {
                anchors.fill: parent

                onClicked: centralBallastTank.flushBallastTanks()
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
                axis { x: 0; y: 0; z: 1 } angle: rightBallastTank.waterFilling ? 90 : 0
            }

            MouseArea {
                anchors.fill: parent

                onClicked: rightBallastTank.fillBallastTanks()
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
                axis { x: 0; y: 0; z: 1 } angle: rightBallastTank.waterFlushing ? 90 : 0
            }

            MouseArea {
                anchors.fill: parent

                onClicked: rightBallastTank.flushBallastTanks()
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

            anchors {
                left: divingPlanesImage.right
                bottom: divingPlanesImage.top
            }

            MouseArea {
                anchors.fill: parent

                onClicked: submarine.increaseWingsAngle(1)
            }
        }

        Image {
            id: divingPlanesRotateDown
            source: url + "down.png"

            anchors {
                left: divingPlanesImage.right
                top: divingPlanesImage.bottom
            }

            MouseArea {
                anchors.fill: parent

                onClicked: submarine.decreaseWingsAngle(1)
            }
        }
    }
}
