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

    InterfaceRFB{
        id: screenInterface
        onPasswordRequest: {
            console.log("interfaceRFBPassword request")
            pageStack.push(passwordComponent)

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
        onResolutionChanged: {
            flickableScreen.contentWidth=width
            flickableScreen.contentHeight=height
            screenPinch.currentScale=1
        }

    }

//L'utilizzo del component con innestato il dialog ha il ruolo di rendere il dialog come oggetto temporaneo che viene distrutto a fine utilizzo
//in caso contrario si tratterebbe di un dialog che resta allocato e sarebbe sempre lo stesso nei successivi utilizzi
    Component{
        id:connectComponent
        ConnectPage{
            id : connectDialog
            onAccepted:{
                screenInterface.vncpath=connectionUrl
                screenInterface.vncquality=screenQuality
            }
        }
    }
    Component{
        id:passwordComponent
        PasswordPage{
            id : passwordDialog
            onAccepted:{
                console.log(connectionPassword);
                screenInterface.vncpassword=connectionPassword
            }
        }
    }


    SilicaFlickable {
        anchors.fill: parent
        id: flickableScreen

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
                    pageStack.push(connectComponent)
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
        onMovementEnded:   {
            //            console.log("flick x"+visibleArea.xPosition+"image x"+imageScreen.x)
            keyboardText.x=contentX
            keyboardText.y=contentY
        }
        VerticalScrollDecorator{

        }
        HorizontalScrollDecorator{

        }

//        contentWidth: 1280 ;contentHeight: 800

        Column {
            id: column
            width: page.width

            spacing: Theme.paddingLarge

            PageHeader {
                id:screenHeader
                title: qsTr("VNC Screen")
            }


            PinchArea {
                property real initialWidth
                property real initialHeight
                property real currentScale: 1
                id:screenPinch
                width: Math.max(flickableScreen.contentWidth, flickableScreen.width)
                height: Math.max(flickableScreen.contentHeight, flickableScreen.height)

                Image {
                    id:imageScreen

                    width: flickableScreen.contentWidth
                    height: flickableScreen.contentHeight

//                    source: "qrc:/VncScreen/icons/schermata.png"

                }


                MouseArea{
                    id:mouseControl

                    anchors.fill: imageScreen
                    onPositionChanged: {
                        console.log("movement")
                        console.log("mouse.x"+mouse.x+"mouse.y"+mouse.y+"currentScale"+screenPinch.currentScale)

                        screenInterface.vncMouseEvent(mouse.x/screenPinch.currentScale,mouse.y/screenPinch.currentScale,mouse.buttons)
                    }
                    onPressed:  {
                        console.log("pressed")
                        console.log("mouse.x"+mouse.x+"mouse.y"+mouse.y+"currentScale"+screenPinch.currentScale)
                        screenInterface.vncMouseEvent(mouse.x/screenPinch.currentScale,mouse.y/screenPinch.currentScale,mouse.buttons)
                    }
                    onReleased: {
                        console.log("released")
                        console.log("mouse.x"+mouse.x+"mouse.y"+mouse.y+"currentScale"+screenPinch.currentScale)
                        screenInterface.vncMouseEvent(mouse.x/screenPinch.currentScale,mouse.y/screenPinch.currentScale,mouse.buttons)
                    }

                }

                onPinchStarted: {
                    console.log("pinchstarted pinchscale"+pinch.scale+"currentscale"+screenPinch.currentScale)
                    initialWidth = imageScreen.width
                    initialHeight = imageScreen.height

                }

                onPinchUpdated: {
                    console.log("onPinchUpdated prev center"+pinch.previousCenter.x +"center"+ pinch.center.x+"scale"+pinch.scale)
                    // ref http://doc.qt.io/qt-5/qtquick-touchinteraction-pincharea-flickresize-qml.html
                    //non viene impostato il contentX e contentY perchè altrimenti al resize viene spostata la posizione del riquadro
                    flickableScreen.resizeContent(initialWidth * pinch.scale, initialHeight * pinch.scale, pinch.center)

                }

                onPinchFinished: {
                    console.log("onPinchFinished")
                   screenPinch.currentScale=screenPinch.currentScale*pinch.scale

                    // Move its content within bounds.
                    //                flickableScreen.returnToBounds()
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
}



