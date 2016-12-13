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

import harbour.vncscreen.InterfaceRFB 1.0


Page{
    id:page


    SilicaListView {
        id: listView
        Label{
            id:label
            height: 100

            text: "prova"

        }

        TextField{
            id:keyboardText
            text:"cioa"
//                        visible: false
            anchors.top: label.bottom
            focus:true
            Keys.onPressed: {
                console.log(event.text)
//                screenInterface.vncKeyEvent(event.key,event.modifiers,true)
            }
            Keys.onReleased: {
                console.log(event.text)
//                screenInterface.vncKeyEvent(event.key,event.modifiers,false)
            }
        }
//        model: 20
//        anchors.fill: parent
//        header: PageHeader {
//            title: qsTr("Nested Page")
//        }
//        delegate: BackgroundItem {
//            id: delegate

//            Label {
//                x: Theme.paddingLarge
//                text: qsTr("Item") + " " + index
//                anchors.verticalCenter: parent.verticalCenter
//                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
//            }
//            onClicked: console.log("Clicked " + index)
//        }
//        VerticalScrollDecorator {}
    }

}


