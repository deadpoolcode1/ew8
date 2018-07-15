#ifndef QMLTREEPARSER_H
#define QMLTREEPARSER_H

#include "rootedtreenode.h"
#include <QObject>

class QmlTreeParser : public QObject
{
    Q_OBJECT
public:
    explicit QmlTreeParser(QObject *aComponentObject);
    void constructTree(void);


private:

QObject * componentObject;

RootedTreeNode * root;

signals:

public slots:
};

#endif // QMLTREEPARSER_H
