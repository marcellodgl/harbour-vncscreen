#ifndef INTERFACESETTINGS_H
#define INTERFACESETTINGS_H
#include <QSettings>
#include <QDebug>
class InterfaceSettings: public QObject
{
    Q_OBJECT
public:
    InterfaceSettings(QObject *parent = 0);
    Q_INVOKABLE QVariant value(QString key);
signals:

public slots:
    void setValue(QString key,QVariant value);
private:
    QSettings *settings;
};

#endif // INTERFACESETTINGS_H
