//+------------------------------------------------------------------+
//|                                                          IWW.mq5 |
//|                                                            ghost |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "ghost"
#property link      ""
#property version   "1.00"


#include <MQLMySQL.mqh>
#include <TimeSeries.mqh>
#include <Expert\Expert.mqh>

string INI;
int DB; // database identifier
input int Contratos = 5;

//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+
CExpert ExtExpert;

//+------------------------------------------------------------------+
//| Start porra                                         |
//+------------------------------------------------------------------+

void OnTick() {
}

void OnInit()
{
 string Host, User, Password, Database, Socket; // database credentials
 string Ativo =Symbol();
 int Port,ClientFlag;
 
 Print (MySqlVersion());

 INI = TerminalInfoString(TERMINAL_PATH)+"\\MQL5\\Scripts\\MyConnection.ini";
 
 // reading database credentials from INI file
 Host = ReadIni(INI, "MYSQL", "Host");
 User = ReadIni(INI, "MYSQL", "User");
 Password = ReadIni(INI, "MYSQL", "Password");
 Database = ReadIni(INI, "MYSQL", "Database");
 Port     = (int)StringToInteger(ReadIni(INI, "MYSQL", "Port"));
 Socket   = ReadIni(INI, "MYSQL", "Socket");
 ClientFlag = CLIENT_MULTI_STATEMENTS; //(int)StringToInteger(ReadIni(INI, "MYSQL", "ClientFlag"));  

 Print ("Host: ",Host, ", User: ", User, ", Database: ",Database);
 
 // open database connection
 Print ("Connecting...");
 
 DB = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
 
 if (DB == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB);}
 
 string Query;
 Query = "DROP TABLE IF EXISTS `"+Ativo+"`";
 MySqlExecute(DB, Query);
 
 Query = "CREATE TABLE `"+Ativo+"` (time datetime, low double, close double)";

 if (MySqlExecute(DB, Query))
    {
     Print ("Tabela "+Ativo+" criada");
    }
 else
    {
     Print ("Table `test_table` cannot be created. Error: ", MySqlErrorDescription);
    }
    
 while(1) {
 
 double xLow = iLow(Symbol(),PERIOD_M1,0);
 double xClose = iClose(Symbol(),PERIOD_M1,0);
 
 if(!isNewBar()) {
   Query = "INSERT INTO `"+Ativo+"` (time, low, close) VALUES ("+TimeToString(TimeLocal(), TIME_DATE|TIME_SECONDS)+","+xLow+","+xClose+")";
   }
  }
 }
 
 void OnDeinit() {
 MySqlDisconnect(DB);
 ExtExpert.Deinit();
 Print ("Disconnected. Script done!");
}


bool isNewBar()
  {
   static datetime last_time=0;
   datetime lastbar_time=SeriesInfoInteger(Symbol(),Period(),SERIES_LASTBAR_DATE);
   if(last_time==0)
     {
      last_time=lastbar_time;
      return(false);
     }
   if(last_time!=lastbar_time)
     {
      last_time=lastbar_time;
      return(true);
     }
   return(false);
  }