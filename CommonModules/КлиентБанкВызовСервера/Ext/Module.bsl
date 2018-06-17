﻿// Загружает настройки формы.
// Если загрузка настроек осуществляется при изменении реквизита формы,
// например, для новой организации, то обязательно проверить подлючено ли 
// расширение для работы с файлами.
//
// Признаком отсутствия подключения будит информация в реквизитах объекта обработки:
// ФайлВыгрузки, ФайлЗагрузки
//
Процедура ЗагрузитьНастройкиОбменаСБанком(БанковскийСчет, СтруктураПрямогоОбмена) Экспорт
	
	Настройки = ХранилищеСистемныхНастроек.Загрузить("Обработка.КлиентБанк.Форма.ОсновнаяФорма/" + ?(ЗначениеЗаполнено(БанковскийСчет), ПолучитьНавигационнуюСсылку(БанковскийСчет), "БанковскийСчетНеУказан"), "ВыгрузкаВСбербанк");
	
	Если Настройки <> Неопределено Тогда
		СтруктураПрямогоОбмена.Вставить("ФайлВыгрузки", Настройки.Получить("ФайлВыгрузки"));
		СтруктураПрямогоОбмена.Вставить("ФайлЗагрузки", Настройки.Получить("ФайлЗагрузки"));
		СтруктураПрямогоОбмена.Вставить("Программа", Настройки.Получить("Программа"));
		СтруктураПрямогоОбмена.Вставить("СтатьяДДСИсходящий", Настройки.Получить("СтатьяДДСИсходящий"));
		СтруктураПрямогоОбмена.Вставить("СтатьяДДСВходящий", Настройки.Получить("СтатьяДДСВходящий"));
		СтруктураПрямогоОбмена.Вставить("ПроводитьЗагружаемые", Настройки.Получить("ПроводитьЗагружаемые"));
		Если Настройки.Получить("ЗаполнятьДолгиАвтоматически") = Неопределено Тогда
			СтруктураПрямогоОбмена.Вставить("ЗаполнятьДолгиАвтоматически", Истина);
		Иначе
			СтруктураПрямогоОбмена.Вставить("ЗаполнятьДолгиАвтоматически", Настройки.Получить("ЗаполнятьДолгиАвтоматически"));
		КонецЕсли;
		СтруктураПрямогоОбмена.Вставить("Кодировка", Настройки.Получить("Кодировка"));
		Если НЕ ЗначениеЗаполнено(СтруктураПрямогоОбмена.Кодировка) Тогда
			СтруктураПрямогоОбмена.Вставить("Кодировка", "Windows");
		КонецЕсли;
		СтруктураПрямогоОбмена.Вставить("ВерсияФормата", Настройки.Получить("ВерсияФормата"));
		Если НЕ ЗначениеЗаполнено(СтруктураПрямогоОбмена.ВерсияФормата) Тогда
			СтруктураПрямогоОбмена.Вставить("ВерсияФормата", "1.02");
		КонецЕсли;
		Если Настройки.Получить("АвтоматическиПодставлятьДокументы") = Неопределено Тогда
			СтруктураПрямогоОбмена.Вставить("АвтоматическиПодставлятьДокументы", Истина);
		Иначе
			СтруктураПрямогоОбмена.Вставить("АвтоматическиПодставлятьДокументы", Настройки.Получить("АвтоматическиПодставлятьДокументы"));
		КонецЕсли;
		Если Настройки.Получить("НеУдалятьДокументыКоторыхНетВВыписке") = Неопределено Тогда
			СтруктураПрямогоОбмена.Вставить("НеУдалятьДокументыКоторыхНетВВыписке", Ложь);
		Иначе
			СтруктураПрямогоОбмена.Вставить("НеУдалятьДокументыКоторыхНетВВыписке", Настройки.Получить("НеУдалятьДокументыКоторыхНетВВыписке"));
		КонецЕсли;
		Если Настройки.Получить("АнализироватьИсториюВыбораЗначенийРеквизитов") = Неопределено Тогда
			СтруктураПрямогоОбмена.Вставить("АнализироватьИсториюВыбораЗначенийРеквизитов", Истина);
		Иначе
			СтруктураПрямогоОбмена.Вставить("АнализироватьИсториюВыбораЗначенийРеквизитов", Настройки.Получить("АнализироватьИсториюВыбораЗначенийРеквизитов"));
		КонецЕсли;
		Если Настройки.Получить("КонтролироватьБезопасностьОбменаСБанком") = Неопределено Тогда
			СтруктураПрямогоОбмена.Вставить("КонтролироватьБезопасностьОбменаСБанком", Истина);
		Иначе
			СтруктураПрямогоОбмена.Вставить("КонтролироватьБезопасностьОбменаСБанком", Настройки.Получить("КонтролироватьБезопасностьОбменаСБанком"));
		КонецЕсли;
	Иначе
		СтруктураПрямогоОбмена.Вставить("ФайлВыгрузки", "");
		СтруктураПрямогоОбмена.Вставить("ФайлЗагрузки", "");
		СтруктураПрямогоОбмена.Вставить("Программа", "");
		СтруктураПрямогоОбмена.Вставить("СтатьяДДСИсходящий", Справочники.СтатьиДвиженияДенежныхСредств.ОплатаПоставщикам);
		СтруктураПрямогоОбмена.Вставить("СтатьяДДСВходящий", Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателей);
		СтруктураПрямогоОбмена.Вставить("ПроводитьЗагружаемые", Ложь);
		СтруктураПрямогоОбмена.Вставить("ЗаполнятьДолгиАвтоматически", Истина);
		СтруктураПрямогоОбмена.Вставить("Кодировка", "Windows");
		СтруктураПрямогоОбмена.Вставить("ВерсияФормата", "1.02");
		СтруктураПрямогоОбмена.Вставить("АвтоматическиПодставлятьДокументы", Истина);
		СтруктураПрямогоОбмена.Вставить("НеУдалятьДокументыКоторыхНетВВыписке", Ложь);
		СтруктураПрямогоОбмена.Вставить("АнализироватьИсториюВыбораЗначенийРеквизитов", Истина);
		СтруктураПрямогоОбмена.Вставить("КонтролироватьБезопасностьОбменаСБанком", Истина);
	КонецЕсли;
	
КонецПроцедуры // ЗагрузитьНастройкиФормы()

// Загружает настройки формы.
// Если загрузка настроек осуществляется при изменении реквизита формы,
// например, для новой организации, то обязательно проверить подлючено ли 
// расширение для работы с файлами.
//
// Признаком отсутствия подключения будит информация в реквизитах объекта обработки:
// ФайлВыгрузки, ФайлЗагрузки
//
Процедура ЗагрузитьНастройкиОбменаСБанкомЧерезФайлы(БанковскийСчет, ДополнительныеПараметры) Экспорт
	
	Настройки = ХранилищеСистемныхНастроек.Загрузить("Обработка.КлиентБанк.Форма.ОсновнаяФорма/" + ?(ЗначениеЗаполнено(БанковскийСчет), ПолучитьНавигационнуюСсылку(БанковскийСчет), "БанковскийСчетНеУказан"), "ВыгрузкаВСбербанк");
	
	Если Настройки <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("ФайлВыгрузки", Настройки.Получить("ФайлВыгрузки"));
		ДополнительныеПараметры.Вставить("ФайлЗагрузки", Настройки.Получить("ФайлЗагрузки"));
		ДополнительныеПараметры.Вставить("Программа", Настройки.Получить("Программа"));
		ДополнительныеПараметры.Вставить("СтатьяДДСИсходящий", Настройки.Получить("СтатьяДДСИсходящий"));
		ДополнительныеПараметры.Вставить("СтатьяДДСВходящий", Настройки.Получить("СтатьяДДСВходящий"));
		ДополнительныеПараметры.Вставить("ПроводитьЗагружаемые", Настройки.Получить("ПроводитьЗагружаемые"));
		Если Настройки.Получить("ЗаполнятьДолгиАвтоматически") = Неопределено Тогда
			ДополнительныеПараметры.Вставить("ЗаполнятьДолгиАвтоматически", Истина);
		Иначе
			ДополнительныеПараметры.Вставить("ЗаполнятьДолгиАвтоматически", Настройки.Получить("ЗаполнятьДолгиАвтоматически"));
		КонецЕсли;
		ДополнительныеПараметры.Вставить("Кодировка", Настройки.Получить("Кодировка"));
		Если НЕ ЗначениеЗаполнено(ДополнительныеПараметры.Кодировка) Тогда
			ДополнительныеПараметры.Вставить("Кодировка", "Авто");
		КонецЕсли;
		ДополнительныеПараметры.Вставить("ВерсияФормата", Настройки.Получить("ВерсияФормата"));
		Если НЕ ЗначениеЗаполнено(ДополнительныеПараметры.ВерсияФормата) Тогда
			ДополнительныеПараметры.Вставить("ВерсияФормата", "1.02");
		КонецЕсли;
		Если Настройки.Получить("АвтоматическиПодставлятьДокументы") = Неопределено Тогда
			ДополнительныеПараметры.Вставить("АвтоматическиПодставлятьДокументы", Истина);
		Иначе
			ДополнительныеПараметры.Вставить("АвтоматическиПодставлятьДокументы", Настройки.Получить("АвтоматическиПодставлятьДокументы"));
		КонецЕсли;
		Если Настройки.Получить("НеУдалятьДокументыКоторыхНетВВыписке") = Неопределено Тогда
			ДополнительныеПараметры.Вставить("НеУдалятьДокументыКоторыхНетВВыписке", Ложь);
		Иначе
			ДополнительныеПараметры.Вставить("НеУдалятьДокументыКоторыхНетВВыписке", Настройки.Получить("НеУдалятьДокументыКоторыхНетВВыписке"));
		КонецЕсли;
		Если Настройки.Получить("АнализироватьИсториюВыбораЗначенийРеквизитов") = Неопределено Тогда
			ДополнительныеПараметры.Вставить("АнализироватьИсториюВыбораЗначенийРеквизитов", Истина);
		Иначе
			ДополнительныеПараметры.Вставить("АнализироватьИсториюВыбораЗначенийРеквизитов", Настройки.Получить("АнализироватьИсториюВыбораЗначенийРеквизитов"));
		КонецЕсли;
		Если Настройки.Получить("КонтролироватьБезопасностьОбменаСБанком") = Неопределено Тогда
			ДополнительныеПараметры.Вставить("КонтролироватьБезопасностьОбменаСБанком", Ложь);
		Иначе
			ДополнительныеПараметры.Вставить("КонтролироватьБезопасностьОбменаСБанком", Настройки.Получить("КонтролироватьБезопасностьОбменаСБанком"));
		КонецЕсли;
		
	Иначе
		ДополнительныеПараметры.Вставить("ФайлВыгрузки", "");
		ДополнительныеПараметры.Вставить("ФайлЗагрузки", "");
		ДополнительныеПараметры.Вставить("Программа", "");
		ДополнительныеПараметры.Вставить("СтатьяДДСИсходящий", Справочники.СтатьиДвиженияДенежныхСредств.ОплатаПоставщикам);
		ДополнительныеПараметры.Вставить("СтатьяДДСВходящий", Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателей);
		ДополнительныеПараметры.Вставить("ПроводитьЗагружаемые", Ложь);
		ДополнительныеПараметры.Вставить("ЗаполнятьДолгиАвтоматически", Истина);
		ДополнительныеПараметры.Вставить("Кодировка", "Авто");
		ДополнительныеПараметры.Вставить("ВерсияФормата", "1.02");
		ДополнительныеПараметры.Вставить("АвтоматическиПодставлятьДокументы", Истина);
		ДополнительныеПараметры.Вставить("НеУдалятьДокументыКоторыхНетВВыписке", Ложь);
		ДополнительныеПараметры.Вставить("АнализироватьИсториюВыбораЗначенийРеквизитов", Истина);
		ДополнительныеПараметры.Вставить("КонтролироватьБезопасностьОбменаСБанком", Истина);
	КонецЕсли;
	
КонецПроцедуры // ЗагрузитьНастройкиФормы()

Функция ПолучитьСтруктуруПрямогоОбмена() Экспорт
	
	СтруктураПрямогоОбмена = Новый Структура("БанковскийСчет, БанковскийСчетОрганизации, Организация, СоглашениеПрямогоОбменаСБанками");
	
	ИспользоватьОбменСБанками = ПолучитьФункциональнуюОпцию("ИспользоватьОбменСБанками");
	Если НЕ ИспользоватьОбменСБанками Тогда
		// Нет ни одной настройки обмена с банками, можно сразу выбирать файл загрузки.
		СтруктураПрямогоОбмена.Вставить("БанковскийСчет", Справочники.БанковскиеСчета.ПустаяСсылка());
	Иначе
		Запрос = Новый Запрос();
		Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиОбменСБанками.Ссылка КАК НастройкиОбменСБанками,
		|	НастройкиОбменСБанками.Банк,
		|	БанковскиеСчета.Ссылка,
		|	НастройкиОбменСБанками.Организация
		|ИЗ
		|	Справочник.БанковскиеСчета КАК БанковскиеСчета
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиОбменСБанками КАК НастройкиОбменСБанками
		|		ПО БанковскиеСчета.Банк = НастройкиОбменСБанками.Банк
		|			И БанковскиеСчета.Владелец = НастройкиОбменСБанками.Организация
		|ГДЕ
		|	НастройкиОбменСБанками.Недействительна = ЛОЖЬ
		|	И НЕ НастройкиОбменСБанками.ПометкаУдаления
		|	И НЕ БанковскиеСчета.ПометкаУдаления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ БанковскиеСчета.Ссылка) КАК КоличествоРазличных
		|ИЗ
		|	Справочник.БанковскиеСчета КАК БанковскиеСчета
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(БанковскиеСчета.Владелец) = ТИП(Справочник.Организации)
		|	И НЕ БанковскиеСчета.ПометкаУдаления";
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		РезультатЗапроса = МассивРезультатов[0];
		Если РезультатЗапроса.Пустой() Тогда // Нет ни одной настройки обмена с банками, можно сразу выбирать файл загрузки.
			СтруктураПрямогоОбмена.Вставить("БанковскийСчет", Справочники.БанковскиеСчета.ПустаяСсылка());
		Иначе
			Выборка = РезультатЗапроса.Выбрать();
			ВыборкаБанковскихСчетов = МассивРезультатов[1].Выбрать();
			ВыборкаБанковскихСчетов.Следующий();
			Если ВыборкаБанковскихСчетов.КоличествоРазличных = 1 Тогда // Один счет, можно сразу подставить его.
				Выборка.Следующий();
				СтруктураПрямогоОбмена.Вставить("БанковскийСчет", Выборка.Ссылка);
				СтруктураПрямогоОбмена.Вставить("Организация", Выборка.Организация);
				СтруктураПрямогоОбмена.Вставить("СоглашениеПрямогоОбменаСБанками", Выборка.НастройкиОбменСБанками);
				ЗагрузитьНастройкиОбменаСБанком(Выборка.Ссылка, СтруктураПрямогоОбмена);
			Иначе // Есть несколько счетов, нужно выбирать.
				СтруктураПрямогоОбмена.Вставить("БанковскийСчет", Неопределено);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СтруктураПрямогоОбмена.БанковскийСчетОрганизации = СтруктураПрямогоОбмена.БанковскийСчет;
	СтруктураПрямогоОбмена.Вставить("КонтролироватьБезопасностьОбменаСБанком", Истина);
	
	Возврат СтруктураПрямогоОбмена;
	
КонецФункции

Функция ПолучитьСтруктуруОбмена(ПараметрБанковскийСчет) Экспорт
	
	СтруктураОбмена = Новый Структура("ПрямойОбмен, БанковскийСчет, БанковскийСчетОрганизации, Организация, СоглашениеПрямогоОбменаСБанками", Ложь);
	
	ИспользоватьОбменСБанками = ПолучитьФункциональнуюОпцию("ИспользоватьОбменСБанками");
	Если НЕ ИспользоватьОбменСБанками Тогда
		// Нет ни одной настройки обмена с банками, можно сразу выбирать файл загрузки.
		СтруктураОбмена.Вставить("БанковскийСчет", ПараметрБанковскийСчет);
		СтруктураОбмена.Вставить("Организация", ПараметрБанковскийСчет.Владелец);
		ЗагрузитьНастройкиОбменаСБанком(ПараметрБанковскийСчет, СтруктураОбмена);
	Иначе
		Запрос = Новый Запрос();
		Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиОбменСБанками.Ссылка КАК НастройкиОбменСБанками,
		|	НастройкиОбменСБанками.Банк,
		|	БанковскиеСчета.Ссылка,
		|	НастройкиОбменСБанками.Организация
		|ИЗ
		|	Справочник.БанковскиеСчета КАК БанковскиеСчета
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиОбменСБанками КАК НастройкиОбменСБанками
		|		ПО БанковскиеСчета.Банк = НастройкиОбменСБанками.Банк
		|			И БанковскиеСчета.Владелец = НастройкиОбменСБанками.Организация
		|ГДЕ
		|	БанковскиеСчета.Ссылка = &ПараметрБанковскийСчет
		|	И НастройкиОбменСБанками.Недействительна = ЛОЖЬ
		|	И НЕ НастройкиОбменСБанками.ПометкаУдаления
		|	И НЕ БанковскиеСчета.ПометкаУдаления";
		
		Запрос.УстановитьПараметр("ПараметрБанковскийСчет", ПараметрБанковскийСчет);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда // Нет ни одной настройки обмена с банками, можно сразу выбирать файл загрузки.
			СтруктураОбмена.Вставить("БанковскийСчет", ПараметрБанковскийСчет);
			СтруктураОбмена.Вставить("Организация", ПараметрБанковскийСчет.Владелец);
			СтруктураОбмена.Вставить("ПрямойОбмен", Ложь);
			ЗагрузитьНастройкиОбменаСБанком(ПараметрБанковскийСчет, СтруктураОбмена);
		Иначе
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			СтруктураОбмена.Вставить("БанковскийСчет", Выборка.Ссылка);
			СтруктураОбмена.Вставить("Организация", Выборка.Организация);
			СтруктураОбмена.Вставить("СоглашениеПрямогоОбменаСБанками", Выборка.НастройкиОбменСБанками);
			СтруктураОбмена.Вставить("ПрямойОбмен", Истина);
			ЗагрузитьНастройкиОбменаСБанком(Выборка.Ссылка, СтруктураОбмена);
		КонецЕсли;
	КонецЕсли;
	
	СтруктураОбмена.БанковскийСчетОрганизации = СтруктураОбмена.БанковскийСчет;
	СтруктураОбмена.Вставить("КонтролироватьБезопасностьОбменаСБанком", Истина);
	
	Возврат СтруктураОбмена;
	
КонецФункции

#Область ПолучениеТекстаФайла

// Проверяет строку на соответствие требованиям
//
// Параметры:
//  ПроверяемаяСтрока - Строка - проверяемый строка.
//
// Возвращаемое значение:
//  Булево - Истина, если ошибок нет.
//
&НаСервере
Функция ТолькоСимволыВСтроке(Знач ПроверяемаяСтрока) Экспорт
	
	Если ПустаяСтрока(ПроверяемаяСтрока) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// приводим строку к нижнему регистру
	ПроверяемаяСтрока = НРег(СокрЛП(ПроверяемаяСтрока));
	
	// допустимые символы
	СпецСимволы = ".,;:$№#@&_-+*=?'/|\""%()[]{} ";
	
	// проверяем наличие спецсимволов в начале или конце строке
	Если ЕстьСимволыВНачалеСтроки(Лев(ПроверяемаяСтрока, 1), СпецСимволы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// проверяем допустимые символы
	Если НЕ СтрокаСодержитТолькоДопустимыеСимволы(ПроверяемаяСтрока, СпецСимволы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ЕстьСимволыВНачалеСтроки(Строка, ПроверяемыеСимволы)
	
	Для Позиция = 1 По СтрДлина(ПроверяемыеСимволы) Цикл
		Символ = Сред(ПроверяемыеСимволы, Позиция, 1);
		СимволНайден = СтрНачинаетсяС(Строка, Символ) ИЛИ СтрЗаканчиваетсяНа(Строка, Символ);
		Если СимволНайден Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция СтрокаСодержитТолькоДопустимыеСимволы(СтрокаПроверки, ДопустимыеСимволы)
	
	// Кириллица
	КодСимволаА = КодСимвола("а"); 
	КодСимволаЯ = КодСимвола("я");
	
	// Цифры
	КодСимвола0 = КодСимвола("0");
	КодСимвола9 = КодСимвола("9");
	
	// Латиница
	КодСимволаA = КодСимвола("a");
	КодСимволаZ = КодСимвола("z");
	
	// Спецсимволы
	КодыДопустимыхСимволов = Новый Массив;
	Для Индекс = 1 По СтрДлина(ДопустимыеСимволы) Цикл
		Символ = Сред(ДопустимыеСимволы, Индекс, 1);
		КодыДопустимыхСимволов.Добавить(КодСимвола(Символ));
	КонецЦикла;
	
	КодыДопустимыхСимволов.Добавить(1105); // "ё"
	
	// Проверяем каждым символ в строке
	// допустим ли он.
	Для Индекс = 1 По СтрДлина(СтрокаПроверки) Цикл
		КодПроверяемогоСимвола = КодСимвола(Сред(СтрокаПроверки, Индекс, 1));
		ЭтоДопустимыйСимвол = 
			КодСимволаА <= КодПроверяемогоСимвола И КодПроверяемогоСимвола <= КодСимволаЯ     // Кириллица
			ИЛИ КодСимволаA <= КодПроверяемогоСимвола И КодПроверяемогоСимвола <= КодСимволаZ // Латиница
			ИЛИ КодСимвола0 <= КодПроверяемогоСимвола И КодПроверяемогоСимвола <= КодСимвола9 // Цифры
			ИЛИ КодыДопустимыхСимволов.Найти(КодПроверяемогоСимвола) <> Неопределено;         // Спецсимволы и ё
			
		Если НЕ ЭтоДопустимыйСимвол Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Функция возвращает тип файла после прочтения первых 5 строк
// Определяем кодировку
&НаСервере
Функция ТипФайла(ИмяФайла)
	
	Текст              = Новый ЧтениеТекста(ИмяФайла, "windows-1251");
	СтрокаТекста       = Текст.ПрочитатьСтроку();
	НомерТекущейСтроки = 0;
	
	Пока СтрокаТекста <> Неопределено Цикл
		// Проверяем кодировку файла
		Если НомерТекущейСтроки = 0 И НЕ ТолькоСимволыВСтроке(СтрокаТекста) Тогда // UTF-8.
			Возврат "UTF-8";
			Прервать;
		ИначеЕсли НЕ ТолькоСимволыВСтроке(СтрокаТекста) Тогда
			Возврат "cp866";
			Прервать;
		КонецЕсли;
		// Читаем первые пять строк, этого должно быть достаточно,
		// чтобы определить кодировку
		Если НомерТекущейСтроки > 5 Тогда 
			Прервать;
		КонецЕсли;
		НомерТекущейСтроки = НомерТекущейСтроки + 1;
		СтрокаТекста       = Текст.ПрочитатьСтроку();
	КонецЦикла;
	
	Возврат "windows-1251";
	
КонецФункции

&НаСервере
Функция ПолучитьТекстФайла(ИмяФайла, Кодировка, ОдиночныйРазделительСтрок = Ложь) Экспорт
	
	Попытка
		
		// Тип файла передаем в виде строки, чтобы обеспечить корректное чтение файла в нелокализованных средах
		// (Linux, англоязычная Windows + англоязычный MS SQL и др.)
		Если Кодировка = Неопределено ИЛИ Кодировка = "Авто" Тогда
			ТипФайла = ТипФайла(ИмяФайла);
		ИначеЕсли (Кодировка = КодировкаТекста.OEM) ИЛИ (Кодировка = "DOS") Тогда
			ТипФайла = "cp866";
		ИначеЕсли Кодировка = "Windows" ИЛИ НЕ ЗначениеЗаполнено(Кодировка) Тогда
			ТипФайла = "windows-1251";
		Иначе
			ТипФайла = Кодировка;
		КонецЕсли;
		
		Если ТипФайла = "cp866" Тогда
			ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла, ТипФайла,,,Ложь);
		Иначе
			// Если в файле строки разделены CR+LF, то одиночные LF не разделяют логические строки файла, а содержится в прикладных данных.
			// При этом в отдельных полях (многострочных) они разделяют подстроки,
			// а в остальных, как правило, содержатся по ошибке и должны быть проигнорированы.
			//
			// Чтобы отличить ошибочные одиночные LF от корректных разделителей CR+LF,
			// при чтении файла используем только двухсимвольный разделитель (CR+LF),
			// а если необходимо избавиться от ошибочных LF (Символы.ПС), то делаем это после чтения строк (перед помещением данных в Секция.Данные).
			//
			// Если же в файле строки разделены одиночным LF, то отличить ошибочные LF от корректных нельзя.
			// Поэтому при чтении файла используем обычный набор разделителей. При этом ошибочно отделенные элементы строк могут быть проигнорированы.
			ДвухсимвольныйРазделительСтрок = Символы.ВК + Символы.ПС;
			Если ОдиночныйРазделительСтрок Тогда
				// Значения по умолчанию. В конструктор их следует передать явно, так как значение пятого параметра указано явно.
				РазделительСтрок               = Символы.ПС;
				КонвертируемыйРазделительСтрок = ДвухсимвольныйРазделительСтрок;
			Иначе
				РазделительСтрок               = ДвухсимвольныйРазделительСтрок;
				КонвертируемыйРазделительСтрок = "";
			КонецЕсли;
			ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла, ТипФайла, РазделительСтрок, КонвертируемыйРазделительСтрок, Ложь);
		КонецЕсли;
	
	Исключение
		
		ТекстСообщения = НСтр("ru = 'Ошибка чтения файла %Файл%.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Файл%", ИмяФайла);
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
		
		Возврат "";
		
	КонецПопытки;
	
	ВремТекстовыйДокумент = Новый ТекстовыйДокумент;
	
	Пока Истина Цикл
		
		ТекстСтрокиФайла = ЧтениеТекста.ПрочитатьСтроку();
		
		Если ТекстСтрокиФайла = Неопределено Тогда 
			Прервать;
		КонецЕсли;
		
		ВремТекстовыйДокумент.ДобавитьСтроку(ТекстСтрокиФайла);
		
	КонецЦикла;
	
	Возврат ВремТекстовыйДокумент.ПолучитьТекст();
	
КонецФункции

#КонецОбласти
