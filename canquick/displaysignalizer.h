#ifndef DISPLAYSIGNALIZER_H
#define DISPLAYSIGNALIZER_H

#include <QQuickItem>
#include "defs.h"
#include "rootedtreenode.h"

class RootedTreeNode;

class DisplaySignalizer : public QQuickItem
{
    Q_OBJECT
public:
    DisplaySignalizer(RootedTreeNode * aRootedTreeNode, QQuickItem * parent = nullptr);

signals:
    void setVisibleSignal(QVariant valueInt, QVariant valueFrac, QVariant unit);
    void setVisibleSignalStr(QVariant);
    void setInvisibleSignal(void);

public slots:

    void forceItemSelfDeactivation(void);

private:

    RootedTreeNode * itsRootedTreeNode;

};

#endif // DISPLAYSIGNALIZER_H
