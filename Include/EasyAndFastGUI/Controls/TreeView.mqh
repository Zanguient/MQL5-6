//+------------------------------------------------------------------+
//|                                                     TreeView.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TreeItem.mqh"
#include "Scrolls.mqh"
#include "Pointer.mqh"
//+------------------------------------------------------------------+
//| Класс для создания древовидного списка                           |
//+------------------------------------------------------------------+
class CTreeView : public CElement
  {
private:
   //--- Объекты для создания элемента
   CTreeItem         m_items[];
   CTreeItem         m_content_items[];
   CScrollV          m_scrollv;
   CScrollV          m_content_scrollv;
   CPointer          m_x_resize;
   //--- Структура элементов закреплённых за каждым пунктом-вкладкой
   struct TVElements
     {
      CElement         *elements[];
      int               list_index;
     };
   TVElements        m_tab_items[];
   //--- Массивы для всех пунктов древовидного списка (полный список)
   int               m_t_list_index[];
   int               m_t_prev_node_list_index[];
   string            m_t_item_text[];
   string            m_t_path_bmp[];
   int               m_t_item_index[];
   int               m_t_node_level[];
   int               m_t_prev_node_item_index[];
   int               m_t_items_total[];
   int               m_t_folders_total[];
   bool              m_t_item_state[];
   bool              m_t_is_folder[];
   //--- Массивы для списка отображаемых пунктов древовидного списка
   int               m_td_list_index[];
   //--- Массивы для списка содержания пунктов выделенных в древовидном списке (полный список)
   int               m_c_list_index[];
   int               m_c_tree_list_index[];
   string            m_c_item_text[];
   //--- Массивы для списка отображаемых пунктов в списке содержания
   int               m_cd_list_index[];
   int               m_cd_tree_list_index[];
   string            m_cd_item_text[];
   //--- Общее количество пунктов и количество в видимой части списков
   int               m_items_total;
   int               m_content_items_total;
   int               m_visible_items_total;
   //--- Индексы выделенных пунктов в списках
   int               m_selected_item_index;
   int               m_selected_content_item_index;
   //--- Текст выделенного пункта в списке.
   //    Только для файлов в случае использования класса для создания файлового навигатора.
   //    Если в списке выбран не файл, то в этом поле должна быть пустая строка "".
   string            m_selected_item_file_name;
   //--- Ширина области древовидного списка
   int               m_treeview_width;
   //--- Высота пунктов
   int               m_item_y_size;
   //--- Режим файлового навигатора
   ENUM_FILE_NAVIGATOR_MODE m_file_navigator_mode;
   //--- Режим подсветки при наведении курсора
   bool              m_lights_hover;
   //--- Режим показа содержания пункта в рабочей области
   bool              m_show_item_content;
   //--- Режим изменения ширины списков
   bool              m_resize_list_mode;
   //--- Режим пунктов-вкладок
   bool              m_tab_items_mode;
   //--- Счётчик таймера для перемотки списка
   int               m_timer_counter;
   //--- (1) Минимальный и (2) максимальный уровень узла
   int               m_min_node_level;
   int               m_max_node_level;
   //--- Количество пунктов в корневом каталоге
   int               m_root_items_total;
   //---
public:
                     CTreeView(void);
                    ~CTreeView(void);
   //--- Методы для создания древовидного списка
   bool              CreateTreeView(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateItems(void);
   bool              CreateScrollV(void);
   bool              CreateContentItems(void);
   bool              CreateContentScrollV(void);
   bool              CreateXResizePointer(void);
   //---
public:
   //--- Указатели полос прокрутки списков
   CScrollV         *GetScrollVPointer(void)                            { return(::GetPointer(m_scrollv));         }
   CScrollV         *GetContentScrollVPointer(void)                     { return(::GetPointer(m_content_scrollv)); }
   CPointer         *GetMousePointer(void)                              { return(::GetPointer(m_x_resize));        }
   //--- Возвращает (1) указатель пункта древовидного списка, (2) указатель пункта списка содержания, 
   CTreeItem        *ItemPointer(const uint index);
   CTreeItem        *ContentItemPointer(const uint index);
   //--- (1) Режим файлового навигатора, (2) режим подсветки при наведении курсора мыши, 
   //    (3) режим изменения ширины списков, (4) режим пунктов-вкладок
   void              NavigatorMode(const ENUM_FILE_NAVIGATOR_MODE mode) { m_file_navigator_mode=mode;              }
   void              LightsHover(const bool state)                      { m_lights_hover=state;                    }
   void              ResizeListMode(const bool state)                   { m_resize_list_mode=state;                }
   void              TabItemsMode(const bool state)                     { m_tab_items_mode=state;                  }
   bool              TabItemsMode(void)                           const { return(m_tab_items_mode);                }
   //--- Режим показа содержания пункта, 
   void              ShowItemContent(const bool state)                  { m_show_item_content=state;               }
   bool              ShowItemContent(void)                        const { return(m_show_item_content);             }
   //--- Количество пунктов (1) в древовидном списке, (2) в списке содержания и (3) видимое количество пунктов
   int               ItemsTotal(void)                             const { return(::ArraySize(m_items));            }
   int               ContentItemsTotal(void)                      const { return(::ArraySize(m_content_items));    }
   void              VisibleItemsTotal(const int total)                 { m_visible_items_total=total;             }
   //--- (1) Высота пункта, (2) ширина древовидного списка и (3) списка содержания
   void              ItemYSize(const int y_size)                        { m_item_y_size=y_size;                    }
   void              TreeViewWidth(const int x_size)                    { m_treeview_width=x_size;                 }
   //--- (1) Выделяет пункт по индексу и (2) возвращает индекс выделенного пункта, (3) возвращает название файла
   void              SelectedItemIndex(const int index)                 { m_selected_item_index=index;             }
   int               SelectedItemIndex(void)                      const { return(m_selected_item_index);           }
   string            SelectedItemFileName(void)                   const { return(m_selected_item_file_name);       }

   //--- Добавляет пункт в древовидный список
   void              AddItem(const int list_index,const int list_id,const string item_name,const string path_bmp,const int item_index,
                             const int node_number,const int item_number,const int items_total,const int folders_total,const bool item_state,const bool is_folder=true);
   //--- Добавляет элемент в массив пункта-вкладки
   void              AddToElementsArray(const int item_index,CElement &object);
   //--- Показать элементы только выделенного пункта-вкладки
   void              ShowTabElements(void);
   //--- Возвращает полный путь выделенного пункта
   string            CurrentFullPath(void);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Таймер
   virtual void      OnEventTimer(void);
   //--- Доступность элемента
   virtual void      IsAvailable(const bool state,const bool without_items=false);
   //--- Управление
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Delete(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Обработка нажатия на кнопке сворачивания/разворачивания списка пункта
   bool              OnClickItemArrow(const string clicked_object,const int id,const int index);
   //--- Обработка нажатия на пункте древовидного списка
   bool              OnClickTreeItem(const string clicked_object,const int id,const int index);
   //--- Обработка нажатия на пункте в списке содержания
   bool              OnClickContentItem(const string clicked_object,const int id,const int index);

   //--- Формирует массив пунктов-вкладок
   void              GenerateTabItemsArray(void);
   //--- Определение и установка (1) границ узлов и (2) размера корневого каталога
   void              SetNodeLevelBoundaries(void);
   void              SetRootItemsTotal(void);
   //--- Смещение списков
   void              ShiftTreeList(void);
   void              ShiftContentList(void);
   //--- Ускоренная перемотка списка
   void              FastSwitching(void);

   //--- Управляет шириной списков
   void              ResizeListArea(void);
   //--- Проверка готовности для изменения ширины списков
   void              CheckXResizePointer(const int x,const int y);
   //--- Проверка на выход за ограничения
   bool              CheckOutOfArea(const int x,const int y);
   //--- Обновление ширины элементов списка
   void              UpdateXSize(const int x);

   //--- Добавляет пункт в список в области содержания
   void              AddDisplayedTreeItem(const int list_index);
   //--- Формирует (1) древовидный список и (2) список содержания
   void              FormTreeList(void);
   void              FormContentList(void);
   //---
public:
   //--- Перерисовка списков
   void              RedrawTreeList(void);
   void              RedrawContentList(void);
   //--- Обновляет (1) древовидный список и (2) список содержания
   void              UpdateTreeList(void);
   void              UpdateContentList(void);
   //---
private:
   //--- Проверка индекса выделенного пункта на выход из диапазона
   void              CheckSelectedItemIndex(void);

   //--- Рисует границу между областями
   virtual void      DrawResizeBorder(void);

   //--- Изменить ширину по правому краю окна
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTreeView::CTreeView(void) : m_treeview_width(150),
                             m_item_y_size(20),
                             m_visible_items_total(12),
                             m_tab_items_mode(false),
                             m_lights_hover(false),
                             m_show_item_content(false),
                             m_resize_list_mode(false),
                             m_timer_counter(SPIN_DELAY_MSC),
                             m_selected_item_index(WRONG_VALUE),
                             m_selected_content_item_index(WRONG_VALUE)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTreeView::~CTreeView(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CTreeView::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Смещаем древовидный список, если управление ползунком полосы прокрутки в действии
      if(m_scrollv.ScrollBarControl())
        {
         ShiftTreeList();
         m_scrollv.Update(true);
         return;
        }
      //--- Заходим, только если есть список
      if(m_t_items_total[m_selected_item_index]>0)
        {
         //--- Смещаем список содержания, если управление ползунком полосы прокрутки в действии
         if(m_content_scrollv.ScrollBarControl())
           {
            ShiftContentList();
            m_content_scrollv.Update(true);
            return;
           }
        }
      //--- Управление шириной области содержания
      ResizeListArea();
      return;
     }
//--- Обработка события нажатия на кнопках полосы прокрутки 
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Выйти, если в режиме измененения размера области списка содержания
      if(m_x_resize.IsVisible() || m_x_resize.State())
         return;
      //--- Обработка нажатия на стрелке пункта
      if(OnClickItemArrow(sparam,(int)lparam,(int)dparam))
         return;
      //--- Обработка нажатия на пункте древовидного списка
      if(OnClickTreeItem(sparam,(int)lparam,(int)dparam))
         return;
      //--- Обработка нажатия на пункте в списке содержания
      if(OnClickContentItem(sparam,(int)lparam,(int)dparam))
         return;
      //--- Если было нажатие на кнопках полосы прокрутки списка
      if(m_scrollv.OnClickScrollInc((uint)lparam,(uint)dparam) ||
         m_scrollv.OnClickScrollDec((uint)lparam,(uint)dparam))
        {
         ShiftTreeList();
         m_scrollv.Update(true);
         return;
        }
      //--- Если было нажатие на кнопках полосы прокрутки списка
      if(m_content_scrollv.OnClickScrollInc((uint)lparam,(uint)dparam) ||
         m_content_scrollv.OnClickScrollDec((uint)lparam,(uint)dparam))
        {
         ShiftContentList();
         m_content_scrollv.Update(true);
         return;
        }
      return;
     }
  }
//+------------------------------------------------------------------+
//| Таймер                                                           |
//+------------------------------------------------------------------+
void CTreeView::OnEventTimer(void)
  {
//--- Ускоренная перемотка значений
   FastSwitching();
  }
//+------------------------------------------------------------------+
//| Создаёт элемент                                                  |
//+------------------------------------------------------------------+
bool CTreeView::CreateTreeView(const int x_gap,const int y_gap)
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
   if(!CreateScrollV())
      return(false);
   if(!CreateContentItems())
      return(false);
   if(!CreateContentScrollV())
      return(false);
   if(!CreateXResizePointer())
      return(false);
//--- Сформируем массив пунктов-вкладок
   GenerateTabItemsArray();
//--- Определение и установка (1) границ узлов и (2) размера корневого каталога
   SetNodeLevelBoundaries();
   SetRootItemsTotal();
//--- Обновить списки
   FormTreeList();
   FormContentList();
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CTreeView::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x      =CElement::CalculateX(x_gap);
   m_y      =CElement::CalculateY(y_gap);
   m_x_size =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset : m_x_size;
   m_y_size =m_item_y_size*m_visible_items_total+2;
//--- Ширина списка
   if(!m_show_item_content)
      m_treeview_width=m_x_size;
   else
      m_treeview_width=(m_treeview_width>=m_x_size)? m_x_size>>1 : m_treeview_width;
//--- Цвета по умолчанию
   m_back_color   =(m_back_color!=clrNONE)? m_back_color : clrWhite;
   m_border_color =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
//--- Проверка индекса выделенного пункта на выход из диапазона
   CheckSelectedItemIndex();
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CTreeView::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("tree_view");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт древовидный список                                       |
//+------------------------------------------------------------------+
bool CTreeView::CreateItems(void)
  {
//--- Координаты
   int x=1,y=1;
//---
   int items_total=::ArraySize(m_items);
   for(int i=0; i<items_total; i++)
     {
      //--- Расчёт координаты Y
      y=(i>0)? y+m_item_y_size : y;
      //--- Сохраним указатель родителя
      m_items[i].MainPointer(this);
      //--- Свойства
      m_items[i].NamePart("tree_item");
      m_items[i].Index(m_t_list_index[i]);
      m_items[i].XSize(m_treeview_width);
      m_items[i].YSize(m_item_y_size);
      m_items[i].IconXGap(m_items[i].ArrowXGap(m_t_node_level[i])+17);
      m_items[i].IconYGap(2);
      m_items[i].IconFile(m_t_path_bmp[i]);
      m_items[i].IsHighlighted(m_lights_hover);
      //--- Определим тип пункта
      ENUM_TYPE_TREE_ITEM type=TI_SIMPLE;
      if(m_file_navigator_mode==FN_ALL)
        {
         type=(m_t_items_total[i]>0)? TI_HAS_ITEMS : TI_SIMPLE;
        }
      else // FN_ONLY_FOLDERS
        {
         type=(m_t_folders_total[i]>0)? TI_HAS_ITEMS : TI_SIMPLE;
        }
      //--- Корректировка начального состояния пункта
      m_t_item_state[i]=(type==TI_HAS_ITEMS)? m_t_item_state[i]: false;
      //--- Создание элемента
      if(!m_items[i].CreateTreeItem(x,y,type,m_t_list_index[i],m_t_node_level[i],m_t_item_text[i],m_t_item_state[i]))
         return(false);
      //--- Добавить элемент в массив
      CElement::AddToArray(m_items[i]);
     }
//--- Установить цвет выделенному пункту
   if(!m_tab_items_mode && m_selected_item_index>=0)
      m_items[m_selected_item_index].IsPressed(true);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт вертикальный скролл                                      |
//+------------------------------------------------------------------+
bool CTreeView::CreateScrollV(void)
  {
//--- Сохранить указатель формы
   m_scrollv.MainPointer(this);
//--- Координаты
   int x=m_treeview_width-((m_show_item_content)? 15 : 16);
   int y=1;
//--- Установим свойства
   m_scrollv.Index(0);
   m_scrollv.XSize(m_scrollv.ScrollWidth());
   m_scrollv.YSize(CElementBase::YSize()-2);
//--- Создание полосы прокрутки
   if(!m_scrollv.CreateScroll(x,y,m_items_total,m_visible_items_total))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_scrollv);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт список содержания выделенного пункта                     |
//+------------------------------------------------------------------+
bool CTreeView::CreateContentItems(void)
  {
//--- Выйти, если (1) содержание пункта не нужно показывать или (2) включен режим вкладок
   if(!m_show_item_content || m_tab_items_mode)
      return(true);
//--- Резервный размер массива
   int reserve_size=10000;
//--- Координаты и ширина
   int x=m_treeview_width,y=1;
   int w=m_x_size-m_treeview_width-2;
//--- Счётчик количества пунктов
   int c=0;
//--- 
   int items_total=::ArraySize(m_items);
   for(int i=0; i<items_total; i++)
     {
      //--- В этот список не должны попасть пункты из корневого каталога, 
      //    поэтому, если уровень узла меньше 1, перейдём к следующему
      if(m_t_node_level[i]<1)
         continue;
      //--- Увеличить размеры массивов на один элемент
      int new_size=c+1;
      ::ArrayResize(m_content_items,new_size,reserve_size);
      ::ArrayResize(m_c_item_text,new_size,reserve_size);
      ::ArrayResize(m_c_tree_list_index,new_size,reserve_size);
      ::ArrayResize(m_c_list_index,new_size,reserve_size);
      //--- Расчёт координаты Y
      y=(c>0)? y+m_item_y_size : y;
      //--- Передадим объект панели
      m_content_items[c].MainPointer(this);
      //--- Установим свойства перед созданием
      m_content_items[c].NamePart("content_item");
      m_content_items[c].Index(m_t_list_index[i]);
      m_content_items[c].XSize(w);
      m_content_items[c].YSize(m_item_y_size);
      m_content_items[c].IconXGap(7);
      m_content_items[c].IconYGap(2);
      m_content_items[c].IconFile(m_t_path_bmp[i]);
      m_content_items[c].IsHighlighted(m_lights_hover);
      //--- Создание объекта
      if(!m_content_items[c].CreateTreeItem(x,y,TI_SIMPLE,c,0,m_t_item_text[i],false))
         return(false);
      //--- Добавить элемент в массив
      CElement::AddToArray(m_content_items[c]);
      //--- Сохранить (1) индекс общего списка содержания, (2) индекс древовидного списка и (3) текст пункта
      m_c_list_index[c]      =c;
      m_c_tree_list_index[c] =m_t_list_index[i];
      m_c_item_text[c]       =m_t_item_text[i];
      //---
      c++;
     }
//--- Сохранить размер списка
   m_content_items_total=::ArraySize(m_content_items);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт вертикальный скролл для рабочей области                  |
//+------------------------------------------------------------------+
bool CTreeView::CreateContentScrollV(void)
  {
//--- Сохранить указатель формы
   m_content_scrollv.MainPointer(this);
//--- Выйти, если содержание пункта не нужно показывать
   if(!m_show_item_content)
      return(true);
//--- Координаты
   int x=16,y=1;
//--- Свойства
   m_content_scrollv.Index(1);
   m_content_scrollv.XSize(m_content_scrollv.ScrollWidth());
   m_content_scrollv.YSize(CElementBase::YSize()-2);
   m_content_scrollv.AnchorRightWindowSide(true);
//--- Создание полосы прокрутки
   if(!m_content_scrollv.CreateScroll(x,y,m_content_items_total,m_visible_items_total))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_content_scrollv);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт указатель курсора изменения ширины                       |
//+------------------------------------------------------------------+
bool CTreeView::CreateXResizePointer(void)
  {
//--- Выйти, если ширину области содержания не нужно изменять или включен режим пунктов-вкладок
   if(!m_resize_list_mode || m_tab_items_mode)
     {
      m_x_resize.State(false);
      m_x_resize.IsVisible(false);
      return(true);
     }
//--- Свойства
   m_x_resize.XGap(12);
   m_x_resize.YGap(9);
   m_x_resize.XSize(25);
   m_x_resize.Type(MP_X_RESIZE);
   m_x_resize.Id(CElementBase::Id());
//--- Создание элемента
   if(!m_x_resize.CreatePointer(m_chart_id,m_subwin))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Возвращает указатель пункта древовидного списка по индексу       |
//+------------------------------------------------------------------+
CTreeItem *CTreeView::ItemPointer(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- Если нет ни одного пункта в контекстном меню, сообщить об этом
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, "
              "когда в контекстном меню есть хотя бы один пункт!");
     }
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть указатель
   return(::GetPointer(m_items[i]));
  }
//+------------------------------------------------------------------+
//| Возвращает указатель пункта области содержания по индексу        |
//+------------------------------------------------------------------+
CTreeItem *CTreeView::ContentItemPointer(const uint index)
  {
   uint array_size=::ArraySize(m_content_items);
//--- Если нет ни одного пункта в контекстном меню, сообщить об этом
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, "
              "когда в контекстном меню есть хотя бы один пункт!");
     }
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть указатель
   return(::GetPointer(m_content_items[i]));
  }
//+------------------------------------------------------------------+
//| Добавляет пункт в общий массив древовидного списка               |
//+------------------------------------------------------------------+
void CTreeView::AddItem(const int list_index,const int prev_node_list_index,const string item_text,const string path_bmp,const int item_index,
                        const int node_level,const int prev_node_item_index,const int items_total,const int folders_total,const bool item_state,const bool is_folder)
  {
//--- Резервный размер массива
   int reserve_size=10000;
//--- Увеличим размер массивов на один элемент
   int array_size =::ArraySize(m_items);
   m_items_total  =array_size+1;
   ::ArrayResize(m_items,m_items_total,reserve_size);
   ::ArrayResize(m_t_list_index,m_items_total,reserve_size);
   ::ArrayResize(m_t_prev_node_list_index,m_items_total,reserve_size);
   ::ArrayResize(m_t_item_text,m_items_total,reserve_size);
   ::ArrayResize(m_t_path_bmp,m_items_total,reserve_size);
   ::ArrayResize(m_t_item_index,m_items_total,reserve_size);
   ::ArrayResize(m_t_node_level,m_items_total,reserve_size);
   ::ArrayResize(m_t_prev_node_item_index,m_items_total,reserve_size);
   ::ArrayResize(m_t_items_total,m_items_total,reserve_size);
   ::ArrayResize(m_t_folders_total,m_items_total,reserve_size);
   ::ArrayResize(m_t_item_state,m_items_total,reserve_size);
   ::ArrayResize(m_t_is_folder,m_items_total,reserve_size);
//--- Сохраним значения переданных параметров
   m_t_list_index[array_size]           =list_index;
   m_t_prev_node_list_index[array_size] =prev_node_list_index;
   m_t_item_text[array_size]            =item_text;
   m_t_path_bmp[array_size]             =path_bmp;
   m_t_item_index[array_size]           =item_index;
   m_t_node_level[array_size]           =node_level;
   m_t_prev_node_item_index[array_size] =prev_node_item_index;
   m_t_items_total[array_size]          =items_total;
   m_t_folders_total[array_size]        =folders_total;
   m_t_item_state[array_size]           =item_state;
   m_t_is_folder[array_size]            =is_folder;
  }
//+------------------------------------------------------------------+
//| Добавляет элемент в массив указанной вкладки                     |
//+------------------------------------------------------------------+
void CTreeView::AddToElementsArray(const int tab_index,CElement &object)
  {
//--- Выйти, если режим пунктов-вкладок отключен
   if(!m_tab_items_mode)
      return;
//--- Проверка на выход из диапазона
   int array_size=::ArraySize(m_tab_items);
   if(array_size<1 || tab_index<0 || tab_index>=array_size)
      return;
//--- Добавим указатель переданного элемента в массив указанной вкладки
   int size=::ArraySize(m_tab_items[tab_index].elements);
   ::ArrayResize(m_tab_items[tab_index].elements,size+1);
   m_tab_items[tab_index].elements[size]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Показывает элементы только выделенного пункта-вкладки            |
//+------------------------------------------------------------------+
void CTreeView::ShowTabElements(void)
  {
//--- Выйти, если (1) элемент скрыт или (2) режим пунктов-вкладок отключен
   if(!CElementBase::IsVisible() || !m_tab_items_mode)
      return;
//--- Индекс выделенной вкладки
   int tab_index=WRONG_VALUE;
//--- Определим индекс выделенной вкладки
   int tab_items_total=::ArraySize(m_tab_items);
   for(int i=0; i<tab_items_total; i++)
     {
      if(m_tab_items[i].list_index==m_selected_item_index)
        {
         tab_index=i;
         break;
        }
     }
//--- Покажем элементы только выделенной вкладки
   for(int i=0; i<tab_items_total; i++)
     {
      //--- Получим количество элементов присоединённых к вкладке
      int tab_elements_total=::ArraySize(m_tab_items[i].elements);
      //--- Если выделен этот пункт-вкладка
      if(i==tab_index)
        {
         //--- Показать элементы
         for(int j=0; j<tab_elements_total; j++)
            m_tab_items[i].elements[j].Reset();
        }
      else
        {
         //--- Скрыть элементы
         for(int j=0; j<tab_elements_total; j++)
            m_tab_items[i].elements[j].Hide();
        }
     }
  }
//+------------------------------------------------------------------+
//| Возвращает полный текущий путь                                   |
//+------------------------------------------------------------------+
string CTreeView::CurrentFullPath(void)
  {
//--- Для формирования директории к выделенному пункту
   string path="";
//--- Индекс выделенного пункта
   int li=m_selected_item_index;
//--- Массив для формирования директории
   string path_parts[];
//--- Получим описание (текст) выделенного пункта древовидного списка,
//    но только, если это папка
   if(m_t_is_folder[li])
     {
      ::ArrayResize(path_parts,1);
      path_parts[0]=m_t_item_text[li];
     }
//--- Пройдёмся по всему списку
   int total=::ArraySize(m_t_list_index);
   for(int i=0; i<total; i++)
     {
      //--- Рассматриваем только папки.
      //    Если файл, переходим к следующему пункту.
      if(!m_t_is_folder[i])
         continue;
      //--- Если (1) индекс общего списка совпадает с индексом общего списка предыдущего узла и
      //    (2) индекс пункта локального списка совпадает с индексом пункта предыдущего узла и
      //    (3) соблюдается последовательность уровней узлов
      if(m_t_list_index[i]==m_t_prev_node_list_index[li] &&
         m_t_item_index[i]==m_t_prev_node_item_index[li] &&
         m_t_node_level[i]==m_t_node_level[li]-1)
        {
         //--- Увеличим массив на один элемент и сохраним описание пункта
         int sz=::ArraySize(path_parts);
         ::ArrayResize(path_parts,sz+1);
         path_parts[sz]=m_t_item_text[i];
         //--- Запомним индекс для следующей проверки
         li=i;
         //--- Если дошли до нулевого уровня узла, выходим из цикла
         if(m_t_node_level[i]==0 || i<=0)
            break;
         //--- Сбросить счётчик цикла
         i=-1;
        }
     }
//--- Сформировать строку - полный путь к выделенному пункту в древовидном списке
   total=::ArraySize(path_parts);
   for(int i=total-1; i>=0; i--)
      ::StringAdd(path,path_parts[i]+"\\");
//--- Если выделенный в древовидном списке пункт - папка
   if(m_t_is_folder[m_selected_item_index])
     {
      m_selected_item_file_name="";
      //--- Если пункт в области содержания выделен
      if(m_selected_content_item_index>0)
        {
         //--- Если выделенный пункт - файл, сохраним его название
         if(!m_t_is_folder[m_c_tree_list_index[m_selected_content_item_index]])
            m_selected_item_file_name=m_c_item_text[m_selected_content_item_index];
        }
     }
//--- Если выделенный в древовидном списке пункт - файл
   else
//--- Сохраним его название
      m_selected_item_file_name=m_t_item_text[m_selected_item_index];
//--- Вернуть директорию
   return(path);
  }
//+------------------------------------------------------------------+
//| Доступность элемента                                             |
//+------------------------------------------------------------------+
void CTreeView::IsAvailable(const bool state,const bool without_items=false)
  {
//--- Если без пунктов
   if(without_items)
     {
      m_is_available=state;
      return;
     }
//--- Если с пунктами
   else
     {
      m_is_available=state;
      int elements_total=CElement::ElementsTotal();
      for(int i=0; i<elements_total; i++)
         m_elements[i].IsAvailable(state);
      //---
      if(state)
         SetZorders();
      else
         ResetZorders();
     }
  }
//+------------------------------------------------------------------+
//| Показывает элемент                                               |
//+------------------------------------------------------------------+
void CTreeView::Show(void)
  {
//--- Выйти, если элемент уже видим
   if(CElementBase::IsVisible())
      return;
//--- Показать элемент
   CElement::Show();
//--- Обновить координаты и размеры списков
   ShiftTreeList();
   ShiftContentList();
  }
//+------------------------------------------------------------------+
//| Скрывает элемент                                                 |
//+------------------------------------------------------------------+
void CTreeView::Hide(void)
  {
//--- Выйти, если элемент уже скрыт
   if(!CElementBase::IsVisible())
      return;
//--- Скрыть элемент
   CElement::Hide();
//--- Скрыть пункты древовидного списка
   int total=::ArraySize(m_items);
   for(int i=0; i<total; i++)
      m_items[i].Hide();
//--- Скрыть пункты списка содержания
   total=::ArraySize(m_content_items);
   for(int i=0; i<total; i++)
      m_content_items[i].Hide();
//--- Скрыть полосы прокрутки
   m_scrollv.Hide();
   m_content_scrollv.Hide();
//--- Скорректируем размер полосы прокрутки
   m_scrollv.ChangeThumbSize(m_items_total,m_visible_items_total);
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CTreeView::Delete(void)
  {
   CElement::Delete();
   m_x_resize.Delete();
//--- Освобождение массивов элемента
   ::ArrayFree(m_items);
   ::ArrayFree(m_content_items);
//---
   int total=::ArraySize(m_tab_items);
   for(int i=0; i<total; i++)
      ::ArrayFree(m_tab_items[i].elements);
   ::ArrayFree(m_tab_items);
//---
   ::ArrayFree(m_t_prev_node_list_index);
   ::ArrayFree(m_t_list_index);
   ::ArrayFree(m_t_item_text);
   ::ArrayFree(m_t_path_bmp);
   ::ArrayFree(m_t_item_index);
   ::ArrayFree(m_t_node_level);
   ::ArrayFree(m_t_prev_node_item_index);
   ::ArrayFree(m_t_items_total);
   ::ArrayFree(m_t_folders_total);
   ::ArrayFree(m_t_item_state);
   ::ArrayFree(m_t_is_folder);
//---
   ::ArrayFree(m_td_list_index);
//---
   ::ArrayFree(m_c_list_index);
   ::ArrayFree(m_c_item_text);
//---
   ::ArrayFree(m_cd_item_text);
   ::ArrayFree(m_cd_list_index);
   ::ArrayFree(m_cd_tree_list_index);
//--- Инициализация переменных значениями по умолчанию
   m_selected_item_index=WRONG_VALUE;
   m_selected_content_item_index=WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CTreeView::Draw(void)
  {
//--- Нарисовать фон
   DrawBackground();
//--- Нарисовать рамку
   DrawBorder();
//--- Нарисовать границу областей
   DrawResizeBorder();
  }
//+------------------------------------------------------------------+
//| Нажатие на кнопку сворачивания/разворачивания списка пункта      |
//+------------------------------------------------------------------+
bool CTreeView::OnClickItemArrow(const string clicked_object,const int id,const int index)
  {
//--- Выйдем, если чужое имя объекта
   if(::StringFind(clicked_object,CElementBase::ProgramName()+"_tree_item_",0)<0)
      return(false);
//--- Выйти, если идентификаторы не совпадают
   if(id!=CElementBase::Id())
      return(false);
//--- Получим индекс пункта в общем списке
   int list_index=CElementBase::IndexFromObjectName(clicked_object);
//--- Выйти, если этот пункт без выпадающего списка
   if(m_items[list_index].Type()!=TI_HAS_ITEMS)
      return(false);
//--- Получим относительные координаты под курсором мыши
   int x=m_mouse.RelativeX(m_canvas);
//--- Выйти, если нажатие было не на стрелке
   if(x<m_items[list_index].ArrowXGap() || x>m_items[list_index].ArrowXGap()+16)
      return(false);
//--- Получим состояние стрелки пункта и установим противоположное
   m_t_item_state[list_index]=!m_t_item_state[list_index];
//--- Подсветить выделенный пункт
   m_items[list_index].ItemState(m_t_item_state[list_index]);
   m_items[list_index].IsPressed((list_index==m_selected_item_index)? true : false);
   m_items[list_index].Update(true);
//--- Сформировать древовидный список
   FormTreeList();
//--- Обновить
   UpdateTreeList();
//--- Рассчитать положение ползунка полосы прокрутки
   m_scrollv.MovingThumb(m_scrollv.CurrentPos());
//--- Показать элементы выделенного пункта-вкладки
   ShowTabElements();
//--- Отправим сообщение об изменении в графическом интерфейсе
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Нажатие на пункте в древовидном списке                           |
//+------------------------------------------------------------------+
bool CTreeView::OnClickTreeItem(const string clicked_object,const int id,const int index)
  {
//--- Выйдем, если полоса прокрутки в активном режиме
   if(m_scrollv.State() || m_content_scrollv.State())
      return(false);
//--- Выйдем, если чужое имя объекта
   if(::StringFind(clicked_object,CElementBase::ProgramName()+"_tree_item_",0)<0)
      return(false);
//--- Выйти, если идентификаторы не совпадают
   if(id!=CElementBase::Id())
      return(false);
//--- Получим текущую позицию ползунка полосы прокрутки
   int v=m_scrollv.CurrentPos();
//--- Пройдёмся по списку
   for(int r=0; r<m_visible_items_total; r++)
     {
      //--- Проверка для предотвращения выхода из диапазона
      if(v>=0 && v<m_items_total)
        {
         //--- Получим общий индекс пункта
         int li=m_td_list_index[v];
         //--- Если выбран этот пункт в списке
         if(m_items[li].CanvasPointer().ChartObjectName()==clicked_object)
           {
            //--- Выйдем, если этот пункт уже выделен
            if(li==m_selected_item_index)
              {
               m_items[li].IsPressed(true);
               m_items[li].Update(true);
               return(false);
              }
            //--- Если включен режим пунктов-вкладок и отключен режим показа содержания,
            //    не будем выделять пункты без списка
            if(m_tab_items_mode && !m_show_item_content)
              {
               //--- Если текущий пункт не содержит в себе списка, остановим цикл
               if(m_t_items_total[li]>0)
                 {
                  m_items[li].IsPressed(false);
                  m_items[li].Update(true);
                  break;
                 }
              }
            //--- Установим цвет предыдущему выделенному пункту
            m_items[m_selected_item_index].IsPressed(false);
            m_items[m_selected_item_index].Update(true);
            //--- Запомним индекс для текущего и изменим его цвет
            m_selected_item_index=li;
            m_items[li].IsPressed(true);
            m_items[li].Update(true);
            break;
           }
         v++;
        }
     }
//--- Сбросить цвета в области содержания
   if(m_selected_content_item_index>=0)
     {
      m_content_items[m_selected_content_item_index].IsPressed(false);
      m_content_items[m_selected_content_item_index].Update();
     }
//--- Сброс выделенного пункта
   m_selected_content_item_index=WRONG_VALUE;
//--- Обновить список содержания
   FormContentList();
   UpdateContentList();
//--- Рассчитать положение ползунка полосы прокрутки
   m_content_scrollv.MovingThumb(m_content_scrollv.CurrentPos());
//--- Показать элементы выделенного пункта-вкладки
   ShowTabElements();
//--- Отправить сообщение о выборе новой директории в древовидном списке
   ::EventChartCustom(m_chart_id,ON_CHANGE_TREE_PATH,0,0,"");
//--- Отправим сообщение об изменении в графическом интерфейсе
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Нажатие на пункте в списке содержания                            |
//+------------------------------------------------------------------+
bool CTreeView::OnClickContentItem(const string clicked_object,const int id,const int index)
  {
//--- Выйти, если область содержания отключена
   if(!m_show_item_content)
      return(false);
//--- Выйдем, если полоса прокрутки в активном режиме
   if(m_scrollv.State() || m_content_scrollv.State())
      return(false);
//--- Выйдем, если чужое имя объекта
   if(::StringFind(clicked_object,CElementBase::ProgramName()+"_content_item_",0)<0)
      return(false);
//--- Выйти, если идентификаторы не совпадают
   if(id!=CElementBase::Id())
      return(false);
//--- Получим количество пунктов в списке содержания
   int content_items_total=::ArraySize(m_cd_list_index);
//--- Получим текущую позицию ползунка полосы прокрутки
   int v=m_content_scrollv.CurrentPos();
//--- Пройдёмся по списку
   for(int r=0; r<m_visible_items_total; r++)
     {
      //--- Проверка для предотвращения выхода из диапазона
      if(v>=0 && v<content_items_total)
        {
         //--- Получим общий индекс списка
         int li=m_cd_list_index[v];
         //--- Если выбран этот пункт в списке
         if(m_content_items[li].CanvasPointer().ChartObjectName()==clicked_object)
           {
            //--- Установить цвет предыдущему выделенному пункту
            if(m_selected_content_item_index>=0)
              {
               m_content_items[m_selected_content_item_index].IsPressed(false);
               m_content_items[m_selected_content_item_index].Update(true);
              }
            //--- Запомним индекс для текущего и изменим цвет
            m_selected_content_item_index=li;
            m_content_items[li].IsPressed(true);
            m_content_items[li].Update(true);
           }
         v++;
        }
     }
//--- Отправить сообщение о выборе новой директории в древовидном списке
   ::EventChartCustom(m_chart_id,ON_CHANGE_TREE_PATH,0,0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Формирует массив пунктов-вкладок                                 |
//+------------------------------------------------------------------+
void CTreeView::GenerateTabItemsArray(void)
  {
//--- Выйти, если режим пунктов-вкладок отключен
   if(!m_tab_items_mode)
      return;
//--- Добавим в массив пунктов-вкладок только пустые пункты
   int items_total=::ArraySize(m_items);
   for(int i=0; i<items_total; i++)
     {
      //--- Если в этом пункте есть другие пункты, перейдём к следующему
      if(m_t_items_total[i]>0)
         continue;
      //--- Увеличим размер массива пунктов-вкладок на один элемент
      int array_size=::ArraySize(m_tab_items);
      ::ArrayResize(m_tab_items,array_size+1);
      //--- Сохраним общий индекс пункта
      m_tab_items[array_size].list_index=i;
     }
//--- Если отключен показ содержания пунктов
   if(!m_show_item_content)
     {
      //--- Получим размер массива пунктов-вкладок
      int tab_items_total=::ArraySize(m_tab_items);
      //--- Скорректируем индекс, если выход из диапазона
      if(m_selected_item_index>=tab_items_total)
         m_selected_item_index=tab_items_total-1;
      //--- Индекс выделенной вкладки
      int tab_index=m_tab_items[m_selected_item_index].list_index;
      m_selected_item_index=tab_index;
      m_items[tab_index].IsPressed(true);
      m_items[tab_index].Update();
     }
  }
//+------------------------------------------------------------------+
//| Определение и установка границ узлов                             |
//+------------------------------------------------------------------+
void CTreeView::SetNodeLevelBoundaries(void)
  {
//--- Определим минимальный и максимальный уровень узлов
   m_min_node_level =m_t_node_level[::ArrayMinimum(m_t_node_level)];
   m_max_node_level =m_t_node_level[::ArrayMaximum(m_t_node_level)];
  }
//+------------------------------------------------------------------+
//| Определение и установка размера корневого каталога               |
//+------------------------------------------------------------------+
void CTreeView::SetRootItemsTotal(void)
  {
//--- Определим количество пунктов в корневом каталоге
   int items_total=::ArraySize(m_items);
   for(int i=0; i<items_total; i++)
     {
      //--- Если это минимальный уровень, увеличим счётчик
      if(m_t_node_level[i]==m_min_node_level)
         m_root_items_total++;
     }
  }
//+------------------------------------------------------------------+
//| Сдвигает древовидный список относительно полосы прокрутки        |
//+------------------------------------------------------------------+
void CTreeView::ShiftTreeList(void)
  {
//--- Выйти, если элемент скрыт
   if(!CElementBase::IsVisible())
      return;
//--- Скрыть все пункты в древовидном списке
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
      m_items[i].Hide();
//--- Получим количество отображаемых пунктов в списке
   int total=::ArraySize(m_td_list_index);
//--- Расчёт ширины пунктов списка
   int w=(m_scrollv.IsScroll())? CElementBase::XSize()-m_scrollv.ScrollWidth()-2 : CElementBase::XSize();
//--- Определение позиции скролла
   int v=(m_scrollv.IsScroll())? m_scrollv.CurrentPos() : 0;
   m_scrollv.CurrentPos(v);
//--- Координаты
   int x=1,y=1;
//---
   for(int r=0; r<m_visible_items_total; r++)
     {
      //--- Проверка для предотвращения выхода из диапазона
      if(v>=0 && v<total)
        {
         //--- Рассчитаем координату Y
         y=(r>0)? y+m_item_y_size : y;
         //--- Получим общий индекс пункта древовидного списка
         int li=m_td_list_index[v];
         //--- Установить координаты и ширину
         m_items[li].UpdateX(x);
         m_items[li].UpdateY(y);
         //--- Показать пункт
         m_items[li].Show();
         v++;
        }
     }
//--- Перерисовать полосу прокрутки
   if(m_scrollv.IsScroll())
      m_scrollv.Show();
  }
//+------------------------------------------------------------------+
//| Сдвигает список содержания относительно полосы прокрутки         |
//+------------------------------------------------------------------+
void CTreeView::ShiftContentList(void)
  {
//--- Выйти, если (1) содержание пункта не нужно показывать или (2) элемент скрыт
   if(!m_show_item_content || !CElementBase::IsVisible())
      return;
//--- Скрыть все пункты в списке содержания
   m_content_items_total=ContentItemsTotal();
   for(int i=0; i<m_content_items_total; i++)
      m_content_items[i].Hide();
//--- Получим количество отображаемых пунктов в списке содержания
   int total=::ArraySize(m_cd_list_index);
//--- Если нужна полоса прокрутки
   bool is_scroll=total>m_visible_items_total;
//--- Расчёт ширины пунктов списка
   int w=(is_scroll)? m_x_size-m_treeview_width-m_content_scrollv.ScrollWidth()-2 : m_x_size-m_treeview_width-2;
//--- Определение позиции скролла
   int v=(is_scroll)? m_content_scrollv.CurrentPos() : 0;
   m_content_scrollv.CurrentPos(v);
//--- Координата X
   int x=m_treeview_width+1;
//--- Координата Y первого пункта древовидного списка
   int y=1;
//--- 
   for(int r=0; r<m_visible_items_total; r++)
     {
      //--- Проверка для предотвращения выхода из диапазона
      if(v>=0 && v<total)
        {
         //--- Рассчитаем координату Y
         y=(r>0)? y+m_item_y_size : y;
         //--- Получим общий индекс пункта древовидного списка
         int li=m_cd_list_index[v];
         //--- Установить координаты и ширину
         m_content_items[li].UpdateX(x);
         m_content_items[li].UpdateY(y);
         //--- Показать пункт
         m_content_items[li].Show();
         v++;
        }
     }
//--- Перерисовать полосу прокрутки
   if(is_scroll)
      m_content_scrollv.Show();
  }
//+------------------------------------------------------------------+
//| Ускоренная перемотка списков                                     |
//+------------------------------------------------------------------+
void CTreeView::FastSwitching(void)
  {
//--- Определение фокуса на одной из кнопок полос прокрутки
   bool spin_buttons_focus=m_scrollv.GetIncButtonPointer().MouseFocus() || 
                           m_scrollv.GetDecButtonPointer().MouseFocus() ||
                           m_content_scrollv.GetIncButtonPointer().MouseFocus() ||
                           m_content_scrollv.GetDecButtonPointer().MouseFocus();
//--- Выйти, если (1) вне области элемента или (2) активирован режим изменения ширины области содержания
   if((!CElementBase::MouseFocus() && !spin_buttons_focus) || m_x_resize.State())
     {
      //--- Отправим сообщение об изменении в графическом интерфейсе
      if(m_timer_counter!=SPIN_DELAY_MSC)
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      //--- Вернём счётчик к первоначальному значению
      m_timer_counter=SPIN_DELAY_MSC;
      return;
     }
//--- Если кнопка мыши отжата
   if(!m_mouse.LeftButtonState())
     {
      //--- Отправим сообщение об изменении в графическом интерфейсе
      if(m_timer_counter!=SPIN_DELAY_MSC)
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      //--- Вернём счётчик к первоначальному значению
      m_timer_counter=SPIN_DELAY_MSC;
     }
//--- Если же кнопка мыши нажата
   else
     {
      //--- Выйти, если ни одна кнопка не зажата
      if(!spin_buttons_focus)
         return;
      //--- Увеличим счётчик на установленный интервал
      m_timer_counter+=TIMER_STEP_MSC;
      //--- Выйдем, если меньше нуля
      if(m_timer_counter<0)
         return;
      //--- Флаг перемотки
      bool scroll_v=false;
      //--- Если прокрутка вверх
      if(m_scrollv.GetIncButtonPointer().MouseFocus())
        {
         m_scrollv.OnClickScrollInc((uint)Id(),0);
         scroll_v=true;
        }
      //--- Если прокрутка вниз
      else if(m_scrollv.GetDecButtonPointer().MouseFocus())
        {
         m_scrollv.OnClickScrollDec((uint)Id(),1);
         scroll_v=true;
        }
      //--- Если кнопка нажата
      if(scroll_v)
        {
         //--- Обновить список
         ShiftTreeList();
         m_scrollv.Update(true);
         return;
        }
      //--- Выйти, если область содержания отключена
      if(!m_show_item_content)
         return;
      //--- Если прокрутка вверх
      if(m_content_scrollv.GetIncButtonPointer().MouseFocus())
        {
         m_content_scrollv.OnClickScrollInc((uint)Id(),2);
         scroll_v=true;
        }
      //--- Если прокрутка вниз
      else if(m_content_scrollv.GetDecButtonPointer().MouseFocus())
        {
         m_content_scrollv.OnClickScrollDec((uint)Id(),3);
         scroll_v=true;
        }
      //--- Если кнопка нажата
      if(scroll_v)
        {
         //--- Обновить список
         ShiftContentList();
         m_content_scrollv.Update(true);
        }
     }
  }
//+------------------------------------------------------------------+
//| Управляет шириной списков                                        |
//+------------------------------------------------------------------+
void CTreeView::ResizeListArea(void)
  {
//--- Выйти, (1) если ширину области содержания не нужно изменять или 
//    (2) включен режим пунктов-вкладок или (3) полоса прокрутки активна
   if(!m_resize_list_mode || !m_show_item_content || m_tab_items_mode || m_scrollv.State())
      return;
//--- Координаты
   int x =m_mouse.RelativeX(m_canvas);
   int y =m_mouse.RelativeY(m_canvas);
//--- Проверка готовности для изменения ширины списков
   CheckXResizePointer(x,y);
//--- Выйти, если курсор отключен
   if(!m_x_resize.State())
      return;
//--- Проверка на выход за установленные ограничения 
   if(!CheckOutOfArea(x,y))
      return;
//--- Установим X-координату объекту по центру курсора мыши
   m_x_resize.UpdateX(m_mouse.X());
//--- Y-координату устанавливаем, только если не вышли за область элемента
   if(y>0 && y<m_y_size)
      m_x_resize.UpdateY(m_mouse.Y());
//--- Обновление ширины элементов списка
   UpdateXSize(x);
//--- Перерисовать указатель
   m_x_resize.Reset();
  }
//+------------------------------------------------------------------+
//| Проверка готовности для изменения ширины списков                 |
//+------------------------------------------------------------------+
void CTreeView::CheckXResizePointer(const int x,const int y)
  {
//--- Если указатель не активирован, но курсор мыши в его области
   if(!m_x_resize.State() && 
      y>0 && y<m_y_size && x>m_treeview_width && x<m_treeview_width+3)
     {
      //--- Обновить координаты указателя и сделать его видимым
      m_x_resize.Moving(m_mouse.X(),m_mouse.Y());
      m_x_resize.Reset();
      //--- Если левая кнопка мыши нажата, активируем указатель
      if(m_mouse.LeftButtonState())
        {
         m_x_resize.State(true);
         m_x_resize.Update(true);
         //--- Отправим сообщение на определение доступных элементов
         ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
         //--- Отправим сообщение об изменении в графическом интерфейсе
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
        }
     }
   else
     {
      //--- Если левая кнопка мыши отжата
      if(!m_mouse.LeftButtonState())
        {
         //--- Выйти, если указатель курсора уже скрыт
         if(!m_x_resize.IsVisible())
            return;
         //--- Если указатель курсора активен
         if(m_x_resize.State())
           {
            //--- Дезактивировать указатель
            m_x_resize.State(false);
            //--- Коррекция ширины пунктов списков
            RedrawTreeList();
            RedrawContentList();
            UpdateTreeList();
            UpdateContentList();
            //--- Отправим сообщение на определение доступных элементов
            ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
            //--- Отправим сообщение об изменении в графическом интерфейсе
            ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
           }
         //--- Скрыть указатель
         m_x_resize.Hide();
        }
     }
  }
//+------------------------------------------------------------------+
//| Проверка на выход за ограничения                                 |
//+------------------------------------------------------------------+
bool CTreeView::CheckOutOfArea(const int x,const int y)
  {
//--- Ограничение
   int area_limit=80;
//--- Если выходим за границы элемента по горизонтали ...
   if(x<area_limit || x>m_x_size-area_limit)
     {
      // ... перемещаем указатель только по вертикали, не выходя за границы
      if(y>0 && y<m_y_size)
         m_x_resize.UpdateY(m_mouse.Y());
      //--- Не изменять ширину списков
      return(false);
     }
//--- Изменить ширину списков
   return(true);
  }
//+------------------------------------------------------------------+
//| Обновление ширины древовидного списка                            |
//+------------------------------------------------------------------+
void CTreeView::UpdateXSize(const int x)
  {
//--- Координаты
   int y1=1,y2=m_y_size-2;
//--- Стереть границу
   m_canvas.LineVertical(m_treeview_width,y1,y2,::ColorToARGB(m_back_color));
//--- Рассчитаем и установим ширину области древовидного списка
   m_treeview_width=x-3;
//--- Рассчитаем и установим ширину для пунктов в древовидном списке с учётом полосы прокрутки
   int w=(m_scrollv.IsScroll())? m_treeview_width-m_scrollv.ScrollWidth()-2 : m_treeview_width-1;
//--- Определение позиции скролла
   int v=(m_scrollv.IsScroll())? m_scrollv.CurrentPos() : 0;
   m_scrollv.CurrentPos(v);
//--- Получим количество отображаемых пунктов в списке
   int total=::ArraySize(m_td_list_index);
   for(int r=0; r<m_visible_items_total; r++)
     {
      //--- Проверка для предотвращения выхода из диапазона
      if(v>=0 && v<total)
        {
         //--- Получим общий индекс пункта древовидного списка
         int li=m_td_list_index[v];
         //--- Установить координаты и ширину
         m_items[li].UpdateWidth(w);
         m_items[li].Update(true);
         v++;
        }
     }
//--- Рассчитаем ширину для пунктов в списке
   w=(m_content_scrollv.IsScroll())? m_x_size-m_treeview_width-m_content_scrollv.ScrollWidth()-3 : m_x_size-m_treeview_width-2;
//--- Определение позиции скролла
   v=(m_content_scrollv.IsScroll())? m_content_scrollv.CurrentPos() : 0;
   m_content_scrollv.CurrentPos(v);
//--- Получим количество отображаемых пунктов в списке содержания
   total=::ArraySize(m_cd_list_index);
   for(int r=0; r<m_visible_items_total; r++)
     {
      //--- Проверка для предотвращения выхода из диапазона
      if(v>=0 && v<total)
        {
         //--- Получим общий индекс пункта древовидного списка
         int li=m_cd_list_index[v];
         //--- Установить координаты и ширину
         m_content_items[li].MouseFocus(false);
         m_content_items[li].UpdateWidth(w);
         m_content_items[li].UpdateX(m_treeview_width+1);
         m_content_items[li].Moving();
         m_content_items[li].Update(true);
         v++;
        }
     }
//--- Нарисовать границу
   m_canvas.LineVertical(m_treeview_width,y1,y2,::ColorToARGB(m_border_color));
//--- Рассчитаем и установим координаты для полосы прокрутки древовидного списка
   m_scrollv.XDistance(m_treeview_width-15);
//--- Обновить элемент
   m_canvas.Update();
  }
//+------------------------------------------------------------------+
//| Добавляет пункт в массив отображаемых пунктов                    |
//| в древовидном списке                                             |
//+------------------------------------------------------------------+
void CTreeView::AddDisplayedTreeItem(const int list_index)
  {
//--- Увеличим размер массивов на один элемент
   int array_size=::ArraySize(m_td_list_index);
   ::ArrayResize(m_td_list_index,array_size+1);
//--- Сохраним значения переданных параметров
   m_td_list_index[array_size]=list_index;
  }
//+------------------------------------------------------------------+
//| Формирует древовидный список                                     |
//+------------------------------------------------------------------+
void CTreeView::FormTreeList(void)
  {
//--- Массивы для контроля последовательности пунктов:
   int l_prev_node_list_index[]; // общий индекс списка предыдущего узла
   int l_item_index[];           // локальный индекс пункта
   int l_items_total[];          // количество пунктов в узле
   int l_folders_total[];        // количество папок в узле
//--- Зададим начальный размер массивов
   int begin_size=m_max_node_level+2;
   ::ArrayResize(l_prev_node_list_index,begin_size);
   ::ArrayResize(l_item_index,begin_size);
   ::ArrayResize(l_items_total,begin_size);
   ::ArrayResize(l_folders_total,begin_size);
//--- Инициализация массивов
   ::ArrayInitialize(l_prev_node_list_index,-1);
   ::ArrayInitialize(l_item_index,-1);
   ::ArrayInitialize(l_items_total,-1);
   ::ArrayInitialize(l_folders_total,-1);
//--- Освобождаем массив отображаемых пунктов древовидного списка
   ::ArrayFree(m_td_list_index);
//--- Счётчик локальных индексов пунктов
   int ii=0;
//--- Для установки флага последнего пункта в корневом каталоге
   bool end_list=false;
//--- Собираем отображаемые пункты в массив. Цикл будет работать до тех пор, пока: 
//    1: счётчик узлов не больше максимального;
//    2: не дошли до последнего пункта (после проверки всех вложенных в него пунктов);
//    3: пользователь не удалил программу.
   int items_total=::ArraySize(m_items);
   for(int nl=m_min_node_level; nl<=m_max_node_level && !end_list; nl++)
     {
      for(int i=0; i<items_total && !::IsStopped(); i++)
        {
         //--- Если включен режим "Отображать только папки"
         if(m_file_navigator_mode==FN_ONLY_FOLDERS)
           {
            //--- Если это файл, перейти к следующему пункту
            if(!m_t_is_folder[i])
               continue;
           }
         //--- Если (1) это не наш узел или (2) последовальность локальных индексов пунктов не соблюдается,
         //    перейдём к следующему
         if(nl!=m_t_node_level[i] || m_t_item_index[i]<=l_item_index[nl])
            continue;
         //--- Перейдём к следующему пункту, если (1) сейчас не в корневом каталоге и 
         //    (2) общий индекс списка предыдущего узла не равен аналогичному в памяти
         if(nl>m_min_node_level && m_t_prev_node_list_index[i]!=l_prev_node_list_index[nl])
            continue;
         //--- Запомним локальный индекс пункта, если следующий будет не меньше размера локального списка
         if(m_t_item_index[i]+1>=l_items_total[nl])
            ii=m_t_item_index[i];
         //--- Если список текущего пункта развёрнут
         if(m_t_item_state[i])
           {
            //--- Добавим пункт в массив отображаемых пунктов в древовидном списке
            AddDisplayedTreeItem(i);
            //--- Запомним текущие значения и перейдём к следующему узлу
            int n=nl+1;
            l_prev_node_list_index[n] =m_t_list_index[i];
            l_item_index[nl]          =m_t_item_index[i];
            l_items_total[n]          =m_t_items_total[i];
            l_folders_total[n]        =m_t_folders_total[i];
            //--- Обнулим счётчик локальных индексов пунктов
            ii=0;
            //--- Перейдём к следующему узлу
            break;
           }
         //--- Добавим пункт в массив отображаемых пунктов в древовидном списке
         AddDisplayedTreeItem(i);
         //--- Увеличим счётчик локальных индексов пунктов
         ii++;
         //--- Если дошли до последнего пункта в корневом каталоге
         if(nl==m_min_node_level && ii>=m_root_items_total)
           {
            //--- Установим флаг и завершим текущий цикл
            end_list=true;
            break;
           }
         //--- Если до последнего пункта в корневом каталоге ещё не дошли
         else if(nl>m_min_node_level)
           {
            //--- Получим количество пунктов в текущем узле
            int total=(m_file_navigator_mode==FN_ONLY_FOLDERS)? l_folders_total[nl]: l_items_total[nl];
            //--- Если это не последний локальный индекс пункта, перейдём к следующему
            if(ii<total)
               continue;
            //--- Если дошли до последнего локального индекса, то 
            //    нужно вернуться на предыдущий узел и продолжить с пункта, на котором остановились
            while(true)
              {
               //--- Сбросим значения текущего узла в перечисленных ниже массивах
               l_prev_node_list_index[nl] =-1;
               l_item_index[nl]           =-1;
               l_items_total[nl]          =-1;
               //--- Уменьшаем счётчик узлов, пока соблюдается равенство в количестве пунктов в локальных списках 
               //    или не дошли до корневого каталога
               if(l_item_index[nl-1]+1>=l_items_total[nl-1])
                 {
                  if(nl-1==m_min_node_level)
                     break;
                  //---
                  nl--;
                  continue;
                 }
               //---
               break;
              }
            //--- Перейдём на предыдущий узел
            nl=nl-2;
            //--- Обнулим счётчик локальных индексов пунктов и перейдём к следующему узлу
            ii=0;
            break;
           }
        }
     }
//--- Перерисовка списка
   RedrawTreeList();
  }
//+------------------------------------------------------------------+
//| Формирует список содержания                                      |
//+------------------------------------------------------------------+
void CTreeView::FormContentList(void)
  {
//--- Индекс выделенного пункта
   int li=m_selected_item_index;
//--- Освободим массивы списка содержания
   ::ArrayFree(m_cd_item_text);
   ::ArrayFree(m_cd_list_index);
   ::ArrayFree(m_cd_tree_list_index);
//--- Сформируем список содержания
   int items_total=::ArraySize(m_items);
   for(int i=0; i<items_total; i++)
     {
      //--- Если совпадают (1) уровни узлов и (2) локальные индексы пунктов, а также
      //    (3) индекс предыдущего узла с индексом выделенного пункта
      if(m_t_node_level[i]==m_t_node_level[li]+1 && 
         m_t_prev_node_item_index[i]==m_t_item_index[li] &&
         m_t_prev_node_list_index[i]==li)
        {
         //--- Увеличим массивы отображаемых пунктов списка содержания
         int size     =::ArraySize(m_cd_list_index);
         int new_size =size+1;
         ::ArrayResize(m_cd_item_text,new_size);
         ::ArrayResize(m_cd_list_index,new_size);
         ::ArrayResize(m_cd_tree_list_index,new_size);
         //--- Сохраним в массивах текст пункта и общий индекс древовидного списка
         m_cd_item_text[size]       =m_t_item_text[i];
         m_cd_tree_list_index[size] =m_t_list_index[i];
        }
     }
//--- Если в итоге список не пустой, заполним массив общих индексов списка содержания
   int cd_items_total=::ArraySize(m_cd_list_index);
   if(cd_items_total>0)
     {
      //--- Счётчик пунктов
      int c=0;
      //--- Пройдёмся по списку
      int c_items_total=::ArraySize(m_c_list_index);
      for(int i=0; i<c_items_total; i++)
        {
         //--- Если описание и общие индексы пунктов древовидного списка совпадают
         if(m_c_item_text[i]==m_cd_item_text[c] && 
            m_c_tree_list_index[i]==m_cd_tree_list_index[c])
           {
            //--- Сохраним общий индекс списка содержания и перейдём к следующему
            m_cd_list_index[c]=m_c_list_index[i];
            c++;
            //--- Выйти из цикла, если дошли конца отображаемого списка
            if(c>=cd_items_total)
               break;
           }
        }
     }
//--- Перерисовка списка
   RedrawContentList();
  }
//+------------------------------------------------------------------+
//| Перерисовка списка                                               |
//+------------------------------------------------------------------+
void CTreeView::RedrawTreeList(void)
  {
//--- Скрыть пункты списка
   int items_total=::ArraySize(m_items);
   for(int i=0; i<items_total; i++)
      m_items[i].Hide();
//--- Скрыть полосу прокрутки
   m_scrollv.Hide();
//--- Координата Y первого пункта древовидного списка
   int y=1;
//--- Получим количество пунктов
   m_items_total=::ArraySize(m_td_list_index);
//--- Скорректировать размеры полосы прокрутки
   m_scrollv.Reinit(m_items_total,m_visible_items_total);
   m_scrollv.ChangeYSize(m_y_size-2);
   m_scrollv.Update(true);
//--- Расчёт ширины пунктов древовидного списка
   int w=0;
   if(m_show_item_content)
      w=(m_scrollv.IsScroll()) ? m_treeview_width-m_scrollv.ScrollWidth()-2 : m_treeview_width-1;
   else
      w=(m_scrollv.IsScroll()) ? m_treeview_width-m_scrollv.ScrollWidth()-3 : m_treeview_width-2;
//--- Установим новые значения
   for(int i=0; i<m_items_total; i++)
     {
      //--- Расчёт координаты Y для каждого пункта
      y=(i>0)? y+m_item_y_size : y;
      //--- Получим общий индекс пункта в списке
      int li=m_td_list_index[i];
      //--- Обновим координаты и размер
      m_items[li].UpdateY(y);
      m_items[li].UpdateWidth(w);
     }
//--- Показать пункты списка
   for(int i=0; i<items_total; i++)
      m_items[i].Show();
//--- Обновить координаты и размер списка
   ShiftTreeList();
  }
//+------------------------------------------------------------------+
//| Перерисовка списка содержания                                    |
//+------------------------------------------------------------------+
void CTreeView::RedrawContentList(void)
  {
//--- Выйти, если (1) содержание пункта не нужно показывать или (2) включен режим вкладок
   if(!m_show_item_content || m_tab_items_mode)
      return;
//--- Количество пунктов списка
   int content_items_total=::ArraySize(m_content_items);
//--- Если элемент не скрыт, скрыть пункты списка
   if(CElementBase::IsVisible())
     {
      for(int i=0; i<content_items_total; i++)
         m_content_items[i].Hide();
      //--- Скрыть полосу прокрутки
      m_content_scrollv.Hide();
     }
//--- Координата Y первого пункта древовидного списка
   int y=1;
//--- Получим количество пунктов
   int items_total=::ArraySize(m_cd_list_index);
//--- Скорректировать размеры полосы прокрутки
   m_content_scrollv.Reinit(items_total,m_visible_items_total);
   m_content_scrollv.ChangeYSize(m_y_size-2);
   m_content_scrollv.Update(true);
//--- Расчёт ширины пунктов древовидного списка
   int w=(m_content_scrollv.IsScroll()) ? m_x_size-m_treeview_width-m_scrollv.ScrollWidth()-3 : m_x_size-m_treeview_width-2;
//--- Установим новые значения
   for(int i=0; i<items_total; i++)
     {
      //--- Расчёт координаты Y для каждого пункта
      y=(i>0)? y+m_item_y_size : y;
      //--- Получим общий индекс пункта в списке
      int li=m_cd_list_index[i];
      //--- Обновим координаты и размер
      m_content_items[li].UpdateY(y);
      m_content_items[li].UpdateWidth(w);
     }
//--- Если элемент не скрыт, показать пункты списка
   if(CElementBase::IsVisible())
     {
      for(int i=0; i<content_items_total; i++)
         m_content_items[i].Show();
     }
//--- Обновить координаты и размер списка
   ShiftContentList();
  }
//+------------------------------------------------------------------+
//| Обновляет список                                                 |
//+------------------------------------------------------------------+
void CTreeView::UpdateTreeList(void)
  {
   int items_total=::ArraySize(m_td_list_index);
   for(int i=0; i<items_total; i++)
     {
      //--- Получим общий индекс пункта в списке
      int li=m_td_list_index[i];
      //--- Обновим
      m_items[li].Update(true);
     }
  }
//+------------------------------------------------------------------+
//| Обновляет список содержания                                      |
//+------------------------------------------------------------------+
void CTreeView::UpdateContentList(void)
  {
   int items_total=::ArraySize(m_cd_list_index);
   for(int i=0; i<items_total; i++)
     {
      //--- Получим общий индекс пункта в списке
      int li=m_cd_list_index[i];
      //--- Обновим
      m_content_items[li].Update(true);
     }
  }
//+------------------------------------------------------------------+
//| Проверка индекса выделенного пункта на выход из диапазона        |
//+------------------------------------------------------------------+
void CTreeView::CheckSelectedItemIndex(void)
  {
//--- Если индекс не определён
   if(m_selected_item_index==WRONG_VALUE)
     {
      //--- Будет выделен первый пункт в списке
      m_selected_item_index=0;
      return;
     }
//--- Проверка на выход из диапазона
   int array_size=::ArraySize(m_items);
   if(array_size<1 || m_selected_item_index<0 || m_selected_item_index>=array_size)
     {
      //--- Будет выделен первый пункт в списке
      m_selected_item_index=0;
      return;
     }
  }
//+------------------------------------------------------------------+
//| Рисует границу между областями                                   |
//+------------------------------------------------------------------+
void CTreeView::DrawResizeBorder(void)
  {
//--- Выйти, если режим отключен
   if(!m_show_item_content)
      return;
//--- Координаты
   int x=m_treeview_width;
   int y1=0,y2=m_y_size;
//--- Нарисовать линию
   m_canvas.LineVertical(x,y1,y2,::ColorToARGB(m_border_color));
  }
//+------------------------------------------------------------------+
//| Изменить ширину по правому краю формы                            |
//+------------------------------------------------------------------+
void CTreeView::ChangeWidthByRightWindowSide(void)
  {
//--- Выйти, если включен режим фиксации к правому краю формы
   if(m_anchor_right_window_side)
      return;
//--- Координаты и ширина
   int x=0,w=0;
//--- Размеры
   int x_size =m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset;
   int y_size =(m_auto_yresize_mode)? m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset : m_y_size;
//--- Установить новый размер
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,y_size);
//--- Если без списка содержания
   if(!m_show_item_content)
     {
      //--- Рассчитаем и установим ширину для пунктов в списке
      w=(m_scrollv.IsScroll())? CElementBase::XSize()-m_scrollv.ScrollWidth()-3 : CElementBase::XSize()-2;
      //---
      int v=(m_scrollv.IsScroll())? m_scrollv.CurrentPos() : 0;
      //--- Получим количество отображаемых пунктов в списке содержания
      int total=::ArraySize(m_td_list_index);
      for(int r=0; r<m_visible_items_total; r++)
        {
         //--- Проверка для предотвращения выхода из диапазона
         if(v>=0 && v<total)
           {
            //--- Получим общий индекс пункта древовидного списка
            int li=m_td_list_index[v];
            //--- Установить координаты и ширину
            m_items[li].UpdateWidth(w);
            m_items[li].Draw();
            v++;
           }
        }
     }
//--- Если есть список содержания
   else
     {
      w=(m_content_scrollv.IsScroll())? m_x_size-m_treeview_width-m_content_scrollv.ScrollWidth()-2 : m_x_size-m_treeview_width-2;
      //---
      int v=(m_content_scrollv.IsScroll())? m_content_scrollv.CurrentPos() : 0;
      //--- Получим количество отображаемых пунктов в списке содержания
      int total=::ArraySize(m_cd_list_index);
      for(int r=0; r<m_visible_items_total; r++)
        {
         //--- Проверка для предотвращения выхода из диапазона
         if(v>=0 && v<total)
           {
            //--- Получим общий индекс пункта древовидного списка
            int li=m_cd_list_index[v];
            //--- Установить координаты и ширину
            m_content_items[li].UpdateWidth(w);
            m_content_items[li].Draw();
            v++;
           }
        }
     }
//--- Перерисовать элемент
   Draw();
  }
//+------------------------------------------------------------------+
