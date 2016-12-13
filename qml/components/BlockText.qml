/*
VNC Screen: Remote Desktop application for Sailfish OS based on VNC standard.

Copyright (c) 2016 Marcello Di Guglielmo

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    property alias label: label.text
    property alias text: text.text
    property alias font: text.font
    property alias detailUrl : detailText.text
    property alias detailImage : detailImage.source
    property alias separator: separator.visible
    property alias color: text.color
    RemorsePopup {id: remorse}

    spacing: Theme.paddingMedium

    anchors {
        right: parent.right
        left: parent.left
    }

    Label {
        id: label
        anchors {
            left: parent.left
        }
        width: parent.width
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeExtraSmall
    }
    Label {
        id: text
        anchors {
            left: parent.left
        }
        color: Theme.primaryColor
        font.pixelSize: Theme.fontSizeSmall
        wrapMode: Text.Wrap
        width: parent.width - (2 * Theme.paddingLarge)
    }
    Row {
        id:rowDetail
        spacing: Theme.paddingLarge
        Image{
            id:detailImage
        }
        Label {

            id: detailText

            function openUrl(url){
                Qt.openUrlExternally(url)
            }

            color: Theme.primaryColor
            linkColor: Theme.highlightColor
            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.Wrap
            onLinkActivated: remorse.execute(qsTr("Opening Url"), openUrl(link), 3000)

        }
    }
    Separator {
        id: separator
        width:parent.width;
        color: Theme.highlightColor
    }
}
