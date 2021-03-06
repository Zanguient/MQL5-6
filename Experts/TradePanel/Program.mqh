//+------------------------------------------------------------------+
//|                                                     RosieBot.mq5 |
//|                                           Copyright 2018, VANTTO |
//|                                        https://www.vantto.com.br |
//+------------------------------------------------------------------+
#include "CreateGUI.mqh"
//+------------------------------------------------------------------+
//| Classe para criar o programa                                                                 |
//+------------------------------------------------------------------+
class Cprogram : public CWndEvents
   {
private:
   //--- Janela
   CWindow     m_window1;
   
   //--- Barra de Status
   CStatusBar  m_status_bar;
   
   //--- Guias
   Ctabs       m_tabs1;
   
   //--- Campo inserido
   CTextEdit   m_symb_filter;
   CTextEdit   m_lot;
   CTextEdit   m_up_level;
   CTextEdit   m_down_level;
   CTextEdit   m_chart_scale;
   
   //--- Botões
   CButton     m_request;
   CButton     m_chart_shift;
   CButton     m_buy;
   CButton     m_sell;
   CButton     m_close_all;
   
   //--- Caixas de combinação
   CComboBox   m_timeframes;
   
   //--- Caixas de verificação
   CCheckBox   m_date_scale;
   CCheckBox   m_price_scale;
   CCheckBox   m_show_indicator;
   
   //--- Tabelas
   CTable      m_table_position;
   CTable      m_table_symb;
   
   //--- Gráfico padrão
   CStandardChart m_sub_chart1;
   
   //--- Barra de progresso
   CprogressBar   m_progress_bar;
   
   public:
      //--- Cria uma interface gráfica
      bool     CreateGUI(void);
   private:
      //--- Formulário
      bool     CreateWindow(const string text);
      
      //--- Barra de Status
      bool     CreateStatusBar(const int x_gap, const int y_gap);
      
      //--- Guias
      bool     CreateTabs1(const int x_gap, const int y_gap);
      
      //--- Campo inserido
      bool     CreateSymbFilter(const int x_gap, const int y_gap, const string text);
      bool     CreateLot(const int x_gap, const int y_gap, const string text);
      bool     CreateUpLevel(const int x_gap, const int y_gap, const string text);
      bool     CreateDownLevel(const int x_gap, const int y_gap, const string text);
      bool     CreateChartScale(const int x_gap, const int y_gap, const string text);
      
      //--- Botões
      bool     CreateRequest(const int x_gap, const int y_gap, const string text);
      bool     CreateChartShift(const int x_gap, const int y_gap, const string text);
      bool     CreateBuy(const int x_gap, const int y_gap, const string text);
      bool     CreateSell(const int x_gap, const int y_gap, const string text);
      bool     CreateCloseAll(const int x_gap, const int y_gap, const string text);
      
      //--- Caixa de combinação
      bool     CreateComboBoxTF(const int x_gap, const int y_gap, const string text);
      
      //--- Caixas de verificação
      bool     CreateDateScale(const int x_gap, const int y_gap, const string text);
      bool     CreatePriceScale(const int x_gap, const int y_gap, const string text);
      bool     CreateShowIndicator(const int x_gap, const int  y_gap, const string text);
      
      //--- Tabelas
      bool     CreatePositionsTable(const int x_gap, const int y_gap);
      bool     CreateSymbolsTable(const int x_gap, const int y_gap);
      
      //--- Gráfico padrão
      bool     CreateSubChart1(const int x_gap, const int y_gap);
      
      //--- Barra de progresso
      bool     CreateProgressBar(const int x_gap, const int y_gap, const string text);
      };