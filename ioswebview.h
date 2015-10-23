#ifndef IOSWEBVIEW_H
#define IOSWEBVIEW_H

#include <QQuickItem>
#include <QDebug>
///
/// \brief The IOSWebView class
/// source code from https://github.com/g00dnight/IOSWebView
///
class IOSWebView : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QString url MEMBER url NOTIFY urlChanged)
public:
    explicit IOSWebView(QQuickItem *parent = 0);
    ~IOSWebView();

public slots:
    void callHandler(const QString& msg);
    void sendMessage(const QString &msg);
    void reloadWebView();
protected:
    QSGNode* updatePaintNode(QSGNode *pNode, UpdatePaintNodeData*);
    virtual void componentComplete();
    virtual void itemChange(ItemChange change, const ItemChangeData & value);

private:
    QPointF absoluteQMLPosition();

    void* pWebView;
    void* _bridge;
    QString url;
    QRectF qmlRect;


signals:
    void updateWebViewSize();
    void urlChanged(QString newUrl);

private slots:
    void onUpdateWebViewSize();
    void onUrlChanged(QString newUrl);

};
#endif // IOSWEBVIEW_H
