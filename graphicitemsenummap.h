#ifndef GRAPHICITEMSENUMMAP_H
#define GRAPHICITEMSENUMMAP_H

#include "defs.h"

#include <QMutex>

class GraphicItemsEnumMap
{

public:

    //TODO add exception on not found
    static DISPLAY_ITEM_ID getId(QString name);
    static QString getName(DISPLAY_ITEM_ID id);

private:

    static GraphicItemsEnumMap * getInstance(void);

    static QMutex instanceMutex;

    static GraphicItemsEnumMap * instance;

    void init(void);

    GraphicItemsEnumMap();

    QHash<QString, DISPLAY_ITEM_ID> graphicItemsIDsMap;

    QHash<DISPLAY_ITEM_ID, QString> graphicItemsNamesMap;

};

#endif // GRAPHICITEMSENUMMAP_H
