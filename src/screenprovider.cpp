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
#include "screenprovider.h"


//QPixmap ScreenProvider::screenPix;
QImage ScreenProvider::screenImage;


ScreenProvider::ScreenProvider(QQmlImageProviderBase::ImageType type, QQmlImageProviderBase::Flags flags) : QQuickImageProvider(type)
{
    Q_UNUSED(flags);
}

//QPixmap ScreenProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
//{
//    qDebug()<<"requestPixmap"<<id<<"size"<<size<<"requestedSize"<<requestedSize;
//    QPixmap pixmap=QPixmap("/home/nemo/schermata.png");
//    return pixmap;
//}

QImage ScreenProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{


    QImage image=ScreenProvider::screenImage;
    qDebug()<<"requestImage"<<id<<"size"<<size<<"requestedSize"<<requestedSize;
    return image;

}



//void ScreenProvider::setScreenPixmap(QPixmap pix)
//{
//    screenPix=pix;
//}

void ScreenProvider::setScreenImage(QImage img)
{
    screenImage=img;
}



