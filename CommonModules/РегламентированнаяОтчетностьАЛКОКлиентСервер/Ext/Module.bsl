﻿
////////////////////////////////////////////////////////////////////////////////
// Модуль содержит общие процедуры и функции регламентированных отчетов ФСРАР
////////////////////////////////////////////////////////////////////////////////


Функция ПолучитьИндексСтраницыРегистра(Форма, ИдГруппы, ИндексСтраницы) Экспорт
	
	СервисРегистровГруппы = Форма["СервисРегистров" + ИдГруппы];	 
	
	Возврат СервисРегистровГруппы[ИндексСтраницы].ИндексСтраницыРегистра;

КонецФункции


Процедура УвеличитьКоличествоСтрокПоТекущейСтранице(Форма, ТекущийИдГруппы, ИндексСтраницы, КоличествоСтрок) Экспорт
	
	СервисРегистровГруппы = Форма["СервисРегистров" + ТекущийИдГруппы];	
	СервисРегистровГруппы[ИндексСтраницы].КоличествоСтрок = СервисРегистровГруппы[ИндексСтраницы].КоличествоСтрок + 1;	
	КоличествоСтрок = СервисРегистровГруппы[ИндексСтраницы].КоличествоСтрок;
	
КонецПроцедуры


Процедура ИзменитьКоличествоПомеченныхНаУдалениеСтрокПоТекущейСтранице(
												Форма, ТекущийИдГруппы, ИндексСтраницы, Дельта) Экспорт
	
	СервисРегистровГруппы = Форма["СервисРегистров" + ТекущийИдГруппы];
	СервисРегистровГруппы[ИндексСтраницы].КолвоСтрокПомНаУдаление = СервисРегистровГруппы[ИндексСтраницы].КолвоСтрокПомНаУдаление + Дельта;
		
КонецПроцедуры


Функция ПолучитьКоличествоСтрокПоСтраницеГруппы(Форма, ИдГруппы, ИндексСтраницы, БезПомеченныхНаУдаление = Ложь) Экспорт
	
	КоличествоСтрокНаСтранице = 0;
	
	СервисРегистровГруппы = Форма["СервисРегистров" + ИдГруппы];
	
	Если БезПомеченныхНаУдаление Тогда	
		Возврат СервисРегистровГруппы[ИндексСтраницы].КоличествоСтрок - СервисРегистровГруппы[ИндексСтраницы].КолвоСтрокПомНаУдаление;
	Иначе
		Возврат СервисРегистровГруппы[ИндексСтраницы].КоличествоСтрок;	
	КонецЕсли; 
	
КонецФункции


Функция ПолучитьКоличествоСтрокПоГруппе(Форма, ИдГруппы, БезПомеченныхНаУдаление = Ложь)
	
	КолСтрокПоГруппе = 0;
				
	СервисРегистров = Форма["СервисРегистров" + ИдГруппы];
	КолСтраницПоГруппе = СервисРегистров.Количество();
	Для Инд = 0 По КолСтраницПоГруппе - 1 Цикл
	    		
		КоличествоСтрокНастранице = ПолучитьКоличествоСтрокПоСтраницеГруппы(Форма, ИдГруппы, Инд, БезПомеченныхНаУдаление);
		
		КолСтрокПоГруппе = КолСтрокПоГруппе + КоличествоСтрокНастранице;
		
	КонецЦикла;
	
	Возврат КолСтрокПоГруппе;
	
КонецФункции


Функция ПолучитьОбщееКоличествоСтрок(Форма, БезПомеченныхНаУдаление = Ложь) Экспорт
	
	КолСтрокПоВсемРазделам = 0;
	
	Для каждого ЭлементСтруктуры Из Форма.мСтруктураМногострочныхРазделов Цикл
	
		ИдГруппы = ЭлементСтруктуры.Ключ;
	    КолСтрокПоВсемРазделам = КолСтрокПоВсемРазделам + ПолучитьКоличествоСтрокПоГруппе(Форма, ИдГруппы, БезПомеченныхНаУдаление);
		
	КонецЦикла; 
		
	Возврат КолСтрокПоВсемРазделам;

КонецФункции 


Функция ПолучитьИмяРегистраСведенийАЛКО(ИдГруппы, СтруктураРеквизитовФормы) Экспорт
	
	СоответствиеИдГруппыРегистр = СтруктураРеквизитовФормы.мСоответствиеИдГруппыРегистр;
							
	Возврат СоответствиеИдГруппыРегистр.Получить(ИдГруппы);
		
КонецФункции


Функция ПолучитьИдГруппыПоИмениРегистраАЛКО(ИмяРегистра, СтруктураРеквизитовФормы) Экспорт
	
	СоответствиеРегистрИдГруппы = СтруктураРеквизитовФормы.мСоответствиеРегистрИдГруппы;
							
	Возврат СоответствиеРегистрИдГруппы.Получить(ИмяРегистра);
	
КонецФункции

Функция ПолучитьТочныйИдГруппыПоРазделуАЛКО(Форма, Раздел) Экспорт

	СписокИдГруппРаздела = ПолучитьСписокИдГруппПоРазделуАЛКО(Раздел, Форма.СтруктураРеквизитовФормы);
														
	ИдГруппы = ПолучитьИдГруппыПоРазделуАЛКО(Раздел, Форма.СтруктураРеквизитовФормы);
								
	Если СписокИдГруппРаздела.Количество() > 1 Тогда
	 
		// Определяем по текущей странице группы страниц.
		ГруппаСтраницыТаблицРаздела = Форма.Элементы.Найти("СтраницыТаблиц" + Раздел);
		
		Если НЕ ГруппаСтраницыТаблицРаздела = Неопределено Тогда
			
			ТекущаяСтраницаГруппыСтраницТаблицРаздела = ГруппаСтраницыТаблицРаздела.ТекущаяСтраница;
			ИмяТекущейСтраницы = ТекущаяСтраницаГруппыСтраницТаблицРаздела.Имя;
			
			Для каждого ЭлементИдГруппы Из СписокИдГруппРаздела Цикл
			
				ИмяТаблицыФормы = ЭлементИдГруппы.Представление;
				Если СтрЗаменить(ИмяТекущейСтраницы, "СтраницаТаблицы", "") = ИмяТаблицыФормы Тогда
				
					ИдГруппы = ЭлементИдГруппы.Значение;
					Прервать;
				
				КонецЕсли; 
			
			КонецЦикла; 
										
		КонецЕсли; 
	
	КонецЕсли;
	
	Возврат ИдГруппы;

КонецФункции
 

Функция ПолучитьИдГруппыПоРазделуАЛКО(Раздел, СтруктураРеквизитовФормы) Экспорт
	
	СоответствиеРазделИдГруппы = СтруктураРеквизитовФормы.мСоответствиеРазделИдГруппы;
							
	Возврат СоответствиеРазделИдГруппы.Получить(Раздел);
		
КонецФункции


Функция ПолучитьСписокИдГруппПоРазделуАЛКО(Раздел, СтруктураРеквизитовФормы) Экспорт
	
	СтруктураИдГрупп = СтруктураРеквизитовФормы.мСтруктураИдГрупп;
	
	СписокИдГрупп = Неопределено;
	СтруктураИдГрупп.Свойство(Раздел, СписокИдГрупп);
	
	Возврат СписокИдГрупп;
		
КонецФункции


Функция ПолучитьРазделПоИдГруппыАЛКО(ИдГруппы, СтруктураРеквизитовФормы) Экспорт
	
	СоответствиеИдГруппыРаздел = СтруктураРеквизитовФормы.мСоответствиеИдГруппыРаздел;
							
	Возврат СоответствиеИдГруппыРаздел.Получить(ИдГруппы);
	
КонецФункции	


Функция ПолучитьСтруктуруИдГруппИменРегистровАЛКО(СтруктураРеквизитовФормы) Экспорт
	
	Результат = Новый Структура;
	
	СоответствиеИдГруппыРегистр = СтруктураРеквизитовФормы.мСоответствиеИдГруппыРегистр;
	
	Для каждого Элемент Из СоответствиеИдГруппыРегистр Цикл
	
		ИдГруппы 	= Элемент.Ключ;
		ИмяРегистра = Элемент.Значение;
		Раздел 		= ПолучитьРазделПоИдГруппыАЛКО(ИдГруппы, СтруктураРеквизитовФормы);
		
		Результат.Вставить(ИдГруппы, ИмяРегистра);
		Результат.Вставить(Раздел, ИмяРегистра);
	
	КонецЦикла; 
		
	Возврат Результат;
	
КонецФункции


Функция ПолучитьСписокИменРегистровАЛКО(СтруктураРеквизитовФормы) Экспорт
	
	СписокИмен = Новый СписокЗначений;
	
	СоответствиеИдГруппыРегистр = СтруктураРеквизитовФормы.мСоответствиеИдГруппыРегистр;
	
	Для каждого Элемент Из СоответствиеИдГруппыРегистр Цикл
	
		ИдГруппы 	= Элемент.Ключ;
		ИмяРегистра = Элемент.Значение;
				
		СписокИмен.Добавить(ИмяРегистра);
		
	КонецЦикла;
		
	Возврат СписокИмен;
	
КонецФункции


Функция СформироватьОбособленноеПодразделениеАЛКО(СведенияОбОП, ЭтоПБОЮЛ, ОрганизацияИНН) Экспорт

   ВыводитьРеквизиты = (НЕ ПустаяСтрока(СведенияОбОП.Наименование)	                 
	                ИЛИ НЕ (ЭтоПБОЮЛ  или ПустаяСтрока(СведенияОбОП.КПП))
	                ИЛИ НЕ ПустаяСтрока( СтрЗаменить(СведенияОбОП.ПредставлениеАдреса, ",", "") ) );
	
	Если ВыводитьРеквизиты Тогда
		НаименованиеОП = "";
		Если НЕ ПустаяСтрока(СведенияОбОП.Наименование) Тогда
			НаименованиеОП = СведенияОбОП.Наименование;
		КонецЕсли;
				
		Если НЕ ( ЭтоПБОЮЛ  или ПустаяСтрока(ОрганизацияИНН) или (ОрганизацияИНН = "Заполнить") ) Тогда
			НаименованиеОП = НаименованиеОП + ?(ПустаяСтрока(НаименованиеОП), "", ", ") + "ИНН " + ОрганизацияИНН;
		КонецЕсли;
		
		Если НЕ (ЭтоПБОЮЛ  или ПустаяСтрока(СведенияОбОП.КПП)) Тогда		
			НаименованиеОП = НаименованиеОП + ?(ПустаяСтрока(НаименованиеОП), "", ", ") + "КПП " + СведенияОбОП.КПП;					
		КонецЕсли; 
		
		Если НЕ ПустаяСтрока( СтрЗаменить(СведенияОбОП.ПредставлениеАдреса, ",", "") ) Тогда
			НаименованиеОП = НаименованиеОП + 
						?(ПустаяСтрока(НаименованиеОП), "", Символы.ПС) + СведенияОбОП.ПредставлениеАдреса;
		КонецЕсли;
	Иначе		
		НаименованиеОП = "";
	КонецЕсли;

	НаименованиеОП = ?(НаименованиеОП = "", "Заполнить", НаименованиеОП);
	
	Возврат НаименованиеОП;

КонецФункции  


Функция ПолучитьКодКвартала(ПоказателиТитульногоЛиста) Экспорт
	
	Если НЕ ПустаяСтрока(ПоказателиТитульногоЛиста.ОтчетныйПериод1Кв) Тогда		
		Возврат "3";		
	ИначеЕсли НЕ ПустаяСтрока(ПоказателиТитульногоЛиста.ОтчетныйПериод2Кв) Тогда		
		Возврат "6";		
	ИначеЕсли НЕ ПустаяСтрока(ПоказателиТитульногоЛиста.ОтчетныйПериод3Кв) Тогда		
		Возврат "9";		
	ИначеЕсли НЕ ПустаяСтрока(ПоказателиТитульногоЛиста.ОтчетныйПериод4Кв) Тогда
		Возврат "0";		
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции


Функция СтрЗначениеПоКлючуСтруктуры(Ключ, Структура) Экспорт
	
	Значение = Неопределено;
	
	Если Структура.Свойство(Ключ, Значение) Тогда 
		Возврат Строка(Значение);
	КонецЕсли;
	
	Возврат "";
	
КонецФункции


Процедура ДополнитьПредставлениеАдресаАЛКО(Дополнение, СтрокаКонкатенации, Представление) Экспорт
	
	Если Дополнение <> "" Тогда
		Представление = Представление + СтрокаКонкатенации + Дополнение;
	КонецЕсли;
	
КонецПроцедуры


Функция ИнициализацияЗаголовкаАЛКО(Заголовок, ИмяФормы, СтруктураРеквизитовФормы) Экспорт

	Если СтрНайти(Заголовок, СтруктураРеквизитовФормы.СтрПериодОтчета) = 0 Тогда
		Заголовок = Заголовок + " за " + СтруктураРеквизитовФормы.СтрПериодОтчета;
	КонецЕсли;
	
	ОргСтр = " (" + СтруктураРеквизитовФормы.НаимОрганизации + ")";
	Если СтрНайти(Заголовок, ОргСтр) = 0 Тогда
		Заголовок = Заголовок + ОргСтр;
	КонецЕсли;
	
	Заголовок = Заголовок + ?(СтрНайти(ИмяФормы, "Внешний") > 0, " - внешний отчет", "");
	
	Возврат Заголовок;
	
КонецФункции


Процедура ПоказатьПериодАЛКО(СтруктураРеквизитовФормы, СтруктураДанныхТитульный, 
							ПринудительноЗаполнить = Ложь) Экспорт

	СтруктураРеквизитовФормы.СтрПериодОтчета = ПредставлениеПериода( НачалоДня(СтруктураРеквизитовФормы.мДатаНачалаПериодаОтчета), КонецДня(СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета), "ФП = Истина" );
    
	Если (НЕ ПринудительноЗаполнить) И (СтруктураРеквизитовФормы.мДокументВосстановлен) 
		И (СтруктураРеквизитовФормы.мСкопированаФорма = Неопределено) Тогда
		
		Возврат;
		
	КонецЕсли;
    
	НомерМесяца   = Формат(СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета, "ДФ=М");
	НомерКвартала = Формат(СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета, "ДФ=к");
	НомерГода     = Формат(СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета, "ДФ=гггг");

	// Отображение на титульном листе отчетного периода.
	Значение1Кв = ?(НомерКвартала = "1", "V", "");
	СтруктураДанныхТитульный.Вставить("ОтчетныйПериод1Кв", Значение1Кв);
	
	Значение2Кв = ?(НомерКвартала = "2", "V", "");
	СтруктураДанныхТитульный.Вставить("ОтчетныйПериод2Кв", Значение2Кв);
		
	Значение3Кв = ?(НомерКвартала = "3", "V", "");
	СтруктураДанныхТитульный.Вставить("ОтчетныйПериод3Кв", Значение3Кв);
		
	Значение4Кв = ?(НомерКвартала = "4", "V", "");
	СтруктураДанныхТитульный.Вставить("ОтчетныйПериод4Кв", Значение4Кв);
		
	СтруктураДанныхТитульный.Вставить("ОтчетныйГод", НомерГода);
	    
КонецПроцедуры


Процедура СформироватьДеревоРазделовОтчетаАЛКО(Форма) Экспорт
	
	Форма["РазделыОтчета"].ПолучитьЭлементы().Очистить();
	
	Для Каждого ЭлементДереваСтраницОтчета Из Форма["мДеревоСтраницОтчета"].ПолучитьЭлементы() Цикл
		
		Если ЭлементДереваСтраницОтчета.ПоказатьСтраницу = 1 Тогда
			
			ЭлементРазделовОтчета = Форма["РазделыОтчета"].ПолучитьЭлементы().Добавить();
			ЭлементРазделовОтчета.КолонкаРазделыОтчета         = ЭлементДереваСтраницОтчета.Представление;
			ЭлементРазделовОтчета.КолонкаРазделыОтчетаСокрНаим = ЭлементДереваСтраницОтчета.ИмяСтраницы;
			ЭлементРазделовОтчета.ИндексКартинки               = 1;
			ЭлементРазделовОтчета.РазделМногостраничный        = Ложь;
			ЭлементРазделовОтчета.РазделМногострочный          = Ложь;
			
			НайденноеЗначение = Неопределено;
			
			Если Форма["мСтруктураМногостраничныхРазделов"].Свойство(ЭлементРазделовОтчета.КолонкаРазделыОтчетаСокрНаим, НайденноеЗначение) Тогда
				
				Если НЕ НайденноеЗначение = Неопределено Тогда
					
					НайденноеЗначение = Форма[НайденноеЗначение];
					
					ЭлементРазделовОтчета.ИндексКартинки        = 0;
					ЭлементРазделовОтчета.РазделМногостраничный = Истина;
					
					Для НомерСтраницы = 1 По НайденноеЗначение.Количество() Цикл
						
						СтраницаРазделаОтчета = ЭлементРазделовОтчета.ПолучитьЭлементы().Добавить();
						
						СтраницаРазделаОтчета.КолонкаРазделыОтчета              = "Стр. " + НомерСтраницы;
						СтраницаРазделаОтчета.КолонкаРазделыОтчетаСокрНаим      = ЭлементРазделовОтчета.КолонкаРазделыОтчетаСокрНаим;
						СтраницаРазделаОтчета.КолонкаНомерСтраницыРазделаОтчета = НомерСтраницы;
						СтраницаРазделаОтчета.ИндексКартинки                    = 1;
						СтраницаРазделаОтчета.РазделМногостраничный             = ЭлементРазделовОтчета.РазделМногостраничный;
						СтраницаРазделаОтчета.РазделМногострочный               = ЭлементРазделовОтчета.РазделМногострочный;
						
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЕсли;
				
		КонецЕсли;
				
	КонецЦикла;
			
КонецПроцедуры


Процедура ВосстановитьСведенияОбОрганизацииИзТитульногоЛистаСтарогоОбразцаАЛКО(
						ПоказателиОтчета, СтруктураДанныхТитульный, СтруктураРеквизитовФормы, ЭтоПБОЮЛ) Экспорт
		
	ПоказателиТаблПоле = ПоказателиОтчета["ПолеТабличногоДокументаТитульный"];
		
	Для Каждого Показатель Из ПоказателиТаблПоле Цикл
		
		ИмяПоказателя = Показатель.Ключ;
		
		Если ИмяПоказателя = "ИНН1_1" Тогда
			СтруктураДанныхТитульный.Вставить("ИНН1");
			Для Ном = 1 По 12 Цикл
				СтруктураДанныхТитульный.ИНН1 = СокрЛП(СтруктураДанныхТитульный.ИНН1) + ПоказателиТаблПоле["ИНН1_" + Ном];
				СтруктураДанныхТитульный.Удалить("ИНН1_" + Ном);
			КонецЦикла;
			Если Лев(СтруктураДанныхТитульный.ИНН1, 2) = "00" Тогда
				СтруктураДанныхТитульный.ИНН1 = Сред(СтруктураДанныхТитульный.ИНН1, 3);
			КонецЕсли;
		ИначеЕсли ИмяПоказателя = "КПП1_1" Тогда
			СтруктураДанныхТитульный.Вставить("КПП1");
			Для Ном = 1 По 9 Цикл
				СтруктураДанныхТитульный.КПП1 = СокрЛП(СтруктураДанныхТитульный.КПП1) + ПоказателиТаблПоле["КПП1_" + Ном];
				СтруктураДанныхТитульный.Удалить("КПП1_" + Ном);
			КонецЦикла;
		ИначеЕсли ИмяПоказателя = "ОтчетныйГод1" Тогда
			СтруктураДанныхТитульный.Вставить("ОтчетныйГод");
			Для Ном = 1 По 4 Цикл
				СтруктураДанныхТитульный.ОтчетныйГод = СокрЛП(СтруктураДанныхТитульный.ОтчетныйГод) + ПоказателиТаблПоле["ОтчетныйГод" + Ном];
				СтруктураДанныхТитульный.Удалить("ОтчетныйГод" + Ном);
			КонецЦикла;
		ИначеЕсли ИмяПоказателя = "НомКорр1" Тогда
			СтруктураДанныхТитульный.Вставить("НомКорр");
			Для Ном = 1 По 2 Цикл
				СтруктураДанныхТитульный.НомКорр = СокрЛП(СтруктураДанныхТитульный.НомКорр) + ПоказателиТаблПоле["НомКорр" + Ном];
				СтруктураДанныхТитульный.Удалить("НомКорр" + Ном);
			КонецЦикла;
		ИначеЕсли ИмяПоказателя = "ПочтовыйИндекс1" Тогда
			СтруктураДанныхТитульный.Вставить("ПочтовыйИндекс");
			Для Ном = 1 По 6 Цикл
				СтруктураДанныхТитульный.ПочтовыйИндекс = СокрЛП(СтруктураДанныхТитульный.ПочтовыйИндекс) + ПоказателиТаблПоле["ПочтовыйИндекс" + Ном];
				СтруктураДанныхТитульный.Удалить("ПочтовыйИндекс" + Ном);
			КонецЦикла;
		ИначеЕсли ИмяПоказателя = "КодРегиона1" Тогда
			СтруктураДанныхТитульный.Вставить("КодРегиона");
			Для Ном = 1 По 2 Цикл
				СтруктураДанныхТитульный.КодРегиона = СокрЛП(СтруктураДанныхТитульный.КодРегиона) + ПоказателиТаблПоле["КодРегиона" + Ном];
				СтруктураДанныхТитульный.Удалить("КодРегиона" + Ном);
			КонецЦикла;
		ИначеЕсли ИмяПоказателя = "Прил1" Тогда
			СтруктураДанныхТитульный.Вставить("Прил");
			Для Ном = 1 По 3 Цикл
				СтруктураДанныхТитульный.Прил = СокрЛП(СтруктураДанныхТитульный.Прил) + ПоказателиТаблПоле["Прил" + Ном];
				СтруктураДанныхТитульный.Удалить("Прил" + Ном);
			КонецЦикла;
				
		КонецЕсли;
		
	КонецЦикла;
		
	СтруктураДанныхТитульный.Вставить("ЭтоПБОЮЛ", ЭтоПБОЮЛ);
	
	СтруктураРеквизитовФормы.Руководитель = Неопределено;
	ПоказателиТаблПоле.Свойство("ОргДиректор", СтруктураРеквизитовФормы.Руководитель);
	СтруктураРеквизитовФормы.Руководитель = ?(СтруктураРеквизитовФормы.Руководитель = Неопределено, "", СтруктураРеквизитовФормы.Руководитель);
	СтруктураДанныхТитульный.Вставить("ОргДиректор", СтруктураРеквизитовФормы.Руководитель);
	
	СтруктураРеквизитовФормы.Бухгалтер = Неопределено;
	ПоказателиТаблПоле.Свойство("ОргБухгалтер", СтруктураРеквизитовФормы.Бухгалтер);
	СтруктураРеквизитовФормы.Бухгалтер = ?(СтруктураРеквизитовФормы.Бухгалтер = Неопределено, "", СтруктураРеквизитовФормы.Бухгалтер);
	СтруктураДанныхТитульный.Вставить("ОргБухгалтер", СтруктураРеквизитовФормы.Бухгалтер);
	
	СтруктураРеквизитовФормы.ТелОрганизации = Неопределено;
	ПоказателиТаблПоле.Свойство("ТелОрганизации", СтруктураРеквизитовФормы.ТелОрганизации);
	СтруктураРеквизитовФормы.ТелОрганизации = ?(СтруктураРеквизитовФормы.ТелОрганизации = Неопределено, "", СтруктураРеквизитовФормы.ТелОрганизации);
	СтруктураДанныхТитульный.Вставить("ТелОрганизации", СтруктураРеквизитовФормы.ТелОрганизации);
	
КонецПроцедуры

