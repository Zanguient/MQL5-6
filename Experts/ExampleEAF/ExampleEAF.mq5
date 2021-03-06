//+------------------------------------------------------------------+
//|                                                TestLibrary16.mq5 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2017, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
//--- Подключение класса приложения
#include "Program.mqh"
CProgram program;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   ulong tick_counter=::GetTickCount();
//---
   program.OnInitEvent();
//--- Установим торговую панель
   if(!program.CreateGUI())
     {
      ::Print(__FUNCTION__," > Не удалось создать графический интерфейс!");
      return(INIT_FAILED);
     }
//---
   ::Print(__FUNCTION__," > objects total: ",::ObjectsTotal(0),"; total ms: ",::GetTickCount()-tick_counter);
//--- Инициализация прошла успешно
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   program.OnDeinitEvent(reason);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(void)
  {
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer(void)
  {
   program.OnTimerEvent();
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade(void)
  {
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int    id,
                  const long   &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   program.ChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
