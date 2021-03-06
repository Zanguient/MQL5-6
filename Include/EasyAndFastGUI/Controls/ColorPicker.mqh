//+------------------------------------------------------------------+
//|                                                  ColorPicker.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextEdit.mqh"
#include "Button.mqh"
#include "ButtonsGroup.mqh"
#include "ColorButton.mqh"
//+------------------------------------------------------------------+
//| Класс для создания цветовой палитры для выбора цвета             |
//+------------------------------------------------------------------+
class CColorPicker : public CElement
  {
private:
   //--- Указатель на кнопку вызывающую элемент для выбора цвета
   CColorButton     *m_color_button;
   //--- Экземпляры для создания элемента
   CButtonsGroup     m_radio_buttons;
   CTextEdit         m_spin_edits[9];
   CButton           m_buttons[2];
   //--- Координаты
   int               m_pallete_x1;
   int               m_pallete_y1;
   int               m_pallete_x2;
   int               m_pallete_y2;
   //--- Размеры палитры
   double            m_pallete_x_size;
   double            m_pallete_y_size;
   //--- Цвет рамки палитры
   color             m_palette_border_color;
   //--- Цвета (1) текущего, (2) выбранного и (3) указанного курсором мыши
   color             m_current_color;
   color             m_picked_color;
   color             m_hover_color;
   //--- Значения компонентов в разных цветовых моделях:
   //    HSL
   double            m_hsl_h;
   double            m_hsl_s;
   double            m_hsl_l;
   //--- RGB
   double            m_rgb_r;
   double            m_rgb_g;
   double            m_rgb_b;
   //--- Lab
   double            m_lab_l;
   double            m_lab_a;
   double            m_lab_b;
   //--- XYZ
   double            m_xyz_x;
   double            m_xyz_y;
   double            m_xyz_z;
   //--- Счётчик таймера для перемотки списка
   int               m_timer_counter;
   //---
public:
                     CColorPicker(void);
                    ~CColorPicker(void);
   //--- Методы для создания элемента
   bool              CreateColorPicker(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateRadioButtons(void);
   bool              CreateSpinEdits(void);
   bool              CreateButtons(void);
   //---
public:
   //--- Возвращает указатели на элементы формы
   CButtonsGroup    *GetRadioButtonsPointer(void) { return(::GetPointer(m_radio_buttons)); }
   CTextEdit        *GetSpinEditPointer(const uint index);
   CButton          *GetButtonPointer(const uint index);
   //--- Сохраняет указатель на кнопку вызывающую цветовую палитру
   void              ColorButtonPointer(CColorButton &object);
   //--- Установка цвета выбранного пользователем цвета на палитре
   void              CurrentColor(const color clr);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Таймер
   virtual void      OnEventTimer(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Получение цвета под курсором мыши
   bool              OnHoverColor(const int x,const int y);
   //--- Обработка нажатия на палитре
   bool              OnClickPalette(const string clicked_object);
   //--- Обработка нажатия на радио-кнопке
   bool              OnClickRadioButton(const uint id,const uint index,const string pressed_object);
   //--- Обработка ввода нового значения в поле ввода
   bool              OnEndEdit(const uint id,const uint index,const string pressed_object="");
   //--- Обработка нажатия на кнопке 'OK'
   bool              OnClickButtonOK(const uint id,const uint index,const string pressed_object);
   //--- Обработка нажатия на кнопке 'Cancel'
   bool              OnClickButtonCancel(const uint id,const uint index,const string pressed_object);

   //--- Рисует палитру
   void              DrawPalette(const int index);
   //--- Рисует палитру по цветовой модели HSL (0: H, 1: S, 2: L)
   void              DrawHSL(const int index);
   //--- Рисует палитру по цветовой модели RGB (3: R, 4: G, 5: B)
   void              DrawRGB(const int index);
   //--- Рисует палитру по цветовой модели LAB (6: L, 7: a, 8: b)
   void              DrawLab(const int index);
   //--- Рисует рамку палитры
   void              DrawPaletteBorder(void);
   //--- Рисует рамку цветовых маркеров
   void              DrawSamplesBorder(void);
   //--- Рисует цветовые маркеры
   void              DrawCurrentSample(void);
   void              DrawPickedSample(void);
   void              DrawHoverSample(void);

   //--- Расчёт и установка компонентов цвета
   void              SetComponents(const int index,const bool fix_selected);
   //--- Установка текущих параметров в поля ввода
   void              SetControls(const int index,const bool fix_selected);

   //--- Установка параметров цветовых моделей относительно (1) HSL, (2) RGB, (3) Lab
   void              SetHSL(void);
   void              SetRGB(void);
   void              SetLab(void);

   //--- Корректировка компонент RGB
   void              AdjustmentComponentRGB(void);
   //--- Корректировка компонент HSL
   void              AdjustmentComponentHSL(void);

   //--- Ускоренная перемотка значений в поле ввода
   void              FastSwitching(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CColorPicker::CColorPicker(void) : m_palette_border_color(clrSilver),
                                   m_current_color(clrGold),
                                   m_picked_color(clrCornflowerBlue),
                                   m_hover_color(clrRed)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CColorPicker::~CColorPicker(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик события графика                                       |
//+------------------------------------------------------------------+
void CColorPicker::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Получение цвета под курсором мыши
      if(OnHoverColor(m_mouse.X(),m_mouse.Y()))
         return;
      //---
      return;
     }
//--- Обработка события нажатия левой кнопки мыши на объекте
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Если нажали на палитре
      if(OnClickPalette(sparam))
         return;
      //---
      return;
     }
//--- Обработка ввода значения в поле ввода
   if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)
     {
      //--- Проверка ввода нового значения
      if(OnEndEdit((uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
//--- Обработка нажатия на элементе
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Если нажали на радио-кнопке
      if(OnClickRadioButton((uint)lparam,(uint)dparam,sparam))
         return;
      //--- Проверка ввода нового значения
      if(OnEndEdit((uint)lparam,(uint)dparam,sparam))
         return;
      //--- Если нажали на кнопке "OK"
      if(OnClickButtonOK((uint)lparam,(uint)dparam,sparam))
         return;
      //--- Если нажали на кнопке "CANCEL"
      if(OnClickButtonCancel((uint)lparam,(uint)dparam,sparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Таймер                                                           |
//+------------------------------------------------------------------+
void CColorPicker::OnEventTimer(void)
  {
//--- Ускоренная перемотка значений
   FastSwitching();
  }
//+------------------------------------------------------------------+
//| Создаёт объект Color Picker                                      |
//+------------------------------------------------------------------+
bool CColorPicker::CreateColorPicker(const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap);
//--- Создадим объекты элемента
   if(!CreateCanvas())
      return(false);
   if(!CreateRadioButtons())
      return(false);
   if(!CreateSpinEdits())
      return(false);
   if(!CreateButtons())
      return(false);
//--- Рассчитать компоненты всех цветовых моделей и нарисовать палитру относительно выделенной радио-кнопки
   SetComponents(m_radio_buttons.SelectedButtonIndex(),false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CColorPicker::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x_size =348;
   m_y_size =266;
   m_x      =CElement::CalculateX(x_gap);
   m_y      =CElement::CalculateY(y_gap);
//--- Размеры и координаты палитры
   m_pallete_x_size =255.0;
   m_pallete_y_size =255.0;
   m_pallete_x1     =6;
   m_pallete_y1     =5;
   m_pallete_x2     =m_pallete_x1+(int)m_pallete_x_size;
   m_pallete_y2     =m_pallete_y1+(int)m_pallete_y_size;
//--- Цвет фона по умолчанию
   m_back_color=(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
//--- Цвет рамки по умолчанию
   m_border_color=(m_border_color!=clrNONE)? m_border_color : m_main.BackColor();
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CColorPicker::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("color_picker");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт группу радио-кнопок                                      |
//+------------------------------------------------------------------+
bool CColorPicker::CreateRadioButtons(void)
  {
//--- Идентификатор последнего добавленного элемента
   CElementBase::LastId(m_main.LastId());
//--- Сохраним указатель на родительский элемент
   m_radio_buttons.MainPointer(this);
//--- Координаты
   int x=266,y=35;
//--- Свойства
   int    buttons_x_offset[] ={0,0,0,0,0,0,0,0,0};
   int    buttons_y_offset[] ={0,19,38,60,79,98,120,139,158};
   string buttons_text[]     ={"H:","S:","L:","R:","G:","B:","L:","a:","b:"};
   int    buttons_width[9];
   ::ArrayInitialize(buttons_width,35);
//--- Свойства
   m_radio_buttons.NamePart("radio_button");
   m_radio_buttons.ButtonYSize(18);
   m_radio_buttons.RadioButtonsMode(true);
   m_radio_buttons.RadioButtonsStyle(true);
   m_radio_buttons.IconYGap(4);
   m_radio_buttons.LabelYGap(4);
   m_radio_buttons.LabelColor(clrBlack);
   m_radio_buttons.LabelColorLocked(clrSilver);
//--- Добавим радио-кнопки с указанными свойствами
   for(int i=0; i<9; i++)
      m_radio_buttons.AddButton(buttons_x_offset[i],buttons_y_offset[i],buttons_text[i],buttons_width[i]);
//--- Создать группу кнопок
   if(!m_radio_buttons.CreateButtonsGroup(x,y))
      return(false);
//--- Выделим кнопку в группе
   m_radio_buttons.SelectButton(8);
//--- Добавить элемент в массив
   CElement::AddToArray(m_radio_buttons);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт поля ввода                                               |
//+------------------------------------------------------------------+
bool CColorPicker::CreateSpinEdits(void)
  {
//--- Координаты
   int x=297;
   int y[9]={36,55,74,96,115,134,156,175,194};
//---
   int max[9]   ={360,100,100,255,255,255,100,127,127};
   int min[9]   ={0,0,0,0,0,0,0,-128,-128};
   int value[9] ={360,50,100,50,50,50,50,50,50};
//---
   for(int i=0; i<9; i++)
     {
      //--- Сохраним указатель на родительский элемент
      m_spin_edits[i].MainPointer(this);
      //--- Свойства
      m_spin_edits[i].Index(i);
      m_spin_edits[i].XSize(45);
      m_spin_edits[i].YSize(18);
      m_spin_edits[i].MaxValue(max[i]);
      m_spin_edits[i].MinValue(min[i]);
      m_spin_edits[i].StepValue(1);
      m_spin_edits[i].SetDigits(0);
      m_spin_edits[i].SpinEditMode(true);
      m_spin_edits[i].SetValue((string)value[i]);
      m_spin_edits[i].BackColor(m_back_color);
      m_spin_edits[i].GetTextBoxPointer().XGap(1);
      m_spin_edits[i].GetTextBoxPointer().AutoSelectionMode(true);
      m_spin_edits[i].GetTextBoxPointer().XSize(m_spin_edits[i].XSize());
      //--- Создание элемента
      if(!m_spin_edits[i].CreateTextEdit("",x,y[i]))
         return(false);
      //--- Отступ для текста в поле ввода
      m_spin_edits[i].GetTextBoxPointer().TextYOffset(4);
      //--- Добавить элемент в массив
      CElement::AddToArray(m_spin_edits[i]);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт кнопки                                                   |
//+------------------------------------------------------------------+
bool CColorPicker::CreateButtons(void)
  {
   for(int i=0; i<2; i++)
     {
      //--- Сохраним указатель на форму
      m_buttons[i].MainPointer(this);
      //--- Координаты
      int x =267;
      int y =(i<1)? 218 : 241;
      //---
      string text=(i<1)? "OK" : "Cancel";
      //--- Свойства
      m_buttons[i].Index(i+9);
      m_buttons[i].NamePart("button");
      m_buttons[i].XSize(76);
      m_buttons[i].YSize(20);
      m_buttons[i].IsCenterText(true);
      //--- Создание элемента
      if(!m_buttons[i].CreateButton(text,x,y))
         return(false);
      //--- Добавить элемент в массив
      CElement::AddToArray(m_buttons[i]);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Возвращает указатель на указанное поле ввода                     |
//+------------------------------------------------------------------+
CTextEdit *CColorPicker::GetSpinEditPointer(const uint index)
  {
   uint array_size=::ArraySize(m_spin_edits);
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//---
   return(::GetPointer(m_spin_edits[i]));
  }
//+------------------------------------------------------------------+
//| Возвращает указатель на указанную кнопку                         |
//+------------------------------------------------------------------+
CButton *CColorPicker::GetButtonPointer(const uint index)
  {
   uint array_size=::ArraySize(m_buttons);
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть указатель
   return(::GetPointer(m_buttons[index]));
  }
//+------------------------------------------------------------------+
//| Сохраняет указатель на кнопку вызывающую цветовую палитру и      |
//| открывает окно, к которому палитра присоединена                  |
//+------------------------------------------------------------------+
void CColorPicker::ColorButtonPointer(CColorButton &object)
  {
//--- Сохранить указатель на кнопку
   m_color_button=::GetPointer(object);
//--- Установим цвет переданной кнопки всем маркерам палитры
   CurrentColor(object.CurrentColor());
//--- Если указатель на окно, к которому присоединена палитра, валиден
   if(::CheckPointer(m_wnd)!=POINTER_INVALID)
     {
      //--- Откроем окно
      m_wnd.OpenWindow();
     }
//--- Сбросить фокус у кнопки
   object.MouseFocus(false);
   object.Update(true);
   object.GetButtonPointer().MouseFocus(false);
   object.GetButtonPointer().Update(true);
  }
//+------------------------------------------------------------------+
//| Установка текущего цвета                                         |
//+------------------------------------------------------------------+
void CColorPicker::CurrentColor(const color clr)
  {
   m_hover_color=clr;
   DrawHoverSample();
//---
   m_picked_color=clr;
   DrawPickedSample();
//---
   m_current_color=clr;
   DrawCurrentSample();
  }
//+------------------------------------------------------------------+
//| Получение цвета под курсором мыши                                |
//+------------------------------------------------------------------+
bool CColorPicker::OnHoverColor(const int x,const int y)
  {
//--- Выйти, если фокус не на элементе
   if(!CElementBase::MouseFocus())
      return(false);
//--- Проверить фокус на палитре
   m_canvas.MouseFocus(x>m_canvas.X()+m_pallete_x1 && x<m_canvas.X()+m_pallete_x2 && 
                       y>m_canvas.Y()+m_pallete_y1 && y<m_canvas.Y()+m_pallete_y2);
//--- Выйти, если фокус не на палитре
   if(!m_canvas.MouseFocus())
     {
      ::ObjectSetString(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TOOLTIP,"\n");
      return(false);
     }
//--- Определим цвет на палитре под курсором мыши
   int lx =x-m_canvas.X();
   int ly =y-m_canvas.Y();
   m_hover_color=(color)::ColorToARGB(m_canvas.PixelGet(lx,ly),0);
//--- Установим цвет и всплывающую подсказку в соответствующий образец (маркер)
   DrawHoverSample();
//--- Установим всплывающую подсказку палитре
   ::ObjectSetString(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TOOLTIP,::ColorToString(m_hover_color));
//--- Обновить холст
   m_canvas.Update();
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на цветовой палитре                            |
//+------------------------------------------------------------------+
bool CColorPicker::OnClickPalette(const string clicked_object)
  {
//--- Выйти, если имя объекта не совпадает
   if(clicked_object!=m_canvas.ChartObjectName())
      return(false);
//--- Установим цвет и всплывающую подсказку в соответствующий образец
   m_picked_color=m_hover_color;
   DrawPickedSample();
//--- Рассчитаем и установим компоненты цвета относительно выделенной радио-кнопки
   SetComponents();
//--- Обновить поля ввода
   for(int i=0; i<9; i++)
      m_spin_edits[i].GetTextBoxPointer().Update(true);
//--- Обновить холст
   m_canvas.Update();
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на радио-кнопке                                |
//+------------------------------------------------------------------+
bool CColorPicker::OnClickRadioButton(const uint id,const uint index,const string pressed_object)
  {
//--- Выйдем, если нажатие было не на радио-кнопке
   if(::StringFind(pressed_object,m_radio_buttons.NamePart())<0)
      return(false);
//--- Выйти, если идентификаторы не совпадают
   if(id!=CElementBase::Id() || index==m_radio_buttons.SelectedButtonIndex())
      return(false);
//--- Обновить палитру с учётом последних изменений
   DrawPalette(index);
//--- Обновить холст
   m_canvas.Update();
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка ввода нового значения в поле ввода                     |
//+------------------------------------------------------------------+
bool CColorPicker::OnEndEdit(const uint id,const uint index,const string pressed_object="")
  {
//--- Выйдем, если нажатие было не на кнопке
   if(pressed_object!="")
      if(::StringFind(pressed_object,"spin")<0)
         return(false);
//--- Выйти, если идентификаторы не совпадают
   if(id!=CElementBase::Id())
      return(false);
//--- Рассчитаем и установим компоненты цвета для всех цветовых моделей 
   SetComponents(index>>1,false);
//--- Обновить поля ввода
   for(int i=0; i<9; i++)
      m_spin_edits[i].GetTextBoxPointer().Update(true);
//--- Обновить холст
   m_canvas.Update();
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на кнопке 'OK'                                 |
//+------------------------------------------------------------------+
bool CColorPicker::OnClickButtonOK(const uint id,const uint index,const string pressed_object)
  {
//--- Выйдем, если нажатие было не на кнопке
   if(::StringFind(pressed_object,m_buttons[0].NamePart())<0)
      return(false);
//--- Выйти, если идентификаторы не совпадают
   if(id!=CElementBase::Id() || index!=m_buttons[0].Index())
      return(false);
//--- Сохранить выбранный цвет
   m_current_color=m_picked_color;
   DrawCurrentSample();
   m_canvas.Update();
//--- Если есть указатель кнопки вызова окна для выбора цвета
   if(::CheckPointer(m_color_button)!=POINTER_INVALID)
     {
      //--- Установим кнопке выбранный цвет
      m_color_button.CurrentColor(m_current_color);
      m_color_button.MouseFocus(false);
      m_color_button.Update(true);
      m_color_button.GetButtonPointer().Update(true);
      //--- Закроем окно
      m_wnd.CloseDialogBox();
      //--- Отправим сообщение об этом
      ::EventChartCustom(m_chart_id,ON_CHANGE_COLOR,CElementBase::Id(),CElementBase::Index(),m_color_button.LabelText());
      //--- Обнулим указатель
      m_color_button=NULL;
     }
   else
     {
      //--- Если указателя нет и окно диалоговое,
      //    вывести сообщение, что нет указателя на кнопку для вызова элемента
      if(m_wnd.WindowType()==W_DIALOG)
         ::Print(__FUNCTION__," > Невалидный указатель вызывающего элемента (CColorButton).");
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на кнопке 'Cancel'                             |
//+------------------------------------------------------------------+
bool CColorPicker::OnClickButtonCancel(const uint id,const uint index,const string pressed_object)
  {
//--- Выйдем, если нажатие было не на кнопке
   if(::StringFind(pressed_object,m_buttons[1].NamePart())<0)
      return(false);
//--- Выйти, если идентификаторы не совпадают
   if(id!=CElementBase::Id() || index!=m_buttons[1].Index())
      return(false);
//--- Закроем окно, если оно диалоговое
   if(m_wnd.WindowType()==W_DIALOG)
      m_wnd.CloseDialogBox();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CColorPicker::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать рамку
   CElement::DrawBorder();
//--- Нарисовать рамку цветовых маркеров
   DrawSamplesBorder();
//--- Нарисовать цветовые маркеры
   DrawCurrentSample();
   DrawPickedSample();
   DrawHoverSample();
//--- Рассчитать компоненты всех цветовых моделей и
//    нарисовать палитру относительно выделенной радио-кнопки
   SetComponents(m_radio_buttons.SelectedButtonIndex(),false);
  }
//+------------------------------------------------------------------+
//| Рисует рамку цветовых маркеров                                   |
//+------------------------------------------------------------------+
void CColorPicker::DrawSamplesBorder(void)
  {
   uint clr=::ColorToARGB(m_palette_border_color);
//--- Рассчитаем координаты
   int x1 =m_pallete_x1+(int)m_pallete_x_size+5;
   int y1 =m_pallete_y1-1;
   int x2 =x1+76;
   int y2 =m_pallete_y1+25;
//--- Нарисовать рамку
   m_canvas.Line(x1,y1,x2,y1,clr);
   m_canvas.Line(x1,y2,x2,y2,clr);
   m_canvas.Line(x1,y1,x1,y2,clr);
   m_canvas.Line(x2,y1,x2,y2,clr);
  }
//+------------------------------------------------------------------+
//| Рисует маркер с текущим цветом                                   |
//+------------------------------------------------------------------+
void CColorPicker::DrawCurrentSample(void)
  {
   uint clr=::ColorToARGB(m_current_color);
//--- Рассчитаем координаты
   int x1 =m_pallete_x1+(int)m_pallete_x_size+6;
   int y1 =m_pallete_y1;
   int x2 =x1+24;
   int y2 =m_pallete_y1+24;
//--- Нарисовать маркер
   m_canvas.FillRectangle(x1,y1,x2,y2,clr);
  }
//+------------------------------------------------------------------+
//| Рисует маркер с выбранным цветом                                 |
//+------------------------------------------------------------------+
void CColorPicker::DrawPickedSample(void)
  {
   uint clr=::ColorToARGB(m_picked_color);
//--- Рассчитаем координаты
   int x1 =m_pallete_x1+(int)m_pallete_x_size+6+25;
   int y1 =m_pallete_y1;
   int x2 =x1+24;
   int y2 =m_pallete_y1+24;
//--- Нарисовать маркер
   m_canvas.FillRectangle(x1,y1,x2,y2,clr);
  }
//+------------------------------------------------------------------+
//| Рисует маркер с указанным цветом                                 |
//+------------------------------------------------------------------+
void CColorPicker::DrawHoverSample(void)
  {
   uint clr=::ColorToARGB(m_hover_color);
//--- Рассчитаем координаты
   int x1 =m_pallete_x1+(int)m_pallete_x_size+6+50;
   int y1 =m_pallete_y1;
   int x2 =x1+24;
   int y2 =m_pallete_y1+24;
//--- Нарисовать маркер
   m_canvas.FillRectangle(x1,y1,x2,y2,clr);
  }
//+------------------------------------------------------------------+
//| Рисует палитру                                                   |
//+------------------------------------------------------------------+
void CColorPicker::DrawPalette(const int index)
  {
   switch(index)
     {
      //--- HSL (0: H, 1: S, 2: L)
      case 0 : case 1 : case 2 :
        {
         DrawHSL(index);
         break;
        }
      //--- RGB (3: R, 4: G, 5: B)
      case 3 : case 4 : case 5 :
        {
         DrawRGB(index);
         break;
        }
      //--- LAB (6: L, 7: a, 8: b)
      case 6 : case 7 : case 8 :
        {
         DrawLab(index);
         break;
        }
     }
//--- Нарисуем рамку палитры
   DrawPaletteBorder();
  }
//+------------------------------------------------------------------+
//| Рисует палитру HSL                                               |
//+------------------------------------------------------------------+
void CColorPicker::DrawHSL(const int index)
  {
   switch(index)
     {
      //--- Hue (H) - цветовой тон в диапазоне от 0 до 360
      case 0 :
        {
         //--- Рассчитаем H-компоненту
         m_hsl_h=(double)m_spin_edits[0].GetValue()/360.0;
         //---
         for(int ly=m_pallete_y1; ly<m_pallete_y2; ly++)
           {
            //--- Рассчитаем L-компоненту
            m_hsl_l=ly/m_pallete_y_size;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Рассчитаем S-компоненту
               m_hsl_s=lx/m_pallete_x_size;
               //--- Конвертация HSL-компонент в RGB-компоненты
               m_clr.HSLtoRGB(m_hsl_h,m_hsl_s,m_hsl_l,m_rgb_r,m_rgb_g,m_rgb_b);
               //--- Скорректировать, если компоненты выходят из диапазона
               AdjustmentComponentRGB();
               //--- Соединим каналы
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
      //--- Saturation (S) - насыщенность в диапазоне от 0 до 100
      case 1 :
        {
         //--- Рассчитаем S-компоненту
         m_hsl_s=(double)m_spin_edits[1].GetValue()/100.0;
         //---
         for(int ly=m_pallete_y1; ly<m_pallete_y2; ly++)
           {
            //--- Рассчитаем L-компоненту
            m_hsl_l=ly/m_pallete_y_size;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Рассчитаем H-компоненту
               m_hsl_h=lx/m_pallete_x_size;
               //--- Конвертация HSL-компонент в RGB-компоненты
               m_clr.HSLtoRGB(m_hsl_h,m_hsl_s,m_hsl_l,m_rgb_r,m_rgb_g,m_rgb_b);
               //--- Скорректировать, если компоненты выходят из диапазона
               AdjustmentComponentRGB();
               //--- Соединим каналы
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
      //--- Lightness (L) - яркость в диапазоне от 0 до 100
      case 2 :
        {
         //--- Рассчитаем L-компоненту
         m_hsl_l=(double)m_spin_edits[2].GetValue()/100.0;
         //---
         for(int ly=m_pallete_y1; ly<m_pallete_y2; ly++)
           {
            //--- Рассчитаем S-компоненту
            m_hsl_s=ly/m_pallete_y_size;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Рассчитаем H-компоненту
               m_hsl_h=lx/m_pallete_x_size;
               //--- Конвертация HSL-компонент в RGB-компоненты
               m_clr.HSLtoRGB(m_hsl_h,m_hsl_s,m_hsl_l,m_rgb_r,m_rgb_g,m_rgb_b);
               //--- Скорректировать, если компоненты выходят из диапазона
               AdjustmentComponentRGB();
               //--- Соединим каналы
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| Рисует палитру RGB                                               |
//+------------------------------------------------------------------+
void CColorPicker::DrawRGB(const int index)
  {
//--- Шаги по осям X и Y для расчёта RGB-компонент
   double rgb_x_step =255.0/m_pallete_x_size;
   double rgb_y_step =255.0/m_pallete_y_size;
//---
   switch(index)
     {
      //--- Red (R) - красный. Цветовой диапазон от 0 до 255
      case 3 :
        {
         //--- Получим текущую R-компоненту и обнулим B-компоненту
         m_rgb_r =(double)m_spin_edits[3].GetValue();
         m_rgb_b =0;
         //---
         for(int ly=m_pallete_y1; ly<m_pallete_y2; ly++)
           {
            //--- Рассчитаем B-компоненту и обнулим R-компоненту
            m_rgb_g=0;
            m_rgb_b+=rgb_y_step;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Рассчитаем G-компоненту
               m_rgb_g+=rgb_x_step;
               //--- Соединим каналы
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
      //--- Green (G) - зелёный. Цветовой диапазон от 0 до 255
      case 4 :
        {
         //--- Получим текущую G-компоненту и обнулим B-компоненту
         m_rgb_g =(double)m_spin_edits[4].GetValue();
         m_rgb_b =0;
         //---
         for(int ly=m_pallete_y1; ly<m_pallete_y2; ly++)
           {
            //--- Рассчитаем B-компоненту и обнулим R-компоненту
            m_rgb_r=0;
            m_rgb_b+=rgb_y_step;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Рассчитаем R-компоненту
               m_rgb_r+=rgb_x_step;
               //--- Соединим каналы
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
      //--- Blue (B) - синий. Цветовой диапазон от 0 до 255
      case 5 :
        {
         //--- Получим текущую B-компоненту и обнулим G-компоненту
         m_rgb_g =0;
         m_rgb_b =(double)m_spin_edits[5].GetValue();
         //---
         for(int ly=m_pallete_y1; ly<m_pallete_y2; ly++)
           {
            //--- Рассчитаем G-компоненту и обнулим R-компоненту
            m_rgb_r=0;
            m_rgb_g+=rgb_y_step;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Рассчитаем R-компоненту
               m_rgb_r+=rgb_x_step;
               //--- Соединим каналы
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| Рисует палитру Lab                                               |
//+------------------------------------------------------------------+
void CColorPicker::DrawLab(const int index)
  {
   switch(index)
     {
      //--- Lightness (L) - яркость в диапазоне от 0 до 100
      case 6 :
        {
         //--- Получим текущую L-компоненту
         m_lab_l=(double)m_spin_edits[6].GetValue();
         //---
         for(int ly=m_pallete_y1; ly<=m_pallete_y2; ly++)
           {
            //--- Рассчитаем b-компоненту
            m_lab_b=(ly/m_pallete_y_size*255.0)-128;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Рассчитаем a-компоненту
               m_lab_a=(lx/m_pallete_x_size*255.0)-128;
               //--- Конвертация Lab-компонент в RGB-компоненты
               m_clr.CIELabToXYZ(m_lab_l,m_lab_a,m_lab_b,m_xyz_x,m_xyz_y,m_xyz_z);
               m_clr.XYZtoRGB(m_xyz_x,m_xyz_y,m_xyz_z,m_rgb_r,m_rgb_g,m_rgb_b);
               //--- Корректировка компонент RGB
               AdjustmentComponentRGB();
               //--- Соединим каналы
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
      //--- Хроматическая компонента 'a' - диапазон от -128 (зелёный) до 127 (пурпурный)
      case 7 :
        {
         //--- Получим текущую a-компоненту
         m_lab_a=(double)m_spin_edits[7].GetValue();
         //---
         for(int ly=m_pallete_y1; ly<=m_pallete_y2; ly++)
           {
            //--- Рассчитаем b-компоненту
            m_lab_b=(ly/m_pallete_y_size*255.0)-128;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Рассчитаем L-компоненту
               m_lab_l=100.0*lx/m_pallete_x_size;
               //--- Конвертация Lab-компонент в RGB-компоненты
               m_clr.CIELabToXYZ(m_lab_l,m_lab_a,m_lab_b,m_xyz_x,m_xyz_y,m_xyz_z);
               m_clr.XYZtoRGB(m_xyz_x,m_xyz_y,m_xyz_z,m_rgb_r,m_rgb_g,m_rgb_b);
               //--- Корректировка компонент RGB
               AdjustmentComponentRGB();
               //--- Соединим каналы
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
      //--- Хроматическая компонента 'b' - диапазон от -128 (синий) до 127 (жёлтый)
      case 8 :
        {
         //--- Получим текущую b-компоненту
         m_lab_b=(double)m_spin_edits[8].GetValue();
         //---
         for(int ly=m_pallete_y1; ly<=m_pallete_y2; ly++)
           {
            //--- Рассчитаем a-компоненту
            m_lab_a=(ly/m_pallete_y_size*255.0)-128;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Рассчитаем L-компоненту
               m_lab_l=100.0*lx/m_pallete_x_size;
               //--- Конвертация Lab-компонент в RGB-компоненты
               m_clr.CIELabToXYZ(m_lab_l,m_lab_a,m_lab_b,m_xyz_x,m_xyz_y,m_xyz_z);
               m_clr.XYZtoRGB(m_xyz_x,m_xyz_y,m_xyz_z,m_rgb_r,m_rgb_g,m_rgb_b);
               //--- Корректировка компонент RGB
               AdjustmentComponentRGB();
               //--- Соединим каналы
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| Рисует рамку палитры                                             |
//+------------------------------------------------------------------+
void CColorPicker::DrawPaletteBorder(void)
  {
   uint clr=::ColorToARGB(m_palette_border_color);
//--- Размер палитры
   int x1 =m_pallete_x1-1;
   int y1 =m_pallete_y1-1;
   int x2 =m_pallete_x1+(int)m_pallete_x_size;
   int y2 =m_pallete_y1+(int)m_pallete_y_size;
//--- Нарисовать рамку
   m_canvas.Line(x1,y1,x2,y1,clr);
   m_canvas.Line(x1,y2,x2,y2,clr);
   m_canvas.Line(x2,y1,x2,y2,clr);
   m_canvas.Line(x1,y1,x1,y2,clr);
  }
//+------------------------------------------------------------------+
//| Расчёт и установка компонентов цвета                             |
//+------------------------------------------------------------------+
void CColorPicker::SetComponents(const int index=0,const bool fix_selected=true)
  {
//--- Если нужно скорректировать цвета относительно выделенного радио-кнопкой компонента
   if(fix_selected)
     {
      //--- Разложим на RGB-компоненты выбранный цвет
      m_rgb_r =m_clr.GetR(m_picked_color);
      m_rgb_g =m_clr.GetG(m_picked_color);
      m_rgb_b =m_clr.GetB(m_picked_color);
      //--- Конвертируем RGB-компоненты в HSL-компоненты
      m_clr.RGBtoHSL(m_rgb_r,m_rgb_g,m_rgb_b,m_hsl_h,m_hsl_s,m_hsl_l);
      //--- Корректировка компонент HSL
      AdjustmentComponentHSL();
      //--- Конвертируем RGB-компоненты в LAB-компоненты
      m_clr.RGBtoXYZ(m_rgb_r,m_rgb_g,m_rgb_b,m_xyz_x,m_xyz_y,m_xyz_z);
      m_clr.XYZtoCIELab(m_xyz_x,m_xyz_y,m_xyz_z,m_lab_l,m_lab_a,m_lab_b);
      //--- Установим цвета в поля ввода
      SetControls(m_radio_buttons.SelectedButtonIndex(),true);
      return;
     }
//--- Установка параметров цветовых моделей
   switch(index)
     {
      case 0 : case 1 : case 2 :
         SetHSL();
         break;
      case 3 : case 4 : case 5 :
         SetRGB();
         break;
      case 6 : case 7 : case 8 :
         SetLab();
         break;
     }
//--- Нарисовать палитру относительно выделенной радио-кнопки
   DrawPalette(m_radio_buttons.SelectedButtonIndex());
  }
//+------------------------------------------------------------------+
//| Установка текущих параметров в поля ввода                        |
//+------------------------------------------------------------------+
void CColorPicker::SetControls(const int index,const bool fix_selected)
  {
//--- Если нужно зафиксировать значение в поле ввода выделенной радио-кнопки
   if(fix_selected)
     {
      //--- Компоненты HSL
      if(index!=0)
         m_spin_edits[0].SetValue(::DoubleToString(m_hsl_h,0),false);
      if(index!=1)
         m_spin_edits[1].SetValue(::DoubleToString(m_hsl_s,0),false);
      if(index!=2)
         m_spin_edits[2].SetValue(::DoubleToString(m_hsl_l,0),false);
      //--- Компоненты RGB
      if(index!=3)
         m_spin_edits[3].SetValue(::DoubleToString(m_rgb_r,0),false);
      if(index!=4)
         m_spin_edits[4].SetValue(::DoubleToString(m_rgb_g,0),false);
      if(index!=5)
         m_spin_edits[5].SetValue(::DoubleToString(m_rgb_b,0),false);
      //--- Компоненты Lab
      if(index!=6)
         m_spin_edits[6].SetValue(::DoubleToString(m_lab_l,0),false);
      if(index!=7)
         m_spin_edits[7].SetValue(::DoubleToString(m_lab_a,0),false);
      if(index!=8)
         m_spin_edits[8].SetValue(::DoubleToString(m_lab_b,0),false);
      return;
     }
//--- Если нужно скорректировать значения в полях ввода всех цветовых моделей
   m_spin_edits[0].SetValue(::DoubleToString(m_hsl_h,0),false);
   m_spin_edits[1].SetValue(::DoubleToString(m_hsl_s,0),false);
   m_spin_edits[2].SetValue(::DoubleToString(m_hsl_l,0),false);
//---
   m_spin_edits[3].SetValue(::DoubleToString(m_rgb_r,0),false);
   m_spin_edits[4].SetValue(::DoubleToString(m_rgb_g,0),false);
   m_spin_edits[5].SetValue(::DoubleToString(m_rgb_b,0),false);
//---
   m_spin_edits[6].SetValue(::DoubleToString(m_lab_l,0),false);
   m_spin_edits[7].SetValue(::DoubleToString(m_lab_a,0),false);
   m_spin_edits[8].SetValue(::DoubleToString(m_lab_b,0),false);
  }
//+------------------------------------------------------------------+
//| Установка параметров цветовых моделей относительно HSL           |
//+------------------------------------------------------------------+
void CColorPicker::SetHSL(void)
  {
//--- Получим текущие значения компонентов HSL
   m_hsl_h =(double)m_spin_edits[0].GetValue();
   m_hsl_s =(double)m_spin_edits[1].GetValue();
   m_hsl_l =(double)m_spin_edits[2].GetValue();
//--- Конвертация HSL-компонент в RGB-компоненты
   m_clr.HSLtoRGB(m_hsl_h/360.0,m_hsl_s/100.0,m_hsl_l/100.0,m_rgb_r,m_rgb_g,m_rgb_b);
//--- Конвертация RGB-компонент в Lab-компоненты
   m_clr.RGBtoXYZ(m_rgb_r,m_rgb_g,m_rgb_b,m_xyz_x,m_xyz_y,m_xyz_z);
   m_clr.XYZtoCIELab(m_xyz_x,m_xyz_y,m_xyz_z,m_lab_l,m_lab_a,m_lab_b);
//--- Установка текущих параметров в поля ввода
   SetControls(0,false);
  }
//+------------------------------------------------------------------+
//| Установка параметров цветовых моделей относительно RGB           |
//+------------------------------------------------------------------+
void CColorPicker::SetRGB(void)
  {
//--- Получим текущие значения компонентов RGB
   m_rgb_r =(double)m_spin_edits[3].GetValue();
   m_rgb_g =(double)m_spin_edits[4].GetValue();
   m_rgb_b =(double)m_spin_edits[5].GetValue();
//--- Конвертация RGB-компонент в HSL-компоненты
   m_clr.RGBtoHSL(m_rgb_r,m_rgb_g,m_rgb_b,m_hsl_h,m_hsl_s,m_hsl_l);
//--- Корректировка компонент HSL
   AdjustmentComponentHSL();
//--- Конвертация RGB-компонент в Lab-компоненты
   m_clr.RGBtoXYZ(m_rgb_r,m_rgb_g,m_rgb_b,m_xyz_x,m_xyz_y,m_xyz_z);
   m_clr.XYZtoCIELab(m_xyz_x,m_xyz_y,m_xyz_z,m_lab_l,m_lab_a,m_lab_b);
//--- Установка текущих параметров в поля ввода
   SetControls(0,false);
  }
//+------------------------------------------------------------------+
//| Установка параметров цветовых моделей относительно Lab           |
//+------------------------------------------------------------------+
void CColorPicker::SetLab(void)
  {
//--- Получим текущие значения компонентов Lab
   m_lab_l =(double)m_spin_edits[6].GetValue();
   m_lab_a =(double)m_spin_edits[7].GetValue();
   m_lab_b =(double)m_spin_edits[8].GetValue();
//--- Конвертация Lab-компонент в RGB-компоненты
   m_clr.CIELabToXYZ(m_lab_l,m_lab_a,m_lab_b,m_xyz_x,m_xyz_y,m_xyz_z);
   m_clr.XYZtoRGB(m_xyz_x,m_xyz_y,m_xyz_z,m_rgb_r,m_rgb_g,m_rgb_b);
//--- Корректировка компонент RGB
   AdjustmentComponentRGB();
//--- Конвертация RGB-компонент в HSL-компоненты
   m_clr.RGBtoHSL(m_rgb_r,m_rgb_g,m_rgb_b,m_hsl_h,m_hsl_s,m_hsl_l);
//--- Корректировка компонент HSL
   AdjustmentComponentHSL();
//--- Установка текущих параметров в поля ввода
   SetControls(0,false);
  }
//+------------------------------------------------------------------+
//| Корректировка компонент RGB                                      |
//+------------------------------------------------------------------+
void CColorPicker::AdjustmentComponentRGB(void)
  {
   m_rgb_r=::fmin(::fmax(m_rgb_r,0),255);
   m_rgb_g=::fmin(::fmax(m_rgb_g,0),255);
   m_rgb_b=::fmin(::fmax(m_rgb_b,0),255);
  }
//+------------------------------------------------------------------+
//| Корректировка компонент HSL                                      |
//+------------------------------------------------------------------+
void CColorPicker::AdjustmentComponentHSL(void)
  {
   m_hsl_h*=360;
   m_hsl_s*=100;
   m_hsl_l*=100;
  }
//+------------------------------------------------------------------+
//| Ускоренная промотка значения в поле ввода                        |
//+------------------------------------------------------------------+
void CColorPicker::FastSwitching(void)
  {
//--- Выйдем, если нет фокуса на элементе
   if(!CElementBase::MouseFocus())
      return;
//--- Вернём счётчик к первоначальному значению, если кнопка мыши отжата
   if(!m_mouse.LeftButtonState())
      m_timer_counter=SPIN_DELAY_MSC;
//--- Если же кнопка мыши нажата
   else
     {
      //--- Увеличим счётчик на установленный интервал
      m_timer_counter+=TIMER_STEP_MSC;
      //--- Выйдем, если меньше нуля
      if(m_timer_counter<0)
         return;
      //--- Определение активированного счётчика у активированной радио-кнопки
      int index=WRONG_VALUE;
      //---
      for(int i=0; i<9; i++)
        {
         if(m_radio_buttons.SelectedButtonIndex()==i && 
            (m_spin_edits[i].GetIncButtonPointer().MouseFocus() || m_spin_edits[i].GetDecButtonPointer().MouseFocus()))
           {
            index=i;
            break;
           }
        }
      //--- Если есть, обновим палитру
      if(index!=WRONG_VALUE)
        {
         DrawPalette(index);
         //--- Обновить холст
         m_canvas.Update();
        }
      //--- Определение активированного счётчика
      index=WRONG_VALUE;
      //---
      for(int i=0; i<9; i++)
        {
         if(m_spin_edits[i].GetIncButtonPointer().MouseFocus() || m_spin_edits[i].GetDecButtonPointer().MouseFocus())
           {
            index=i;
            break;
           }
        }
      //--- Если есть, пересчитаем компоненты всех цветовых моделей и обновим палитру
      if(index!=WRONG_VALUE)
        {
         SetComponents(index,false);
         //--- Обновить холст
         m_canvas.Update();
        }
     }
  }
//+------------------------------------------------------------------+
