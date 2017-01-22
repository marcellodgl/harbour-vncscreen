/****************************************************************************
**
** Copyright (C) 2007-2008 Urs Wolfer <uwolfer @ kde.org>
**
** This file is part of KDE.
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; see the file COPYING. If not, write to
** the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
** Boston, MA 02110-1301, USA.
**
****************************************************************************/

#include "vncclientthread.h"

#include <QMutexLocker>
#include <QTimer>

static QString outputErrorMessageString;


#define MAX_COLOR_DEPTH 32

rfbBool VncClientThread::newclient(rfbClient *cl)
{

    VncClientThread *t = (VncClientThread*)rfbClientGetClientData(cl, 0);
    qDebug()<<"newclient quality()"<<t->quality();
    Q_ASSERT(t);

    switch (t->quality())
    {
    case VncClientThread::High:
        cl->format.bitsPerPixel = MAX_COLOR_DEPTH;
        cl->appData.useBGR233 = 0;
        cl->appData.encodingsString = "copyrect hextile raw";
        cl->appData.compressLevel = 0;
        cl->appData.qualityLevel = 9;
        break;
    case VncClientThread::Medium:
        cl->format.bitsPerPixel = 16;
        cl->appData.useBGR233 = 0;
        cl->appData.encodingsString = "tight zrle ultra copyrect hextile zlib corre rre raw";
        cl->appData.compressLevel = 5;
        cl->appData.qualityLevel = 7;
        break;
    case VncClientThread::Low:
    case VncClientThread::Unknown:
    default:

        cl->format.bitsPerPixel = 16; //TODO: add support for 8bit (needs color map)
        cl->appData.encodingsString = "tight zrle ultra copyrect hextile zlib corre rre raw";
        cl->appData.compressLevel = 9;
        cl->appData.qualityLevel = 1;
    }
    qDebug()<<"bitperpixel"<<cl->format.bitsPerPixel<<"encodingString"<<cl->appData.encodingsString<<"compresslevel"<<cl->appData.compressLevel<<"qualitylevel"<<cl->appData.qualityLevel;
    if(cl->format.bitsPerPixel == 16) {
        cl->format.depth = 16; //number of useful bits in the pixel value
        cl->format.redShift = 11;
        cl->format.greenShift = 5;
        cl->format.blueShift = 0;
        cl->format.redMax = 0x1f;
        cl->format.greenMax = 0x3f;
        cl->format.blueMax = 0x1f;
    } else {
        cl->format.depth = 24; //number of useful bits in the pixel value
        cl->format.redShift = 16;
        cl->format.greenShift = 8;
        cl->format.blueShift = 0;
        cl->format.redMax = 0xff;
        cl->format.greenMax = 0xff;
        cl->format.blueMax = 0xff;
    }

    if (t->frameBuffer)
        delete [] t->frameBuffer; // do not leak if we get a new framebuffer size
    const int size = cl->width * cl->height * (cl->format.bitsPerPixel / 8);
    t->frameBuffer = new uint8_t[size];
    cl->frameBuffer = t->frameBuffer;
    memset(cl->frameBuffer, '\0', size);


    SetFormatAndEncodings(cl);

    return true;
}

void VncClientThread::updatefb(rfbClient* cl, int x, int y, int w, int h)
{

//    qDebug() << "updated client: x: " << x << ", y: " << y << ", w: " << w << ", h: " << h;
    const QImage img(
            cl->frameBuffer,
            cl->width,
            cl->height,
            (cl->format.bitsPerPixel==16)?QImage::Format_RGB16:QImage::Format_RGB32
    );

    if (img.isNull()) {
        qDebug()<<"image not loaded";
    }

    VncClientThread *t = (VncClientThread*)rfbClientGetClientData(cl, 0);
    Q_ASSERT(t);

    t->setImage(img);

    t->emitUpdated(x, y, w, h);

}

void VncClientThread::cuttext(rfbClient* cl, const char *text, int textlen)
{
    const QString cutText = QString::fromUtf8(text, textlen);

    qDebug()<<"cuttext: " << cutText;
    if (!cutText.isEmpty()) {
        VncClientThread *t = (VncClientThread*)rfbClientGetClientData(cl, 0);
        Q_ASSERT(t);

//        t->emitGotCut(cutText);
    }
}

char *VncClientThread::passwdHandler(rfbClient *cl)
{

    VncClientThread *t = (VncClientThread*)rfbClientGetClientData(cl, 0);
    Q_ASSERT(t);
    qDebug()<<"VncClientThread"<<t;
    t->m_passwordError = true;
    t->setPriority(QThread::IdlePriority);
    t->emitPasswordRequest();
    t->m_passwordWaiting=1;



    qDebug()<<"password request with password"<<t->password();
    return strdup(t->password().toLocal8Bit());
}

void VncClientThread::setPassword(const QString &password)
{
//    if(password.isNull()) //cancelled, don't retry
//        m_passwordError = false;
    setPriority(QThread::InheritPriority);
    m_passwordWaiting=false;
    m_password = password;
}

void VncClientThread::outputHandler(const char *format, ...)
{
    va_list args;
    va_start(args, format);

    QString message;
    message.vsprintf(format, args);

    va_end(args);

    message = message.trimmed();

    qDebug()<< message;

}

VncClientThread::VncClientThread(int argc, char *argv[],QObject *parent)
    : QThread(parent)
    , frameBuffer(0)
{
    QMutexLocker locker(&mutex);
    m_stopped = false;
    argv1=argv;
    argc1=argc;
    m_passwordWaiting=false;
}

VncClientThread::~VncClientThread()
{
//    stop();

//    const bool quitSuccess = wait(4000);

//    if(!quitSuccess)
//        kDebug(5011) << "~VncClientThread(): Quit failed";

    delete [] frameBuffer;
    //cl is free()d when event loop exits.
}

void VncClientThread::checkOutputErrorMessage()
{
    if (!outputErrorMessageString.isEmpty()) {
        QString errorMessage = outputErrorMessageString;
        outputErrorMessageString.clear();
        // show authentication failure error only after the 3rd unsuccessful try
//        if ((errorMessage != i18n("VNC authentication failed.")) || m_passwordError)
//            emit outputErrorMessage(errorMessage);
    }
}

void VncClientThread::setHost(const QString &host)
{
    QMutexLocker locker(&mutex);
    m_stopped=false;
    m_host = host;
}

void VncClientThread::setPort(int port)
{
    QMutexLocker locker(&mutex);
    m_port = port;
}

void VncClientThread::setUrlPath(const QUrl urlPath)
{
    QMutexLocker locker(&mutex);
    m_stopped=false;
    m_host = urlPath.host();
    m_port=urlPath.port();
}




void VncClientThread::setQuality(VncClientThread::Quality quality)
{
    m_quality = quality;
}

VncClientThread::Quality VncClientThread::quality() const
{
    return m_quality;
}

void VncClientThread::setImage(const QImage &img)
{
    QMutexLocker locker(&mutex);
    m_image = img;
}

const QImage VncClientThread::image(int x, int y, int w, int h)
{
    QMutexLocker locker(&mutex);

    if (w == 0) // full image requested
        return m_image;
    else
        return m_image.copy(x, y, w, h);
}

void VncClientThread::emitUpdated(int x, int y, int w, int h)
{
    emit imageUpdated(x, y, w, h);
}

void VncClientThread::emitPasswordRequest()
{
    qDebug()<<"emitPasswordRequest()";
    emit passwordRequest();
}

//void VncClientThread::emitGotCut(const QString &text)
//{
//    emit gotCut(text);
//}

void VncClientThread::stop()
{
    if(m_stopped)
        return;

    //also abort listening for connections, should be safe without locking
    if(listen_port)
        cl->listenSpecified = false;

    QMutexLocker locker(&mutex);
    m_stopped = true;
    m_passwordWaiting=false;
}

void VncClientThread::run()
{
    sleep(2);
    QMutexLocker locker(&mutex);
    m_password=QString();
    int passwd_failures = 0;
    while (!m_stopped)
    {
        // try to connect as long as the server allows
        m_passwordError = false;
        outputErrorMessageString.clear(); //don't deliver error messages of old instances...
        rfbClientLog = outputHandler;
        rfbClientErr = outputHandler;
        cl = rfbGetClient(8, 3, 4); // bitsPerSample, samplesPerPixel, bytesPerPixel
        cl->MallocFrameBuffer = newclient;
        cl->canHandleNewFBSize = true;
        cl->GetPassword = passwdHandler;
        cl->GotFrameBufferUpdate = updatefb;
        cl->GotXCutText = cuttext;

        rfbClientSetClientData(cl, 0, this);

        cl->serverHost = strdup(m_host.toUtf8().constData());

        if (m_port < 0 || !m_port) // port is invalid or empty...
            m_port = 5900; // fallback: try an often used VNC port

        if (m_port >= 0 && m_port < 100) // the user most likely used the short form (e.g. :1)
            m_port += 5900;
        cl->serverPort = m_port;

        listen_port=5500;
        cl->listenSpecified = rfbBool(listen_port > 0);
        cl->listenPort = listen_port;
        qDebug()<<"server host"<<cl->serverHost<<"server Port"<<cl->serverPort<<"password"<<m_password;
        bool connectOk=ConnectToRFBServer(cl,cl->serverHost,cl->serverPort);
        qDebug()<<"parametri ok="<<connectOk;

        qDebug()<< "--------------------- trying init ---------------------";

        while(m_passwordWaiting)
        {


        }

        if (rfbInitClient(cl,0 ,0))
        {
            qDebug()<<"entra nel break";
            break;
        }


        qDebug()<<"init failed password error"<<m_passwordError;

        //init failed...
        if (m_passwordError) {
            qDebug()<<"password error"<<m_password;
            passwd_failures++;
            if(passwd_failures < 3)
                continue; //that's ok, try again
        }

//        //stop connecting
        m_stopped = true;
        qDebug()<<"finisce il tentativo";
        emit disconnected();
        return; //no cleanup necessary, cl was free()d by rfbInitClient()

    }


    locker.unlock();
    qDebug()<<"loop successivo";
    m_stopped=false;
    // Main VNC event loop

    emit connected();
    while (!m_stopped) {


        const int i = WaitForMessage(cl, 500);
        if(m_stopped or i < 0)

            break;
//        qDebug()<<"HandleRFBServerMessage"<<i;
        if (i)
        {
            if (!HandleRFBServerMessage(cl))
                break;

        }
        locker.relock();

        while (!m_eventQueue.isEmpty()) {
            ClientEvent* clientEvent = m_eventQueue.dequeue();
            clientEvent->fire(cl);
            delete clientEvent;
        }

        locker.unlock();
    }

    // Cleanup allocated resources
    locker.relock();
    rfbClientCleanup(cl);
    m_stopped = true;
    emit disconnected();

}

ClientEvent::~ClientEvent()
{
}

void PointerClientEvent::fire(rfbClient* cl)
{
    SendPointerEvent(cl, m_x, m_y, m_buttonMask);
}

void KeyClientEvent::fire(rfbClient* cl)
{
    SendKeyEvent(cl, m_key, m_pressed);
}

//void ClientCutEvent::fire(rfbClient* cl)
//{
//    SendClientCutText(cl, text.toUtf8().data(), text.size());
//}

void VncClientThread::mouseEvent(int x, int y, int buttonMask)
{
    QMutexLocker lock(&mutex);
    if (m_stopped)
        return;

    m_eventQueue.enqueue(new PointerClientEvent(x, y, buttonMask));
}

void VncClientThread::keyEvent(int key, bool pressed)
{
    QMutexLocker lock(&mutex);
    if (m_stopped)
        return;

    m_eventQueue.enqueue(new KeyClientEvent(key, pressed));
}

//void VncClientThread::clientCut(const QString &text)
//{
//    QMutexLocker lock(&mutex);
//    if (m_stopped)
//        return;

//    m_eventQueue.enqueue(new ClientCutEvent(text));
//}
