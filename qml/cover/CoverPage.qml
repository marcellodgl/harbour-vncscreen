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

CoverBackground {
    property string iconSource
    Column {
        spacing: Theme.paddingLarge
        width: parent.width
        anchors.centerIn: parent
        Label {
            id: label
//            anchors.centerIn: parent

            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("VNC Screen")
        }
        Image{
            id: placeHolder
            anchors.horizontalCenter: parent.horizontalCenter

            source:iconSource //"image://rfbimage/horizontal"+10
            width: parent.width*0.9
            fillMode: Image.PreserveAspectFit

        }

    }
    CoverActionList {
        id: coverAction

//        CoverAction {
//            iconSource: "image://theme/icon-cover-refresh"
//        }
    }
    function updatePreview(){
        console.log("vncPreviewUpdate")
//        placeHolder.icon.source=iconSource //"image://rfbimage/horizontal"+10
    }

    onIconSourceChanged: console.log("iconSource "+iconSource)
}


