#ifndef DISPLAYSIGNALIZER_H
#define DISPLAYSIGNALIZER_H

#include <QQuickItem>
#include "defs.h"
#include "rootedtreenode.h"

class RootedTreeNode;
class AMJsonGraphicItemAction;

class DisplaySignalizer : public QQuickItem
{
    Q_OBJECT
public:
    DisplaySignalizer(RootedTreeNode * aRootedTreeNode, QQuickItem * parent = nullptr);

    void setAction(AMJsonGraphicItemAction * action);

signals:
    void setVisibleSignal(QVariant valueInt, QVariant valueFrac, QVariant unit);
    void setVisibleSignalStr(QVariant);
    void setInvisibleSignal(void);

public slots:

    void forceItemSelfDeactivation(void);
    void forceItemActionDeactivation(void);

private:

    RootedTreeNode * itsRootedTreeNode;
    AMJsonGraphicItemAction * itsAction = nullptr;

};

#endif // DISPLAYSIGNALIZER_H
