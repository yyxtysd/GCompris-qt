/* GCompris - GCDialogCheckBox.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import QtQuick.Controls 2.0
import GCompris 1.0

/**
 * GCompris' CheckBox component.
 * @ingroup components
 *
 * @inherit QtQuick.Controls2.CheckBox
 */
CheckBox {
    id: checkBox
	width: parent.width

    /**
     * type:int
     * Font size of the label text.
     * By default it is set to 16 i.e. GCText.mediumSize
     *
     */
    property int labelTextFontSize: 16
    /**
     * type:int
     * Height of the indicator image.
     */
    property int indicatorImageHeight: 50 * ApplicationInfo.ratio

    spacing: 10

    focusPolicy: Qt.NoFocus

    indicator: Image {
        sourceSize.height: indicatorImageHeight
        property string suffix: checkBox.enabled ? ".svg" : "_disabled.svg"
        source:
            checkBox.checked ? "qrc:/gcompris/src/core/resource/apply" + suffix :
                              "qrc:/gcompris/src/core/resource/cancel" + suffix
    }
    contentItem: GCText {
	    anchors.left: indicator.right
        fontSize: labelTextFontSize
        text: checkBox.text
        wrapMode: Text.WordWrap
        width: parent.width - 50 * ApplicationInfo.ratio - 10 * 2
    }
}
