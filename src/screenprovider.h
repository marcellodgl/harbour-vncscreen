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
#ifndef SCREENPROVIDER_H
#define SCREENPROVIDER_H

#include <QQuickImageProvider>
#include <QDebug>

class ScreenProvider : public QQuickImageProvider
{
public:
    ScreenProvider(ImageType type, Flags flags = 0);
//    virtual QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);
    virtual QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);
//    static void setScreenPixmap(QPixmap pix);
    static void setScreenImage(QImage img);

signals:

public slots:

private:
//    static QPixmap screenPix;

//    viene adoperato il parametro static perchè dall'oggetto InterfaceRFB (dichiarato nel QML) non è possibile accedere a un
//    oggetto screenprovider, i due tra loro non sono facilmente interlacciabili.
//    con il parametro definito static la variabile può essere settata da qualsiasi posizione bastando che la classe venga inclusa
    static QImage screenImage;
};

#endif // SCREENPROVIDER_H
