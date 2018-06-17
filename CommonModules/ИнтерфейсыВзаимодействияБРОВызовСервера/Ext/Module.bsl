﻿////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции интерфейсов взаимодействия БРО
// с другими библиотеками/конфигурациями.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Предназначена для получения сведений об уполномоченном представителе организации в налоговом органе.
// Параметры:
//	 РегистрацияВНалоговомОргане - СправочникСсылка.РегистрацииВНалоговомОргане - должно быть непустым значением.
//	 ДатаПодписи - дата - дата, по состоянию на которую будут читаться данные представителя-физлица.
//
// Возвращаемое значение: 
//   Структура - структура с полями: 
//	   * ТипПодписанта - строка со значениями "1", "2";
//	   * ПредставительЮрЛицо - Булево - признак представителя юр. лица; 
//	   * НаименованиеОрганизацииПредставителя - Строка - наименование организации представителя;
//	   * ДокументПредставителя - Строка - документ представителя;
//	   * Фамилия - Строка - фамилия;
//	   * Имя - Строка - имя;
//	   * Отчество - Строка - отчество;
//	   * ФИОПредставителя - Строка - ФИО представителя.
//
Функция СведенияОПредставителеПоРегистрацииВНалоговомОргане(РегистрацияВНалоговомОргане, ДатаПодписи) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ТипПодписанта", "1");
	Результат.Вставить("ПредставительЮрЛицо", Истина);
	Результат.Вставить("НаименованиеОрганизацииПредставителя", "");
	Результат.Вставить("ДокументПредставителя", "");
	Результат.Вставить("Фамилия", "");
	Результат.Вставить("Имя", "");
	Результат.Вставить("Отчество", "");
	Результат.Вставить("ФИОПредставителя", "");

	Если НЕ ЗначениеЗаполнено(РегистрацияВНалоговомОргане) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ДанныеРегистрации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегистрацияВНалоговомОргане, "Представитель, УполномоченноеЛицоПредставителя, ДокументПредставителя");
	
	Если НЕ ЗначениеЗаполнено(ДанныеРегистрации.Представитель) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Представитель = ДанныеРегистрации.Представитель;
	Результат.Вставить("ТипПодписанта", "2");
	
	Если НЕ РегламентированнаяОтчетность.ПредставительЯвляетсяФизЛицом(Представитель) Тогда
		
		ИмяПоля = ?(Представитель.Метаданные().Реквизиты.Найти("НаименованиеПолное") <> Неопределено, "НаименованиеПолное", "Наименование");
		Результат.Вставить("НаименованиеОрганизацииПредставителя", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Представитель, ИмяПоля));
		Результат.Вставить("ФИОПредставителя", СокрЛП(ДанныеРегистрации.УполномоченноеЛицоПредставителя));
		СтрокиФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ДанныеРегистрации.УполномоченноеЛицоПредставителя, " ");
		
		Если СтрокиФИО.Количество() > 0 Тогда
			
			Результат.Фамилия = СокрЛП(СтрокиФИО[0]);
			
			Если СтрокиФИО.Количество() > 1 Тогда
				
				Результат.Имя = СокрЛП(СтрокиФИО[1]);
				
				Если СтрокиФИО.Количество() > 2 Тогда
					
					Для ИндСтроки = 2 По СтрокиФИО.ВГраница() Цикл
						Результат.Отчество = Результат.Отчество + ?(ЗначениеЗаполнено(Результат.Отчество), " ", "") + СтрокиФИО[ИндСтроки]
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Результат.Вставить("ПредставительЮрЛицо", Ложь);
		ЗаполнитьЗначенияСвойств(Результат, РегламентированнаяОтчетность.ПолучитьФИОФизЛица(Представитель, ДатаПодписи));
		Результат.Вставить("ФИОПредставителя", СокрЛП(СокрЛП(Результат.Фамилия) + " " + СокрЛП(Результат.Имя) + " " + СокрЛП(Результат.Отчество)));
		
	КонецЕсли;
	
	Результат.Вставить("ДокументПредставителя", ДанныеРегистрации.ДокументПредставителя);
	
	Возврат Результат;
	
КонецФункции

// Возвращает дату подключения учетной записи документооборота для организации или наименьшую дату одобрения заявления.
Функция ДатаПодключения1СОтчетности(Организация) Экспорт
	
	Результат = Неопределено;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Организация,
			"ВидОбменаСКонтролирующимиОрганами, УчетнаяЗаписьОбмена");
		
		Если РеквизитыОрганизации.ВидОбменаСКонтролирующимиОрганами <> Перечисления.ВидыОбменаСКонтролирующимиОрганами.ОбменВУниверсальномФормате
			ИЛИ НЕ ЗначениеЗаполнено(РеквизитыОрганизации.УчетнаяЗаписьОбмена) Тогда
			
			Возврат Неопределено;
		КонецЕсли;
		
		Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			РеквизитыОрганизации.УчетнаяЗаписьОбмена,
			"ДатаПодключения");
		
		ДатаПодключенияИзЗаявления = Неопределено;
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ДатаПолученияОтвета КАК ДатаПолученияОтвета
			|ИЗ
			|	Документ.ЗаявлениеАбонентаСпецоператораСвязи КАК ЗаявлениеАбонентаСпецоператораСвязи
			|ГДЕ
			|	ЗаявлениеАбонентаСпецоператораСвязи.Организация = &Организация
			|	И ЗаявлениеАбонентаСпецоператораСвязи.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Одобрено)
			|	И ЗаявлениеАбонентаСпецоператораСвязи.НастройкаЗавершена
			|	И НЕ ЗаявлениеАбонентаСпецоператораСвязи.ПометкаУдаления
			|УПОРЯДОЧИТЬ ПО
			|	ЗаявлениеАбонентаСпецоператораСвязи.ДатаПолученияОтвета");
		Запрос.УстановитьПараметр("Организация", Организация);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ДатаПодключенияИзЗаявления = Выборка.ДатаПолученияОтвета;
			
			Если НЕ ЗначениеЗаполнено(Результат)
			ИЛИ (ЗначениеЗаполнено(ДатаПодключенияИзЗаявления) И ДатаПодключенияИзЗаявления < Результат) Тогда
				Результат = ДатаПодключенияИзЗаявления;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти



#Область СлужебныеПроцедурыИФункции

#Область ЗапросВФНСНаПроверкуСведенийРаботников

Функция СформироватьФайлЗапросаВФНСНаПроверкуСведенийРаботников(СтруктураПараметров) Экспорт
	
	ПолучитьДанныеДляЗапросаВФНСНаПроверкуСведенийРаботников(СтруктураПараметров);
	
	Если НЕ СтруктураПараметров.Свойство("СведенияОРаботниках") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НЕ СтруктураПараметров.Свойство("ДатаПодписи") Тогда
		СтруктураПараметров.Вставить("ДатаПодписи", ТекущаяДатаСеанса());
	КонецЕсли;
	
	ИмяФайлаЗапроса = "";
	
	ТекстXML = ТекстФайлаЗапросаВФНСНаПроверкуСведенийРаботников(СтруктураПараметров, ИмяФайлаЗапроса);
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ТекстXML);
	ТекстовыйДокумент.Записать(ИмяВременногоФайла);
	
	ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяВременногоФайла);
	АдресФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
	
	УдалитьФайлы(ИмяВременногоФайла);
	
	Результат = Новый Структура();
	Результат.Вставить("ПолучаемыеФайлы", Новый Массив);
	Результат.ПолучаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ИмяФайлаЗапроса + ".xml", АдресФайла));
	
	Возврат Результат;
	
КонецФункции

Процедура ПолучитьДанныеДляЗапросаВФНСНаПроверкуСведенийРаботников(СтруктураПараметров)
	
	Если СтруктураПараметров.Свойство("РасчетПоСтраховымВзносам") Тогда
		
		СохраненныйДокумент = СтруктураПараметров.РасчетПоСтраховымВзносам.ПолучитьОбъект();
		СохраненныеДанные = СохраненныйДокумент.ДанныеОтчета.Получить();
		
		ДанныеТитульного = СохраненныеДанные.ПоказателиОтчета.ПолеТабличногоДокументаТитульный;
		
		Если СохраненныеДанные.Свойство("ОкружениеСохранения") Тогда
			
			// Случай данных отчета, сохраненного в 2.0.
			
		Иначе
			
			СтруктураПараметров.Вставить("СведенияОРаботниках", СохраненныеДанные.ДанныеМногоуровневыхРазделов.Раздел3);
			СтруктураПараметров.Вставить("КодНалоговогоОргана", СокрЛП(ДанныеТитульного.НалоговыйОрган));
			СтруктураПараметров.Вставить("ИНН", СокрЛП(ДанныеТитульного.ИНН));
			СтруктураПараметров.Вставить("КПП", СокрЛП(ДанныеТитульного.КПП));
			
		КонецЕсли;
		
	ИначеЕсли СтруктураПараметров.Свойство("Организация") Тогда
		
		РегламентированнаяОтчетностьПереопределяемый.ПолучитьДанныеДляЗапросаВФНСНаПроверкуСведенийРаботников(
		СтруктураПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ТекстФайлаЗапросаВФНСНаПроверкуСведенийРаботников(СтруктураПараметров, ИмяФайлаЗапроса)
	
	СведенияОРаботниках = СтруктураПараметров.СведенияОРаботниках;
	
	Если ТипЗнч(СведенияОРаботниках) = Тип("ДеревоЗначений") Тогда
		СведенияОРаботниках = СведенияОРаботниках.Строки;
		ИмяПок_ИННФЛ          = "П000310006001";
		ИмяПок_СНИЛС          = "П000310007001";
		ИмяПок_Фамилия        = "П000310008001";
		ИмяПок_Имя            = "П000310009001";
		ИмяПок_Отчество       = "П000310010001";
		ИмяПок_ДатаРожд       = "П000310011001";
		ИмяПок_КодВидДок      = "П000310014001";
		ИмяПок_СерияДокумента = "П000310015001";
		ИмяПок_НомерДокумента = "П000310015002";
	Иначе
		ИмяПок_Фамилия        = "Фамилия";
		ИмяПок_Имя            = "Имя";
		ИмяПок_Отчество       = "Отчество";
		ИмяПок_ИННФЛ          = "ИНН";
		ИмяПок_СНИЛС          = "СтраховойНомерПФР";
		ИмяПок_ДатаРожд       = "ДатаРождения";
		ИмяПок_КодВидДок      = "ВидДокумента";
		ИмяПок_СерияДокумента = "СерияДокумента";
		ИмяПок_НомерДокумента = "НомерДокумента";
	КонецЕсли;
	
	КодНалоговогоОргана = СокрЛП(СтруктураПараметров.КодНалоговогоОргана);
	ДатаПодписи = СтруктураПараметров.ДатаПодписи;
	ИНН = СокрЛП(СтруктураПараметров.ИНН);
	КПП = СокрЛП(СтруктураПараметров.КПП);
	
	ИмяФайлаЗапроса = "VO_ZAPRRAB"
	+ "_" + КодНалоговогоОргана
	+ "_" + (ИНН + КПП)
	+ "_" + Формат(ДатаПодписи, "ДФ=ггггММдд")
	+ "_" + Новый УникальныйИдентификатор();
	
	ДеревоФорматаXML = ПолучитьОбщийМакет("ФорматЗапросаВФНСНаПроверкуСведенийРаботников401");
	ТекстФорматаXML = ДеревоФорматаXML.ПолучитьТекст();
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстФорматаXML);
	
	ПостроительDOM = Новый ПостроительDOM;
	ДеревоФормата = ПостроительDOM.Прочитать(ЧтениеXML);
	
	ДеревоВыгрузки = Новый ДеревоЗначений;
	ДеревоВыгрузки.Колонки.Добавить("Имя",      Новый ОписаниеТипов("Строка"));
	ДеревоВыгрузки.Колонки.Добавить("Значение", Новый ОписаниеТипов("Строка"));
	
	Атрибуты = Новый Соответствие;
	Атрибуты.Вставить("ИдФайл", ИмяФайлаЗапроса);
	Атрибуты.Вставить("ВерсФорм", "4.01");
	Атрибуты.Вставить("ТипИнф", "ЗАПР_ПРОВ_РАБ");
	Атрибуты.Вставить("ВерсПрог", РегламентированнаяОтчетность.НазваниеИВерсияПрограммы());
	
	УзелСправки = ДобавитьУзелВДеревоXML(ДеревоВыгрузки, "Файл", "", Атрибуты);
	
	ФорматНабораЗаписейФизЛицо = ЗагрузитьФорматНабораЗаписей(ДеревоФормата, "ПолучДох");
	
	Для каждого СтрокаСведений Из СведенияОРаботниках Цикл
		
		СведенияОРаботнике
		= ?(ТипЗнч(СтрокаСведений) = Тип("СтрокаДереваЗначений"), СтрокаСведений.Данные, СтрокаСведений);
		
		НаборЗаписейФизЛицо = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(ФорматНабораЗаписейФизЛицо);
		
		НаборЗаписейФизЛицо.ФИО.Значение.Фамилия = СведенияОРаботнике[ИмяПок_Фамилия];
		НаборЗаписейФизЛицо.ФИО.Значение.Имя = СведенияОРаботнике[ИмяПок_Имя];
		НаборЗаписейФизЛицо.ФИО.Значение.Отчество = СведенияОРаботнике[ИмяПок_Отчество];
		
		Если НЕ ЗначениеЗаполнено(СведенияОРаботнике[ИмяПок_ИННФЛ]) Тогда
			НаборЗаписейФизЛицо.Удалить("ИННФЛ");
		Иначе
			НаборЗаписейФизЛицо.ИННФЛ.Значение = СведенияОРаботнике[ИмяПок_ИННФЛ];
		КонецЕсли;
		
		НаборЗаписейФизЛицо.СНИЛС.Значение = СведенияОРаботнике[ИмяПок_СНИЛС];
		
		НаборЗаписейФизЛицо.ДатаРожд.Значение = СведенияОРаботнике[ИмяПок_ДатаРожд];
		
		Если НЕ ЗначениеЗаполнено(СокрЛП(СведенияОРаботнике[ИмяПок_КодВидДок]
			+ СведенияОРаботнике[ИмяПок_СерияДокумента]
			+ СведенияОРаботнике[ИмяПок_НомерДокумента])) Тогда
			НаборЗаписейФизЛицо.Удалить("УдЛичнФЛ");
		Иначе
			НаборЗаписейДокУдЛичности = НаборЗаписейФизЛицо.УдЛичнФЛ.Значение;
			НаборЗаписейДокУдЛичности.КодВидДок = СведенияОРаботнике[ИмяПок_КодВидДок];
			НаборЗаписейДокУдЛичности.СерНомДок
			= СокрЛП(СведенияОРаботнике[ИмяПок_СерияДокумента]) + " "
			+ СокрЛП(СведенияОРаботнике[ИмяПок_НомерДокумента]);
		КонецЕсли;
		
		Атрибуты = ДанныеВыгружаемыеКакАтрибуты(НаборЗаписейФизЛицо);
		УзелФЛ = ДобавитьУзелВДеревоXML(УзелСправки, "СвРаб", "", Атрибуты);
		ДобавитьИнформациюВДерево(УзелФЛ, НаборЗаписейФизЛицо);
		
	КонецЦикла;
	
	СтруктураПараметров.Удалить("СведенияОРаботниках");
	
	ПотокВыгрузкиXML = РегламентированнаяОтчетность.СоздатьНовыйПотокXML();
	ЗаписатьУзелДереваВXML(ДеревоВыгрузки, ПотокВыгрузкиXML, "xsi", "http://www.w3.org/2001/XMLSchema-instance");
	СтрокаXML = ПотокВыгрузкиXML.Закрыть();
	
	Возврат СтрокаXML;
	
КонецФункции

Функция ДобавитьУзелВДеревоXML(Ветка, Имя, Значение, СписокАтрибутов = Неопределено, ТипДанных = "", ЗначениеЗаписи = Неопределено)
	
	ПустаяДата = Дата(1,1,1);
	
	НовыйУзел = Ветка.Строки.Добавить();
	НовыйУзел.Имя = Имя;
	НовыйУзел.Значение = Значение;
	
	Если СписокАтрибутов <> Неопределено Тогда
		ВеткаАтрибутов = НовыйУзел.Строки.Добавить();
		ВеткаАтрибутов.Имя = "АтрибутыXMLУзла";
		ВеткаАтрибутов.Значение = Неопределено;
		
		Для Каждого ЭлементСпискаАтрибутов Из СписокАтрибутов Цикл
			ЛистАтрибутов = ВеткаАтрибутов.Строки.Добавить();
			ЛистАтрибутов.Имя = ЭлементСпискаАтрибутов.Ключ;
			
			ЛистАтрибутов.Значение = Строка(ЭлементСпискаАтрибутов.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТипДанных = "СТРОКА" И ЗначениеЗаписи <> Неопределено Тогда
		ЗначениеЗаписи = "";
	ИначеЕсли ТипДанных = "ЧИСЛО" И ЗначениеЗаписи <> Неопределено Тогда
		Если ТипЗнч(ЗначениеЗаписи) = Тип("Число") Тогда
			ЗначениеЗаписи = 0;
		Иначе
			ЗначениеЗаписи = "";
		КонецЕсли;
	ИначеЕсли ТипДанных = "ДАТА" И ЗначениеЗаписи <> Неопределено Тогда
		ЗначениеЗаписи = ПустаяДата;
	КонецЕсли;
	
	Возврат НовыйУзел;
	
КонецФункции

Функция ЗагрузитьФорматНабораЗаписей(Знач ДеревоФормата, Знач ИмяНабораЗаписей, НомерВыбираемогоЭлемента = 1)
	ФорматНабора = Новый Структура();
	
	УзлыФормата = ДеревоФормата.ДочерниеУзлы[0].ПолучитьЭлементыПоИмени(ИмяНабораЗаписей)[0].ДочерниеУзлы;
	
	Для Каждого УзелФормата Из УзлыФормата Цикл
		
		Если ТипЗнч(УзелФормата) <> Тип("ЭлементDOM") Тогда
			Продолжить;
		КонецЕсли;
		
		ФорматЗаписи = Новый Структура("ТипДанных, Размер, РазрядностьДробнойЧасти, Поля, Значение, ЭлементНеОбязателен, ТипЭлемента, НеВыводитьВФайл");
		
		// Имя записи хранится в 4 колонке.
		ИмяЗаписи =  УзелФормата.ДочерниеУзлы[3].ТекстовоеСодержимое;
		
		// Тип данных хранится во 2 колонке.
		ТипДанных = ВРег(УзелФормата.ДочерниеУзлы[1].ТекстовоеСодержимое);
		
		// Признак обязательности элемента хранится в 5-й колонке.
		ЭлементНеОбязателен = (ВРег(УзелФормата.ДочерниеУзлы[4].ТекстовоеСодержимое) = "НЕ ОБЯЗАТЕЛЬНО" Или ВРег(УзелФормата.ДочерниеУзлы[4].ТекстовоеСодержимое) = "Н");
		
		Если УзелФормата.ДочерниеУзлы.Количество() = 7 И УзелФормата.ДочерниеУзлы[6].ИмяУзла = "ТипЭлемента" Тогда
			ТипЭлемента = ВРег(УзелФормата.ДочерниеУзлы[6].ТекстовоеСодержимое);
		Иначе
			ТипЭлемента = "С";
		КонецЕсли;
		
		Если ТипДанных = "" Тогда// если тип данных не задан, то встретили строку - группировку
			Продолжить;
		КонецЕсли; 
		
		ПозицияРазделителя = СтрНайти(ТипДанных,"/");
		Если ПозицияРазделителя <> 0 Тогда
			ТипДанных = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТипДанных, "/")[НомерВыбираемогоЭлемента-1];
		КонецЕсли;
		
		ПозицияРазделителя = СтрНайти(ИмяЗаписи,"/");
		Если ПозицияРазделителя <> 0 Тогда
			ИмяЗаписи = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяЗаписи, "/")[НомерВыбираемогоЭлемента-1];
		КонецЕсли;
		
		ФорматЗаписи.ТипДанных =  ТипДанных;
		ФорматЗаписи.ЭлементНеОбязателен = ЭлементНеОбязателен;
		ФорматЗаписи.ТипЭлемента = ТипЭлемента;
		ФорматЗаписи.НеВыводитьВФайл = Ложь;
		// Размер хранится в 3 колонке.
		СтрРазмерПоля =  УзелФормата.ДочерниеУзлы[2].ТекстовоеСодержимое;
		
		Если ФорматЗаписи.ТипДанных = "КОНСТАНТА" Тогда
			
			// В колонке "размер" должно указываться значение константы.
			ФорматЗаписи.Значение = СтрРазмерПоля;
			
		ИначеЕсли ФорматЗаписи.ТипДанных = "ЧИСЛО" Тогда
			
			ПозицияТочки = СтрНайти(СтрРазмерПоля,".");
			Если ПозицияТочки<>0 Тогда
				ФорматЗаписи.Размер = Число(Лев(СтрРазмерПоля,ПозицияТочки-1));
				ФорматЗаписи.РазрядностьДробнойЧасти = Число(Сред(СтрРазмерПоля,ПозицияТочки+1));
			Иначе	
				ФорматЗаписи.Размер = Число(СтрРазмерПоля);
				ФорматЗаписи.РазрядностьДробнойЧасти = 0;
			КонецЕсли;
			
			ФорматЗаписи.Значение = 0;
			
		ИначеЕсли ФорматЗаписи.ТипДанных = "СТРОКА" Тогда
			
			ФорматЗаписи.Размер = Число(СтрРазмерПоля);
			
			ФорматЗаписи.Значение = "";
			
		ИначеЕсли ФорматЗаписи.ТипДанных = "ДАТА" Тогда
			
			ФорматЗаписи.Значение = Дата('00010101');
			
		ИначеЕсли ФорматЗаписи.ТипДанных = "ТАБЛИЦА" Тогда
			
			// Имя области-описания формата полей таблицы или структуры хранится в колонке размер.
			ФорматЗаписи.Поля = ПолучитьФорматЗаписиИзДереваФормата(ДеревоФормата, СтрРазмерПоля);
			ФорматЗаписи.Значение = Новый ТаблицаЗначений;
			
			Для каждого Поле Из ФорматЗаписи.Поля Цикл
				
				Если Поле.ТипДанных = "ТАБЛИЦА" Тогда
					ФорматЗаписи.Значение.Колонки.Добавить(Поле.ИмяПоля);
				Иначе	
					Если Поле.ТипДанных = "ЧИСЛО" Тогда
						ОписаниеТиповПоля = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(Поле.Размер, Поле.РазрядностьДробнойЧасти));
					ИначеЕсли Поле.ТипДанных = "СТРОКА" Тогда
						ОписаниеТиповПоля = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(Поле.Размер));
					ИначеЕсли Поле.ТипДанных = "ДАТА" Тогда
						ОписаниеТиповПоля = Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата));
					КонецЕсли; 
					ФорматЗаписи.Значение.Колонки.Добавить(Поле.ИмяПоля, ОписаниеТиповПоля);
				КонецЕсли;
				
			КонецЦикла;
			
		ИначеЕсли ФорматЗаписи.ТипДанных = "СТРУКТУРА" Тогда
			
			ПозицияРазделителя = СтрНайти(ИмяЗаписи,"/");
			Если ПозицияРазделителя <> 0 Тогда
				ИмяЗаписи = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяЗаписи, "/")[НомерВыбираемогоЭлемента-1]
			КонецЕсли;
			ПозицияРазделителя = СтрНайти(СтрРазмерПоля,"/");
			Если ПозицияРазделителя <> 0 Тогда
				СтрРазмерПоля = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрРазмерПоля, "/")[НомерВыбираемогоЭлемента-1]
			КонецЕсли;
			
			// Имя области-описания формата полей таблицы или структуры хранится в колонке размер.
			ФорматЗаписи.Поля = ПолучитьФорматЗаписиИзДереваФормата(ДеревоФормата, СтрРазмерПоля);
			ФорматЗаписи.Значение = Новый Структура;
			Для каждого Поле Из ФорматЗаписи.Поля Цикл
				
				ПустоеЗначениеПоля = Неопределено;
				Если Поле.ТипДанных = "ЧИСЛО" Тогда
					ПустоеЗначениеПоля = 0;
				ИначеЕсли Поле.ТипДанных = "ДАТА" Тогда
					ПустоеЗначениеПоля = Дата('00010101');
				Иначе
					ПустоеЗначениеПоля = "";
				КонецЕсли; 
				
				ФорматЗаписи.Значение.Вставить(Поле.ИмяПоля, ПустоеЗначениеПоля);
				
			КонецЦикла; 
			
		ИначеЕсли ФорматЗаписи.ТипДанных = "НАБОРЗАПИСЕЙ" Тогда
			
			// Имя набора записей хранится в третьей колонке.
			ИмяНабора = УзелФормата.ДочерниеУзлы[2].ТекстовоеСодержимое;
			ПозицияРазделителя = СтрНайти(ИмяНабора,"/");
			Если ПозицияРазделителя <> 0 Тогда
				ИмяНабора = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяНабора, "/")[НомерВыбираемогоЭлемента-1]
			КонецЕсли;
			ПозицияРазделителя = СтрНайти(ИмяЗаписи,"/");
			Если ПозицияРазделителя <> 0 Тогда
				ИмяЗаписи = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяЗаписи, "/")[НомерВыбираемогоЭлемента-1]
			КонецЕсли;
			ФорматЗаписи.Значение = ЗагрузитьФорматНабораЗаписей(ДеревоФормата, ИмяНабора, НомерВыбираемогоЭлемента);
			
		КонецЕсли;
		
		ФорматНабора.Вставить(ИмяЗаписи, ФорматЗаписи);
		
	КонецЦикла;
	
	Возврат ФорматНабора;
	
КонецФункции

Функция ПолучитьФорматЗаписиИзДереваФормата(Знач ДеревоФормата, Знач ИмяЗаписи)
	
	ТаблицаФормаЗаписи = Новый ТаблицаЗначений;
	ТаблицаФормаЗаписи.Колонки.Добавить("ИмяПоля",					Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(100)));
	ТаблицаФормаЗаписи.Колонки.Добавить("ТипДанных",				Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(10)));
	ТаблицаФормаЗаписи.Колонки.Добавить("ТипЭлемента",				Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(10)));
	ТаблицаФормаЗаписи.Колонки.Добавить("Размер",					Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(5)));
	ТаблицаФормаЗаписи.Колонки.Добавить("РазрядностьДробнойЧасти",	Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(5)));
	ТаблицаФормаЗаписи.Колонки.Добавить("ЭлементНеОбязателен", Новый ОписаниеТипов("Булево"));
	ТаблицаФормаЗаписи.Колонки.Добавить("НеВыводитьВФайл", Новый ОписаниеТипов("Булево"));
	
	УзлыФормата = ДеревоФормата.ДочерниеУзлы[0].ПолучитьЭлементыПоИмени(ИмяЗаписи)[0].ДочерниеУзлы;
	
	Для Каждого УзелФормата Из УзлыФормата Цикл
		
		Если ТипЗнч(УзелФормата) <> Тип("ЭлементDOM") Тогда
			Продолжить;
		КонецЕсли;
		
		// Имя поля хранится в 4-ой колонке.
		ИмяПоля = УзелФормата.ДочерниеУзлы[3].ТекстовоеСодержимое;
		Если ИмяПоля <> "" Тогда
			
			НовоеПоле = ТаблицаФормаЗаписи.Добавить();
			НовоеПоле.ИмяПоля = СокрЛП(ИмяПоля);
			// Тип данных хранится во 2-ой колонке.
			НовоеПоле.ТипДанных = ВРег(УзелФормата.ДочерниеУзлы[1].ТекстовоеСодержимое);
			
			НовоеПоле.НеВыводитьВФайл = Ложь;
			
			Если УзелФормата.ДочерниеУзлы.Количество() = 7 И УзелФормата.ДочерниеУзлы[6].ИмяУзла = "ТипЭлемента" Тогда
				НовоеПоле.ТипЭлемента = ВРег(УзелФормата.ДочерниеУзлы[6].ТекстовоеСодержимое);
			Иначе
				НовоеПоле.ТипЭлемента = "С";
			КонецЕсли;
			
			// Размер поля хранится в 3-ей колонке.
			СтрРазмерПоля = УзелФормата.ДочерниеУзлы[2].ТекстовоеСодержимое;
			// Если указан размер поля, сохраним его.
			Если (НовоеПоле.ТипДанных = "ЧИСЛО" Или НовоеПоле.ТипДанных = "СТРОКА") И СтрРазмерПоля <> "" Тогда
				ПозицияТочки = СтрНайти(СтрРазмерПоля,".");
				Если ПозицияТочки<>0 Тогда
					НовоеПоле.Размер = Число(Лев(СтрРазмерПоля,ПозицияТочки-1));
					НовоеПоле.РазрядностьДробнойЧасти = Число(Сред(СтрРазмерПоля,ПозицияТочки+1));
				Иначе
					НовоеПоле.Размер = Число(СтрРазмерПоля);
					НовоеПоле.РазрядностьДробнойЧасти = 0;
				КонецЕсли;
			КонецЕсли;
			// Признак обязательности элемента хранится в 5-й колонке.
			НовоеПоле.ЭлементНеОбязателен = (ВРег(УзелФормата.ДочерниеУзлы[4].ТекстовоеСодержимое) = "НЕ ОБЯЗАТЕЛЬНО" Или ВРег(УзелФормата.ДочерниеУзлы[4].ТекстовоеСодержимое) = "Н");
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТаблицаФормаЗаписи;
КонецФункции

Функция ДанныеВыгружаемыеКакАтрибуты(СтруктураДанных)
	
	Атрибуты = Новый Структура;
	Для каждого Поле Из СтруктураДанных Цикл
		Если Поле.Значение.ТипЭлемента = "А" Тогда
			Данные = Поле.Значение.Значение;
			Если Поле.Значение.ТипДанных = "ЧИСЛО" Тогда
				Данные = Формат(Данные,"ЧЦ=" + Поле.Значение.Размер + "; ЧДЦ=" + Поле.Значение.РазрядностьДробнойЧасти + "; ЧРД=.; ЧН=; ЧГ=0")
			ИначеЕсли Поле.Значение.ТипДанных = "ДАТА" Тогда
				Если Не ЗначениеЗаполнено(Данные) Тогда
					Данные = ""
				Иначе
					Данные = Формат(Данные,"ДЛФ=D");
				КонецЕсли;
			КонецЕсли;
			Атрибуты.Вставить(Поле.Ключ, Данные);
			СтруктураДанных.Удалить(Поле.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Атрибуты
	
КонецФункции

Процедура ДобавитьИнформациюВДерево(ДеревоВыгрузки, НаборЗаписей)
	
	ПустаяДата = Дата(1,1,1);
	
	Для каждого ЭлементНабора Из НаборЗаписей Цикл
		ИмяЗаписи = ЭлементНабора.Ключ;
		
		Запись = ЭлементНабора.Значение;
		
		Если Запись.НеВыводитьВФайл Тогда 
			Запись.НеВыводитьВФайл = Ложь;
			Продолжить;
		КонецЕсли;
		
		ТипДанных = Запись.ТипДанных;
		Если ТипДанных = "КОНСТАНТА" Тогда
			
			ДобавитьУзелВДеревоXML(ДеревоВыгрузки, ИмяЗаписи, Запись.Значение, , ТипДанных, Запись.Значение);
			
		ИначеЕсли ТипДанных = "ЧИСЛО" Тогда
			
			// для проверок
			// Запись.Размер 
			// Запись.РазрядностьДробнойЧасти
			ДобавитьУзелВДеревоXML(ДеревоВыгрузки, ИмяЗаписи, Формат(Запись.Значение,"ЧЦ=" + Запись.Размер + "; ЧДЦ=" + Запись.РазрядностьДробнойЧасти + "; ЧРД=.; ЧН=; ЧГ=0"), , ТипДанных, Запись.Значение);
			Запись.НеВыводитьВФайл = Ложь;
		ИначеЕсли ТипДанных = "СТРОКА" Тогда
			
			// для проверок
			// Запись.Размер 
			
			ДобавитьУзелВДеревоXML(ДеревоВыгрузки, ИмяЗаписи, Запись.Значение, ,ТипДанных, Запись.Значение);
			
		ИначеЕсли ТипДанных = "ДАТА" Тогда
			
			ДобавитьУзелВДеревоXML(ДеревоВыгрузки, ИмяЗаписи, ?(Запись.Значение = ПустаяДата,"00.00.0000", Формат(Запись.Значение,"ДФ=dd.MM.yyyy")), ,ТипДанных, Запись.Значение);
			
		ИначеЕсли ТипДанных = "ТАБЛИЦА" Тогда	
			
			ПроверятьНеобязательныеПоля = Ложь;
			Для каждого Поле Из Запись.Поля Цикл
				ПроверятьНеобязательныеПоля = Поле.ЭлементНеОбязателен;
				Если ПроверятьНеобязательныеПоля Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла; 
			
			Для каждого СтрокаТЗ Из Запись.Значение Цикл
				
				ВыводитьНеобязательныеПоля = Ложь;
				Если ПроверятьНеобязательныеПоля Тогда
					Для каждого Поле Из Запись.Поля Цикл
						Если Поле.ЭлементНеОбязателен Тогда
							ВыводитьНеобязательныеПоля = ЗначениеЗаполнено(СтрокаТЗ[Поле.ИмяПоля]);
							Если ВыводитьНеобязательныеПоля Тогда
								Прервать;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				
				Атрибуты = Новый Структура;
				Для каждого Поле Из Запись.Поля Цикл
					
					Если Поле.ЭлементНеОбязателен И Не ВыводитьНеобязательныеПоля Тогда
						Продолжить;
					КонецЕсли;
					
					Данные = СтрокаТЗ[Поле.ИмяПоля];
					
					Если Поле.ТипДанных = "ЧИСЛО" Тогда
						Данные = Формат(Данные,"ЧЦ=" + Поле.Размер + "; ЧДЦ=" + Поле.РазрядностьДробнойЧасти + "; ЧРД=.; ЧН=; ЧГ=0")
					ИначеЕсли Поле.ТипДанных = "ДАТА" Тогда
						Если Не ЗначениеЗаполнено(Данные) Тогда
							Данные = ""
						Иначе
							Данные = Формат(Данные,"ДФ=dd.MM.yyyy");
						КонецЕсли;
					КонецЕсли;
					
					Если Поле.ТипЭлемента = "А" И НЕ Поле.НеВыводитьВФайл Тогда
						Атрибуты.Вставить(Поле.ИмяПоля, Данные);
					КонецЕсли;
					
				КонецЦикла;
				
				ВеткаСтрокиТЗ = ДобавитьУзелВДеревоXML(ДеревоВыгрузки, ИмяЗаписи, "", Атрибуты);
				
				Для каждого Поле Из Запись.Поля Цикл
					
					Если Поле.ТипЭлемента = "А" Тогда
						Поле.НеВыводитьВФайл = Ложь;
						Продолжить;
					КонецЕсли;
					
					Если Поле.НеВыводитьВФайл Тогда
						Поле.НеВыводитьВФайл = Ложь;
						Продолжить;
					КонецЕсли;
					
					Если Поле.ЭлементНеОбязателен И Не ВыводитьНеобязательныеПоля Тогда
						Продолжить;
					КонецЕсли;
					
					ДобавитьИнформациюВДерево(ВеткаСтрокиТЗ, СтрокаТЗ[Поле.ИмяПоля])
					
				КонецЦикла;
				
			КонецЦикла;
			
		ИначеЕсли ТипДанных = "СТРУКТУРА" Тогда
			МассивДанных = Новый Массив;
			Атрибуты = Новый Структура;
			Для каждого Поле Из Запись.Поля Цикл
				
				Данные = Запись.Значение[Поле.ИмяПоля];
				
				Если Поле.ЭлементНеОбязателен И Не ЗначениеЗаполнено(Данные) Тогда
					Продолжить;
				КонецЕсли;
				
				ПустоеЗначение = "";
				Если Поле.ТипДанных = "ЧИСЛО" Тогда
					Если ТипЗнч(Данные) = Тип("Число") Тогда
						ПустоеЗначение = 0;	
					КонецЕсли;
					Данные = Формат(Данные,"ЧЦ=" + Поле.Размер + "; ЧДЦ=" + Поле.РазрядностьДробнойЧасти + "; ЧРД=.; ЧН=; ЧГ=0");
				ИначеЕсли Поле.ТипДанных = "ДАТА" Тогда
					Если Не ЗначениеЗаполнено(Данные) Тогда
						Данные = ""
					Иначе
						Данные = Формат(Данные,"ДФ=dd.MM.yyyy");
						ПустоеЗначение = '00010101';
					КонецЕсли;
				КонецЕсли;
				
				Если Поле.ТипЭлемента = "А" И НЕ Поле.НеВыводитьВФайл  Тогда
					Атрибуты.Вставить(Поле.ИмяПоля, Данные);
				ИначеЕсли НЕ Поле.НеВыводитьВФайл Тогда 
					СтруктураДанных = Новый Структура;
					СтруктураДанных.Вставить("ИмяПоля", Поле.ИмяПоля);
					СтруктураДанных.Вставить("Значение", Запись.Значение[Поле.ИмяПоля]);
					СтруктураДанных.Вставить("Данные", Данные);
					СтруктураДанных.Вставить("ТипДанных", Поле.ТипДанных);
					МассивДанных.Добавить(СтруктураДанных);
				КонецЕсли;
				Поле.НеВыводитьВФайл = Ложь;
				Запись.Значение[Поле.ИмяПоля] = ПустоеЗначение;
			КонецЦикла; 
				
			ВеткаСтруктуры = ДобавитьУзелВДеревоXML(ДеревоВыгрузки, ИмяЗаписи, "", Атрибуты);
			
			Для Каждого Поле Из МассивДанных Цикл
				ДобавитьУзелВДеревоXML(ВеткаСтруктуры, Поле.ИмяПоля, Поле.Данные, ,Поле.ТипДанных, Поле.Данные);
			КонецЦикла;
			
		ИначеЕсли ТипДанных = "НАБОРЗАПИСЕЙ" Тогда
			
			Значение = Запись.Значение;
			
			Атрибуты = Новый Структура;
			Для каждого Поле Из Значение Цикл
				Если Поле.Значение.ТипЭлемента = "А" И НЕ Поле.Значение.НеВыводитьВФайл  Тогда
					Данные = Поле.Значение.Значение;
					Если Поле.Значение.ТипДанных = "ЧИСЛО" Тогда
						Данные = Формат(Данные,"ЧЦ=" + Поле.Значение.Размер + "; ЧДЦ=" + Поле.Значение.РазрядностьДробнойЧасти + "; ЧРД=.; ЧН=; ЧГ=0")
					ИначеЕсли Поле.Значение.ТипДанных = "ДАТА" Тогда
						Если Не ЗначениеЗаполнено(Данные) Тогда
							Данные = ""
						Иначе
							Данные = Формат(Данные,"ДФ=dd.MM.yyyy");
						КонецЕсли;
					КонецЕсли;
					Атрибуты.Вставить(Поле.Ключ, Данные);
					Значение.Удалить(Поле.Ключ);
				КонецЕсли;
			КонецЦикла;
			
			ДобавитьИнформациюВДерево(ДобавитьУзелВДеревоXML(ДеревоВыгрузки, ИмяЗаписи, "", Атрибуты), Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаписатьУзелДереваВXML(СтрокаДерева, ПотокXML, ПрефиксПространстваИмен = Неопределено, URIПространстваИмен = Неопределено)
	
	Если ТипЗнч(СтрокаДерева) = Тип("СтрокаДереваЗначений") Тогда
		
		Если НЕ ПустаяСтрока(СтрокаДерева.Имя) Тогда
			ПотокXML.ЗаписатьНачалоЭлемента(СтрокаДерева.Имя);	
			Если ПрефиксПространстваИмен <> Неопределено И URIПространстваИмен <> Неопределено Тогда
				ПотокXML.ЗаписатьСоответствиеПространстваИмен(ПрефиксПространстваИмен, URIПространстваИмен);
			КонецЕсли;
			СписокАтрибутов = СтрокаДерева.Строки.Найти("АтрибутыXMLУзла", "Имя", Ложь);
			
			Если СписокАтрибутов <> Неопределено Тогда
				Для каждого СтрокаСАтрибутом Из СписокАтрибутов.Строки Цикл
					ПотокXML.ЗаписатьАтрибут(СтрокаСАтрибутом.Имя, СтрокаСАтрибутом.Значение);
				КонецЦикла;
			КонецЕсли;
			
			ПотокXML.ЗаписатьТекст(?(СтрокаДерева.Значение = "00.00.0000", "", СтрокаДерева.Значение));
			
		КонецЕсли;
		
	КонецЕсли;
	
	Для каждого Лист Из СтрокаДерева.Строки Цикл
		Если Лист.Имя = "АтрибутыXMLУзла" Тогда
			Продолжить;
		КонецЕсли;
		ЗаписатьУзелДереваВXML(Лист, ПотокXML, ПрефиксПространстваИмен, URIПространстваИмен);
	КонецЦикла;
	
	Если ТипЗнч(СтрокаДерева) = Тип("СтрокаДереваЗначений") Тогда
		Если НЕ ПустаяСтрока(СтрокаДерева.Имя) Тогда
			ПотокXML.ЗаписатьКонецЭлемента();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти