//+------------------------------------------------------------------+
//|                                                       Slider.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextEdit.mqh"
//+------------------------------------------------------------------+
//| Класс для создания слайдера с полем ввода                        |
//+------------------------------------------------------------------+
class CSlider : public CElement
  {
private:
   //--- Объекты для создания элемента
   CTextEdit         m_left_edit;
   CTextEdit         m_right_edit;
   //--- (1) Координата и (2) размер области индикатора
   int               m_slot_y;
   int               m_slot_y_size;
   //--- Цвета индикатора в разных состояниях
   color             m_slot_line_dark_color;
   color             m_slot_line_light_color;
   color             m_slot_indicator_color;
   color             m_slot_indicator_color_locked;
   //--- Текущая позиция ползунка слайдера: (1) значение, (2) координаты XY
   double            m_thumb_x_pos_left;
   double            m_thumb_x_pos_right;
   double            m_thumb_x_left;
   double            m_thumb_x_right;
   int               m_thumb_y;
   //--- Размеры ползунка слайдера
   int               m_thumb_x_size;
   int               m_thumb_y_size;
   //--- Цвета ползунка слайдера
   color             m_thumb_color;
   color             m_thumb_color_hover;
   color             m_thumb_color_locked;
   color             m_thumb_color_pressed;
   //--- (1) Фокус на ползунке и (2) момент его пересечения границ
   bool              m_thumb_focus_left;
   bool              m_thumb_focus_right;
   bool              m_is_crossing_left_thumb_border;
   bool              m_is_crossing_right_thumb_border;
   //--- Количество пикселей в рабочей области
   int               m_pixels_total;
   //--- Количество шагов в диапазоне значений рабочей области
   int               m_value_steps_total;
   //--- Размер шага относительно ширины рабочей области
   double            m_position_step;
   //--- Состояние кнопки мыши (нажата/отжата)
   ENUM_MOUSE_STATE  m_clamping_left_thumb;
   ENUM_MOUSE_STATE  m_clamping_right_thumb;
   //--- Для определения режима перемещения ползунка слайдера
   bool              m_slider_thumb_state;
   //--- Переменные связанные с перемещением ползунка
   int               m_slider_size_fixing;
   int               m_slider_point_fixing;
   //--- Режим двойного слайдера
   bool              m_dual_slider_mode;
   //---
public:
                     CSlider(void);
                    ~CSlider(void);
   //--- Методы для создания элемента
   bool              CreateSlider(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateLeftTextEdit(void);
   bool              CreateRightTextEdit(void);
   //---
public:
   //--- Возвращает указатели на элементы
   CTextEdit        *GetLeftEditPointer(void)                   { return(::GetPointer(m_left_edit));  }
   CTextEdit        *GetRightEditPointer(void)                  { return(::GetPointer(m_right_edit)); }
   //--- Цвета индикатора слайдера в разных состояниях
   void              SlotLineDarkColor(const color clr)         { m_slot_line_dark_color=clr;         }
   void              SlotLineLightColor(const color clr)        { m_slot_line_light_color=clr;        }
   void              SlotIndicatorColor(const color clr)        { m_slot_indicator_color=clr;         }
   void              SlotIndicatorColorLocked(const color clr)  { m_slot_indicator_color_locked=clr;  }
   //--- Режим двойного слайдера
   void              DualSliderMode(const bool state)           { m_dual_slider_mode=state;           }
   bool              DualSliderMode(void)                 const { return(m_dual_slider_mode);         }
   bool              State(void)                          const { return(m_slider_thumb_state);       }
   //--- Размеры ползунка слайдера
   void              ThumbXSize(const int x_size)               { m_thumb_x_size=x_size;              }
   void              ThumbYSize(const int y_size)               { m_thumb_y_size=y_size;              }
   //--- Цвета ползунка слайдера
   void              ThumbColor(const color clr)                { m_thumb_color=clr;                  }
   void              ThumbColorHover(const color clr)           { m_thumb_color_hover=clr;            }
   void              ThumbColorLocked(const color clr)          { m_thumb_color_locked=clr;           }
   void              ThumbColorPressed(const color clr)         { m_thumb_color_pressed=clr;          }
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Обработка ввода значения в поле ввода
   bool              OnEndEditLeftThumb(const int id,const int index);
   bool              OnEndEditRightThumb(const int id,const int index);
   //--- Процесс перемещения ползунка слайдера
   void              OnDragLeftThumb(void);
   void              OnDragRightThumb(void);
   //--- Обновление положения ползунка слайдера
   void              UpdateLeftThumb(const int new_x_point);
   void              UpdateRightThumb(const int new_x_point);

   //--- Проверка фокуса над ползунком
   bool              CheckLeftThumbFocus(void);
   bool              CheckRightThumbFocus(void);
   //--- Проверяет состояние кнопки мыши
   void              CheckMouseOnLeftThumb(void);
   void              CheckMouseOnRightThumb(void);
   //--- Обнуление переменных связанных с перемещением ползунка слайдера
   void              ZeroLeftThumbVariables(void);
   void              ZeroRightThumbVariables(void);
   //--- Расчёт значений (шаги и коэффициенты)
   bool              CalculateCoefficients(void);
   //--- Расчёт координаты X ползунка слайдера
   void              CalculateLeftThumbX(void);
   void              CalculateRightThumbX(void);
   //--- Изменяет позицию ползунка слайдера относительно текущего значения
   void              CalculateLeftThumbPos(void);
   void              CalculateRightThumbPos(void);
   //--- Текущий цвет ползунка
   uint              ThumbColorCurrent(const bool thumb_focus,const ENUM_MOUSE_STATE thumb_clamping);

   //--- Рисует границы для индикатора
   void              DrawSlot(void);
   //--- Рисует индикатор
   void              DrawIndicator(void);
   //--- Рисует ползунок слайдера
   void              DrawLeftThumb(void);
   void              DrawRightThumb(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSlider::CSlider(void) : m_dual_slider_mode(false),
                         m_slider_size_fixing(0),
                         m_slider_point_fixing(0),
                         m_slot_y(30),
                         m_slot_y_size(4),
                         m_slot_line_dark_color(clrSilver),
                         m_slot_line_light_color(clrWhite),
                         m_slot_indicator_color(C'85,170,255'),
                         m_slot_indicator_color_locked(clrLightGray),
                         m_thumb_x_pos_left(WRONG_VALUE),
                         m_thumb_x_pos_right(WRONG_VALUE),
                         m_thumb_x_left(0),
                         m_thumb_x_right(0),
                         m_thumb_y(0),
                         m_thumb_x_size(6),
                         m_thumb_y_size(14),
                         m_thumb_color(C'205,205,205'),
                         m_thumb_color_hover(C'166,166,166'),
                         m_thumb_color_locked(clrLightGray),
                         m_thumb_color_pressed(C'96,96,96'),
                         m_thumb_focus_left(false),
                         m_thumb_focus_right(false),
                         m_is_crossing_left_thumb_border(false),
                         m_is_crossing_right_thumb_border(false)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSlider::~CSlider(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик события графика                                       |
//+------------------------------------------------------------------+
void CSlider::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Проверим и запомним состояние кнопки мыши
      CheckMouseOnRightThumb();
      //--- Изменим цвет ползунка слайдера
      CheckRightThumbFocus();
      //--- Если управление передано полосе слайдера, определим её положение
      if(m_clamping_right_thumb==PRESSED_INSIDE)
        {
         //--- Перемещение ползунка слайдера
         OnDragRightThumb();
         //--- Расчёт позиции ползунка слайдера в диапазоне значений
         CalculateRightThumbPos();
         //--- Установка нового значения в поле ввода
         m_right_edit.SetValue(::DoubleToString(m_thumb_x_pos_right,m_right_edit.GetDigits()),false);
         //--- Обновить элемент
         Update(true);
         m_right_edit.GetTextBoxPointer().Update(true);
         return;
        }
      //--- Выйти, если это не двойной слайдер
      if(!m_dual_slider_mode)
         return;
      //--- Проверим и запомним состояние кнопки мыши
      CheckMouseOnLeftThumb();
      //--- Изменим цвет ползунка слайдера
      CheckLeftThumbFocus();
      //--- Если управление передано полосе слайдера, определим её положение
      if(m_clamping_left_thumb==PRESSED_INSIDE)
        {
         //--- Перемещение ползунка слайдера
         OnDragLeftThumb();
         //--- Расчёт позиции ползунка слайдера в диапазоне значений
         CalculateLeftThumbPos();
         //--- Установка нового значения в поле ввода
         m_left_edit.SetValue(::DoubleToString(m_thumb_x_pos_left,m_left_edit.GetDigits()),false);
         //--- Обновить элемент
         Update(true);
         m_left_edit.GetTextBoxPointer().Update(true);
         return;
        }
      return;
     }
//--- Обработка события изменения значения в поле ввода
   if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)
     {
      //--- Обработка ввода значения
      if(OnEndEditLeftThumb((int)lparam,(int)dparam))
         return;
      //--- Обработка ввода значения
      if(OnEndEditRightThumb((int)lparam,(int)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт слайдер с полем ввода                                    |
//+------------------------------------------------------------------+
bool CSlider::CreateSlider(const string text,const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(text,x_gap,y_gap);
//--- Создание элемента
   if(!CreateCanvas())
      return(false);
   if(!CreateRightTextEdit())
      return(false);
   if(!CreateLeftTextEdit())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CSlider::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x           =CElement::CalculateX(x_gap);
   m_y           =CElement::CalculateY(y_gap);
   m_label_text  =text;
   m_back_color  =(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
   m_border_color=(m_border_color!=clrNONE)? m_border_color : clrBlack;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CSlider::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("slider");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт поле ввода                                               |
//+------------------------------------------------------------------+
bool CSlider::CreateRightTextEdit(void)
  {
//--- Сохраним указатель на главный элемент
   m_right_edit.MainPointer(this);
//--- Координаты
   int x=0,y=0;
//--- Свойства
   m_right_edit.Index(0);
   m_right_edit.YSize(20);
   m_right_edit.LabelXGap(0);
   m_right_edit.MaxValue((m_right_edit.MaxValue()==DBL_MAX)? 1000 : m_right_edit.MaxValue());
   m_right_edit.MinValue((m_right_edit.MinValue()==DBL_MIN)? -1000 : m_right_edit.MinValue());
   m_right_edit.StepValue(m_right_edit.StepValue());
   m_right_edit.SetDigits(m_right_edit.GetDigits());
//--- Значение в поле ввода
   int digits=m_right_edit.GetDigits();
   string value=(m_right_edit.GetValue()=="")? ::DoubleToString(0,digits) : m_right_edit.GetValue();
   m_right_edit.SetValue(value);
//--- Размер
   int xsize=m_right_edit.GetTextBoxPointer().XSize();
   m_right_edit.GetTextBoxPointer().XSize((xsize>0)? xsize : 60);
//---
   m_right_edit.AutoXResizeMode(true);
   m_right_edit.IsDropdown(CElementBase::IsDropdown());
   m_right_edit.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Создадим элемент управления
   if(!m_right_edit.CreateTextEdit(m_label_text,x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_right_edit);
//--- Расчёт значений вспомогательных переменных
   CalculateCoefficients();
//--- Расчёт координаты X ползунка относительно текущего значения в поле ввода
   CalculateRightThumbX();
//--- Расчёт координаты Y ползунка 
   m_thumb_y=m_slot_y-((m_thumb_y_size-m_slot_y_size)/2);
//--- Расчёт позиции ползунка слайдера в диапазоне значений
   CalculateRightThumbPos();
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт поле ввода                                               |
//+------------------------------------------------------------------+
bool CSlider::CreateLeftTextEdit(void)
  {
   if(!m_dual_slider_mode)
      return(true);
//--- Сохраним указатель на родителя
   m_left_edit.MainPointer(this);
//--- Размеры
   int x_size=m_right_edit.GetTextBoxPointer().XSize();
//--- Координаты
   int x=x_size*2+2;
   int y=0;
//--- Свойства
   m_left_edit.Index(1);
   m_left_edit.XSize(x_size+1);
   m_left_edit.YSize(20);
   m_left_edit.LabelXGap(0);
   m_left_edit.MaxValue(m_right_edit.MaxValue());
   m_left_edit.MinValue(m_right_edit.MinValue());
   m_left_edit.StepValue(m_right_edit.StepValue());
   m_left_edit.SetDigits(m_right_edit.GetDigits());
//--- Значение в поле ввода
   int digits=m_right_edit.GetDigits();
   string value=(m_left_edit.GetValue()=="")? ::DoubleToString(0,digits) : m_left_edit.GetValue();
   m_left_edit.SetValue((string)value);
   m_left_edit.AnchorRightWindowSide(true);
   m_left_edit.IsDropdown(CElementBase::IsDropdown());
   m_left_edit.GetTextBoxPointer().XSize(x_size);
   m_left_edit.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Создадим элемент управления
   if(!m_left_edit.CreateTextEdit("",x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_left_edit);
//--- Расчёт координаты X ползунка относительно текущего значения в поле ввода
   CalculateLeftThumbX();
//--- Расчёт позиции ползунка слайдера в диапазоне значений
   CalculateLeftThumbPos();
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка ввода значения в поле ввода                            |
//+------------------------------------------------------------------+
bool CSlider::OnEndEditLeftThumb(const int id,const int index)
  {
//--- Выйдем, если идентификаторы и индексы не совпадают
   if(id!=m_left_edit.Id() || index!=m_left_edit.Index())
      return(false);
//--- Получим только что введённое значение
   double entered_value=::StringToDouble(m_left_edit.GetValue());
//--- Рассчитаем координату X ползунка
   CalculateLeftThumbX();
//--- Обновление положения ползунка слайдера
   UpdateLeftThumb((int)m_thumb_x_left);
//--- Рассчитаем позицию в диапазоне значений
   CalculateLeftThumbPos();
//--- Установка нового значения в поле ввода
   m_left_edit.SetValue(::DoubleToString(m_thumb_x_pos_left,m_left_edit.GetDigits()));
//--- Обновить элемент
   Update(true);
   m_left_edit.GetTextBoxPointer().Update(true);
//--- Отправим сообщение об этом
//::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),index,m_label_text);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка ввода значения в поле ввода                            |
//+------------------------------------------------------------------+
bool CSlider::OnEndEditRightThumb(const int id,const int index)
  {
//--- Выйдем, если идентификаторы и индексы не совпадают
   if(id!=m_right_edit.Id() || index!=m_right_edit.Index())
      return(false);
//--- Получим только что введённое значение
   double entered_value=::StringToDouble(m_right_edit.GetValue());
//--- Рассчитаем координату X ползунка
   CalculateRightThumbX();
//--- Обновление положения ползунка слайдера
   UpdateRightThumb((int)m_thumb_x_right);
//--- Рассчитаем позицию в диапазоне значений
   CalculateRightThumbPos();
//--- Установка нового значения в поле ввода
   m_right_edit.SetValue(::DoubleToString(m_thumb_x_pos_right,m_right_edit.GetDigits()));
//--- Обновить элемент
   Update(true);
   m_right_edit.GetTextBoxPointer().Update(true);
//--- Отправим сообщение об этом
//::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),index,m_label_text);
   return(true);
  }
//+------------------------------------------------------------------+
//| Процесс перемещения ползунка слайдера                            |
//+------------------------------------------------------------------+
void CSlider::OnDragLeftThumb(void)
  {
   int x=m_mouse.RelativeX(m_canvas);
//--- Для определения новой X координаты
   int new_x_point=0;
//--- Если ползунок слайдера неактивен, ...
   if(!m_slider_thumb_state)
     {
      //--- ...обнулим вспомогательные переменные для перемещения ползунка
      m_slider_point_fixing =0;
      m_slider_size_fixing  =0;
      return;
     }
//--- Если точка фиксации нулевая, то запомним текущую координату курсора
   if(m_slider_point_fixing==0)
      m_slider_point_fixing=x;
//--- Если значение расстояния от крайней точки ползунка до текущей координаты курсора нулевое, рассчитаем его
   if(m_slider_size_fixing==0)
      m_slider_size_fixing=(int)m_thumb_x_left-x;
//--- Если в нажатом состоянии прошли порог вправо
   if(x-m_slider_point_fixing>0)
     {
      //--- Рассчитаем координату X
      new_x_point=x+m_slider_size_fixing;
      //--- Обновление положения полосы прокрутки
      UpdateLeftThumb(new_x_point);
      return;
     }
//--- Если в нажатом состоянии прошли порог влево
   if(x-m_slider_point_fixing<0)
     {
      //--- Рассчитаем координату X
      new_x_point=x-::fabs(m_slider_size_fixing);
      //--- Обновление положения полосы прокрутки
      UpdateLeftThumb(new_x_point);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Процесс перемещения ползунка слайдера                            |
//+------------------------------------------------------------------+
void CSlider::OnDragRightThumb(void)
  {
   int x=m_mouse.RelativeX(m_canvas);
//--- Для определения новой X координаты
   int new_x_point=0;
//--- Если ползунок слайдера неактивен, ...
   if(!m_slider_thumb_state)
     {
      //--- ...обнулим вспомогательные переменные для перемещения ползунка
      m_slider_point_fixing =0;
      m_slider_size_fixing  =0;
      return;
     }
//--- Если точка фиксации нулевая, то запомним текущую координату курсора
   if(m_slider_point_fixing==0)
      m_slider_point_fixing=x;
//--- Если значение расстояния от крайней точки ползунка до текущей координаты курсора нулевое, рассчитаем его
   if(m_slider_size_fixing==0)
      m_slider_size_fixing=(int)m_thumb_x_right-x;
//--- Если в нажатом состоянии прошли порог вправо
   if(x-m_slider_point_fixing>0)
     {
      //--- Рассчитаем координату X
      new_x_point=x+m_slider_size_fixing;
      //--- Обновление положения полосы прокрутки
      UpdateRightThumb(new_x_point);
      return;
     }
//--- Если в нажатом состоянии прошли порог влево
   if(x-m_slider_point_fixing<0)
     {
      //--- Рассчитаем координату X
      new_x_point=x-::fabs(m_slider_size_fixing);
      //--- Обновление положения полосы прокрутки
      UpdateRightThumb(new_x_point);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Обновление положения ползунка слайдера                           |
//+------------------------------------------------------------------+
void CSlider::UpdateLeftThumb(const int new_x_point)
  {
   int x=new_x_point;
//--- Обнуление точки фиксации
   m_slider_point_fixing=0;
//--- Правая граница
   int right_limit=(!m_dual_slider_mode)? m_x_size-m_thumb_x_size :(int)m_thumb_x_right-m_thumb_x_size;
//--- Проверка на выход из рабочей области
   if(x>right_limit)
      x=right_limit;
   if(x<=0)
      x=0;
//--- Сохранить координату
   m_thumb_x_left=x;
  }
//+------------------------------------------------------------------+
//| Обновление положения ползунка слайдера                           |
//+------------------------------------------------------------------+
void CSlider::UpdateRightThumb(const int new_x_point)
  {
   int x=new_x_point;
//--- Обнуление точки фиксации
   m_slider_point_fixing=0;
//--- Правая граница
   int right_limit=m_x_size-m_thumb_x_size;
//--- Левая граница
   int left_limit=(!m_dual_slider_mode)? 0 :(int)m_thumb_x_left+m_thumb_x_size;
//--- Проверка на выход из рабочей области
   if(x>right_limit)
      x=right_limit;
   if(x<=left_limit)
      x=left_limit;
//--- Сохранить координату
   m_thumb_x_right=x;
  }
//+------------------------------------------------------------------+
//| Текущий цвет ползунка                                            |
//+------------------------------------------------------------------+
uint CSlider::ThumbColorCurrent(const bool thumb_focus,const ENUM_MOUSE_STATE thumb_clamping)
  {
//--- Определим цвет ползунка
   color clr=(thumb_clamping==PRESSED_INSIDE)? m_thumb_color_pressed : m_thumb_color;
//--- Если курсор мыши в зоне ползунка
   if(thumb_focus)
     {
      //--- Если левая кнопка мыши отжата
      if(thumb_clamping==NOT_PRESSED)
         clr=m_thumb_color_hover;
      //--- Левая кнопка мыши нажата на ползунке
      else if(thumb_clamping==PRESSED_INSIDE)
         clr=m_thumb_color_pressed;
     }
//--- Если курсор вне зоны ползунка
   else
     {
      //--- Левая кнопка мыши отжата
      if(thumb_clamping==NOT_PRESSED)
         clr=(m_is_locked)? m_thumb_color_locked : m_thumb_color;
     }
//---
   return(::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Проверка фокуса над ползунком                                    |
//+------------------------------------------------------------------+
bool CSlider::CheckLeftThumbFocus(void)
  {
//--- Выйти, если невалидный указатель
   if(::CheckPointer(m_mouse)==POINTER_INVALID)
      return(false);
//--- Проверка фокуса над ползунком
   int x =m_mouse.RelativeX(m_canvas);
   int y =m_mouse.RelativeY(m_canvas);
//--- Проверка фокуса
   m_thumb_focus_left=(x>m_thumb_x_left && x<m_thumb_x_left+m_thumb_x_size && 
                       y>m_thumb_y && y<m_thumb_y+m_thumb_y_size);
//--- Если это момент пересечения границ элемента
   if((m_thumb_focus_left && !m_is_crossing_left_thumb_border) || 
      (!m_thumb_focus_left && m_is_crossing_left_thumb_border))
     {
      m_is_crossing_left_thumb_border=m_thumb_focus_left;
      //--- Нарисовать прямоугольник с заливкой
      DrawLeftThumb();
      m_canvas.Update();
      return(true);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Проверка фокуса над ползунком                                    |
//+------------------------------------------------------------------+
bool CSlider::CheckRightThumbFocus(void)
  {
//--- Выйти, если невалидный указатель
   if(::CheckPointer(m_mouse)==POINTER_INVALID)
      return(false);
//--- Проверка фокуса над ползунком
   int x =m_mouse.RelativeX(m_canvas);
   int y =m_mouse.RelativeY(m_canvas);
//--- Проверка фокуса
   m_thumb_focus_right=(x>m_thumb_x_right && x<m_thumb_x_right+m_thumb_x_size && 
                        y>m_thumb_y && y<m_thumb_y+m_thumb_y_size);
//--- Если это момент пересечения границ элемента
   if((m_thumb_focus_right && !m_is_crossing_right_thumb_border) || 
      (!m_thumb_focus_right && m_is_crossing_right_thumb_border))
     {
      m_is_crossing_right_thumb_border=m_thumb_focus_right;
      //--- Нарисовать прямоугольник с заливкой
      DrawRightThumb();
      m_canvas.Update();
      return(true);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Проверяет состояние кнопки мыши                                  |
//+------------------------------------------------------------------+
void CSlider::CheckMouseOnLeftThumb(void)
  {
//--- Выйти, если это не двойной слайдер
   if(!m_dual_slider_mode)
      return;
//--- Если левая кнопка мыши отжата
   if(!m_mouse.LeftButtonState())
     {
      //--- Обнулим переменные
      ZeroLeftThumbVariables();
      return;
     }
//--- Если левая кнопка мыши нажата
   else
     {
      //--- Выйдем, если кнопка уже нажата в какой-либо области
      if(m_clamping_left_thumb!=NOT_PRESSED)
         return;
      //--- Вне области ползунка слайдера
      if(!m_thumb_focus_left)
         m_clamping_left_thumb=PRESSED_OUTSIDE;
      //--- В области ползунка слайдера
      else
        {
         m_slider_thumb_state  =true;
         m_clamping_left_thumb =PRESSED_INSIDE;
         //--- Перерисовать ползунок
         DrawLeftThumb();
         m_canvas.Update();
         //--- Отправим сообщение на определение доступных элементов
         ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
         //--- Отправим сообщение об изменении в графическом интерфейсе
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
        }
     }
  }
//+------------------------------------------------------------------+
//| Проверяет состояние кнопки мыши                                  |
//+------------------------------------------------------------------+
void CSlider::CheckMouseOnRightThumb(void)
  {
//--- Если левая кнопка мыши отжата
   if(!m_mouse.LeftButtonState())
     {
      //--- Обнулим переменные
      ZeroRightThumbVariables();
      return;
     }
//--- Если левая кнопка мыши нажата
   else
     {
      //--- Выйдем, если кнопка уже нажата в какой-либо области
      if(m_clamping_right_thumb!=NOT_PRESSED)
         return;
      //--- Вне области ползунка слайдера
      if(!m_thumb_focus_right)
         m_clamping_right_thumb=PRESSED_OUTSIDE;
      //--- В области ползунка слайдера
      else
        {
         m_slider_thumb_state=true;
         m_clamping_right_thumb=PRESSED_INSIDE;
         //--- Перерисовать ползунок
         DrawRightThumb();
         m_canvas.Update();
         //--- Отправим сообщение на определение доступных элементов
         ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
         //--- Отправим сообщение об изменении в графическом интерфейсе
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
        }
     }
  }
//+------------------------------------------------------------------+
//| Обнуление переменных связанных с перемещением ползунка слайдера  |
//+------------------------------------------------------------------+
void CSlider::ZeroLeftThumbVariables(void)
  {
//--- Выйти, если это не двойной слайдер
   if(!m_dual_slider_mode)
      return;
//--- Если зашли сюда, то это значит, что левая кнопка мыши отжата.
//    Если до этого зажатие левой кнопки мыши было осуществлено над ползунком слайдера...
   if(m_clamping_left_thumb==PRESSED_INSIDE)
     {
      //--- ... отправим сообщение, что изменение значения в поле ввода посредством ползунка завершена
      ::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),CElementBase::Index(),"");
      //--- Отправим сообщение на определение доступных элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
     }
//--- Обнулить переменные
   if(m_clamping_left_thumb!=NOT_PRESSED)
     {
      m_slider_thumb_state  =false;
      m_slider_size_fixing  =0;
      m_clamping_left_thumb =NOT_PRESSED;
      //--- Перерисовать ползунок
      DrawLeftThumb();
      m_canvas.Update();
     }
  }
//+------------------------------------------------------------------+
//| Обнуление переменных связанных с перемещением ползунка слайдера  |
//+------------------------------------------------------------------+
void CSlider::ZeroRightThumbVariables(void)
  {
//--- Если зашли сюда, то это значит, что левая кнопка мыши отжата.
//    Если до этого зажатие левой кнопки мыши было осуществлено над ползунком слайдера...
   if(m_clamping_right_thumb==PRESSED_INSIDE)
     {
      //--- ... отправим сообщение, что изменение значения в поле ввода посредством ползунка завершена
      ::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),CElementBase::Index(),"");
      //--- Отправим сообщение на определение доступных элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
     }
//--- Обнулить переменные
   if(m_clamping_right_thumb!=NOT_PRESSED)
     {
      m_slider_thumb_state   =false;
      m_slider_size_fixing   =0;
      m_clamping_right_thumb =NOT_PRESSED;
      //--- Перерисовать ползунок
      DrawRightThumb();
      m_canvas.Update();
     }
  }
//+------------------------------------------------------------------+
//| Расчёт значений (шаги и коэффициенты)                            |
//+------------------------------------------------------------------+
bool CSlider::CalculateCoefficients(void)
  {
//--- Выйти, если ширина элемента меньше, чем ширина ползунка слайдера
   if(CElementBase::XSize()<m_thumb_x_size)
      return(false);
//--- Количество пикселей в рабочей области
   m_pixels_total=CElementBase::XSize()-m_thumb_x_size;
//--- Количество шагов в диапазоне значений рабочей области
   m_value_steps_total=int((m_right_edit.MaxValue()-m_right_edit.MinValue())/m_right_edit.StepValue());
//--- Размер шага относительно ширины рабочей области
   m_position_step=m_right_edit.StepValue()*(double(m_value_steps_total)/double(m_pixels_total));
   return(true);
  }
//+------------------------------------------------------------------+
//| Расчёт координаты X ползунка слайдера                            |
//+------------------------------------------------------------------+
void CSlider::CalculateLeftThumbX(void)
  {
//--- Корректировка с учётом того, что минимальное значение может быть отрицательным
   double neg_range=(m_left_edit.MinValue()<0)? ::fabs(m_left_edit.MinValue()/m_position_step) : 0;
//--- Рассчитаем координату X для ползунка слайдера
   m_thumb_x_left=((double)m_left_edit.GetValue()/m_position_step)+neg_range;
//--- Если выходим за пределы рабочей области влево
   if(m_thumb_x_left<0)
      m_thumb_x_left=0;
//--- Если выходим за пределы рабочей области вправо
   if(m_thumb_x_left+m_thumb_x_size>m_thumb_x_right)
      m_thumb_x_left=m_thumb_x_right-m_thumb_x_size;
  }
//+------------------------------------------------------------------+
//| Расчёт координаты X ползунка слайдера                            |
//+------------------------------------------------------------------+
void CSlider::CalculateRightThumbX(void)
  {
//--- Корректировка с учётом того, что минимальное значение может быть отрицательным
   double neg_range=(m_right_edit.MinValue()<0)? ::fabs(m_right_edit.MinValue()/m_position_step) : 0;
//--- Рассчитаем координату X для ползунка слайдера
   m_thumb_x_right=((double)m_right_edit.GetValue()/m_position_step)+neg_range;
//--- Если выходим за пределы рабочей области влево
   if(m_thumb_x_right<0)
      m_thumb_x_right=0;
//--- Если выходим за пределы рабочей области вправо
   if(m_thumb_x_right+m_thumb_x_size>m_x_size)
      m_thumb_x_right=m_x_size-m_thumb_x_size;
  }
//+------------------------------------------------------------------+
//| Расчёт позиции ползунка слайдера в диапазоне значений            |
//+------------------------------------------------------------------+
void CSlider::CalculateLeftThumbPos(void)
  {
//--- Получим номер позиции ползунка слайдера
   m_thumb_x_pos_left=m_thumb_x_left*m_position_step;
//--- Корректировка с учётом того, что минимальное значение может быть отрицательным
   if(m_left_edit.MinValue()<0 && m_thumb_x_left!=WRONG_VALUE)
      m_thumb_x_pos_left+=int(m_left_edit.MinValue());
//--- Проверка на выход из рабочей области влево
   if(m_thumb_x_left<=0)
      m_thumb_x_pos_left=int(m_left_edit.MinValue());
  }
//+------------------------------------------------------------------+
//| Расчёт позиции ползунка слайдера в диапазоне значений            |
//+------------------------------------------------------------------+
void CSlider::CalculateRightThumbPos(void)
  {
//--- Получим номер позиции ползунка слайдера
   m_thumb_x_pos_right=m_thumb_x_right*m_position_step;
//--- Корректировка с учётом того, что минимальное значение может быть отрицательным
   if(m_right_edit.MinValue()<0 && m_thumb_x_right!=WRONG_VALUE)
      m_thumb_x_pos_right+=int(m_right_edit.MinValue());
//--- Проверка на выход из рабочей области вправо/влево
   if(m_thumb_x_right+m_thumb_x_size>m_x_size)
      m_thumb_x_pos_right=int(m_right_edit.MaxValue());
   if(m_thumb_x_right<=0)
      m_thumb_x_pos_right=int(m_right_edit.MinValue());
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CSlider::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать границы индикатора
   DrawSlot();
//--- Нарисовать индикатор
   DrawIndicator();
//--- Нарисовать ползунок слайдера
   DrawLeftThumb();
//--- Нарисовать ползунок слайдера
   DrawRightThumb();
  }
//+------------------------------------------------------------------+
//| Рисует границы для индикатора                                    |
//+------------------------------------------------------------------+
void CSlider::DrawSlot(void)
  {
//--- Верхняя граница
   int x1=0,x2=m_x_size;
   int y1=m_slot_y,y2=y1;
   m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_slot_line_dark_color));
//--- Нижняя граница
   y1+=m_slot_y_size; y2=y1;
   m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_slot_line_light_color));
  }
//+------------------------------------------------------------------+
//| Рисует индикатор                                                 |
//+------------------------------------------------------------------+
void CSlider::DrawIndicator(void)
  {
//--- Координаты
   int x1 =(int)m_thumb_x_left;
   int x2 =(int)m_thumb_x_right;
   int y1 =m_slot_y+1;
   int y2 =m_slot_y+m_slot_y_size-1;
//--- Цвет
   color clr=(m_is_locked)? m_slot_indicator_color_locked : m_slot_indicator_color;
//--- Рисуем индикатор
   m_canvas.FillRectangle(x1,y1,x2,y2,::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Рисует ползунок слайдера                                         |
//+------------------------------------------------------------------+
void CSlider::DrawLeftThumb(void)
  {
//--- Выйти, если это не двойной слайдер
   if(!m_dual_slider_mode)
      return;
//--- Координаты
   int x1 =(int)m_thumb_x_left;
   int x2 =(int)m_thumb_x_left+m_thumb_x_size;
   int y1 =m_thumb_y;
   int y2 =y1+m_thumb_y_size;
//--- Рисуем ползунок
   m_canvas.FillRectangle(x1,y1,x2,y2,ThumbColorCurrent(m_thumb_focus_left,m_clamping_left_thumb));
  }
//+------------------------------------------------------------------+
//| Рисует ползунок слайдера                                         |
//+------------------------------------------------------------------+
void CSlider::DrawRightThumb(void)
  {
//--- Координаты
   int x1 =(int)m_thumb_x_right;
   int x2 =(int)m_thumb_x_right+m_thumb_x_size;
   int y1 =m_thumb_y;
   int y2 =y1+m_thumb_y_size;
//--- Рисуем ползунок
   m_canvas.FillRectangle(x1,y1,x2,y2,ThumbColorCurrent(m_thumb_focus_right,m_clamping_right_thumb));
  }
//+------------------------------------------------------------------+
