//+------------------------------------------------------------------+
//|                                                     MM_Lucas.mq5 |
//|                                           Copyright 2018, VANTTO |
//|                                        https://www.vantto.com.br |
//+------------------------------------------------------------------+
//--- indicator buffers
double         MediamaeBuffer[];
double         MediaaBuffer[];
double         MediabBuffer[];
double         MediacBuffer[];
//--- Variáveis
input int periodo_mae=200;
input int periodo_1=21;
input int periodo_2=44;
input int periodo_3=66;
input double desvio=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,MediamaeBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,MediaaBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,MediabBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,MediacBuffer,INDICATOR_DATA);
   PlotIndexSetInteger(0,PLOT_LINE_WIDTH,2);
   PlotIndexSetInteger(1,PLOT_LINE_WIDTH,2);
   PlotIndexSetInteger(2,PLOT_LINE_WIDTH,2);
   PlotIndexSetInteger(3,PLOT_LINE_WIDTH,2);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
    //+------------------------------------------------------------------+
    //| Medias moveis                                                    |
    //+------------------------------------------------------------------+
   
   //--- Media mãe
   for (int i=(periodo_mae)-1; i<rates_total; i++)
   {
   //---Variaveis do for
    double media_m=0;
    for(int j=0; j<periodo_mae; j++)
      {
       media_m= media_m + close[i-j] / periodo_mae;
      }
   MediamaeBuffer[i]=(media_m) * (1+desvio/100);
   }  
   
   //--- Media 1
   for (int i=(periodo_1)-1; i<rates_total; i++)
   {
   //---Variaveis do for
    double media_a=0;
    for(int j=0; j<periodo_1; j++)
      {
       media_a = media_a + close[i-j] / periodo_1;
      }
   MediaaBuffer[i]=(media_a) * (1+desvio/100);
   }  
   
   //--- Media 2
   for (int i=periodo_2-1; i<rates_total; i++)
   {
   //---Variaveis do for
    double media_b=0;
    for(int j=0; j<periodo_2; j++)
      {
       media_b = media_b + close[i-j] / periodo_2;
      }
   MediabBuffer[i]=(media_b) * (1+desvio/100);
   }  
   
    //--- Media 3
   for (int i=periodo_3-1; i<rates_total; i++)
   {
   //---Variaveis do for
    double media_c=0;
    for(int j=0; j<periodo_3; j++)
      {
       media_c = media_c + close[i-j] / periodo_3;
      }
   MediacBuffer[i]=(media_c) * (1+desvio/100);
   }  

   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
