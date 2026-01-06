#include "peglib.h"
using namespace peg;

#include "candbsignal.h"
#include "canrxmsg.h"
#include <stdint.h>
#include "defs.h"

#include "candbgrammar.h"

// Use core library instead of Qt
#include "core/file_utils.h"
#include "core/logger.h"
#include "core/serialization.h"

#include <string>
#include <algorithm>

#include "amjsonprotocol.h"
#include "core/types.h"

class CanRxMsg;
class AMJsonProtocol;

core::DataStream & operator<< (core::DataStream & out, const Signal & any)
{

    SerializedSignal_t sesig;

     sesig.startByte = any.startByte;
     sesig.startBit = any.startBit;
     sesig.numOfBits = any.numOfBits;
     sesig.sign = static_cast<uint8_t>(any.sign);
     sesig.factor = any.factor;
     sesig.offset = any.offset;
     sesig.min = any.min;
     sesig.max = any.max;
     sesig.enumValueType = static_cast<int8_t>(any.valueType);
     sesig.AMJsonSignalIdx = any.AMJsonSignalIdx;

     out.writeRawData((const char*) (& sesig), sizeof(SerializedSignal_t));

     return out;
}

core::DataStream & operator>> (core::DataStream & in, Signal & any)
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

    if (in.status() != core::DataStream::Ok)
    {
        coreDebug() << "WARNING:" << any.AMJsonSignalIdx << "signal status" << in.status();
    }

    return in;
}


bool CanDBSignal::readDBCFile(const std::string& protocolName, std::string& extractedString)
{
    bool ret = true;

    std::string filePath = std::string(BASE_TARGET_DIR) + "dbc/" + protocolName + ".dbc";
    core::File dbcFile(filePath);

    if(dbcFile.exists())
    {
        coreDebug() << "Found DBC files";
        if(dbcFile.open(core::File::ReadOnly))
        {
            coreDebug() << "signals JSON scheme successfully found and open.";

            //TODO: evaluate json consistency

            extractedString = dbcFile.readAll();

            // Replace \r\n with \n
            size_t pos = 0;
            while ((pos = extractedString.find("\r\n", pos)) != std::string::npos) {
                extractedString.replace(pos, 2, "\n");
                pos += 1;
            }

            // Replace \" with '
            pos = 0;
            while ((pos = extractedString.find("\\\"", pos)) != std::string::npos) {
                extractedString.replace(pos, 2, "'");
                pos += 1;
            }

            dbcFile.close();
        }

        //TODO clean from the junk stuff
    }
    else
    {
        coreDebug() << "dbc file read failed.";
        ret = false;
    }

    return ret;
}



  void CanDBSignal::init_parser(void)
  {
      pParser = new parser(candbgrammar);



       phrases = new std::vector<std::string>();
       c_identifiers = new std::vector<std::string>();
       signs  = new std::vector<std::string>();
       ecu_tokens  = new std::vector<std::string>();
       numbers  = new std::vector<int64_t>();//TODO think about floats implementation
       cansignals = new std::vector<Signal *>();
#if 0
       //NOTE: is not actually used, defined at Json
       vtRows = new std::vector<Value>();
#endif

      //version elements:
      (* pParser)["phrase"] = [this](const SemanticValues & sv)
      {
          std::string str(sv.token().data(), sv.token().size());
          // Remove quotes
          str.erase(std::remove(str.begin(), str.end(), '"'), str.end());
          phrases->push_back(str);
      };

      (* pParser)["version"]   = [this](const SemanticValues &)
      {
          if (!phrases->empty())
          {
              phrases->pop_back();
          }
          else
          {
              coreDebug() << "Empty version";
          }
      };


      (* pParser)["ECU_NAME"]   = [this](const SemanticValues &)
      {
#if USE_ECU_NAME
          std::string str(sv.token().data(), sv.token().size());
          str.erase(std::remove(str.begin(), str.end(), '\r'), str.end());
          str.erase(std::remove(str.begin(), str.end(), '\n'), str.end());
          c_identifiers->push_back(str);
#endif
      };


      //signal elements:
      (* pParser)["NAME"]   = [this](const SemanticValues & sv)
      {
          std::string str(sv.token().data(), sv.token().size());
          str.erase(std::remove(str.begin(), str.end(), '\r'), str.end());
          str.erase(std::remove(str.begin(), str.end(), '\n'), str.end());
          c_identifiers->push_back(str);
      };

      (* pParser)["number"] = [this](const SemanticValues & sv)
      {
          try {
              int64_t number = std::stoull(sv.token(), nullptr, 10);
              numbers->push_back(number);
          } catch (const std::exception& ex)
          {
              coreDebug() << "Unable to parse number from " << sv.token().c_str();
          }
      };

      (* pParser)["sign"] = [this](const SemanticValues & sv)
      {
          std::string str(sv.token().data(), sv.token().size());
          //TODO convert signs to booleans
          signs->push_back(str);
      };




      (* pParser)["signal"]   = [this](const SemanticValues &)
      {
          Signal * cansig = new Signal();

#ifdef USE_ECU_NAME
          coreDebug() << "ecu_name:" << c_identifiers->back();
          c_identifiers->pop_back();
#endif
        /*std::string unit =*/ phrases->back(); phrases->pop_back();
          int64_t max = numbers->back(); numbers->pop_back();
          int64_t min = numbers->back(); numbers->pop_back();
          int64_t offset = numbers->back(); numbers->pop_back();
          int64_t factor = numbers->back(); numbers->pop_back();
          std::string sign = signs->back(); signs->pop_back();

        /*int64_t byteOrder =*/ numbers->back(); numbers->pop_back();
          int64_t signalSize = numbers->back(); numbers->pop_back();
          int64_t startBit = numbers->back(); numbers->pop_back();
          std::string name = c_identifiers->back(); c_identifiers->pop_back();

          const int8_t OctetBitLen = 8;

          cansig->name = name;
          cansig->startByte = startBit /  OctetBitLen ;
          cansig->startBit = startBit %  OctetBitLen;
          cansig->numOfBits= signalSize;
          cansig->sign =  (sign == "+");
          cansig->factor = (double)factor;
          cansig->offset = (double)offset;
          cansig->min = (double)min;
          cansig->max = (double)max;

          //WARNING: default TODO: check in the Vector spec
          cansig->valueType = SIGNAL_VALUE_TYPE_INTEGER ;


          cansignals->insert(cansignals->begin(), cansig);

#ifdef USE_MUX_NDX
          //NOTE:  Not implemented.
#endif
      };

      (* pParser)["message"] = [this](const SemanticValues &)
      {
          coreDebug() << "message:";

#ifdef USE_ECU_NAME
          coreDebug() << "ecu:" << c_identifiers->back();
          c_identifiers->pop_back();
#endif
          std::string name = c_identifiers->back(); c_identifiers->pop_back();
          coreDebug() << "name:" << name;

          coreDebug() << "dlc:" << numbers->back(); numbers->pop_back();
          uint64_t id = numbers->back(); numbers->pop_back();
          coreDebug() << "id:" << id;


          CanRxMsg * rxmsg;

          //WARNING: VECTOR__INDEPENDENT_SIG_MSG id is not supported
          if (id <= 0xFFFFFFFF)
          {
              rxmsg = CanRxMsg::createInstance((uint32_t)id, name);
              // Convert std::vector<Signal*> to QList<Signal*>
              QList<Signal *> * qlistSignals = new QList<Signal *>();
              for (Signal * sig : *cansignals) {
                  qlistSignals->append(sig);
              }
              rxmsg->applyCanDBSignalsArray(qlistSignals);

              rxmsg->setItsJsonProtocol(curParsedProtocol);
          }

          // Clean up the std::vector (QList now owns the signals)
          delete cansignals;
          cansignals = new std::vector<Signal *>();

          numbers->clear();
          c_identifiers->clear();
      };

      (* pParser)["number_phrase_pair"] = [this](const SemanticValues &)
      {
          /*std::string a_name =*/ phrases->back(); phrases->pop_back();
          /*double a_value = (double)*/ numbers->back(); numbers->pop_back();
#if 0
          Value a_row = {.name = a_name,
                         .value = a_value};
          vtRows->insert(vtRows->begin(), a_row);
#endif
      };

      (* pParser)["val_entry"] = [this](const SemanticValues &)
      {
          coreDebug() << "Value Table:";
          std::string name = c_identifiers->back(); c_identifiers->pop_back();
          coreDebug() << "name:" << name;

#if 0
          for(const Value & vt_row : *vtRows)
          {
              coreDebug() << "row:" << vt_row.value << vt_row.name;
          }
          vtRows->clear();
#endif
      };


      (* pParser)["vals"] = [this](const SemanticValues &)
      {


          /*int64_t message_num =*/ numbers->back(); numbers->pop_back();
          /*std::string name =*/ c_identifiers->back(); c_identifiers->pop_back();
 #if 0
          coreDebug() << "Value For Signal:";
          coreDebug() << "message id:" << message_num;
          coreDebug() << "signal name:" << name;
          for(const Value & vt_row : *vtRows)
          {
              coreDebug() << "row:" << vt_row.value << "," << vt_row.name;
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

  bool CanDBSignal::parseDBCFileString(const std::string& extractedFile)
  {
     bool status = true;

     if (!pParser->parse(extractedFile.c_str()))
     {
         coreDebug() << "dbc syntax error...";
         status = false;
     }

     return status;
  }

  bool CanDBSignal::processDBCFile(AMJsonProtocol * prot)
  {
      bool status = true;
      std::string protocolName = prot->getName();
      std::string dbcString;
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


  std::any extractSignal(Signal * canSignal, struct can_frame *frame)
  {

     std::any ret;

     if(canSignal)
     {
         //Extract the signal value

         uint8_t cut_mask = 0xFF>>(0x08 - (canSignal->numOfBits));
         uint8_t raw_val =
                 frame->data[(canSignal->startByte)]>>(canSignal->startBit)&cut_mask;

         switch(canSignal->valueType)
         {
         case SIGNAL_VALUE_TYPE_DOUBLE:
             ret = (double)raw_val;
             break;

         case SIGNAL_VALUE_TYPE_FLOAT:
             ret = (double)raw_val;
             break;

         case SIGNAL_VALUE_TYPE_INTEGER:

             if(1 == canSignal->numOfBits || (canSignal->min == 0 && canSignal->max == 1))
             {
                 ret = (bool)raw_val;
             }
             else
             {
                  ret = (int32_t)raw_val;
             }
             break;

         default:
             coreDebug() << "Illegal signal value type";
             ret = std::any();
         }

      }

      return ret;
  }
