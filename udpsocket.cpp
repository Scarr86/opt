#include "udpsocket.h"

UdpClient::UdpClient(QObject* pobj): QObject(pobj) {
    pipAddrTextField = pobj->findChild<QObject*>("ipAddr");
    pportTextField = pobj->findChild<QObject*>("port");
    pconnectionIndicatorStyle = pobj->findChild<QObject*>("connectionIndicatorStyle");
    pconnectionIndicatorLabel = pobj->findChild<QObject*>("connectionIndicatorLabel");
    pportText = pobj->findChild<QObject*>("portText");
    pipAddrText = pobj->findChild<QObject*>("ipAddrText");
    plogTextArea = pobj->findChild<QObject*>("logTextArea");
    qDebug() << plogTextArea;
    pprmB1Indicator = pobj->findChild<QObject*>("prmB1IndicatorStyle");
    pprmK1Indicator = pobj->findChild<QObject*>("prmK1IndicatorStyle");
    pprmO1Indicator = pobj->findChild<QObject*>("prmO1IndicatorStyle");
    pprmB2Indicator = pobj->findChild<QObject*>("prmB2IndicatorStyle");
    pprmK2Indicator = pobj->findChild<QObject*>("prmK2IndicatorStyle");
    pprmO2Indicator = pobj->findChild<QObject*>("prmO2IndicatorStyle");
    ppssdIndicator = pobj->findChild<QObject*>("pssdIndicatorStyle");
    pbasket1Indicator = pobj->findChild<QObject*>("basket1IndicatorStyle");
    pbasket2Indicator = pobj->findChild<QObject*>("basket2IndicatorStyle");
    ps1tgIndicator = pobj->findChild<QObject*>("s1tgIndicatorStyle");
    paksIndicator = pobj->findChild<QObject*>("aksIndicatorStyle");
    pirpsIndicator = pobj->findChild<QObject*>("irpsIndicatorStyle");
    pethIndicator = pobj->findChild<QObject*>("ethIndicatorStyle");
    paruIndicator = pobj->findChild<QObject*>("aruIndicatorStyle");
    pantennaIndicator = pobj->findChild<QObject*>("antennaIndicatorStyle");
    pantennaText = pobj->findChild<QObject*>("antennaText");
    ppmyIndicator = pobj->findChild<QObject*>("pmyIndicatorStyle");
    ppmyText = pobj->findChild<QObject*>("pmyText");
    ptermIndicator = pobj->findChild<QObject*>("termIndicatorStyle");
    ptermText = pobj->findChild<QObject*>("termText");
    pmalyyShleyfIndicator = pobj->findChild<QObject*>("malyyShleyfIndicatorStyle");
    pmalyyShleyfText = pobj->findChild<QObject*>("malyyShleyfText");
    pksvIndicator = pobj->findChild<QObject*>("ksvIndicatorStyle");
    pksvText = pobj->findChild<QObject*>("ksvText");
    pchPrdIndicator = pobj->findChild<QObject*>("chPrdIndicatorStyle");
    pchPrdText = pobj->findChild<QObject*>("chPrdText");
    pbasketLabel = pobj->findChild<QObject*>("basketLabel");
    pftsIndicator = pobj->findChild<QObject*>("ftsIndicatorStyle");
    pftsText = pobj->findChild<QObject*>("ftsText");
    pcmdExeFlagText = pobj->findChild<QObject*>("cmdExeFlagText");
    perrText = pobj->findChild<QObject*>("errText");
    //pmsgHighlighter = new MsgHighlighter(static_cast<QQuickTextDocument*>(plogTextArea)->textDocument());
    pudpSocket = new QUdpSocket(this);
    ptimer = new QTimer(this);
    ptimer->setInterval(1000);
    loadSettings();
    msgCounter = 1;

    connect(pudpSocket, &QUdpSocket::readyRead, this, &UdpClient::receiveData);
    connect(pudpSocket, QOverload<QAbstractSocket::SocketError>::of(&QAbstractSocket::error), this, &UdpClient::errorHandler);
    connect(ptimer, &QTimer::timeout, this, &UdpClient::retryRequest);
    createConnect();
    requestCheckLY();
}

UdpClient::~UdpClient() {
    if(ptimer->isActive()) ptimer->stop();
    delete this;
}

void UdpClient::createConnect() {
    isConnectionCreated = false;
    ptimer->start();
    retryCounter = 0;
}

void UdpClient::sendData(QByteArray &data) {
    lastMsg = data;
    qint8 senderFlag;
    senderFlag = pudpSocket->writeDatagram(data, QHostAddress(this->ipAddr), this->port);
    emit sendToLogTextArea("<< " + baToStr(data));
    if(senderFlag == -1) qDebug() << "Ошибка передачи данных";
    else qDebug() << "Пакет отправлен";
    if (!ptimer->isActive()) createConnect();
    if(retryCounter == 2) {
        emit sendToLogTextArea("");
        retryCounter = 0;
        if(msgCounter != 15) msgCounter++;
        else msgCounter = 1;
        if (pconnectionIndicatorLabel) pconnectionIndicatorLabel->setProperty("text", "Соединение не установлено");
        if (pconnectionIndicatorStyle) pconnectionIndicatorStyle->setProperty("color", error);
    } else {
        retryCounter++;
        if (pconnectionIndicatorLabel) pconnectionIndicatorLabel->setProperty("text", "Установка соединения...");
        if (pconnectionIndicatorStyle) pconnectionIndicatorStyle->setProperty("color", "#ecb612");
    }
    if(pcmdExeFlagText) pcmdExeFlagText->setProperty("text", " ");
    if(perrText) perrText->setProperty("text", " ");
}

void UdpClient::receiveData() {
    lastMsg.clear();
    qDebug() << "Пакет принят";
    do {
        receiveBuffer.resize(pudpSocket->pendingDatagramSize());
        pudpSocket->readDatagram(receiveBuffer.data(), receiveBuffer.size());
    }while(pudpSocket->hasPendingDatagrams());
    emit sendToLogTextArea(">> " + baToStr(receiveBuffer) + "\n");

    parsingMsg(receiveBuffer);
}


void UdpClient::updateSettings(QString ipAddr, QString port) {
    this->ipAddr = ipAddr;
    this->port = port.toInt();
    settings.setValue("fly-sfera-spd/netSettings/ipAddr", this->ipAddr);
    settings.setValue("fly-sfera-spd/netSettings/port", this->port);
    if (pipAddrText) pipAddrText->setProperty("text", ipAddr);
    if (pportText) pportText->setProperty("text", port);
    if (!ptimer->isActive()) createConnect();
    requestCheckLY();
}

void UdpClient::requestCheckLY() {
    QByteArray data;
    data.resize(9);
    data = createHdr(ID_SFERA, ID_PC, MSG_HDR_LEN + 2, 0, REQUEST_MSG, msgCounter | (CM_RD_DATA << 4), CMD_CNTRL);
    data[7] = 0x0b;
    data[8] = 0;
    sendData(data);
}

void UdpClient::requestMode() {
    QByteArray data;
    data = createHdr(ID_SFERA, ID_PC, MSG_HDR_LEN, 0, REQUEST_MSG, msgCounter | (CM_RD_DATA << 4), CMD_MODE);
    sendData(data);
}

void UdpClient::retryRequest() {
    QByteArray ba;//дополнительный массив для редактирования номера сообщения в повторе

    ba = lastMsg.left(5);
    ba.append(msgCounter | (lastMsg[5] & 0xF0));
    ba.append(lastMsg.right(lastMsg.size() - 6));
    sendData(ba);
}

void UdpClient::loadSettings() {
   ipAddr = settings.value("fly-sfera-spd/netSettings/ipAddr", "0.0.0.0").toString();
   port = settings.value("fly-sfera-spd/netSettings/port", 0).toInt();

   if (pipAddrTextField) pipAddrTextField->setProperty("text", ipAddr);
   if (pportTextField) pportTextField->setProperty("text", port);
   if (pipAddrText) pipAddrText->setProperty("text", ipAddr);
   if (pportText) pportText->setProperty("text", port);
}

void UdpClient::errorHandler() {
    qDebug() << "Сокет: " + pudpSocket->errorString();
}

QString UdpClient::baToStr(QByteArray &ba) {
    QString out, tmp;

    tmp = ba.toHex();
    for(quint16 i = 0; i < tmp.length(); ++i)
    {
        out += tmp[i++];
        if(i < tmp.length())
        {
            out += tmp[i];
            out += ' ';
        }
    }

    return out;
}

QByteArray UdpClient::createHdr(quint8 idReceiver, quint8 idSender, quint8 lenMb, quint8 lenSb, quint8 type,
                               quint8 prisAndNum, quint8 numCmd) {
   QByteArray baHdr;
   baHdr.append(idReceiver);
   baHdr.append(idSender);
   baHdr.append(lenMb);
   baHdr.append(lenSb);
   baHdr.append(type);
   baHdr.append(prisAndNum);
   baHdr.append(numCmd);

   return baHdr;
}

void UdpClient::parsingMsg(QByteArray &msg) {
    if(static_cast<quint8>(msg[0]) == ID_PC && static_cast<quint8>(msg[1]) == ID_SFERA &&
       static_cast<quint8>(msg[4]) == RESPONSE_MSG) {
        switch(((msg[5] & 0xF0) >> 4)) {//Признак исполнения
        case CEF_ENABLE_INFOPART:
            if(pcmdExeFlagText) pcmdExeFlagText->setProperty("text", "В ответном сообщении присутствует информационная часть");
            switch (msg[6]) {//Номер команды
            case CMD_MODE://Режим работы
                mode.b1Basket1 = msg[7];
                mode.k1Basket1 = msg[7] >> 2;
                mode.o1Basket1 = msg[7] >> 4;
                mode.basket1 = msg[7] >> 6;
                mode.b2Basket1 = msg[8];
                mode.k2Basket1 = msg[8] >> 2;
                mode.o2Basket1 = msg[8] >> 4;
                mode.ftsBasket1 = msg[8] >> 6;
                mode.pmy = msg[10];
                mode.antenna = msg[11];
                mode.chPrd = msg[11] >> 3;
                mode.ksv = msg[11] >> 4;
                mode.malyyShleyf = msg[11] >> 8;
                mode.term = msg[11] >> 5;
                mode.aks = msg[18];
                mode.irps = msg[18] >> 2;
                mode.pssD = msg[18] >> 4;
                mode.eth = msg[18] >> 6;
                mode.aru = msg[19];
                mode.basket2 = msg[19] >> 2;
                mode.s1tg = msg[19] >> 6;
                mode.b1Basket2 = msg[22];
                mode.k1Basket2 = msg[22] >> 2;
                mode.o1Basket2 = msg[22] >> 4;
                mode.basket2 = msg[22] >> 6;
                mode.b2Basket2 = msg[23];
                mode.k2Basket2 = msg[23] >> 2;
                mode.o2Basket2 = msg[23] >> 4;
                mode.ftsBasket2 = msg[23] >> 6;
                displayMode();
                break;
            }
            break;
        case CEF_MSG_REC_OK:
            if(pcmdExeFlagText) pcmdExeFlagText->setProperty("text", "Сообщение принято без ошибок");
            break;
        case CEF_MSG_UNKNOWN:
            if(pcmdExeFlagText) pcmdExeFlagText->setProperty("text", "Сообщение неизвестно");
            break;
        case CEF_MSG_ERR_DATA:
            if(pcmdExeFlagText) pcmdExeFlagText->setProperty("text", "Ошибка данных сообщения");
            break;
        case CEF_PROC_MSG:
            if(pcmdExeFlagText) pcmdExeFlagText->setProperty("text", "Идет обработка сообщения");
            break;
        case CEF_PRD_RDY:
            if(pcmdExeFlagText) pcmdExeFlagText->setProperty("text", "Передатчик готов к приему данных");
            break;
        case CEF_CHECK_LY:
            if(pcmdExeFlagText) pcmdExeFlagText->setProperty("text", "Проверка ЛУ");
            break;
        case CEF_CMD_UNFUL:
            if(pcmdExeFlagText) pcmdExeFlagText->setProperty("text", "Команда не выполнена:");
            switch(msg[7]) {//Признак ошибки
            case ERR_INTRF_NOT_RESPOND:
                if(perrText) perrText->setProperty("text", "интерфейс не отвечает");
                break;
            case ERR_PRD_ON:
                if(perrText) perrText->setProperty("text", "включен режим ПЕРЕДАЧА");
                break;
            case ERR_CNTRL_ON:
                if(perrText) perrText->setProperty("text", "включен режим КОНТРОЛЬ");
                break;
            case ERR_VBAY_ON:
                if(perrText) perrText->setProperty("text", "подключено ВБАУ");
                break;
            case ERR_OVERHEAT:
                if(perrText) perrText->setProperty("text", "перегрев");
                break;
            case ERR_PMY_OMITTED:
                if(perrText) perrText->setProperty("text", "ПМУ опущено");
                break;
            case ERR_BP_PRD_OFF:
                if(perrText) perrText->setProperty("text", "блок питания ПРД выключен");
                break;
            case ERR_ALL_BASKET_ON:
                if(perrText) perrText->setProperty("text", "включены обе корзины приемников");
                break;
            case ERR_RADIO_SILENCE_ON:
                if(perrText) perrText->setProperty("text", "включен режим РАДИОМОЛЧАНИЯ");
                break;
            case ERR_NO_RD:
                if(perrText) perrText->setProperty("text", "нет радиоданных");
                break;
            default:
                if(perrText) perrText->setProperty("text", "необработанный признак ошибки");
                break;
            }
            break;
        }

        //Перенести в отдельный метод?
        isConnectionCreated = true;
        retryCounter = 0;
        if(pconnectionIndicatorLabel) pconnectionIndicatorLabel->setProperty("text", "Соединение установлено");
        if(pconnectionIndicatorStyle) pconnectionIndicatorStyle->setProperty("color", success);
        if(ptimer->isActive()) ptimer->stop();
    }
}

void UdpClient::setModeIndicator(QObject* pobj, quint8 block) {
    switch(block){
    case 0: pobj->setProperty("color", inactive);break;
    case 1: pobj->setProperty("color", error);break;
    case 2: pobj->setProperty("color", success);break;
    }
}

void UdpClient::displayMode() {
    if(mode.basket1 != 0) {
        setModeIndicator(pprmB1Indicator, mode.b1Basket1);
        setModeIndicator(pprmK1Indicator, mode.k1Basket1);
        setModeIndicator(pprmO1Indicator, mode.o1Basket1);
        setModeIndicator(pprmB2Indicator, mode.b2Basket1);
        setModeIndicator(pprmK2Indicator, mode.k2Basket1);
        setModeIndicator(pprmO2Indicator, mode.o2Basket1);
        if(mode.basket1 == 1) pbasketLabel->setProperty("text", "Корзина 1 неисправна");
        else pbasketLabel->setProperty("text", "Корзина 1 включена");
        switch(mode.ftsBasket1) {
        case 0:
            pftsIndicator->setProperty("color", inactive);
            pftsText->setProperty("text", "Выход отключен");
            break;
        case 1:
            pftsIndicator->setProperty("color", error);
            pftsText->setProperty("text", "Неисправен");
            break;
        case 2:
            pftsIndicator->setProperty("color", success);
            pftsText->setProperty("text", "Исправен");
            break;
        }
    } else if(mode.basket2 != 0) {
        setModeIndicator(pprmB1Indicator, mode.b1Basket2);
        setModeIndicator(pprmK1Indicator, mode.k1Basket2);
        setModeIndicator(pprmO1Indicator, mode.o1Basket2);
        setModeIndicator(pprmB2Indicator, mode.b2Basket2);
        setModeIndicator(pprmK2Indicator, mode.k2Basket2);
        setModeIndicator(pprmO2Indicator, mode.o2Basket2);
        if(mode.basket2 == 1) pbasketLabel->setProperty("text", "Корзина 2 неисправна");
        else pbasketLabel->setProperty("text", "Корзина 2 включена");
        switch(mode.ftsBasket2) {
        case 0:
            pftsIndicator->setProperty("color", inactive);
            pftsText->setProperty("text", "Выход отключен");
            break;
        case 1:
            pftsIndicator->setProperty("color", error);
            pftsText->setProperty("text", "Неисправен");
            break;
        case 2:
            pftsIndicator->setProperty("color", success);
            pftsText->setProperty("text", "Исправен");
            break;
        }
    } else {
        setModeIndicator(pprmB1Indicator, 0);
        setModeIndicator(pprmK1Indicator, 0);
        setModeIndicator(pprmO1Indicator, 0);
        setModeIndicator(pprmB2Indicator, 0);
        setModeIndicator(pprmK2Indicator, 0);
        setModeIndicator(pprmO2Indicator, 0);
        pbasketLabel->setProperty("text", "Ни одна из корзин не включена");
    }
    setModeIndicator(ppssdIndicator, mode.pssD);
    setModeIndicator(pbasket1Indicator, mode.basket1);
    setModeIndicator(pbasket2Indicator, mode.basket2);
    setModeIndicator(ps1tgIndicator, mode.s1tg);
    setModeIndicator(paksIndicator, mode.aks);
    setModeIndicator(pirpsIndicator, mode.irps);
    setModeIndicator(pethIndicator, mode.eth);
    setModeIndicator(paruIndicator, mode.aru);
    if(mode.pmy == 1) {
        ppmyIndicator->setProperty("color", success);
        ppmyText->setProperty("text", "Поднято");
    } else {
        ppmyIndicator->setProperty("color", error);
        ppmyText->setProperty("text", "Опущено");
    }
    switch(mode.antenna) {
    case 0:
        pantennaIndicator->setProperty("color", success);
        pantennaText->setProperty("text", "Штатная");
        break;
    case 1:
        pantennaIndicator->setProperty("color", success);
        pantennaText->setProperty("text", "ВБАУ");
        break;
    case 2:
        pantennaIndicator->setProperty("color", error);
        pantennaText->setProperty("text", "Включен режим «РАДИОМОЛЧАНИЕ»");
        break;
    }
    if(mode.chPrd == 1) {
        pchPrdIndicator->setProperty("color", error);
        pchPrdText->setProperty("text", "Занят");
    } else {
        pchPrdIndicator->setProperty("color", success);
        pchPrdText->setProperty("text", "Свободен");
    }
    if(mode.ksv == 1) {
        pksvIndicator->setProperty("color", error);
        pksvText->setProperty("text", "Не в норме");
    } else {
        pksvIndicator->setProperty("color", success);
        pksvText->setProperty("text", "В норме");
    }
    if(mode.malyyShleyf == 1) {
        pmalyyShleyfIndicator->setProperty("color", success);
        pmalyyShleyfText->setProperty("text", "Установлен");
    } else {
        pmalyyShleyfIndicator->setProperty("color", inactive);
        pmalyyShleyfText->setProperty("text", "Не установлен");
    }
    if(mode.term == 1) {
        ptermIndicator->setProperty("color", error);
        ptermText->setProperty("text", "Неисправно");
    } else {
        ptermIndicator->setProperty("color", success);
        ptermText->setProperty("text", "Исправно");
    }
}
