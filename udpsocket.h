#ifndef UDPSOCKET_H
#define UDPSOCKET_H
#include <QtCore>
#include <QtNetwork/QUdpSocket>
#include <QString>
#include <QSettings>
#include <QQmlApplicationEngine>
#include <QQuickTextDocument>

#include "main.h"
#include "msghighlighter.h"

class UdpClient: public QObject{    
Q_OBJECT
public:
    QUdpSocket* pudpSocket;
    quint16 port;
    QString ipAddr;
    explicit UdpClient(QObject* pobj=0);
    ~UdpClient();
    Q_INVOKABLE void createConnect();
private:
    QByteArray sendBuffer;
    QByteArray receiveBuffer;
    QByteArray lastMsg;
    QSettings settings;
    QObject* pipAddrTextField;
    QObject* pportTextField;
    QObject* pconnectionIndicatorStyle;
    QObject* pconnectionIndicatorLabel;
    QObject* pipAddrText;
    QObject* pportText;
    QObject* plogTextArea;
    QObject* pprmB1Indicator;
    QObject* pprmK1Indicator;
    QObject* pprmO1Indicator;
    QObject* pprmB2Indicator;
    QObject* pprmK2Indicator;
    QObject* pprmO2Indicator;
    QObject* ppssdIndicator;
    QObject* pbasket1Indicator;
    QObject* pbasket2Indicator;
    QObject* paruIndicator;
    QObject* ps1tgIndicator;
    QObject* paksIndicator;
    QObject* pirpsIndicator;
    QObject* pethIndicator;
    QObject* pantennaIndicator;
    QObject* pantennaText;
    QObject* ppmyIndicator;
    QObject* ppmyText;
    QObject* ptermIndicator;
    QObject* ptermText;
    QObject* pmalyyShleyfIndicator;
    QObject* pmalyyShleyfText;
    QObject* pksvIndicator;
    QObject* pksvText;
    QObject* pchPrdIndicator;
    QObject* pchPrdText;
    QObject* pbasketLabel;
    QObject* pftsIndicator;
    QObject* pftsText;
    QObject* pcmdExeFlagText;
    QObject* perrText;
    MsgHighlighter* pmsgHighlighter;
    QString success = "#28af2f";
    QString error = "#f22929";
    QString inactive = "#5f5f5f";
    QTimer* ptimer;
    bool isConnectionCreated;
    quint8 msgCounter:4;
    quint8 retryCounter:2;
    mode_tt mode;
    void loadSettings();
    QString baToStr(QByteArray &ba);
    QByteArray createHdr(quint8 idReceiver, quint8 idSender, quint8 lenMb, quint8 lenSb, quint8 type,
                         quint8 prisAndNum, quint8 numCmd);
    void parsingMsg(QByteArray &msg);
    void setModeIndicator(QObject* pobj, quint8 block);
    void displayMode();

public slots:
    void sendData(QByteArray &data);
    void receiveData();
    void requestCheckLY();
    void requestMode();
    void updateSettings(QString ipAddr, QString port);
    void errorHandler();
    void retryRequest();
signals:
    void sendToLogTextArea(QString);
};

#endif // UDPSOCKET_H
