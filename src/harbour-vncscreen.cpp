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

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif
#include <QtQml>
#include <sailfishapp.h>
#include <QQmlEngine>
#include <QScopedPointer>
#include <QQuickView>
#include <QGuiApplication>
#include "interfacerfb.h"
#include "interfacesettings.h"
#include "screenprovider.h"
//#include "vncclientthread.h"

int main(int argc, char *argv[])
{

    QGuiApplication* application = SailfishApp::application(argc, argv);
    application->setApplicationVersion(APP_VERSION);
    application->setOrganizationName("Marcello Di Guglielmo");
//    QString country=QLocale::system().name();
//    QString appTranslationFile=QString("%1-%2.qm").arg(application->applicationName().toLower()).arg(country);
//    qDebug()<<"appTranslationFile"<<appTranslationFile;
//    QTranslator translator;
//    if(translator.load(appTranslationFile,QString("/usr/share/%1/translations").arg(application->applicationName().toLower())))
//    {
//        qDebug()<<"translation load";
//        application->installTranslator(&translator);
//    }

    QScopedPointer<QGuiApplication> app(application);
    QScopedPointer<QQuickView> v(SailfishApp::createView());
    qmlRegisterType<InterfaceRFB>("harbour.vncscreen.InterfaceRFB", 1, 0, "InterfaceRFB");
    qmlRegisterType<InterfaceSettings>("harbour.vncscreen.InterfaceSettings", 1, 0, "InterfaceSettings");
    QQmlEngine *engine=v->engine();
    ScreenProvider *screenProvider= new ScreenProvider(QQmlImageProviderBase::Image);
    engine->addImageProvider(QLatin1String("rfbimage"),screenProvider);
    //importante mettere i setSource dopo la configurazione degli engine
    v->setSource(SailfishApp::pathTo("qml/harbour-vncscreen.qml"));
    v->show();
    return app->exec();

    //return SailfishApp::main(argc, argv);
}

