//+------------------------------------------------------------------+
//|                                                      MenuBar.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "MenuItem.mqh"
#include "ContextMenu.mqh"
//+------------------------------------------------------------------+
//| Класс для создания главного меню                                 |
//+------------------------------------------------------------------+
class CMenuBar : public CElement
  {
private:
   //--- Объекты для создания пункта меню
   CMenuItem         m_items[];
   //--- Массив указателей на контекстные меню
   CContextMenu     *m_contextmenus[];
   //--- Состояние главного меню
   bool              m_menubar_state;
   //--- Индекс предыдущего активированного пункта
   int               m_prev_active_item_index;
   //---
public:
                     CMenuBar(void);
                    ~CMenuBar(void);
   //--- Методы для создания элемента
   bool              CreateMenuBar(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateItems(void);
   //---
public:
   //--- (1) Получение указателя указанного пункта меню, (2) получение указателя указанного контекстного меню
   CMenuItem        *GetItemPointer(const uint index);
   CContextMenu     *GetContextMenuPointer(const uint index);
   //--- Количество (1) пунктов и (2) контекстных меню, (3) состояние главного меню
   int               ItemsTotal(void)               const { return(::ArraySize(m_items));        }
   int               ContextMenusTotal(void)        const { return(::ArraySize(m_contextmenus)); }
   bool              State(void)                    const { return(m_menubar_state);             }
   void              State(const bool state);
   //--- Добавляет пункт меню с указанными свойствами до создания главного меню
   void              AddItem(const int width,const string text);
   //--- Присоединяет переданное контекстное меню к указанному пункту главного меню
   void              AddContextMenuPointer(const uint index,CContextMenu &object);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Удаление
   virtual void      Delete(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Обработка нажатия на пункте меню
   bool              OnClickMenuItem(const int id,const int index);
   //--- Возвращает активный пункт главного меню
   int               ActiveItemIndex(void);
   //--- Переключает контекстные меню главного меню, наведением курсора
   void              SwitchContextMenuByFocus(void);

   //--- Изменить ширину по правому краю окна
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMenuBar::CMenuBar(void) : m_menubar_state(false),
                           m_prev_active_item_index(WRONG_VALUE)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
//--- Центрировать текст в пунктах меню
   CElement::IsCenterText(true);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMenuBar::~CMenuBar(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CMenuBar::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события смены фокуса на кнопках меню
   if(id==CHARTEVENT_CUSTOM+ON_MOUSE_FOCUS)
     {
      //--- Выйти, если (2) главное меню не активировано или (2) идентификаторы не совпадают
      if(!m_menubar_state || lparam!=CElementBase::Id())
         return;
      //--- Переключить контекстное меню по активированному пункту главного меню
      SwitchContextMenuByFocus();
      return;
     }
//--- Обработка события нажатия левой кнопки мыши на пункте главного меню
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(OnClickMenuItem((uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт главное меню                                             |
//+------------------------------------------------------------------+
bool CMenuBar::CreateMenuBar(const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap);
//--- Создание элемента
   if(!CreateCanvas())
      return(false);
   if(!CreateItems())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CMenuBar::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x        =CElement::CalculateX(x_gap);
   m_y        =CElement::CalculateY(y_gap);
   m_x_size   =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
   m_y_size   =(m_y_size<1)? 22 : m_y_size;
//--- Свойства по умолчанию
   m_back_color           =(m_back_color!=clrNONE)? m_back_color : C'225,225,225';
   m_back_color_hover     =(m_back_color_hover!=clrNONE)? m_back_color_hover : C'51,153,255';
   m_back_color_pressed   =(m_back_color_pressed!=clrNONE)? m_back_color_pressed : m_back_color_hover;
   m_border_color         =(m_border_color!=clrNONE)? m_border_color : m_back_color;
   m_border_color_hover   =(m_border_color_hover!=clrNONE)? m_border_color_hover : m_back_color;
   m_border_color_pressed =(m_border_color_pressed!=clrNONE)? m_border_color_pressed : m_back_color;
   m_label_y_gap          =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 3;
   m_label_color          =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_hover    =(m_label_color_hover!=clrNONE)? m_label_color_hover : clrWhite;
   m_label_color_pressed  =(m_label_color_pressed!=clrNONE)? m_label_color_pressed : clrWhite;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CMenuBar::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("menubar");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт список пунктов меню                                      |
//+------------------------------------------------------------------+
bool CMenuBar::CreateItems(void)
  {
//--- Координаты
   int x=0,y=0;
//---
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Расчёт координаты X
      x=(i>0)? x+m_items[i-1].XSize() : x;
      //--- Сохраним указатель на главный элемент
      m_items[i].MainPointer(this);
      //--- Установим свойства перед созданием
      m_items[i].Index(i);
      m_items[i].NamePart("menu_item");
      m_items[i].TwoState(true);
      m_items[i].TypeMenuItem(MI_HAS_CONTEXT_MENU);
      m_items[i].ShowRightArrow(false);
      m_items[i].XSize(m_items[i].XSize());
      m_items[i].YSize(m_y_size);
      m_items[i].BackColor(m_back_color);
      m_items[i].BackColorHover(m_back_color_hover);
      m_items[i].BackColorPressed(m_back_color_pressed);
      m_items[i].BorderColor(m_border_color);
      m_items[i].BorderColorHover(m_border_color_hover);
      m_items[i].BorderColorPressed(m_border_color_pressed);
      m_items[i].IconXGap(3);
      m_items[i].IconYGap(4);
      m_items[i].LabelXGap(m_label_x_gap);
      m_items[i].LabelYGap(m_label_y_gap);
      m_items[i].LabelColor(m_label_color);
      m_items[i].LabelColorHover(m_label_color_hover);
      m_items[i].LabelColorPressed(m_label_color_pressed);
      m_items[i].IsCenterText(CElement::IsCenterText());
      //--- Создание пункта меню
      if(!m_items[i].CreateMenuItem(m_items[i].LabelText(),x,y))
         return(false);
      //--- Добавить элемент в массив
      CElement::AddToArray(m_items[i]);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Установка состояния главного меню                                |
//+------------------------------------------------------------------+
void CMenuBar::State(const bool state)
  {
   if(state)
      m_menubar_state=true;
   else
     {
      m_menubar_state=false;
      //--- Пройтись по всем пунктам главного меню для установки статуса отключенных контекстных меню
      int items_total=ItemsTotal();
      for(int i=0; i<items_total; i++)
        {
         m_items[i].IsPressed(false);
         m_items[i].Update(true);
        }
     }
  }
//+------------------------------------------------------------------+
//| Возвращает указатель пункта меню по индексу                      |
//+------------------------------------------------------------------+
CMenuItem *CMenuBar::GetItemPointer(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- Если нет ни одного пункта в главном меню, сообщить об этом
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, "
              "когда в главном меню есть хотя бы один пункт!");
     }
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть указатель
   return(::GetPointer(m_items[i]));
  }
//+------------------------------------------------------------------+
//| Возвращает указатель контекстного меню по индексу                |
//+------------------------------------------------------------------+
CContextMenu *CMenuBar::GetContextMenuPointer(const uint index)
  {
   uint array_size=::ArraySize(m_contextmenus);
//--- Если нет ни одного пункта в главном меню, сообщить об этом
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, "
              "когда в главном меню есть хотя бы один пункт!");
     }
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть указатель
   return(::GetPointer(m_contextmenus[i]));
  }
//+------------------------------------------------------------------+
//| Добавляет пункт меню                                             |
//+------------------------------------------------------------------+
void CMenuBar::AddItem(const int width,const string text)
  {
//--- Увеличим размер массивов на один элемент  
   int array_size=::ArraySize(m_items);
   ::ArrayResize(m_items,array_size+1);
   ::ArrayResize(m_contextmenus,array_size+1);
//--- Сохраним значения переданных параметров
   m_items[array_size].XSize(width);
   m_items[array_size].LabelText(text);
  }
//+------------------------------------------------------------------+
//| Добавляет указатель контекстного меню                            |
//+------------------------------------------------------------------+
void CMenuBar::AddContextMenuPointer(const uint index,CContextMenu &object)
  {
//--- Проверка на выход из диапазона
   uint size=::ArraySize(m_contextmenus);
   if(size<1 || index>=size)
      return;
//--- Сохранить указатель
   m_contextmenus[index]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CMenuBar::Delete(void)
  {
//--- Удаление объектов  
   CElement::Delete();
//--- Освобождение массивов элемента
   ::ArrayFree(m_items);
   ::ArrayFree(m_contextmenus);
  }
//+------------------------------------------------------------------+
//| Нажатие на пункте главного меню                                  |
//+------------------------------------------------------------------+
bool CMenuBar::OnClickMenuItem(const int id,const int index)
  {
//--- Выйти, если (1) идентификаторы не совпадают или (2) элемент заблокирован
   if(id!=CElementBase::Id() || CElementBase::IsLocked())
      return(false);
//--- Если есть указатель на контекстное меню
   if(::CheckPointer(m_contextmenus[index])!=POINTER_INVALID)
     {
      //--- Состояние главного меню зависит от видимости контекстного меню
      m_menubar_state=(m_contextmenus[index].IsVisible())? false : true;
      //--- Определим выделенный пункт
      m_prev_active_item_index=(m_menubar_state)? index : WRONG_VALUE;
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Возвращает индекс активированного пункта меню                    |
//+------------------------------------------------------------------+
int CMenuBar::ActiveItemIndex(void)
  {
   int active_item_index=WRONG_VALUE;
//---
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Если пункт в фокусе
      if(m_items[i].MouseFocus())
        {
         //--- Запомним индекс и остановим цикл
         active_item_index=i;
         break;
        }
     }
//---
   return(active_item_index);
  }
//+------------------------------------------------------------------+
//| Переключает контекстные меню главного меню, наведением курсора   |
//+------------------------------------------------------------------+
void CMenuBar::SwitchContextMenuByFocus(void)
  {
//--- Получим индекс активиронного пункта главного меню
   int active_item_index=ActiveItemIndex();
//--- Выйти, если (1) меню не активировано или (2) это тот же пункт меню
   if(active_item_index==WRONG_VALUE || active_item_index==m_prev_active_item_index)
      return;
//--- Перейти к следующему, если в этом пункте нет контекстного меню
   if(::CheckPointer(m_contextmenus[active_item_index])!=POINTER_INVALID)
     {
      //--- Сделать контекстное меню видимым
      m_contextmenus[active_item_index].Show();
      m_items[active_item_index].IsPressed(true);
     }
//--- Получим указатель на предыдущий выделенный пункт
   CContextMenu *cm=m_contextmenus[m_prev_active_item_index];
//--- Скрыть контекстные меню, которые открыты из других контекстных меню.
//    Пройдёмся в цикле по пунктам текущего контекстного меню, чтобы выяснить, есть ли такие.
   int cm_items_total=cm.ItemsTotal();
   for(int c=0; c<cm_items_total; c++)
     {
      CMenuItem *mi=cm.GetItemPointer(c);
      //--- Перейти к следующему, если указатель на пункт некорректный
      if(::CheckPointer(mi)==POINTER_INVALID)
         continue;
      //--- Перейти к следующему, если этот пункт не содержит в себе контекстное меню
      if(mi.TypeMenuItem()!=MI_HAS_CONTEXT_MENU)
         continue;
      //--- Если контекстное меню активировано
      if(mi.IsPressed())
        {
         //--- Отправить сигнал на закрытие всех контекстных меню, которые открыты из этого
         ::EventChartCustom(m_chart_id,ON_HIDE_BACK_CONTEXTMENUS,CElementBase::Id(),0,"");
         break;
        }
     }
//--- Скрыть контекстное меню главного меню
   m_contextmenus[m_prev_active_item_index].Hide();
   m_items[m_prev_active_item_index].IsPressed(false);
   m_items[m_prev_active_item_index].Update(true);
//--- Запомним индекс текущего активированного меню
   m_prev_active_item_index=active_item_index;
//--- Отправим сообщение на определение доступных элементов
   ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
//--- Отправим сообщение об изменении в графическом интерфейсе
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
  }
//+------------------------------------------------------------------+
//| Изменить ширину по правому краю формы                            |
//+------------------------------------------------------------------+
void CMenuBar::ChangeWidthByRightWindowSide(void)
  {
//--- Выйти, если включен режим фиксации к правому краю формы
   if(m_anchor_right_window_side)
      return;
//--- Размеры
   int x_size=0;
//--- Рассчитать и установить новый размер фону элемента
   x_size=m_main.X2()-m_canvas.X()-m_auto_xresize_right_offset;
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,m_y_size);
//--- Перерисовать элемент
   Draw();
//--- Обновить положение объектов
   Moving();
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CMenuBar::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
  }
//+------------------------------------------------------------------+
