
QT += gui core widgets qml quick gui-private

HEADERS += \
    ioswebview.h \
    WebViewJavascriptBridge/WebViewJavascriptBridge/WebViewJavascriptBridge.h \
    WebViewJavascriptBridge/WebViewJavascriptBridge/WebViewJavascriptBridgeBase.h

OBJECTIVE_SOURCES += \
    ioswebview.mm \
    WebViewJavascriptBridge/WebViewJavascriptBridge/WebViewJavascriptBridge.mm \
    WebViewJavascriptBridge/WebViewJavascriptBridge/WebViewJavascriptBridgeBase.mm

SOURCES += \
    main.cpp

DISTFILES += \
    main.qml \
    WebViewJavascriptBridge/WebViewJavascriptBridge/WebViewJavascriptBridge.js.txt
#WEBVIEW_RESOURCE.files +=\
#   $$PWD/WebViewJavascriptBridge/WebViewJavascriptBridge/WebViewJavascriptBridge.js.txt \
#   $$PWD/test.html

WEBVIEW_RESOURCE.files +=\
   $$PWD/WebViewJavascriptBridge/WebViewJavascriptBridge/WebViewJavascriptBridge.js.txt \
   $$PWD/canvasjs-1.8.0-beta/bdcharts.html \
  $$PWD/canvasjs-1.8.0-beta/canvasjs.min.js\
  $$PWD/canvasjs-1.8.0-beta/jquery.canvasjs.min.js \
  $$PWD/canvasjs-1.8.0-beta/canvasjs.js \
  $$PWD/canvasjs-1.8.0-beta/excanvas.js \
  $$PWD/canvasjs-1.8.0-beta/jquery.canvasjs.js\
   $$PWD/canvasjs-1.8.0-beta/test.html

QMAKE_BUNDLE_DATA += WEBVIEW_RESOURCE
RESOURCES += \
    iosrc.qrc
