/* GCompris - Dataset.qml
 *
 * Copyright (C) RUDRA NIL BASU <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *   RUDRA NIL BASU <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
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
    property real nodeWidth: background.nodeWidthRatio
    property real nodeHeight: background.nodeHeightRatio

    /*
     * Vertically, the screen is divided into three parts:
     * gen_1: stands for Generation 1
     * gen_2: stands for Generation 2
     * gen_3: stands for Generation 3
     */
    readonly property real gen_1: 0.10
    readonly property real gen_2: 0.40
    readonly property real gen_3: 0.70

    /*
     * Horizontally, the screen is divided into left, center
     * and right
     */
    readonly property real left: 0.2
    readonly property real center: 0.4
    readonly property real right: 0.6

    /*
     * ext: exterior
     * int: interior
     */
    readonly property real left_ext: 0.1
    readonly property real left_int: 0.3
    readonly property real right_int: 0.5
    readonly property real right_ext: 0.7

    /*
     * pairs are used to determine the correct
     * pair for a given relation in the family_find_relative
     * activity
     * A correct pair is formed by selecting a node of type
     * "pair_1" and "pair_2" only
     */
    readonly property int pair_1: -1
    readonly property int pair_2: 1
    readonly property int no_pair: 0

    function rightXEdge(xPosition) {
        /*
         * Returns the x coordinate of the
         * right edge of a node
         */
        return xPosition + nodeWidth
    }

    function nodeMidPointY(yPosition) {
        /*
         * Returns the y coordinate of the
         * midpoint of a node
         */
        return yPosition + nodeHeight / 2
    }

    function nodeMidPointX(xLeftPosition, xRightPosition) {
        /*
         * Returns the x coordinate of the
         * midpoint of two nodes
         */
        return ((xLeftPosition + nodeWidth) + xRightPosition) / 2
    }

    property var levelElements: [
        // level 1
        {
            edgeList: [
                [left + nodeWidth, gen_1 + nodeHeight / 2, right, gen_1 + nodeHeight / 2],
                [((left + nodeWidth) + right) / 2, gen_1 + nodeHeight / 2, ((left + nodeWidth) + right) / 2, gen_2]
            ],
            nodePositions: [
                [left, gen_1],
                [right, gen_1],
                [center, gen_2]
            ],
            captions: [
                [center - (nodeWidth *  3 / 4), gen_2 + nodeHeight / 2],
                [left - nodeWidth / 2, gen_1]
            ],
            nodeleave: ["man3.svg", "lady2.svg", "boy1.svg"],
            nodeWeights: [pair_1, no_pair, pair_2],
            currentState: ["activeTo", "deactive", "active"],
            edgeState:["married","others"],
            answer: [qsTr("Father")],
            options: [qsTr("Father"), qsTr("Grandfather"), qsTr("Uncle")]
        },
        // level 2
        {
            edgeList: [
                [left + nodeWidth, gen_1 + nodeHeight / 2, right, gen_1 + nodeHeight / 2],
                [((left + nodeWidth) + right) / 2, gen_1 + nodeHeight / 2, ((left + nodeWidth) + right) / 2, gen_2]
            ],
            nodePositions: [
                [left, gen_1],
                [right, gen_1],
                [center, gen_2]
            ],
            captions: [
                [center - (nodeWidth *  3 / 4), gen_2 + nodeHeight / 2],
                [right + nodeWidth, gen_1]
            ],
            nodeleave: ["man3.svg", "lady2.svg", "boy1.svg"],
            nodeWeights: [no_pair, pair_1, pair_2],
            currentState: ["deactive", "activeTo", "active"],
            edgeState:["married","others"],
            answer: [qsTr("Mother")],
            options: [qsTr("Mother"), qsTr("Grandmother"), qsTr("Aunt")]
        },
        // level 3
        {
            edgeList: [
                [rightXEdge(left), nodeMidPointY(gen_1), right, nodeMidPointY(gen_1)],
                [nodeMidPointX(left, right), nodeMidPointY(gen_1), nodeMidPointX(left, right), gen_2 - nodeHeight / 4],
                [left + nodeWidth / 2, gen_2 - nodeHeight / 4, right + nodeWidth / 2, gen_2 - nodeHeight / 4],
                [left + nodeWidth / 2, gen_2 - nodeHeight / 4, left + nodeWidth / 2, gen_2],
                [right + nodeWidth / 2, gen_2 - nodeHeight / 4, right + nodeWidth / 2, gen_2]
            ],
            nodePositions: [
                [left, gen_1],
                [right, gen_1],
                [left, gen_2],
                [right, gen_2]
            ],
            captions:[
                [left - (nodeWidth *  3 / 4), gen_2 + nodeHeight / 2],
                [right + nodeWidth, gen_2]
            ],
            nodeleave: ["man3.svg", "lady2.svg", "boy1.svg", "boy2.svg"],
            nodeWeights: [no_pair, no_pair, pair_1, pair_2],
            currentState: ["deactive", "deactive", "active", "activeTo"],
            edgeState:["married","others","others","others"],
            answer: [qsTr("Brother")],
            options: [qsTr("Cousin"), qsTr("Brother"), qsTr("Sister")]
        },
        // level 4
        {
            edgeList: [
                [rightXEdge(left), nodeMidPointY(gen_1), right, nodeMidPointY(gen_1)],
                [nodeMidPointX(left, right), nodeMidPointY(gen_1), nodeMidPointX(left, right), gen_2 - nodeHeight / 4],
                [left + nodeWidth / 2, gen_2 - nodeHeight / 4, right + nodeWidth / 2, gen_2 - nodeHeight / 4],
                [left + nodeWidth / 2, gen_2 - nodeHeight / 4, left + nodeWidth / 2, gen_2],
                [center + nodeWidth / 2, gen_2 - nodeHeight / 4, center + nodeWidth / 2, gen_2],
                [right + nodeWidth / 2, gen_2 - nodeHeight / 4, right + nodeWidth / 2, gen_2]
            ],
            nodePositions: [
                [left, gen_1],
                [right, gen_1],
                [left, gen_2],
                [center, gen_2],
                [right, gen_2]
            ],
            captions: [
                [left - (nodeWidth *  3 / 4), gen_2 + nodeHeight / 2],
                [center + nodeWidth / 2, (gen_2 + nodeHeight)]
            ],
            nodeleave: ["man3.svg", "lady2.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
            nodeWeights: [no_pair, no_pair, pair_1, pair_2, pair_1],
            currentState: ["deactive", "deactive", "active", "activeTo", "deactive"],
            edgeState:["married", "others", "others", "others", "others", "others"],
            answer: [qsTr("Sister")],
            options: [qsTr("Cousin"), qsTr("Brother"), qsTr("Sister")]
        },
        // level 5
        {
            edgeList: [
                [left_ext + nodeWidth, gen_1 + nodeHeight / 2, right_int, gen_1 + nodeHeight / 2],
                [((left_ext + nodeWidth) + right_int) / 2, gen_1 + nodeHeight / 2, ((left_ext + nodeWidth) + right_int) / 2, gen_2],
                [left_int + nodeWidth, gen_2 + nodeHeight / 2, right, gen_2 + nodeHeight / 2],
                [((left_int + nodeWidth) + right) / 2, gen_2 + nodeHeight / 2, ((left_int + nodeWidth) + right) / 2, gen_3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen_3 - nodeWidth / 4, right + nodeWidth / 2, gen_3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen_3 - nodeWidth / 4, left + nodeWidth / 2, gen_3],
                [center + nodeWidth / 2, gen_3 - nodeWidth / 4, center + nodeWidth / 2, gen_3],
                [right + nodeWidth / 2, gen_3 - nodeWidth / 4, right + nodeWidth / 2, gen_3]
            ],
            nodePositions: [
                [left_ext, gen_1],
                [right_int, gen_1],
                [left_int, gen_2],
                [right, gen_2],
                [left, gen_3],
                [center, gen_3],
                [right, gen_3]
            ],
            captions: [
                [left_ext, gen_3 + nodeHeight / 4],
                [left_ext, gen_1 + nodeHeight]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "girl1.svg", "boy1.svg", "boy2.svg"],
            nodeWeights: [pair_1, no_pair, no_pair, no_pair, pair_2, pair_2, pair_2],
            currentState: ["activeTo", "deactive", "deactive", "deactive", "active", "deactive", "deactive"],
            edgeState:["married","others","married","others","others","others","others","others" ],
            answer: [qsTr("Grandfather")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
        },
        // level 6
        {
            edgeList: [
                [left_ext + nodeWidth, gen_1 + nodeHeight / 2, right_int, gen_1 + nodeHeight / 2],
                [((left_ext + nodeWidth) + right_int) / 2, gen_1 + nodeHeight / 2, ((left_ext + nodeWidth) + right_int) / 2, gen_2],
                [left_int + nodeWidth, gen_2 + nodeHeight / 2, right, gen_2 + nodeHeight / 2],
                [((left_int + nodeWidth) + right) / 2, gen_2 + nodeHeight / 2, ((left_int + nodeWidth) + right) / 2, gen_3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen_3 - nodeWidth / 4, right + nodeWidth / 2, gen_3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen_3 - nodeWidth / 4, left + nodeWidth / 2, gen_3],
                [center + nodeWidth / 2, gen_3 - nodeWidth / 4, center + nodeWidth / 2, gen_3],
                [right + nodeWidth / 2, gen_3 - nodeWidth / 4, right + nodeWidth / 2, gen_3]
            ],
            nodePositions: [
                [left_ext, gen_1],
                [right_int, gen_1],
                [left_int, gen_2],
                [right, gen_2],
                [left, gen_3],
                [center, gen_3],
                [right, gen_3]
            ],
            captions: [
                [right + nodeWidth, gen_3 + (nodeHeight * 3 / 4)],
                [right_int, gen_1 + nodeHeight]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
            nodeWeights: [no_pair, pair_1, no_pair, no_pair, pair_2, pair_2, pair_2],
            currentState: ["deactive", "activeTo", "deactive", "deactive", "deactive", "deactive", "active", "active"],
            edgeState:["married","others","married","others","others","others","others","others" ],
            answer: [qsTr("Grandmother")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")],
        },
        // level 7
        {
            edgeList: [
                [left_ext + nodeWidth, gen_1 + nodeHeight / 2, right_int, gen_1 + nodeHeight / 2],
                [((left_ext + nodeWidth) + right_int) / 2, gen_1 + nodeHeight / 2, ((left_ext + nodeWidth) + right_int) / 2, gen_2],
                [left_int + nodeWidth, gen_2 + nodeHeight / 2, right, gen_2 + nodeHeight / 2],
                [((left_int + nodeWidth) + right) / 2, gen_2 + nodeHeight / 2, ((left_int + nodeWidth) + right) / 2, gen_3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen_3 - nodeWidth / 4, right + nodeWidth / 2, gen_3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen_3 - nodeWidth / 4, left + nodeWidth / 2, gen_3],
                [center + nodeWidth / 2, gen_3 - nodeWidth / 4, center + nodeWidth / 2, gen_3],
                [right + nodeWidth / 2, gen_3 - nodeWidth / 4, right + nodeWidth / 2, gen_3]
            ],
            nodePositions: [
                [left_ext, gen_1],
                [right_int, gen_1],
                [left_int, gen_2],
                [right, gen_2],
                [left, gen_3],
                [center, gen_3],
                [right, gen_3]
            ],
            captions: [
                [left_ext + nodeWidth, gen_1],
                [right + nodeWidth, gen_3]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "boy2.svg","girl1.svg" ],
            nodeWeights: [pair_1, pair_1, no_pair, no_pair, no_pair, no_pair, pair_2],
            currentState: ["active", "deactive", "deactive", "deactive", "deactive", "deactive", "activeTo"],
            edgeState:["married","others","married","others","others","others","others","others" ],
            answer: [qsTr("Granddaughter")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
        },
        // level 8
        {
            edgeList: [
                [left_ext + nodeWidth, gen_1 + nodeHeight / 2, right_int, gen_1 + nodeHeight / 2],
                [((left_ext + nodeWidth) + right_int) / 2, gen_1 + nodeHeight / 2, ((left_ext + nodeWidth) + right_int) / 2, gen_2],
                [left_int + nodeWidth, gen_2 + nodeHeight / 2, right, gen_2 + nodeHeight / 2],
                [((left_int + nodeWidth) + right) / 2, gen_2 + nodeHeight / 2, ((left_int + nodeWidth) + right) / 2, gen_3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen_3 - nodeWidth / 4, right + nodeWidth / 2, gen_3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen_3 - nodeWidth / 4, left + nodeWidth / 2, gen_3],
                [center + nodeWidth / 2, gen_3 - nodeWidth / 4, center + nodeWidth / 2, gen_3],
                [right + nodeWidth / 2, gen_3 - nodeWidth / 4, right + nodeWidth / 2, gen_3]
            ],
            nodePositions: [
                [left_ext, gen_1],
                [right_int, gen_1],
                [left_int, gen_2],
                [right, gen_2],
                [left, gen_3],
                [center, gen_3],
                [right, gen_3]
            ],
            captions: [
                [right_int + nodeWidth, gen_1],
                [right + nodeWidth, gen_3]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
            nodeWeights: [pair_1, pair_1, no_pair, no_pair, pair_2, no_pair, pair_2],
            currentState: ["deactive", "active", "deactive", "deactive", "deactive", "deactive", "activeTo", "active"],
            edgeState:["married","others","married","others","others","others","others","others" ],
            answer: [qsTr("Grandson")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
        },
        // level 9
        {
            edgeList: [
                [center + nodeWidth / 2, gen_1 + nodeHeight, center + nodeWidth / 2, gen_2 + nodeHeight / 2],
                [rightXEdge(left), nodeMidPointY(gen_2), right, nodeMidPointY(gen_2)],
                [left + nodeWidth / 2, gen_2 + nodeHeight, left + nodeWidth / 2, gen_3],
                [right + nodeWidth / 2, gen_2 + nodeHeight, right + nodeWidth / 2, gen_3]
            ],
            nodePositions: [
                [center, gen_1],
                [left, gen_2],
                [right, gen_2],
                [left, gen_3],
                [right, gen_3]
            ],
            captions: [
                [(right + nodeWidth * 1.1), gen_3 + nodeHeight / 4],
                [left - nodeWidth / 2, gen_3 + nodeHeight / 4]
            ],
            nodeleave: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg","boy2.svg"],
            nodeWeights: [no_pair, no_pair, no_pair, pair_2, pair_1],
            currentState: ["deactive", "deactive", "deactive", "activeTo","active"],
            edgeState:["others","others","others","others"],
            answer: [qsTr("Cousin")],
            options: [qsTr("Brother"), qsTr("Sister"), qsTr("Cousin")]
        },
        // level 10
        {
            edgeList: [
                [center + nodeWidth / 2, gen_1 + nodeHeight, center + nodeWidth / 2, gen_2 + nodeHeight / 2],
                [rightXEdge(left), nodeMidPointY(gen_2), right, nodeMidPointY(gen_2)],
                [left + nodeWidth / 2, gen_2 + nodeHeight, left + nodeWidth / 2, gen_3]
            ],
            nodePositions: [
                [center, gen_1],
                [left, gen_2],
                [right, gen_2],
                [left, gen_3]
            ],
            captions: [
                [left - nodeWidth * 3 / 4, gen_3 + nodeHeight / 4],
                [right + nodeWidth * 1.1, gen_2 + nodeHeight / 4]
            ],
            nodeleave: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg"],
            nodeWeights: [no_pair, no_pair, pair_1, pair_2],
            currentState: ["deactive", "deactive", "activeTo", "active"],
            edgeState:["others","others","others"],
            answer: [qsTr("Uncle")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 11
        {
            edgeList: [
                [center + nodeWidth / 2, gen_1 + nodeHeight, center + nodeWidth / 2, gen_2 + nodeHeight / 2],
                [rightXEdge(left), nodeMidPointY(gen_2), right, nodeMidPointY(gen_2)],
                [left + nodeWidth / 2, gen_2 + nodeHeight, left + nodeWidth / 2, gen_3]
            ],
            nodePositions: [
                [center, gen_1],
                [left, gen_2],
                [right, gen_2],
                [left, gen_3]
            ],
            captions: [
                [right + nodeWidth * 1.1, gen_2 + nodeHeight / 4],
                [left - nodeWidth * 3 / 4, gen_3 + nodeHeight / 4]
            ],
            nodeleave: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg"],
            nodeWeights: [no_pair, no_pair, pair_2, pair_1],
            currentState: ["deactive", "deactive", "active", "activeTo"],
            edgeState:["others","others","others"],
            answer: [qsTr("Nephew")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 12
        {
            edgeList: [
                [rightXEdge(left), gen_1 + nodeHeight / 2, right, gen_1 + nodeHeight / 2],
                [nodeMidPointX(left, right), nodeMidPointY(gen_1), nodeMidPointX(left, right), nodeMidPointY(gen_2)],
                [rightXEdge(left), nodeMidPointY(gen_2), right, nodeMidPointY(gen_2)],
                [left + nodeWidth / 2, gen_2 + nodeHeight, left + nodeWidth / 2, gen_3]
            ],
            nodePositions: [
                [left, gen_1],
                [right, gen_1],
                [left, gen_2],
                [right, gen_2],
                [left, gen_3]
            ],
            captions: [
                [left - nodeWidth * 3 / 4, gen_3 + nodeHeight / 4],
                [right + nodeWidth * 1.1, gen_2 + nodeHeight / 4]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady1.svg", "babyboy.svg"],
            nodeWeights: [no_pair, no_pair, no_pair, pair_1, pair_2],
            currentState: ["deactive", "deactive", "deactive", "activeTo", "active"],
            edgeState:["married","others","siblings","others","others","others"],
            answer: [qsTr("Aunt")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 13
        {
            edgeList: [
                [rightXEdge(left), gen_1 + nodeHeight / 2, right, gen_1 + nodeHeight / 2],
                [nodeMidPointX(left, right), nodeMidPointY(gen_1), nodeMidPointX(left, right), nodeMidPointY(gen_2)],
                [rightXEdge(left), nodeMidPointY(gen_2), right, nodeMidPointY(gen_2)],
                [left + nodeWidth / 2, gen_2 + nodeHeight, left + nodeWidth / 2, gen_3]
            ],
            nodePositions: [
                [left, gen_1],
                [right, gen_1],
                [left, gen_2],
                [right, gen_2],
                [left, gen_3]
            ],
            captions: [
                [right + nodeWidth * 1.1, gen_2 + nodeHeight / 4],
                [left - nodeWidth / 2, gen_3 + nodeHeight / 4]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady1.svg", "babygirl.svg"],
            nodeWeights: [no_pair, no_pair, no_pair, pair_2, pair_1],
            currentState: ["deactive", "deactive", "deactive", "active", "activeTo"],
            edgeState:["married","others","siblings","others","others","others"],
            answer: [qsTr("Niece")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 14
        {
            edgeList: [
                [rightXEdge(center), nodeMidPointY(gen_1), right_ext, nodeMidPointY(gen_1)],
                [nodeMidPointX(center, right_ext), nodeMidPointY(gen_1), nodeMidPointX(center, right_ext), nodeMidPointY(gen_2)],
                [rightXEdge(center), nodeMidPointY(gen_2), right_ext, nodeMidPointY(gen_2)],
                [rightXEdge(left_ext), nodeMidPointY(gen_2), center, nodeMidPointY(gen_2)]
            ],
            nodePositions: [
                [center, gen_1],
                [right_ext, gen_1],
                [center, gen_2],
                [right_ext, gen_2],
                [left_ext, gen_2]
            ],
            captions: [
                [left_ext - nodeWidth / 2, gen_2 + nodeHeight * 3 / 4],
                [center - nodeWidth * 3 / 4, gen_1 + nodeHeight / 4]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "man1.svg", "lady2.svg"],
            nodeWeights: [pair_1, no_pair, no_pair, no_pair, pair_2],
            currentState: ["activeTo", "deactive", "deactive", "deactive", "active"],
            edgeState:["married","others","others","married"],
            answer: [qsTr("Father-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 15
        {
            edgeList: [
                [rightXEdge(center), nodeMidPointY(gen_1), right_ext, nodeMidPointY(gen_1)],
                [nodeMidPointX(center, right_ext), nodeMidPointY(gen_1), nodeMidPointX(center, right_ext), nodeMidPointY(gen_2)],
                [rightXEdge(center), nodeMidPointY(gen_2), right_ext, nodeMidPointY(gen_2)],
                [rightXEdge(left_ext), nodeMidPointY(gen_2), center, nodeMidPointY(gen_2)]
            ],
            nodePositions: [
                [center, gen_1],
                [right_ext, gen_1],
                [center, gen_2],
                [right_ext, gen_2],
                [left_ext, gen_2]
            ],
            captions: [
                [left_ext - nodeWidth / 2, gen_2 + nodeHeight * 3 / 4],
                [right_ext + nodeWidth * 1.1, gen_1 + nodeHeight / 4]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "man1.svg", "lady2.svg"],
            nodeWeights: [no_pair, pair_1, no_pair, no_pair, pair_2],
            currentState: ["deactive", "activeTo", "deactive", "deactive", "active"],
            edgeState:["married","others","others","married","others"],
            answer: [qsTr("Mother-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 16
        {
            edgeList: [
                [rightXEdge(center), nodeMidPointY(gen_1), right_ext, nodeMidPointY(gen_1)],
                [nodeMidPointX(center, right_ext), nodeMidPointY(gen_1), nodeMidPointX(center, right_ext), nodeMidPointY(gen_2)],
                [rightXEdge(center), nodeMidPointY(gen_2), right_ext, nodeMidPointY(gen_2)],
                [rightXEdge(left_ext), nodeMidPointY(gen_2), center, nodeMidPointY(gen_2)]
            ],
            nodePositions: [
                [center, gen_1],
                [right_ext, gen_1],
                [center, gen_2],
                [right_ext, gen_2],
                [left_ext, gen_2]
            ],
            captions: [
                [left_ext - nodeWidth / 2, gen_2 + nodeHeight * 3 / 4],
                [right_ext + nodeWidth * 1.1, gen_2 + nodeHeight / 4]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "man1.svg", "lady2.svg"],
            nodeWeights: [no_pair, no_pair, no_pair, pair_1, pair_2],
            currentState: ["deactive", "deactive", "deactive", "activeTo", "active"],
            edgeState:["married","others","others","married","others"],
            answer: [qsTr("Brother-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 17
        {
            edgeList: [
                [rightXEdge(left_int), nodeMidPointY(gen_1), right_int, nodeMidPointY(gen_1)],
                [nodeMidPointX(left_int, right_int), nodeMidPointY(gen_1), nodeMidPointX(left_int, right_int), nodeMidPointY(gen_2)],
                [rightXEdge(left_int), nodeMidPointY(gen_2), right_int, nodeMidPointY(gen_2)],
                [rightXEdge(left_ext), nodeMidPointY(gen_2), left_int, nodeMidPointY(gen_2)],
                [rightXEdge(right_int), nodeMidPointY(gen_2), right_ext, nodeMidPointY(gen_2)]
            ],
            nodePositions: [
                [left_int, gen_1],
                [right_int, gen_1],
                [left_int, gen_2],
                [left_ext, gen_2],
                [right_int, gen_2],
                [right_ext, gen_2]
            ],
            captions: [
                [left_ext - nodeWidth / 2, gen_2],
                [right_ext + nodeWidth, gen_2 + nodeHeight / 4]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "lady1.svg", "man1.svg"],
            nodeWeights: [no_pair, no_pair, no_pair, pair_1, pair_2, no_pair],
            currentState: ["dective", "deactive", "deactive", "active", "deactive", "activeTo"],
            edgeState:["married","others","others","married","married"],
            answer: [qsTr("Sister-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 18
        {
            edgeList: [
                [rightXEdge(center), nodeMidPointY(gen_1), right_ext, nodeMidPointY(gen_1)],
                [nodeMidPointX(center, right_ext), nodeMidPointY(gen_1), nodeMidPointX(center, right_ext), nodeMidPointY(gen_2)],
                [rightXEdge(center), nodeMidPointY(gen_2), right_ext, nodeMidPointY(gen_2)],
                [rightXEdge(left_ext), nodeMidPointY(gen_2), center, nodeMidPointY(gen_2)]
            ],
            nodePositions: [
                [center, gen_1],
                [right_ext, gen_1],
                [center, gen_2],
                [left_ext, gen_2],
                [right_ext, gen_2]
            ],
            captions: [
                [center - (nodeWidth * 3/ 4), gen_1 + nodeHeight / 4],
                [left_ext - nodeWidth / 2, gen_2 + nodeHeight / 2]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "lady2.svg", "man3.svg", "man1.svg"],
            nodeWeights: [pair_1, pair_1, no_pair, pair_2, no_pair],
            currentState: ["active", "deactive", "deactive", "activeTo", "deactive", "deactive"],
            edgeState:["married","others","others","married","others"],
            answer: [qsTr("Son-in-law")],
            options: [qsTr("Son-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        }
    ]
}
