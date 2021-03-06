//+------------------------------------------------------------------+
//|                                                     RosieBot.mq5 |
//|                                           Copyright 2018, VANTTO |
//|                                        https://www.vantto.com.br |
//+------------------------------------------------------------------+
#include "CreateGUI.mqh"
//+------------------------------------------------------------------+
//| Classe para criar o programa                                                                 |
//+------------------------------------------------------------------+
class CProgram : public CWndEvents
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
      
//+----------´--------------------------------------------------------+
//| Criando o formulário para os controles                            |
//+----------´--------------------------------------------------------+
bool CProgram::CreateWindow(const string caption_text)
  {
//--- Adicione o ponteiro da janela para a matriz de janelas
   CWndContainer::AddWindow(m_window1);
//--- Propriedades
   m_window1.XSize(750);
   m_window1.YSize(450);
   m_window1.FontSize(9);
   m_window1.IsMovable(true);
   m_window1.ResizeMode(true);
   m_window1.CloseButtonIsUsed(true);
   m_window1.CollapseButtonIsUsed(true);
   m_window1.TooltipsButtonIsUsed(true);
   m_window1.FullscreenButtonIsUsed(true);
//--- Defina as dicas de balão
   m_window1.GetCloseButtonPointer().Tooltip("Close");
   m_window1.GetTooltipButtonPointer().Tooltip("Tooltips");
   m_window1.GetFullscreenButtonPointer().Tooltip("Fullscreen");
   m_window1.GetCollapseButtonPointer().Tooltip("Collapse/Expand");
//--- Criação do formulário
   if(!m_window1.CreateWindow(m_chart_id,m_subwin,caption_text,1,1))
      return(false);
//---
   return(true);
  }