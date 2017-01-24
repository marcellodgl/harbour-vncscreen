#include "interfacesettings.h"

InterfaceSettings::InterfaceSettings(QObject *parent) : QObject(parent)
{
    settings=new QSettings();
}

QVariant InterfaceSettings::value(QString key)
{
    QVariant settingsValue=settings->value(key);
    return settingsValue;
}

void InterfaceSettings::setValue(QString key,QVariant value)
{
    qDebug()<<"value type"<<value.type();
    settings->setValue(key,value);
}

