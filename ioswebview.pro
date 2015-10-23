
QT += gui core widgets qml quick gui-private

HEADERS += \
    ioswebview.h \
    bridge/WebViewJavascriptBridge.h \
    bridge/WebViewJavascriptBridgeBase.h

OBJECTIVE_SOURCES += \
    ioswebview.mm \
    bridge/WebViewJavascriptBridge.mm \
    bridge/WebViewJavascriptBridgeBase.mm

SOURCES += \
    main.cpp

DISTFILES += \
    main.qml \
    bridge/WebViewJavascriptBridge.js.txt
#WEBVIEW_RESOURCE.files +=\
#   $$PWD/WebViewJavascriptBridge/WebViewJavascriptBridge/WebViewJavascriptBridge.js.txt \
#   $$PWD/test.html

WEBVIEW_RESOURCE.files +=\
   $$PWD/bridge/WebViewJavascriptBridge.js.txt \
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
