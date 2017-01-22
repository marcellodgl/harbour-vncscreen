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


Page {
    id: page
    allowedOrientations: Orientation.All
    Component{
        id:passwordDialog
        PasswordPage{

            id : dialog
            onAccepted:{
                console.log(connectionPassword);
                screenInterface.vncpassword=connectionPassword
            }
        }//        model: 20
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

    InterfaceRFB{
        id: screenInterface
        onPasswordRequest: {
            console.log("interfaceRFBPassword request")
            pageStack.push(passwordDialog)

        }
        onVncStatus: {
            status==InterfaceRFB.Connected ? actionConnect.visible=false : {}
            status==InterfaceRFB.Connected ? actionDisconnect.visible=true : {}
            status==InterfaceRFB.Connected ? keyboardButton.visible=true : {}
            status==InterfaceRFB.Disconnected ? actionConnect.visible=true : {}
            status==InterfaceRFB.Disconnected ? actionDisconnect.visible=false : {}
            status==InterfaceRFB.Disconnected ? keyboardButton.visible=false : {}
        }
        onVncImageUpdate: {
            console.log("image update"+index)
            imageScreen.source="image://rfbimage/horizontal"+index
            console.log("image update complete"+index)
        }


    }



    Component{
        id:connectDialog
        ConnectPage{
            id : dialog
            onAccepted:{
                screenInterface.vncpath=connectionUrl
                screenInterface.vncquality=screenQuality
            }
        }
    }



    SilicaFlickable {
        anchors.fill: parent
        id: flickableScreen
        property int visibleAreaX: 0
        property int visibleAreaY: 0
        onMovementEnded:  {
            console.log("flick x"+visibleArea.xPosition+"image x"+imageScreen.x)
            keyboardText.x=contentX
            keyboardText.y=contentY

            visibleAreaX=visibleArea.xPosition*imageScreen.width
            visibleAreaY=visibleArea.yPosition*imageScreen.height
        }



        contentHeight: column.height
        contentWidth: imageScreen.width
        VerticalScrollDecorator{
            flickable: imageScreen
        }
        HorizontalScrollDecorator{
            flickable: imageScreen
        }

        Timer{
            id:focusTimer
            interval: 250
            onTriggered: {
                flickableScreen.contentX=flickableScreen.visibleAreaX
                flickableScreen.contentY=flickableScreen.visibleAreaY
            }
        }

        PullDownMenu {
            MenuItem {
                id:actionAbout
                text: qsTr("About")
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
                }
            }
            MenuItem {
                id:actionConnect
                text: qsTr("Connect")
                visible: true
                onClicked:{
                    pageStack.push(connectDialog)
                }
            }
            MenuItem {
                id:actionDisconnect
                text: qsTr("Disconnect")
                visible: false
                onClicked:{
                    screenInterface.vncDisconnect()
                }
            }
        }
        PushUpMenu{
            MenuLabel{
                id:toolButtonMenu
                IconButton {
                    id: keyboardButton
                    icon.source: "image://theme/icon-m-keyboard"
                    onClicked: {
                        console.log("keyboard")
                            keyboardText.forceActiveFocus()

                    }
                }
                IconButton {
                    id: mouseButton
                    anchors.left: keyboardButton.right
                    icon.source: "image://theme/icon-m-mouse"
                    onClicked: {
                        console.log("mouse")
                    }
                }
            }

        }


        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                id:screenHeader
                title: qsTr("VNC Screen")
            }


            Image {
                id: imageScreen

                fillMode: Image.TileVertically
                MouseArea{
                    id:mouseControl
                    anchors.fill: parent
                    onPositionChanged: {
                        console.log("movement")
                        console.log(mouse.x)
                        console.log(mouse.y)
                        screenInterface.vncMouseEvent(mouse.x,mouse.y,mouse.buttons)
                    }
                    onPressed:  {
                        console.log("pressed")
                        screenInterface.vncMouseEvent(mouse.x,mouse.y,mouse.buttons)
                    }
                    onReleased: {
                        console.log("released")
                        screenInterface.vncMouseEvent(mouse.x,mouse.y,mouse.buttons)
                    }

                }



            }
            TextField{
                id:keyboardText
                visible: false

                property int indexKey: 0
                property int textSize:  0
                property  int keyCode: 0
//Importante per non far comparire shift automatici e dover applicare tecniche che possan generare confusione
//Evita anche che vengano utilizzati degli anticipatori di testo che in tal caso sono fuorvianti perchè i caratteri
//vanno passati al vnc
                echoMode: TextInput.NoEcho

//                text:"A"
//                focus: true


                Keys.onPressed: {
                    console.log(event.text)
                    screenInterface.vncKeyEvent(event.key,event.modifiers,true)
                }
                Keys.onReleased: {
                    console.log(event.text)
//Condizione di if perchè il backspace genera solo evento di rilased senza pressed
                    if(event.key === Qt.Key_Backspace)
                    {
                        screenInterface.vncKeyEvent(event.key,event.modifiers,true)
                    }

                    screenInterface.vncKeyEvent(event.key,event.modifiers,false)

//                    text="A"
                }
                onTextChanged: {

                    keyCode=text.charCodeAt(text.length-1)
                    console.log(text.charAt(text.length-1))
                    console.log("text "+keyboardText.text+" char "+text.charAt(text.length-1)+" CHARCODE "+keyCode+" textlength"+text.length+"textsize"+textSize+"extremous"+Qt.Key_A+" "+Qt.Key_Z)
                    if(text.length>textSize)
                    {
                        console.log("screenInterface.vnckey "+text.charAt(text.length-1))
                        screenInterface.vncKey(text.charAt(text.length-1))
                    }


                    textSize=text.length



                }
            }

        }

    }

}


