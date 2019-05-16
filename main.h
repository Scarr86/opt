#ifndef MAIN_H
#define MAIN_H
#include <QtCore>

//Код сообщения
#define CM_WR_DATA_             0x1
#define CM_RD_DATA              0x2
#define CM_CLR_DATA             0x3
#define CM_CNTRL                0x4
#define CM_TECH_MODE            0x5



//Признаки исполнения команды
#define CEF_ENABLE_INFOPART     0x1
#define CEF_MSG_REC_OK          0x2
#define CEF_MSG_UNKNOWN         0x3
#define CEF_MSG_ERR_DATA        0x4
#define CEF_PROC_MSG            0x5
#define CEF_PRD_RDY             0x6
//#define CEF_ERR_CS                0x7
#define CEF_CHECK_LY            0x8
#define CEF_CMD_UNFUL           0x9

//Номер команды
#define CMD_RD                  0x1
#define CMD_RD_YM               0x2
#define CMD_STATE               0x3
#define CMD_CNTRL               0x4
#define CMD_MODE                0x5
#define CMD_CONFIG              0x6
#define CMD_POWER               0x7
#define CMD_DOP                 0x8
#define CMD_CH                  0x9

//Признак ошибки
#define ERR_INTRF_NOT_RESPOND   0x1
#define ERR_PRD_ON              0x2
#define ERR_CNTRL_ON            0x3
#define ERR_VBAY_ON             0x4
#define ERR_OVERHEAT            0x5
#define ERR_PMY_OMITTED         0x6
#define ERR_BP_PRD_OFF          0x7
#define ERR_ALL_BASKET_ON       0x8
#define ERR_RADIO_SILENCE_ON    0x9
#define ERR_NO_RD               0xA


//Вид сообщения
#define REQUEST_MSG             0x31
#define RESPONSE_MSG            0x32

//Идентификаторы устройств
#define ID_PC                   0x90
#define ID_SFERA                0x83


#define MSG_HDR_LEN                7


typedef struct {
    quint8 b1Basket1:2;
    quint8 k1Basket1:2;
    quint8 o1Basket1:2;
    quint8 basket1:2;
    quint8 b2Basket1:2;
    quint8 k2Basket1:2;
    quint8 o2Basket1:2;
    quint8 ftsBasket1:2;
    quint8 antenna:2;
    quint8 chPrd:1;
    quint8 ksv:1;
    quint8 malyyShleyf:1;
    quint8 term:1;
    quint8 pmy:1;
    quint8 aks:2;
    quint8 irps:2;
    quint8 pssD:2;
    quint8 eth:2;
    quint8 aru:2;
    quint8 s1tg:2;
    quint8 b1Basket2:2;
    quint8 k1Basket2:2;
    quint8 o1Basket2:2;
    quint8 basket2:2;
    quint8 b2Basket2:2;
    quint8 k2Basket2:2;
    quint8 o2Basket2:2;
    quint8 ftsBasket2:2;
}mode_tt;

#endif // MAIN_H
