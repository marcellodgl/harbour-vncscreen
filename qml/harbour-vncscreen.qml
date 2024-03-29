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
import "pages"
import "cover"

ApplicationWindow
{
    id: root
    signal updatePreviewRequest
    function updatePreviewImg(){
        console.log("update Img")
        cover.updateImg()
    }
    property string previewSource

    initialPage: Component {
        MainPage {
            onVncPreviewUpdate: previewSource=source
        }
    }
//    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    cover: Component{


        CoverPage {
            id: coverComponent
            function updateImg(){
                console.log("updateImg")
            }
            iconSource: previewSource

        }

//        Connections{
//            target:
//        }


    }
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All

}


