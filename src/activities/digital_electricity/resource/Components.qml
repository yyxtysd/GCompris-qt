/* GCompris
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
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
import QtQuick 2.0

QtObject {
    property variant components : [
        {
            "imgName": "zero.svg",
            "imgWidth": 0.12,
            "imgHeight": 0.2,
            "toolTipText": qsTr("Zero input"),
            "terminalSize": 0.205,
            "inputTerminals": [],
            "outputTerminals": [
                {
                    "posX": 0.91,
                    "posY": 0.5,
                    "value": 0
                }
            ],
            "information": qsTr("Digital electronics is a branch of electronics that handle digital signals " +
                                "(i.e discrete signals instead of continous signals). Therefore all values within " +
                                "a range or band represent the same numeric value. In most cases, the number of " +
                                "these states is two and they are represented by two voltage bands: one near a " +
                                "reference value (typically termed as 'ground' or zero volts), and other value near " +
                                "the supply voltage. These correspond to the 'false' ('0') and 'true' ('1') values " +
                                "of the Boolean domain respectively (named after its inventor, George Boole). " +
                                "In this activity, you can give '0' and '1' as input to other logical devices, " +
                                "and see their output through an output device."),
            "truthTable": []

        },
        {
            "imgName": "one.svg",
            "imgWidth": 0.12,
            "imgHeight": 0.2,
            "toolTipText": qsTr("One input"),
            "terminalSize": 0.218,
            "inputTerminals": [],
            "outputTerminals": [
                {
                    "posX": 0.91,
                    "posY": 0.5,
                    "value": 1
                }
            ],
            "information": qsTr("Digital electronics is a branch of electronics that handle digital signals " +
                                "(i.e discrete signals instead of continous signals). Therefore all values within " +
                                "a range or band represent the same numeric value. In most cases, the number of " +
                                "these states is two and they are represented by two voltage bands: one near a " +
                                "reference value (typically termed as 'ground' or zero volts), and other value near " +
                                "the supply voltage. These correspond to the 'false' ('0') and 'true' ('1') values " +
                                "of the Boolean domain respectively (named after its inventor, George Boole). " +
                                "In this activity, you can give '0' and '1' as input to other logical devices, " +
                                "and see their output through an output device."),
            "truthTable": []
        },
        {
            "imgName": "gateAnd.svg",
            "imgWidth": 0.15,
            "imgHeight": 0.12,
            "toolTipText": qsTr("AND gate"),
            "terminalSize": 0.246,
            "inputTerminals": [
                {
                    "posX": 0.045,
                    "posY": 0.219
                },
                {
                    "posX": 0.045,
                    "posY": 0.773
                }
            ],
            "outputTerminals": [
                {
                    "posX": 0.955,
                    "posY": 0.5
                }
            ],
            "information": qsTr("AND gate takes 2 or more binary input in its input terminals and outputs a single " +
                                "value. The output is 0 if any of the input is 0, else it is 1. In this activity, " +
                                "a 2 input AND gate is shown. Truth table for 2 input AND gate is:"),
            "truthTable": [['A','B',"A.B"],
                           ['0','0','0'],
                           ['0','1','0'],
                           ['1','0','0'],
                           ['1','1','1']]
        },
        {
            "imgName": "ledOff.svg",
            "imgWidth": 0.16,
            "imgHeight": 0.2,
            "toolTipText": qsTr("LED"),
            "terminalSize": 0.111,
            "inputTerminals": [
                {
                    "posX": 0.319,
                    "posY": 0.945,
                },
                {
                    "posX": 0.776,
                    "posY": 0.698
                }
            ],
            "outputTerminals": [],
            "information": qsTr("LED (Light-emitting diode) is a two-lead semiconductor light source. It emits " +
                                "light when activated. LED has 2 input terminals, the longer terminal is the " +
                                "positive terminal (anode) and smaller terminal is the negative terminal (cathode)" +
                                ". LED is activated when anode has a higher potential than cathode. In digital " +
                                "electronics LED can be used to check the output of the components. Connect " +
                                "the cathode of LED to ground ('0') and anode of LED to the output of the " +
                                "component. If output is 1, the LED will be activated (emit light), and if " +
                                "output is 0, the LED will be deactivated."),
            "truthTable": []
        }
    ]
}
