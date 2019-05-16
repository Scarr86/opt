#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQuickStyle>

#include "udpsocket.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Fusion");

    QQmlApplicationEngine engine;
    /*engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;*/
    QQmlComponent comp(&engine, QUrl("qrc:/main.qml"));
    QObject* pobj = comp.create();

    QObject* pdialog = pobj->findChild<QObject*>("objDialog");
    QObject* pcheckConnectionAction = pobj->findChild<QObject*>("checkConnectionAction");
    QObject* plogTextArea = pobj->findChild<QObject*>("logTextArea");
    QObject* prequestModeButton = pobj->findChild<QObject*>("requestModeButton");

    UdpClient udpClient(pobj);

    QObject::connect(pdialog, SIGNAL(applyBtn(QString, QString)), &udpClient, SLOT(updateSettings(QString, QString)));
    QObject::connect(pcheckConnectionAction, SIGNAL(checkConnectionAction()), &udpClient, SLOT(requestCheckLY()));
    QObject::connect(&udpClient, SIGNAL(sendToLogTextArea(QString)), plogTextArea, SLOT(append(QString)));
    QObject::connect(prequestModeButton, SIGNAL(requestModeBtn()), &udpClient, SLOT(requestMode()));

    return app.exec();
}
