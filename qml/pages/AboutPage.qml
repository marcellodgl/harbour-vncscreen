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
import "../components"

Page {
    id: aboutPage

    SilicaFlickable {
        id: aboutFlickable
        anchors.fill: parent
        contentHeight: aboutColumn.height

        Column {
            PageHeader {
                title: qsTr("About VNC Screen")
                id:aboutHeader
                 Image {
                    id: imageHeader
                    width:43
                    height: 43
                    x:aboutHeader.extraContent.x
                    y:aboutHeader.extraContent.y
                    source: "qrc:/VncScreen/icons/86x86/harbour-vncscreen.png"
                }
            }

            id: aboutColumn
            anchors { left: parent.left; right: parent.right }
            height: childrenRect.height

            BlockText {
                anchors {
                    left: parent.left
                    margins: Theme.paddingLarge
                }
                label: qsTr("VNC Screen")
                text: qsTr("This is a remote desktop application for Sailfish OS based on VNC standard.")
                separator: true
            }
            BlockText {
                anchors {
                    left: parent.left
                    margins: Theme.paddingLarge
                }
                label: qsTr("Author")
                text: "Marcello Di Guglielmo"
                detailUrl: "<a href='mailto:marcellodgl@aruba.it?subject=VNC Screen'>marcellodgl@aruba.it</a>"

                separator: true
            }

            BlockText {
                anchors {
                    left: parent.left
                    margins: Theme.paddingLarge
                }
                label: qsTr("License")
                text: qsTr("VNC Screen is free software and licensed under GNU Geneal Public License v3")
                detailUrl: "<a href='https://www.gnu.org/licenses/gpl-3.0.en.html'>Details</a>"
                detailImage: "qrc:/VncScreen/icons/gplv3.png"
                separator: true
            }
            BlockText {
                anchors {
                    left: parent.left
                    margins: Theme.paddingLarge
                }
                label: qsTr("Version")
                detailUrl: "<a href='https://github.com/marcellodgl/harbour-vncscreen'>Source</a>"
                detailImage: "qrc:/VncScreen/icons/git.png"
                text: Qt.application.version
                separator: true
            }
            BlockText {
                anchors {
                    left: parent.left
                    margins: Theme.paddingLarge
                }
                label: qsTr("Donate")
                text: qsTr("If you like this app and would like to make a donation, via Paypal")
                detailUrl: "<a href='https://www.paypal.me/VNCScreen'>Link</a>"
                detailImage: "qrc:/VncScreen/icons/paypal.png"
                separator: true
            }
        }
    }
}
