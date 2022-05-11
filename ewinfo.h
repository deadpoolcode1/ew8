#ifndef EWINFO_H
#define EWINFO_H

#include <QObject>


class EWInfo: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString sn READ getEwsn)
    Q_PROPERTY(QString bin READ getEngineVer)
    Q_PROPERTY(QString cfg READ getConfigVer)



public:

    EWInfo(QObject * parent = nullptr);

    //Single time fired
    static void declareQML();
    QString getEwsn(void);
    QString getEngineVer(void);
    QString getConfigVer(void);

private:



    void readEWInfo(void);
#ifndef WIN32
    void readServiceNumber(void);
    void enableDisableSFC(quint32 * wr_ptr, bool On);
    quint32 readDataSFC(quint32 * rd_ptr, quint32 index);



    quint8 ewsn_lsb[8];
    quint8 ewsn_msb[8];
#endif

    QString ewsn_str;
    QString ewbin_str;
    QString ewcfg_str;
};

#endif // EWINFO_H
