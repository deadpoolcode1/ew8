#include "peglib.h"
using namespace peg;

#include "candbsignal.h"
#include "canrxmsg.h"
#include <stdint.h>
#include "defs.h"

#include "candbgrammar.h"
#include <QFile>

#include "amjsonprotocol.h"

class CanRxMsg;
class AMJsonProtocol;



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
       vtRows = new QList<Value>();

      //version elements:
      (* pParser)["phrase"] = [this](const SemanticValues & sv)
      {
          QString str = QString::fromUtf8(sv.token().data(),sv.token().size());
          str.remove('"');
          phrases->append(str);
      };

      (* pParser)["version"]   = [this](const SemanticValues & sv)
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


      (* pParser)["ECU_NAME"]   = [this](const SemanticValues & sv)
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




      (* pParser)["signal"]   = [this](const SemanticValues & sv)
      {
          Signal * cansig = new Signal();

          qDebug ("signal:");

#ifdef USE_ECU_NAME
          qDebug ("ecu_name:%lu",qPrintable(c_identifiers->takeLast()));
#endif
          QString unit = phrases->takeLast(); qDebug ("unit:%s",qPrintable(unit));
          qint64 max = numbers->takeLast(); qDebug ("max:%lu", max);
          qint64 min = numbers->takeLast(); qDebug ("min:%lu", min);
          qint64 offset = numbers->takeLast(); qDebug ("offset:%lu", offset);
          qint64 factor = numbers->takeLast(); qDebug ("factor:%lu", factor);
          QString sign = signs->takeLast(); qDebug ("sign:%s",qPrintable(sign));

          qint64 byteOrder = numbers->takeLast(); qDebug ("byteOrder:%lu", byteOrder);
          qint64 signalSize = numbers->takeLast(); qDebug ("signalSize:%lu", signalSize);
          qint64 startBit = numbers->takeLast(); qDebug ("startBit:%lu", startBit);
          QString name = c_identifiers->takeLast(); qDebug ("name:%s",qPrintable(name));

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

      (* pParser)["message"] = [this](const SemanticValues & sv)
      {
          qDebug("message:");

#ifdef USE_ECU_NAME
          qDebug ("ecu:%s",qPrintable(c_identifiers->takeLast()));
#endif
          qDebug ("name:%s",qPrintable(c_identifiers->takeLast()));
          qDebug ("dlc:%lu",numbers->takeLast());
          quint64 id = numbers->takeLast(); qDebug ("id:%u", id);


          CanRxMsg * rxmsg;

          //WARNING: VECTOR__INDEPENDENT_SIG_MSG id is not supported
          if (id <= 0xFFFFFFFF)
          {
              rxmsg = CanRxMsg::createInstance((quint32)id);
              rxmsg->applyCanDBSignalsArray(cansignals);

              rxmsg->setItsJsonProtocol(curParsedProtocol);
          }

          cansignals = new QList<Signal *>();

          numbers->clear();
          c_identifiers->clear();
      };

      (* pParser)["number_phrase_pair"] = [this](const SemanticValues &)
      {
          QString a_name = phrases->takeLast();
          double a_value = (double)numbers->takeLast();
          Value a_row = {.name = a_name,
                         .value = a_value};
#if 0
          qDebug("row: %s, %lf",qPrintable(a_name), a_value);
#endif
          vtRows->prepend(a_row);
      };

      (* pParser)["val_entry"] = [this](const SemanticValues &)
      {
          qDebug("Value Table:");
          QString name = c_identifiers->takeLast(); qDebug("name:%s",qPrintable(name));

          foreach(const Value & vt_row, * vtRows)
          {
              qDebug("row:%lf,%s", vt_row.value, qPrintable(vt_row.name));
          }
          vtRows->clear();
      };


      (* pParser)["vals"] = [this](const SemanticValues &)
      {
          qDebug("Value For Signal:");

          qint64 message_num = numbers->takeLast();  qDebug("message id:%lu", message_num);

          QString name = c_identifiers->takeLast(); qDebug("signal name:%s",qPrintable(name));

          foreach(const Value & vt_row, * vtRows)
          {
              qDebug("row:%lf,%s", vt_row.value, qPrintable(vt_row.name));
          }
          vtRows->clear();
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


  sg_var_t extractSignal(Signal * canSignal, struct can_frame *frame)
  {

     sg_var_t ret;



     ret.sg_type =  EXT_SG_VAL_TYPE_BROKEN;
     ret.sg_val._double = 0;

     if(canSignal)
     {
         //Extract the signal value

         quint8 cut_mask = 0xFF>>(0x08 - (canSignal->numOfBits));
         quint8 raw_val =
                 frame->data[(canSignal->startByte)]>>(canSignal->startBit)&cut_mask;

         switch(canSignal->valueType)
         {
         case SIGNAL_VALUE_TYPE_DOUBLE:
             ret.sg_val._double = (double)raw_val;
             ret.sg_type = EXT_SG_VAL_TYPE_DOUBLE;
             break;

         case SIGNAL_VALUE_TYPE_FLOAT:
             ret.sg_val._double = (double)raw_val;
             ret.sg_type = EXT_SG_VAL_TYPE_DOUBLE;
             break;

         case SIGNAL_VALUE_TYPE_INTEGER:

             if(1 == canSignal->numOfBits || (canSignal->min == 0 && canSignal->max == 1))
             {
                 ret.sg_val._bool = (bool)raw_val;
                 ret.sg_type = EXT_SG_VAL_TYPE_BOOL;
             }
             else
             {
                  ret.sg_val._int = (qint32)raw_val;
                 ret.sg_type = EXT_SG_VAL_TYPE_INTEGER;
             }
             break;

         default:
             qDebug("Illegal signal value type");
         }

      }

      return ret;
  }

  //Used by hardcoded smart messages
  Signal * extractSignalPtr(const char * name, quint32 msgId)
  {
      Signal * ret = nullptr;


      CanRxMsg * msg = CanRxMsg::getMsgByCanId(msgId);


      if(msg)
      {
          ret = msg->getCANSignalByName(QString(name));

      }

      return ret;

  }
