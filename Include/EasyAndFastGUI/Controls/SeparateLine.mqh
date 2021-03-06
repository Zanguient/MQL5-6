//+------------------------------------------------------------------+
//|                                                 SeparateLine.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//+------------------------------------------------------------------+
//| Класс для создания разделительной линии                          |
//+------------------------------------------------------------------+
class CSeparateLine : public CElement
  {
private:
   //--- Свойства
   ENUM_TYPE_SEP_LINE m_type_sep_line;   
   color             m_dark_color;
   color             m_light_color;
   //---
public:
                     CSeparateLine(void);
                    ~CSeparateLine(void);
   //--- Создание разделительной линии
   bool              CreateSeparateLine(const int x_gap,const int y_gap,const int x_size,const int y_size);
   //---
private:
   //--- Создаёт холст для рисования разделительной линии
   bool              CreateSepLine(void);
   //---
public:
   //--- (1) Тип линии, (2) цвета линии
   void              TypeSepLine(const ENUM_TYPE_SEP_LINE type) { m_type_sep_line=type; }
   void              DarkColor(const color clr)                 { m_dark_color=clr;     }
   void              LightColor(const color clr)                { m_light_color=clr;    }
   //---
public:
   //--- Рисует элемент
   virtual void      Draw(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSeparateLine::CSeparateLine(void) : m_type_sep_line(H_SEP_LINE),
                                     m_dark_color(C'160,160,160'),
                                     m_light_color(clrWhite)
  {
//--- Сохраним имя класса элемента в базовом классе  
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSeparateLine::~CSeparateLine(void)
  {
  }
//+------------------------------------------------------------------+
//| Создаёт разделительную линию                                     |
//+------------------------------------------------------------------+
bool CSeparateLine::CreateSeparateLine(const int x_gap,const int y_gap,const int x_size,const int y_size)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   m_x      =CElement::CalculateX(x_gap);
   m_y      =CElement::CalculateY(y_gap);
   m_x_size =x_size;
   m_y_size =y_size;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
//--- Создание элемента
   if(!CreateSepLine())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт холст для рисования разделительной линии                 |
//+------------------------------------------------------------------+
bool CSeparateLine::CreateSepLine(void)
  {
//--- Формирование имени объекта  
   string name=CElementBase::ElementName("separate_line");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
     return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CSeparateLine::Draw(void)
  {
//--- Координаты для линий
   int x1=0,x2=0,y1=0,y2=0;
//--- Размеры холста
   int x_size =(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_XSIZE)-1;
   int y_size =(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_YSIZE)-1;
//--- Очистить холст
   m_canvas.Erase(::ColorToARGB(clrNONE,0));
//--- Если линия горизонтальная
   if(m_type_sep_line==H_SEP_LINE)
     {
      //--- Сверху тёмная линия
      x1=0; y1=0; x2=x_size; y2=0;
      m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_dark_color));
      //--- Снизу светлая линия
      x1=0; x2=x_size; y1=y_size; y2=y_size;
      m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_light_color));
     }
//--- Если линия вертикальная
   else
     {
      //--- Слева тёмная линия
      x1=0; x2=0; y1=0; y2=y_size;
      m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_dark_color));
      //--- Справа светлая линия
      x1=x_size; y1=0; x2=x_size; y2=y_size;
      m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_light_color));
     }
  }
//+------------------------------------------------------------------+
