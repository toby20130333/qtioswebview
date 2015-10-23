import QtQuick 2.2
import QtQuick.Window 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2

import IOSWebView 1.0

Window {
    width: Screen.width
    height: Screen.height
    visible: true
    color: "transparent"
    Item{
        id:top
        anchors.top: parent.top
        anchors.topMargin: 0
        height: 30
        width: parent.width
    }
    Rectangle{
        id:lbRect
        height: 30
        anchors.top: top.bottom
        anchors.topMargin: 0
        width: parent.width
        color: "white"//Qt.rgba(Math.random(),Math.random(),Math.random(),1);
        Text{
//            text: "原生WebView的QML图表应用"
            text:"A QML Charts For iOS"
            color: "black"
            font.pixelSize: 24
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
        }
    }
    ComboBox {
        id:comBox
        anchors.top: lbRect.bottom
        anchors.topMargin: 0
        currentIndex: 0
        height:40
        width: 120
        activeFocusOnPress: true
         style: ComboBoxStyle {
             id: comboBox
             background: Rectangle {
                 id: rectCategory
//                 radius: 5
                 border.width: 1
                 color: "#fff"
//                 Image {
//                     source: "pics/corner.png"
//                     anchors.bottom: parent.bottom
//                     anchors.right: parent.right
//                     anchors.bottomMargin: 5
//                     anchors.rightMargin: 5
//                 }
             }
             label: Text {
                 verticalAlignment: Text.AlignVCenter
                 horizontalAlignment: Text.AlignHCenter
                 font.pointSize: 15
                 font.family: "Courier"
                 font.capitalization: Font.SmallCaps
                 color: "black"
                 text: control.currentText
             }
         }
        model: ListModel {
            id: cbItems
            ListElement { text: "bubble"; color: "Yellow" }
            ListElement { text: "line"; color: "Green" }
            ListElement { text: "column"; color: "Brown" }
            ListElement { text: "doughnut"; color: "gray" }
            ListElement { text: "spline"; color: "gray" }
            ListElement { text: "dyline"; color: "gray" }
            ListElement { text: "candlestick"; color: "gray" }
        }
        onCurrentIndexChanged:{
            console.log(cbItems.get(currentIndex).text);
            iosView.sendMessage(cbItems.get(currentIndex).text);
        }
    }
    Button{
        id:refreshBtn
        width: 100
        height: 40
        text: "reload"
        anchors.right: parent.right
        anchors.left: comBox.right
        anchors.top: lbRect.bottom
        anchors.topMargin: 0
        style: ButtonStyle {
               background: Rectangle {
                   implicitWidth: 100
                   implicitHeight: 25
                   color: control.pressed ? "black" : Qt.rgba(Math.random(),Math.random(),Math.random(),1)
                   Text {
                       id: name
                       text: control.text
                       color: control.pressed?Qt.rgba(Math.random(),Math.random(),Math.random(),1):"black"
                       anchors.fill: parent
                       horizontalAlignment: Text.AlignHCenter
                       verticalAlignment: Text.AlignVCenter
                   }
               }
           }
        onClicked: {
            iosView.reloadWebView();
        }
    }

    Slider {
        id:sliderId
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: refreshBtn.bottom
        tickmarksEnabled:true
        onValueChanged:{
            //console.log("sssssss "+styleData.handleWidth)
        }
        style: SliderStyle {
            groove: Rectangle {
                implicitWidth: 200
                implicitHeight: 8
                color: "green"
                radius: 8
                Rectangle{
                    id:valueId
                    width: sliderId.width*sliderId.value
                    height: 8
                    radius: 8
                    color: "red"
                }
            }
            handle: Rectangle {
                anchors.centerIn: parent
                color: control.pressed ? "white" : "lightgray"
                border.color: "gray"
                border.width: 1
                implicitWidth: 20
                implicitHeight: 20
                radius: 10
            }
        }
    }
    IOSWebView{
        id:iosView
        url:"bdcharts.html"
//        url:"file:///Users/tobyyi/Desktop/Duoduozhijiao-doc/oschina/IOSWebView/test.html"
//        url:"http://www.heilqt.com"
        width: parent.width
        anchors.top: sliderId.bottom
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        Component.onCompleted: {
            iosView.sendMessage(cbItems.get(cbItems.currentIndex).text);
        }
    }

}

