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

#include "interfacerfb.h"

InterfaceRFB::InterfaceRFB(QObject *parent) : QObject(parent)
{

    timer=new QTimer();
    connect(timer,SIGNAL(timeout()),this,SLOT(timerTimeout()));
    timer->setInterval(1000);

    vncThread=new VncClientThread(0,0);
    vncIndex=0;
    connect(vncThread,SIGNAL(passwordRequest()),this,SIGNAL(passwordRequest()));
    connect(vncThread,SIGNAL(connected()),this,SLOT(onConnected()));
    connect(vncThread,SIGNAL(disconnected()),this,SLOT(onDisconnected()));
    connect(vncThread,SIGNAL(imageUpdated(int,int,int,int)),this,SLOT(onImageUpdate(int,int,int,int)));
    keyEventAccepted<<Qt::Key_Control<<Qt::Key_Alt<<Qt::Key_Shift<<Qt::Key_Return<<Qt::Key_Backspace;
}





void InterfaceRFB::setVncpath(QString path)
{
    if(!path.startsWith("vnc://"))
    {
        path.prepend("vnc://");
    }

    urlPath=QUrl(path);
    qDebug()<<"path="<<path<<"host"<<urlPath.host()<<"port"<<urlPath.port()<<"scheme"<<urlPath.scheme();
    vncThread->setUrlPath(urlPath);
    vncThread->start();

}

QString InterfaceRFB::vncpath()
{
    return urlPath.path();
}

void InterfaceRFB::setVncpassword(QString password)
{

    urlPassword=password;
    if(vncThread)
    {
        vncThread->setPassword(urlPassword);
    }
}

QString InterfaceRFB::vncpassword()
{
    return urlPassword;
}



void InterfaceRFB::setVncquality(int quality)
{
    qDebug()<<"quality"<<quality;
    if(quality==1) vncThread->setQuality(VncClientThread::Low);
    else if(quality==2) vncThread->setQuality(VncClientThread::Medium);
    else if(quality==3) vncThread->setQuality(VncClientThread::High);
    else vncThread->setQuality(VncClientThread::Unknown);
}

int InterfaceRFB::vncquality()
{
    if(vncThread->quality()==VncClientThread::Low) return 1;
    else if(vncThread->quality()==VncClientThread::Medium) return 2;
    else if(vncThread->quality()==VncClientThread::High) return 3;
    else return 0;
}

void InterfaceRFB::vncDisconnect()
{
    if(vncThread)
    {
        vncThread->stop();
    }
}

void InterfaceRFB::timerTimeout()
{

}

void InterfaceRFB::vncMouseEvent(int x, int y, int button)
{
//    qDebug()<<"vncMouseEvent x "<<x<<" y "<<y<<" button "<<button;
    vncThread->mouseEvent(x,y,button);
}

void InterfaceRFB::vncKeyEvent(int key, int modifiers, bool pressed)
{
//    qDebug()<<"vncKeyEvent key "<<key<<"modifiers"<<modifiers<<"pressed"<<pressed;
    Q_UNUSED(modifiers);
    if(keyEventAccepted.contains(key))
    {
        int rfbKey=qt2rfbkey(key);
//        qDebug()<<"vncKeyEvent key "<<key<<"rfbKey"<<rfbKey<<"pressed"<<pressed;

        vncThread->keyEvent(rfbKey,pressed);
    }
}

void InterfaceRFB::vncKey(QString key)
{
    if(key.size()==1)
    {
        QKeySequence qtKeySequence=QKeySequence::fromString(key);
        int qtKey=qtKeySequence[0];
         int rfbKey=qt2rfbkey(qtKey);
        QChar charKey=key.at(0);
//        qDebug()<<"key-----------"<<key<<"qtKey"<<qtKey<<"is upper"<<charKey.isUpper();
        if((Qt::Key_A<=qtKey && Qt::Key_Z>=qtKey) && charKey.isUpper())
        {
            rfbKey=rfbKey-0x20;

        }
        vncThread->keyEvent(rfbKey,true);
        vncThread->keyEvent(rfbKey,false);
    }
}



void InterfaceRFB::onConnected()
{
    qDebug()<<"on connected";
    emit vncStatus(Connected);
}

void InterfaceRFB::onDisconnected()
{
    emit vncStatus(Disconnected);
}

void InterfaceRFB::onImageUpdate(int x, int y, int w, int h)
{
    QImage image=vncThread->image(0 , 0 , 0 ,  0);
    ScreenProvider::setScreenImage(image);
//    qDebug()<<"getimage x"<<x<<" y "<<y<<" w "<<w<<" h "<<h;
    emit vncImageUpdate(vncIndex);
    vncIndex++;
}

