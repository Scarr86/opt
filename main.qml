import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2

Window {
    property string inactive: "#5f5f5f"
    property string muteText: "#646464"
    property string borderColor: "#a4a3a3"


    id: window
    width: 1280
    height: 720
    property alias scrollView: scrollView
    visible: true
    minimumWidth: 960
    minimumHeight: 640
    //x: 640
    //y: 360
    title: qsTr("Сфера-СПД")

    MenuBar {
        id: menuBar
        height: 40
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Menu {
            title: qsTr("Настройки")

            Action {
                text: qsTr("Подключение к станции")
                onTriggered: {
                    netSettingsDialog.open();
                    netSettingsDialog.x = window.x + 100;
                    netSettingsDialog.y = window.y + 100;
                }
            }
        }

        Menu {
            title: qsTr("Сервис")

            Action {
                signal checkConnectionAction()
                objectName: "checkConnectionAction"
                text: qsTr("Проверить подключение")
                onTriggered: checkConnectionAction()
            }

            CheckBox {
                checked: true
                text: qsTr("Консоль логов")
                anchors.top: menuBar.bottom
                anchors.topMargin: -40
                anchors.bottom: menuBar.top
                anchors.bottomMargin: -40
                anchors.left: menuBar.right
                anchors.leftMargin: -1280
                anchors.right: menuBar.left
                anchors.rightMargin: -131
                anchors.horizontalCenter: menuBar.horizontalCenter
                anchors.verticalCenter: menuBar.verticalCenter
                onCheckedChanged: {
                    if(checked == false) {
                        logRectangle.state = "collapsed";
                        window.width = window.width - 272;
                    } else {
                        window.width = window.width + 272;
                        logRectangle.state = "expand";
                    }
                }
            }
        }

        Menu {
            title: qsTr("Справка")

            Action {
                text: qsTr("О программе")
            }
        }
    }

    Rectangle {
        id: logRectangle
        x: 0
        width: 272
        color: "#ffffff"
        anchors.bottom: toolBarFooter.top
        anchors.bottomMargin: 0
        anchors.top: menuBar.bottom
        anchors.topMargin: 0
        border.width: 1
        border.color: borderColor
        states: [
            State {
                name: "collapsed"
                PropertyChanges {
                    target: logRectangle
                    width: 0
                }
                PropertyChanges {
                    target: logLabel
                    visible: false
                }
            },
            State {
                name: "expand"
                PropertyChanges {
                    target: logRectangle
                    width: 272
                }
            }
        ]
        transitions: [
            Transition {
                from: "expand"
                to: "collapsed"
                NumberAnimation {
                    target: logRectangle
                    property: "width"
                    easing.type: Easing.InQuad
                    duration: 300
                }
            },
            Transition {
                from: "collapsed"
                to: "expand"
                NumberAnimation {
                    target: logRectangle
                    property: "width"
                    easing.type: Easing.InQuad
                    duration: 200
                }
            }
        ]
        Label {
            id: logLabel
            y: 0
            height: 29
            text: qsTr("Консоль логов")
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        ScrollView {
            id: scrollView
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.bottom: clearLogButton.top
            anchors.bottomMargin: 0
            anchors.top: logLabel.bottom
            anchors.topMargin: 0

            TextArea {
                id: logTextArea
                objectName: "logTextArea"
                x: -7
                width: 269
                text: qsTr("")
                wrapMode: Text.WordWrap
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: false
                readOnly: true
                selectByMouse: true
                //color: "#4687ff"
                //selectedTextColor: "red"
                //selectionColor: "white"
            }
        }

        Button {
            id: clearLogButton
            y: 377
            height: 33
            text: qsTr("Очистить")
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            onClicked: logTextArea.clear()
        }

    }

    Item {
        id: item1
        anchors.bottom: toolBarFooter.top
        anchors.bottomMargin: 0
        anchors.left: logRectangle.right
        anchors.leftMargin: 0
        anchors.right: modeItem.left
        anchors.rightMargin: 0
        anchors.top: menuBar.bottom
        anchors.topMargin: 0

        Label {
            id: antennaInfoLabel
            x: 516
            y: 363
            text: qsTr("")
        }

    }

    Rectangle {
        id: modeItem
        x: 790
        width: 490
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: toolBarFooter.top
        anchors.bottomMargin: 0
        anchors.top: menuBar.bottom
        anchors.topMargin: 0
        border.width: 1
        border.color: borderColor

        Label {
            id: modeLabel
            height: 26
            text: qsTr("Панель состояния станции")
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            id: prmItem
            height: 82
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: modeLabel.bottom
            anchors.topMargin: 0

            Label {
                id: prmLabel
                text: qsTr("Приемники |")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
            }


            Label {
                id: basketLabel
                objectName: "basketLabel"
                y: 1
                text: qsTr("Н/Д")
                verticalAlignment: Text.AlignVCenter
                anchors.left: prmLabel.right
                anchors.leftMargin: 5
            }

            Item {
                id: b1Item
                x: 24
                y: 23
                width: 46
                height: 59

                Label {
                    id: b1Label
                    x: 16
                    y: 8
                    text: qsTr("Б1")
                }

                RoundButton {
                    id: prmB1Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: prmB1IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "prmB1IndicatorStyle"
                    }
                }
            }

            Item {
                id: k1Item
                x: 103
                y: 23
                width: 46
                height: 59
                Label {
                    id: k1Label
                    x: 16
                    y: 8
                    text: qsTr("К1")
                }

                RoundButton {
                    id: prmK1Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: prmK1IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "prmK1IndicatorStyle"
                    }
                }
            }

            Item {
                id: o1Item
                x: 183
                y: 23
                width: 46
                height: 59
                Label {
                    id: o1Label
                    x: 16
                    y: 8
                    text: qsTr("О1")
                }

                RoundButton {
                    id: prmO1Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: prmO1IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "prmO1IndicatorStyle"
                    }
                }
            }

            Item {
                id: b2Item
                x: 268
                y: 23
                width: 46
                height: 59
                Label {
                    id: b2Label
                    x: 16
                    y: 8
                    text: qsTr("Б2")
                }

                RoundButton {
                    id: prmB2Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: prmB2IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "prmB2IndicatorStyle"
                    }
                }
            }

            Item {
                id: k2Item
                x: 352
                y: 23
                width: 46
                height: 59
                Label {
                    id: k2Label
                    x: 16
                    y: 8
                    text: qsTr("К2")
                }

                RoundButton {
                    id: prmK2Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: prmK2IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "prmK2IndicatorStyle"
                    }
                }
            }

            Item {
                id: o2Item
                x: 424
                y: 23
                width: 46
                height: 59
                Label {
                    id: o2Label
                    x: 16
                    y: 8
                    text: qsTr("О2")
                }

                RoundButton {
                    id: prmO2Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: prmO2IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "prmO2IndicatorStyle"
                    }
                }
            }

        }


        Item {
            id: prdItem
            x: 0
            y: 114
            height: 82
            anchors.leftMargin: 10
            anchors.rightMargin: 0
            anchors.left: parent.left
            Label {
                id: prdLabel
                text: qsTr("Передатчики")
                anchors.topMargin: 0
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.top: parent.top
                anchors.left: parent.left
                verticalAlignment: Text.AlignVCenter
                anchors.right: parent.right
                horizontalAlignment: Text.AlignLeft
            }

            Item {
                id: prd1Item
                x: 24
                y: 23
                width: 46
                height: 59
                Label {
                    id: prd1Label
                    x: 8
                    y: 8
                    text: qsTr("ПРД1")
                }

                RoundButton {
                    id: prd1Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: prd1IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "prd1IndicatorStyle"
                    }
                }
            }

            Item {
                id: prd2Item
                x: 103
                y: 23
                width: 46
                height: 59
                Label {
                    id: prd2Label
                    x: 8
                    y: 8
                    text: qsTr("ПРД2")
                }

                RoundButton {
                    id: prd2Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: prd2IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "prd2IndicatorStyle"
                    }
                }
            }

            Item {
                id: prd3Item
                x: 183
                y: 23
                width: 46
                height: 59
                Label {
                    id: prd3Label
                    x: 9
                    y: 8
                    text: qsTr("ПРД3")
                }

                RoundButton {
                    id: prd3Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: prd3IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "prd3IndicatorStyle"
                    }
                }
            }

            Item {
                id: prd4Item
                x: 268
                y: 23
                width: 46
                height: 59
                Label {
                    id: prd4Label
                    x: 9
                    y: 8
                    text: qsTr("ПРД4")
                }

                RoundButton {
                    id: prd4Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: prd4IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "prd4IndicatorStyle"
                    }
                }
            }

            Item {
                id: prd5Item
                x: 352
                y: 23
                width: 46
                height: 59
                Label {
                    id: prd5Label
                    x: 8
                    y: 8
                    text: qsTr("ПРД5")
                }

                RoundButton {
                    id: prd5Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: prd5IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "prd5IndicatorStyle"
                    }
                }
            }

            Item {
                id: prd6Item
                x: 424
                y: 23
                width: 46
                height: 59
                Label {
                    id: prd6Label
                    x: 8
                    y: 8
                    text: qsTr("ПРД6")
                }

                RoundButton {
                    id: prd6Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: prd6IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "prd6IndicatorStyle"
                    }
                }
            }
            anchors.right: parent.right
        }

        Item {
            id: commInterfaceItem
            x: 5
            y: 202
            height: 138
            anchors.leftMargin: 10
            anchors.rightMargin: 0
            anchors.left: parent.left
            Label {
                id: commInterfaceLabel
                text: qsTr("Интерфейсы связи")
                anchors.topMargin: 0
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.top: parent.top
                anchors.left: parent.left
                verticalAlignment: Text.AlignVCenter
                anchors.right: parent.right
                horizontalAlignment: Text.AlignLeft
            }

            Item {
                id: pssdItem
                x: 49
                y: 23
                width: 46
                height: 59
                Label {
                    id: pssdLabel
                    x: 5
                    y: 8
                    text: qsTr("ПСС-Д")
                }

                RoundButton {
                    id: pssdIndicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: pssdIndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "pssdIndicatorStyle"
                    }
                }
            }

            Item {
                id: basket1Item
                x: 161
                y: 23
                width: 46
                height: 59
                Label {
                    id: basket1Label
                    x: -6
                    y: 8
                    text: qsTr("Корзина 1")
                }

                RoundButton {
                    id: basket1Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: basket1IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "basket1IndicatorStyle"
                    }
                }
            }

            Item {
                id: basket2Item
                x: 295
                y: 23
                width: 46
                height: 59
                Label {
                    id: basket2Label
                    x: -7
                    y: 8
                    text: qsTr("Корзина 2")
                }

                RoundButton {
                    id: basket2Indicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: basket2IndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "basket2IndicatorStyle"
                    }
                }
            }

            Item {
                id: aruItem
                x: 399
                y: 23
                width: 46
                height: 59
                Label {
                    id: aruLabel
                    x: 13
                    y: 8
                    text: qsTr("АРУ")
                }

                RoundButton {
                    id: aruIndicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: aruIndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "aruIndicatorStyle"
                    }
                }
            }

            Item {
                id: s1tgItem
                x: 49
                y: 79
                width: 46
                height: 59
                Label {
                    id: s1tgLabel
                    x: 8
                    y: 8
                    text: qsTr("С1-ТГ")
                }

                RoundButton {
                    id: s1tgIndicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: s1tgIndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "s1tgIndicatorStyle"
                    }
                }
            }

            Item {
                id: aksItem
                x: 161
                y: 79
                width: 46
                height: 59
                Label {
                    id: aksLabel
                    x: 11
                    y: 8
                    text: qsTr("АКС")
                }

                RoundButton {
                    id: aksIndicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: aksIndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "aksIndicatorStyle"
                    }
                }
            }

            Item {
                id: irpsItem
                x: 295
                y: 79
                width: 46
                height: 59
                Label {
                    id: irpsLabel
                    x: 5
                    y: 8
                    text: qsTr("ИРПС")
                }

                RoundButton {
                    id: irpsIndicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: irpsIndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "irpsIndicatorStyle"
                    }
                }
            }

            Item {
                id: ethItem
                x: 399
                y: 79
                width: 46
                height: 59
                Label {
                    id: ethLabel
                    x: 13
                    y: 8
                    text: qsTr("Eth")
                }

                RoundButton {
                    id: ethIndicator
                    x: 13
                    y: 31
                    width: 20
                    height: 20
                    background: Rectangle {
                        id: ethIndicatorStyle
                        color: inactive
                        radius: 20
                        border.width: 1
                        border.color: borderColor
                        objectName: "ethIndicatorStyle"
                    }
                }
            }
            anchors.right: parent.right
        }

        Item {
            id: antennaItem
            x: 0
            width: 160
            height: 45
            anchors.top: commInterfaceItem.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 10

            Label {
                id: antennaLabel
                text: qsTr("Антенна")
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                font.pointSize: 12
            }

            Text {
                id: antennaText
                objectName: "antennaText"
                x: 0
                width: 115
                height: 23
                color: muteText
                text: qsTr("Н/Д")
                anchors.top: antennaLabel.bottom
                anchors.topMargin: 0
                font.capitalization: Font.MixedCase
                font.pointSize: 8
                lineHeight: 0.8
                verticalAlignment: Text.AlignTop
                wrapMode: Text.WordWrap
            }

            RoundButton {
                id: antennaIndicator
                x: 121
                width: 20
                height: 20
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 12
                anchors.top: parent.top
                anchors.topMargin: 13
                background: Rectangle {
                    id: antennaIndicatorStyle
                    color: inactive
                    radius: 20
                    border.width: 1
                    border.color: borderColor
                    objectName: "antennaIndicatorStyle"
                }
            }
        }

        Item {
            id: pmyItem
            x: 332
            width: 160
            height: 45
            anchors.top: commInterfaceItem.bottom
            anchors.topMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 10
            Label {
                id: pmyLabel
                text: qsTr("ПМУ")
                anchors.topMargin: 0
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.left: parent.left
                font.pointSize: 12
            }

            Text {
                id: pmyText
                x: 0
                width: 115
                height: 23
                color: muteText
                text: qsTr("Н/Д")
                anchors.topMargin: 0
                anchors.top: pmyLabel.bottom
                font.capitalization: Font.MixedCase
                lineHeight: 0.8
                objectName: "pmyText"
                verticalAlignment: Text.AlignTop
                wrapMode: Text.WordWrap
                font.pointSize: 8
            }

            RoundButton {
                id: pmyIndicator
                x: 121
                width: 20
                height: 20
                anchors.right: parent.right
                anchors.rightMargin: 5
                background: Rectangle {
                    id: pmyIndicatorStyle
                    color: inactive
                    radius: 20
                    border.width: 1
                    border.color: borderColor
                    objectName: "pmyIndicatorStyle"
                }
                anchors.topMargin: 13
                anchors.bottomMargin: 12
                anchors.top: parent.top
                anchors.bottom: parent.bottom
            }
        }




        Item {
            id: termItem
            width: 160
            height: 45
            anchors.top: antennaItem.bottom
            anchors.topMargin: 5
            anchors.leftMargin: 10
            anchors.left: parent.left
            Label {
                id: termLabel
                text: qsTr("Термодатчик")
                anchors.topMargin: 0
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.left: parent.left
                font.pointSize: 12
            }

            Text {
                id: termText
                x: 0
                width: 115
                height: 23
                color: muteText
                text: qsTr("Н/Д")
                anchors.topMargin: 0
                anchors.top: termLabel.bottom
                font.capitalization: Font.MixedCase
                lineHeight: 0.8
                objectName: "termText"
                verticalAlignment: Text.AlignTop
                wrapMode: Text.WordWrap
                font.pointSize: 8
            }

            RoundButton {
                id: termIndicator
                x: 121
                width: 20
                height: 20
                anchors.right: parent.right
                anchors.rightMargin: 5
                background: Rectangle {
                    id: termIndicatorStyle
                    color: inactive
                    radius: 20
                    border.width: 1
                    border.color: borderColor
                    objectName: "termIndicatorStyle"
                }
                anchors.topMargin: 13
                anchors.bottomMargin: 12
                anchors.top: parent.top
                anchors.bottom: parent.bottom
            }
        }



        Item {
            id: malyyShleyfItem
            x: -6
            y: 390
            width: 160
            height: 45
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: pmyItem.bottom
            anchors.topMargin: 5
            Label {
                id: malyyShleyfLabel
                text: qsTr("Малый шлейф")
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 0
                font.pointSize: 12
                anchors.leftMargin: 0
            }

            Text {
                id: malyyShleyfText
                x: 0
                width: 115
                height: 23
                color: muteText
                text: qsTr("Н/Д")
                anchors.top: malyyShleyfLabel.bottom
                lineHeight: 0.8
                font.capitalization: Font.MixedCase
                anchors.topMargin: 0
                objectName: "malyyShleyfText"
                wrapMode: Text.WordWrap
                font.pointSize: 8
                verticalAlignment: Text.AlignTop
            }

            RoundButton {
                id: malyyShleyfIndicator
                x: 121
                width: 20
                height: 20
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.top: parent.top
                anchors.bottomMargin: 12
                anchors.bottom: parent.bottom
                anchors.topMargin: 13
                background: Rectangle {
                    id: malyyShleyfIndicatorStyle
                    color: inactive
                    radius: 20
                    objectName: "malyyShleyfIndicatorStyle"
                    border.width: 1
                    border.color: borderColor
                }
            }
        }

        Item {
            id: ksvItem
            x: 7
            width: 160
            height: 45
            anchors.top: termItem.bottom
            anchors.left: parent.left
            anchors.topMargin: 5
            Label {
                id: ksvLabel
                text: qsTr("КСВ")
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 0
                font.pointSize: 12
                anchors.leftMargin: 0
            }

            Text {
                id: ksvText
                x: 0
                width: 115
                height: 23
                color: muteText
                text: qsTr("Н/Д")
                anchors.top: ksvLabel.bottom
                lineHeight: 0.8
                font.capitalization: Font.MixedCase
                anchors.topMargin: 0
                objectName: "ksvText"
                wrapMode: Text.WordWrap
                font.pointSize: 8
                verticalAlignment: Text.AlignTop
            }

            RoundButton {
                id: ksvIndicator
                x: 121
                width: 20
                height: 20
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.top: parent.top
                anchors.bottomMargin: 12
                anchors.bottom: parent.bottom
                anchors.topMargin: 13
                background: Rectangle {
                    id: ksvIndicatorStyle
                    color: inactive
                    radius: 20
                    objectName: "ksvIndicatorStyle"
                    border.width: 1
                    border.color: borderColor
                }
            }
            anchors.leftMargin: 10
        }

        Item {
            id: chPrdItem
            x: 340
            y: 441
            width: 160
            height: 45
            anchors.top: malyyShleyfItem.bottom
            anchors.rightMargin: 10
            anchors.right: parent.right
            anchors.topMargin: 5
            Label {
                id: chPrdLabel
                text: qsTr("Канал передачи")
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 0
                font.pointSize: 12
                anchors.leftMargin: 0
            }

            Text {
                id: chPrdText
                x: 0
                width: 115
                height: 23
                color: muteText
                text: qsTr("Н/Д")
                anchors.top: chPrdLabel.bottom
                lineHeight: 0.8
                font.capitalization: Font.MixedCase
                wrapMode: Text.WordWrap
                objectName: "chPrdText"
                anchors.topMargin: 0
                font.pointSize: 8
                verticalAlignment: Text.AlignTop
            }

            RoundButton {
                id: chPrdIndicator
                x: 130
                width: 20
                height: 20
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.top: parent.top
                anchors.bottomMargin: 12
                anchors.bottom: parent.bottom
                anchors.topMargin: 13
                background: Rectangle {
                    id: chPrdIndicatorStyle
                    color: inactive
                    radius: 20
                    objectName: "chPrdIndicatorStyle"
                    border.width: 1
                    border.color: borderColor
                }
            }
        }

        Item {
            id: ftsItem
            x: 11
            width: 160
            height: 45
            anchors.top: ksvItem.bottom
            anchors.left: parent.left
            anchors.topMargin: 5
            Label {
                id: ftsLabel
                text: qsTr("ФТС")
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 0
                font.pointSize: 12
                anchors.leftMargin: 0
            }

            Text {
                id: ftsText
                x: 0
                width: 115
                height: 23
                color: muteText
                text: qsTr("Н/Д")
                anchors.top: ftsLabel.bottom
                lineHeight: 0.8
                font.capitalization: Font.MixedCase
                wrapMode: Text.WordWrap
                objectName: "ftsText"
                anchors.topMargin: 0
                font.pointSize: 8
                verticalAlignment: Text.AlignTop
            }

            RoundButton {
                id: ftsIndicator
                x: 121
                width: 20
                height: 20
                anchors.top: parent.top
                anchors.bottomMargin: 12
                anchors.rightMargin: 5
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.topMargin: 13
                background: Rectangle {
                    id: ftsIndicatorStyle
                    color: inactive
                    radius: 20
                    objectName: "ftsIndicatorStyle"
                    border.width: 1
                    border.color: borderColor
                }
            }
            anchors.leftMargin: 10
        }

        Button {
            signal requestModeBtn()
            id: requestModeButton
            objectName: "requestModeButton"
            y: 369
            height: 40
            text: qsTr("Запросить состояние")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            onClicked: requestModeBtn()
        }




    }


    Dialog {
        signal applyBtn(string ipAddr, string port)
        title: qsTr("Настройки подключения к станции")
        id: netSettingsDialog
        objectName: "objDialog"
        width: 280
        height: 160
        standardButtons: StandardButton.Ok | StandardButton.Cancel | StandardButton.Apply
        onApply: applyBtn(ipAddr.text, port.text)
        Column {
            id: netSettingsColumn
            spacing: 20
            anchors.fill: parent
            Row {
                id: ipAddrRow
                spacing: 30

                Label {
                    id: ipAddrLabel
                    text: qsTr("IP-адрес")
                    font.pixelSize: 16
                }

                TextField {
                    id: ipAddr
                    objectName: "ipAddr"
                    //Не работает валидатор ip адреса
                    /*validator: RegExpValidator {
                        regExp: /^(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\.(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\.(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\.(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$/
                    }*/
                    placeholderText: qsTr("0.0.0.0")
                }
            }

            Row {
                id: portRow
                spacing: 18

                Label {
                    id: portLabel
                    text: qsTr("UDP-порт")
                    font.pixelSize: 16
                }

                TextField {
                    id: port
                    objectName: "port"
                    validator: RegExpValidator {regExp: /[0-9]{1,5}/}
                    placeholderText: qsTr("0")
                }
            }
        }

    }

    ToolBar {
        id: toolBarFooter
        y: 449
        height: 30
        position: ToolBar.Footer
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        RoundButton {
            id: connectionIndicator
            x: 10
            width: 20
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5

            background: Rectangle {
                id: connectionIndicatorStyle
                objectName: "connectionIndicatorStyle"
                color: inactive
                radius: 20
                border {
                    width: 1
                    color: borderColor
                }
                /*
                states: [
                    State {
                        name: "connecting"
                        PropertyChanges {
                            target: connectionIndicatorStyle
                            color: "#ecb612"
                        }
                    },
                    State {
                        name: "error"
                        PropertyChanges {
                            target: connectionIndicatorStyle
                            color: "#f22929"
                        }
                    },
                    State {
                        name: "success"
                        PropertyChanges {
                            target: connectionIndicatorStyle
                            color: "#28af2f"
                        }
                    }
                ]
                transitions: Transition {
                    from: "*"
                    to: "*"
                    PropertyAnimation {
                        target: connectionIndicatorStyle
                        properties: "color, text"
                        easing.type: Easing.InCirc
                        duration: 400
                    }
                }
                */
            }
        }

        Label {
            id: connectionIndicatorLabel
            objectName: "connectionIndicatorLabel"
            x: 36
            text: qsTr("Статус соединения")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            anchors.top: parent.top
            anchors.topMargin: 7
        }

        ToolSeparator {
            id: toolSeparator
            x: 206
            y: 3
            width: 13
            height: 25
        }

        Label {
            id: pLabel
            x: 581
            text: qsTr("Порт:")
            anchors.right: portText.left
            anchors.rightMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            anchors.top: parent.top
            anchors.topMargin: 7
        }


        Text {
            id: portText
            objectName: "portText"
            x: 618
            text: qsTr("0")
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            anchors.top: parent.top
            anchors.topMargin: 7
            font.pixelSize: 12
        }


        Text {
            id: ipAddrText
            objectName: "ipAddrText"
            x: 543
            text: qsTr("0.0.0.0")
            anchors.right: pLabel.left
            anchors.rightMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            anchors.top: parent.top
            anchors.topMargin: 7
            font.pixelSize: 12
        }


        Label {
            id: label
            x: 485
            text: qsTr("IP-адрес:")
            anchors.right: ipAddrText.left
            anchors.rightMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            anchors.top: parent.top
            anchors.topMargin: 7
        }



        Text {
            id: cmdExeFlagText
            objectName: "cmdExeFlagText"
            y: 7
            height: 17
            text: qsTr("<Признак исполнения команды>")
            anchors.left: toolSeparator.right
            anchors.leftMargin: 5
            font.pixelSize: 12
        }



        Text {
            id: errText
            objectName: "errText"
            y: 7
            text: qsTr("<Признак ошибки>")
            anchors.left: cmdExeFlagText.right
            anchors.leftMargin: 10
            font.pixelSize: 12
        }
    }


}

/*##^## Designer {
    D{i:14;anchors_x:14}D{i:13;anchors_width:490;anchors_x:790}D{i:132;anchors_height:82}
D{i:160;anchors_x:459}
}
 ##^##*/
