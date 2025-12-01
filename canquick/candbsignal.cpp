#include "peglib.h"
using namespace peg;

#include "candbsignal.h"
#include "canrxmsg.h"
#include <stdint.h>
#include "defs.h"

#include "candbgrammar.h"
#include <QFile>
#include <QDebug>

#include "amjsonprotocol.h"

class CanRxMsg;
class AMJsonProtocol;

QDataStream & operator<< (QDataStream & out, const Signal & any)
{

    SerializedSignal_t sesig;

     sesig.startByte = any.startByte;
     sesig.startBit = any.startBit;
     sesig.numOfBits = any.numOfBits;
     sesig.sign = static_cast<quint8>(any.sign);
     sesig.factor = any.factor;
     sesig.offset = any.offset;
     sesig.min = any.min;
     sesig.max = any.max;
     sesig.enumValueType = static_cast<qint8>(any.valueType);
     sesig.AMJsonSignalIdx = any.AMJsonSignalIdx;

     out.writeRawData((const char*) (& sesig),sizeof(SerializedSignal_t));

     return out;
}

QDataStream & operator>> (QDataStream & in, Signal & any)
{
    SerializedSignal_t sesig;

    in.readRawData((char*) & sesig, sizeof(SerializedSignal_t));

    any.startByte = sesig.startByte;
    any.startBit =  sesig.startBit;
    any.numOfBits =  sesig.numOfBits;
    any.sign = sesig.sign ? true : false;
    any.factor = sesig.factor;
    any.offset = sesig.offset;
    any.min = sesig.min;
    any.max = sesig.max;
    any.valueType = static_cast<SignalValueType>(sesig.enumValueType);
    any.AMJsonSignalIdx = sesig.AMJsonSignalIdx;

    if (in.status() != QDataStream::Ok)
    {
        qDebug() << "WARNING:" << any.AMJsonSignalIdx << "signal status" << in.status();
    }

    return in;
}


bool CanDBSignal::readDBCFile(QString protocolName,  QString & extractedString)
{
    bool ret = true;

    QFile dbcFile(QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("dbc/")+protocolName.toLatin1()+QStringLiteral(".dbc"));

    if(dbcFile.exists())
    {
        qDebug ("Found DBC files");
        if(dbcFile.open(QIODevice::ReadOnly))
        {
            qDebug("signals JSON scheme  successfully found and open.");

            //TODO: evaluate json consistency


            extractedString = dbcFile.readAll();

            extractedString.replace("\r\n","\n");

            extractedString.replace("\\\"","'");

            dbcFile.close();
        }

        //TODO clean from the junc staff
    }
    else
    {
        qDebug("dbc file read failed.");
        ret = false;
    }

    return ret;
}



  void CanDBSignal::init_parser(void)
  {
      pParser = new parser(candbgrammar);



       phrases = new QList<QString>();
       c_identifiers = new QList<QString>();
       signs  = new QList<QString>();
       ecu_tokens  = new QList<QString>();
       numbers  = new QList<qint64>();//TODO think about floats implementation
       cansignals = new QList<Signal *>();
#if 0
       //NOTE: is not actually used, defined at Json
       vtRows = new QList<Value>();
#endif

      //version elements:
      (* pParser)["phrase"] = [this](const SemanticValues & sv)
      {
          QString str = QString::fromUtf8(sv.token().data(),sv.token().size());
          str.remove('"');
          phrases->append(str);
      };

      (* pParser)["version"]   = [this](const SemanticValues &)
      {
          if (!phrases->isEmpty())
          {
              phrases->removeLast();
          }
          else
          {
              qDebug("Empty version");
          }
      };


      (* pParser)["ECU_NAME"]   = [this](const SemanticValues &)
      {
#if USE_ECU_NAME
          QString str = QString::fromUtf8(sv.token().data(),sv.token().size());
          str.remove('\r');
          str.remove('\n');
          c_identifiers->append(str);
#endif
      };


      //signal elements:
      (* pParser)["NAME"]   = [this](const SemanticValues & sv)
      {
          QString str = QString::fromUtf8(sv.token().data(),sv.token().size());
          str.remove('\r');
          str.remove('\n');
          c_identifiers->append(str);
      };

      (* pParser)["number"] = [this](const SemanticValues & sv)
      {
          try {
              qint64 number = std::stoull(sv.token(), nullptr, 10);
              numbers->append(number);
          } catch (const std::exception& ex)
          {
              qDebug("Unable to parse number from %s", sv.token().c_str());
          }
      };

      (* pParser)["sign"] = [this](const SemanticValues & sv)
      {
          QString str = QString::fromUtf8(sv.token().data(),sv.token().size());
          //TODO convert signs to booleans
          signs->append(str);
      };




      (* pParser)["signal"]   = [this](const SemanticValues &)
      {
          Signal * cansig = new Signal();

#ifdef USE_ECU_NAME
          qDebug ("ecu_name:%lu",qPrintable(c_identifiers->takeLast()));
#endif
        /*QString unit =*/ phrases->takeLast();
          qint64 max = numbers->takeLast();
          qint64 min = numbers->takeLast();
          qint64 offset = numbers->takeLast();
          qint64 factor = numbers->takeLast();
          QString sign = signs->takeLast();

        /*qint64 byteOrder =*/ numbers->takeLast();
          qint64 signalSize = numbers->takeLast();
          qint64 startBit = numbers->takeLast();
          QString name = c_identifiers->takeLast();

          const qint8 OctetBitLen = 8;

          cansig->name = name;
          cansig->startByte = startBit /  OctetBitLen ;
          cansig->startBit = startBit %  OctetBitLen;
          cansig->numOfBits= signalSize;
          cansig->sign =  (sign == "+");
          cansig->factor = (double)factor;
          cansig->offset = (double)offset;
          cansig->min = (double)min;
          cansig->max = (double)max;

          //WARNIG: default TODO: check in the Vector spec
          cansig->valueType = SIGNAL_VALUE_TYPE_INTEGER ;


          cansignals->prepend(cansig);

#ifdef USE_MUX_NDX
          //NOTE:  Not implemented.
#endif
      };

      (* pParser)["message"] = [this](const SemanticValues &)
      {
          qDebug("message:");

#ifdef USE_ECU_NAME
          qDebug ("ecu:%s",qPrintable(c_identifiers->takeLast()));
#endif
          QString name = c_identifiers->takeLast();
          qDebug ("name:%s",qPrintable(name));

          qDebug () << "dlc:" << numbers->takeLast();
          quint64 id = numbers->takeLast(); qDebug() << "id:" << id;


          CanRxMsg * rxmsg;

          //WARNING: VECTOR__INDEPENDENT_SIG_MSG id is not supported
          if (id <= 0xFFFFFFFF)
          {
              rxmsg = CanRxMsg::createInstance((quint32)id, name);
              rxmsg->applyCanDBSignalsArray(cansignals);

              rxmsg->setItsJsonProtocol(curParsedProtocol);
          }

          cansignals = new QList<Signal *>();

          numbers->clear();
          c_identifiers->clear();
      };

      (* pParser)["number_phrase_pair"] = [this](const SemanticValues &)
      {
          /*QString a_name =*/ phrases->takeLast();
          /*double a_value = (double)*/ numbers->takeLast();
#if 0
          Value a_row = {.name = a_name,
                         .value = a_value};
          vtRows->prepend(a_row);
#endif
      };

      (* pParser)["val_entry"] = [this](const SemanticValues &)
      {
          qDebug() << "Value Table:";
          QString name = c_identifiers->takeLast(); qDebug("name:%s",qPrintable(name));

#if 0
          foreach(const Value & vt_row, * vtRows)
          {
              qDebug() << "row:" << vt_row.value << qPrintable(vt_row.name);
          }
          vtRows->clear();
#endif
      };


      (* pParser)["vals"] = [this](const SemanticValues &)
      {


          /*qint64 message_num =*/ numbers->takeLast();
          /*QString name =*/ c_identifiers->takeLast();
 #if 0
          qDebug("Value For Signal:");
          qDebug() << "message id:" << message_num;
          qDebug() << "signal name:" << qPrintable(name);
          foreach(const Value & vt_row, * vtRows)
          {
              qDebug() << "row:" << vt_row.value << "," << qPrintable(vt_row.name);
          }
          vtRows->clear();
#endif
      };


  }

  CanDBSignal::CanDBSignal()
  {
      curParsedProtocol = nullptr;
      init_parser();
  }

  bool CanDBSignal::parseDBCFileString(QString extractedFile)
  {
     bool status = true;

     const std::string str2Parse = extractedFile.toStdString();

     if (!pParser->parse(str2Parse.c_str()))
     {
         qDebug("dbc syntax error...");
         status = false;
     }

     return status;
  }

  bool CanDBSignal::processDBCFile(AMJsonProtocol * prot)
  {
      bool status = true;
      QString protocolName = prot->getName();
      QString dbcString;
      status = readDBCFile(protocolName, dbcString);
      if(status)
      {
         curParsedProtocol =  prot;
#if 1
         status = parseDBCFileString(dbcString);
#else
         parseDBCFileString(dbcString);
#endif
      }
      return status;
  }


  QVariant extractSignal(Signal * canSignal, struct can_frame *frame)
  {

     QVariant ret;

     if(canSignal)
     {
         //Extract the signal value

         quint8 cut_mask = 0xFF>>(0x08 - (canSignal->numOfBits));
         quint8 raw_val =
                 frame->data[(canSignal->startByte)]>>(canSignal->startBit)&cut_mask;

         switch(canSignal->valueType)
         {
         case SIGNAL_VALUE_TYPE_DOUBLE:
             ret = QVariant((double)raw_val);
             break;

         case SIGNAL_VALUE_TYPE_FLOAT:
             ret = QVariant((double)raw_val);
             break;

         case SIGNAL_VALUE_TYPE_INTEGER:

             if(1 == canSignal->numOfBits || (canSignal->min == 0 && canSignal->max == 1))
             {
                 ret = QVariant((bool)raw_val);
             }
             else
             {
                  ret = QVariant((qint32)raw_val);
             }
             break;

         default:
             qDebug("Illegal signal value type");
             ret = QVariant::fromValue((QObject * const) nullptr);
         }

      }

      return ret;
  }
