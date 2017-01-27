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
import harbour.vncscreen.InterfaceSettings 1.0
// property var serverField. Then inside urlField: Component.onCompleted: serverField = urlField. Access that field by serverField
Dialog {
    property string connectionUrl: ""
    property int screenQuality: 0
    property var historyList: []

    id: connectDialog

    function readModelList(){


    }



    InterfaceSettings {
        id:settingsConfiguration

    }


    onOpened: {
        historyList=settingsConfiguration.value("urlHistory")

        for(var i=0;i<historyList.length;i++)
        {
            historyModel.append({"connectionUrl":historyList[i]})
        }

    }


    onAccepted: {
        historyList=[]
        for(var i=0;i<historyModel.count;i++)
        {
            var listElement=historyModel.get(i)
            historyList[i]=listElement["connectionUrl"]

        }
        console.log(connectionUrl)
        if(connectionUrl.length>0 )
        {
            if(historyList.indexOf(connectionUrl)!=-1)
            {
                console.log("exist"+historyList.indexOf(connectionUrl))
                historyList.splice(historyList.indexOf(connectionUrl),1)
            }
            console.log(historyList)
            historyList.unshift(connectionUrl)
            settingsConfiguration.setValue("urlHistory",historyList)
        }
    }


    SilicaListView {
        id:silicaView
        anchors.fill: parent
        function setConnectionUrl(urlText)
        {
            headerColumn.urlFieldText=urlText
        }

        header: Column{

            id:headerColumn
            property  alias urlFieldText: urlField.text
            width:parent.width
            //dimensione che sarà seguita dalla lista del historyModel
            height: dialogHeader.height+urlField.height+qualitySlider.height+historyLabel.height+3*Theme.paddingLarge
            DialogHeader{
                id: dialogHeader

                title: qsTr("Connect")
            }
            spacing: Theme.paddingLarge
            TextField{
                id: urlField
                placeholderText: qsTr("VNC Server URL")
                label: qsTr("Url")
                width: parent.width
                EnterKey.onClicked: accept()
                onTextChanged: connectDialog.connectionUrl=text
                text:connectDialog.connectionUrl
            }
            Slider {
                id: qualitySlider
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
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
                onValueChanged: connectDialog.screenQuality=value
                value:1
            }
            Label{
                id:historyLabel
                text:qsTr("Connection history")
                color: Theme.highlightColor
                x:Theme.horizontalPageMargin
            }


        }
        model: ListModel {
            id:historyModel


        }

        delegate: ListItem {
            id:listEntry
            width: parent.width
            Label {
                id:historyLabelUrl
                text: connectionUrl
                anchors.verticalCenter: parent.verticalCenter
                x:Theme.horizontalPageMargin

            }
            onClicked: connectDialog.connectionUrl=historyLabelUrl.text
            menu: ContextMenu{
                MenuItem{
                    text:qsTr("Remove")
                    onClicked: listEntry.remorseAction(qsTr("Deleting"),removeListItem())
                    function removeListItem()
                    {
                        historyModel.remove(model.index)
                    }
                }
            }
        }

        PushUpMenu{
            MenuItem{
                text: qsTr("Clear all")
                onClicked: historyModel.clear()
            }
        }

        VerticalScrollDecorator { }
    }


}


