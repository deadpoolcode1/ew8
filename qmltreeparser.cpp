#include "qmltreeparser.h"

QmlTreeParser::QmlTreeParser(QObject *aComponentObject) : QObject()
{

    componentObject = aComponentObject;

}

void QmlTreeParser::constructTree(void)
{

        QObject * current = componentObject->findChild<QObject*>("main_panel_root");

        current->children();

       current->dumpObjectTree();


}
