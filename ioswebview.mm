#include "ioswebview.h"
#include <QGuiApplication>
#include <QtGui/qpa/qplatformnativeinterface.h>
#include <UIKit/UIKit.h>
#include "WebViewJavascriptBridge/WebViewJavascriptBridge/WebViewJavascriptBridge.h"
#include "WebViewJavascriptBridge/WebViewJavascriptBridge/WebViewJavascriptBridgeBase.h"
#include <TargetConditionals.h>
#include <dlfcn.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

IOSWebView::IOSWebView(QQuickItem *parent) :
    QQuickItem(parent)
{
    setFlag(QQuickItem::ItemHasContents);
    pWebView = NULL;

    connect(this, SIGNAL(updateWebViewSize()), this, SLOT(onUpdateWebViewSize()));
    connect(this, SIGNAL(urlChanged(QString)), this, SLOT(onUrlChanged(QString)));
}

IOSWebView::~IOSWebView()
{
    if (pWebView) {
        [(UIWebView*)pWebView removeFromSuperview];
        [(UIWebView*)pWebView release];
        pWebView = NULL;
    }
}

void IOSWebView::componentComplete()
{
    QQuickItem::componentComplete();
    if (pWebView == NULL) {
        UIView *pMainView = static_cast<UIView*>(QGuiApplication::platformNativeInterface()->nativeResourceForWindow("uiview", (QWindow*)window()));
        pWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [pMainView addSubview:(UIWebView*)pWebView];
        ((UIWebView*)pWebView).scalesPageToFit = YES;
        onUrlChanged(url);
    }
}

void IOSWebView::itemChange(ItemChange change, const ItemChangeData & value)
{
    if (change == QQuickItem::ItemVisibleHasChanged && pWebView)
        ((UIWebView*)pWebView).hidden = !value.boolValue;
    QQuickItem::itemChange(change, value);
}


QSGNode* IOSWebView::updatePaintNode(QSGNode *pNode, UpdatePaintNodeData*)
{
    qmlRect = QRectF(absoluteQMLPosition(), QSizeF(width(), height()));
    emit updateWebViewSize();
    return pNode;
}

void IOSWebView::onUpdateWebViewSize()
{
    qDebug()<<"onUpdateWebViewSize "<<qmlRect;
    if (pWebView)
        ((UIWebView*)pWebView).frame = CGRectMake(qmlRect.x(), qmlRect.y(), qmlRect.width(), qmlRect.height());
}

void IOSWebView::onUrlChanged(QString newUrl)
{
    qDebug()<<"onUrlChanged "<<newUrl;
    if (pWebView) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
#if TARGET_IPHONE_SIMULATOR
            NSString *frameworkPath = [[NSProcessInfo processInfo] environment][@"DYLD_FALLBACK_FRAMEWORK_PATH"];
            if (frameworkPath) {
                NSString *webkitLibraryPath = [NSString pathWithComponents:@[frameworkPath, @"WebKit.framework", @"WebKit"]];
                dlopen([webkitLibraryPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_LAZY);
            }
#else
            dlopen("/System/Library/Frameworks/WebKit.framework/WebKit", RTLD_LAZY);
#endif
        }
        NSURL *url;

        NSBundle *bundle = [NSBundle mainBundle];
        if(newUrl.contains("http://")){
                    url = [NSURL URLWithString:newUrl.toNSString()];
        }else{
        QString filePath = QGuiApplication::applicationDirPath();
        filePath.append("/");
        filePath.append(newUrl);
        url = [NSURL URLWithString:filePath.toNSString()];
        }

        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [(UIWebView*)pWebView loadRequest:requestObj];
        NSLog(@"html url  path %@",url);
        [WebViewJavascriptBridge enableLogging];
        UIView *pMainView = static_cast<UIView*>(QGuiApplication::platformNativeInterface()->nativeResourceForWindow("uiview", (QWindow*)window()));
        NSObject<UIWebViewDelegate> *webDelegate = static_cast<NSObject<UIWebViewDelegate> *>(pMainView);
        _bridge = [WebViewJavascriptBridge bridgeForWebView:(UIWebView*)pWebView webViewDelegate:webDelegate handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"ObjC received message from JS: %@", data);
            responseCallback(@"Response for message from ObjC");
        }];

        [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"testObjcCallback called: %@", data);
            responseCallback(@"Response from testObjcCallback");
        }];

        [_bridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
            NSLog(@"IOSWebView---: objc got response! %@", responseData);
        }];
        [_bridge callHandler:@"IOSWebView: ---testJavascriptHandler" data:@{ @"foo":@"before ready" }];

        [_bridge send:@"A string sent from ObjC after Webview has loaded."];
    }
}
void IOSWebView::sendMessage(const QString& msg) {
    NSString* message = msg.toNSString();
    [_bridge send:message responseCallback:^(id response) {
        NSLog(@"IOSWebView: sendMessage got response: %@", response);
    }];
}

void IOSWebView::reloadWebView()
{
    [(UIWebView*)pWebView reload];
}

void IOSWebView::callHandler(const QString& msg) {
    id data = @{ @"IOSWebView :greetingFromObjC": @"Hi there, JS!" };
    NSString* message = msg.toNSString();
    [_bridge callHandler:message data:data responseCallback:^(id response) {
        NSLog(@"IOSWebView:testJavascriptHandler responded: %@", response);
    }];
}

QPointF IOSWebView::absoluteQMLPosition() {
    QPointF p(0, 0);
    QQuickItem* pItem = this;
    while (pItem != NULL) { // absolute position relative to rootItem
        p += pItem->position();
        pItem = pItem->parentItem();
    }
    return p;
}
