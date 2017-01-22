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

Dialog {
    property string connectionUrl: urlField.text
    property string screenQuality: qualitySlider.value
    DialogHeader{
        id: header
        title: "Connect"
    }
    TextField{
        id: urlField
        placeholderText: qsTr("VNC Server URL")
        anchors.top: header.bottom
        label: qsTr("Url")
        width: parent.width
        EnterKey.onClicked: accept()
    }
    Slider {
        id: qualitySlider
        anchors.top:urlField.bottom
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        value: 0
        label:qsTr("Quality")
        minimumValue: 1
        maximumValue: 3
        stepSize: 1

        function sliderLabel(){
            if(value==1) return "Low (ISDN)"
            else if(value==2) return "Medium (DSL)"
            else if(value==3) return "High (LAN)"
            else return ""
        }
        valueText: sliderLabel()
    }
}




