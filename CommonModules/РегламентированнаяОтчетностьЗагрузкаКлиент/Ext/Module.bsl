﻿////////////////////////////////////////////////////////////////////////////////
// Модуль содержит общие процедуры и функции для загрузки данных в формы
// регламентированной отчетности из файлов электронных представлений.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет данными из файлов электронного представления документ
// регламентированного отчета и открывает его в переданной форме отчета.
//
// Параметры:
//  Форма  - Управляемая форма - Форма регламентированного отчета.
//
Процедура ЗагрузитьИзФайлаОтчет(Форма) Экспорт
	
	Если ТипЗнч(Форма) <> Тип("УправляемаяФорма") Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметрыОповещения = Новый Структура;
	ДополнительныеПараметрыОповещения.Вставить("Форма", Форма);
	ОповещениеОЗакрытииФормы = Новый ОписаниеОповещения("ЗагрузитьИзФайлаОтчетПродолжение", ЭтотОбъект, ДополнительныеПараметрыОповещения);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВладелецФормы", Форма);
	ДополнительныеПараметры.Вставить("ОповещениеОЗакрытииФормы", ОповещениеОЗакрытииФормы);
	
	ПолучениеФайловДляЗагрузкиНачало(Форма.УникальныйИдентификатор, , ДополнительныеПараметры);
	
КонецПроцедуры

// Смотрите описание процедуры "ЗагрузитьИзФайлаОтчет(Форма)".
//
Процедура ЗагрузитьИзФайлаОтчетПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Перем ИмяФормыОтчета;
	Перем СохраненныйДок;
	Перем ПредставлениеДокументаРеглОтч;
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	ЭтоФормаРеглОтчета = ЭтоФормаРегламентированногоОтчета(Форма);
	
	ПараметрыФормыОтчета = Новый Структура;
	ПараметрыФормыОтчета.Вставить("Организация");
	ПараметрыФормыОтчета.Вставить("ОрганизацияЮЛ");
	ПараметрыФормыОтчета.Вставить("ОрганизацияФЛ");
	ПараметрыФормыОтчета.Вставить("мСохраненныйДок");
	ПараметрыФормыОтчета.Вставить("мДатаНачалаПериодаОтчета");
	ПараметрыФормыОтчета.Вставить("мДатаКонцаПериодаОтчета");
	ПараметрыФормыОтчета.Вставить("мПериодичность");
	ПараметрыФормыОтчета.Вставить("мВыбраннаяФорма");
	ПараметрыФормыОтчета.Вставить("мФормаОтчета");
	ПараметрыФормыОтчета.Вставить("ИсточникОтчета");
	
	ПараметрыФормыОтчета.Вставить("ЭтоБалансНекоммерческойОрганизации");
	
	Если Результат.Свойство("СвойстваВидаОтчета") Тогда
		Если ТипЗнч(Результат.СвойстваВидаОтчета) = Тип("Структура") Тогда
			Результат.СвойстваВидаОтчета.Свойство("БалансНекоммерческойОрганизации", ПараметрыФормыОтчета.ЭтоБалансНекоммерческойОрганизации);
		КонецЕсли;
	КонецЕсли;
	
	Если ЭтоФормаРеглОтчета Тогда
		ИмяФормыОтчета = Форма.ИмяФормы;
		СохраненныйДок = Форма.СтруктураРеквизитовФормы.мСохраненныйДок;
		
		ПараметрыФормыИзСохраненногоОтчета = РегламентированнаяОтчетностьВызовСервера.ПолучитьПараметрыФормыИзСохраненногоОтчета(СохраненныйДок, ПредставлениеДокументаРеглОтч);
		
		ЗаполнитьЗначенияСвойств(ПараметрыФормыОтчета, ПараметрыФормыИзСохраненногоОтчета);
		ПараметрыФормыОтчета.Вставить("мФормаОтчета", ПараметрыФормыИзСохраненногоОтчета.мВыбраннаяФорма);
		
		// Переопределим параметры заполняемого отчета из свойств электронного представления.
		Если Результат.Организация <> Неопределено И НЕ Результат.Организация.Пустая() Тогда
			ПараметрыФормыОтчета.Вставить("Организация", Результат.Организация);
		КонецЕсли;
		Если НЕ ПустаяСтрока(Результат.Периодичность) Тогда
			ПараметрыФормыОтчета.Вставить("мПериодичность", Результат.Периодичность);
		КонецЕсли;
		Если Результат.ДатаНачала <> '00010101000000' И Результат.ДатаНачала < Результат.ДатаОкончания Тогда
			ПараметрыФормыОтчета.Вставить("мДатаНачалаПериодаОтчета", Результат.ДатаНачала);
			ПараметрыФормыОтчета.Вставить("мДатаКонцаПериодаОтчета",  Результат.ДатаОкончания);
		КонецЕсли;
	Иначе
		ПредставлениеДокументаРеглОтч = Результат.Наименование;
		
		Попытка
			ПараметрыФормыИзРезультатаАнализа = РегламентированнаяОтчетностьВызовСервера.ПолучитьПараметрыОтчетаИзРезультатаАнализаФайловВыгрузки(Результат, ИмяФормыОтчета);
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не предусмотрена загрузка данных в отчет ""%1"".'"), ПредставлениеДокументаРеглОтч);
			Сообщение.Сообщить();
			Возврат;
		КонецПопытки;
		
		Если ТипЗнч(ПараметрыФормыИзРезультатаАнализа) = Тип("Структура") Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыФормыОтчета, ПараметрыФормыИзРезультатаАнализа);
			ПараметрыФормыОтчета.Вставить("мФормаОтчета", ПараметрыФормыИзРезультатаАнализа.мВыбраннаяФорма);
		КонецЕсли;
	КонецЕсли;
	
	ФормаОтчета = Неопределено;
	ОписаниеОшибки = "";
	Попытка
		ФормаОтчета = ПолучитьЗаполненнуюПоУмолчаниюФормуОтчета(ИмяФормыОтчета, ПараметрыФормыОтчета);
	Исключение
		ОписаниеОшибки = НСтр("ru = 'Ошибка: '") + ИнформацияОбОшибке().Описание + ".";
	КонецПопытки;
	Если ФормаОтчета = Неопределено Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить заполненную по умолчанию форму отчета ""%1"". %2'"), ПредставлениеДокументаРеглОтч, ОписаниеОшибки);
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	ТекстКомментария = НСтр("ru = 'Данные отчета загружены из файла.'");
	ТекстДопКомментария = ?(ПустаяСтрока(Результат.Комментарий), "", НСтр("ru = ' Примечание: '") + СокрЛП(Результат.Комментарий) +  ".");
	ФормаОтчета.Комментарий = ТекстКомментария + ТекстДопКомментария;
	
	// Отключаем авторасчет ячеек для точной загрузки из файла.
	Если ФормаОтчета.СтруктураРеквизитовФормы.Свойство("ФлажокОтклАвтоРасчет") Тогда
		ФормаОтчета.СтруктураРеквизитовФормы.ФлажокОтклАвтоРасчет = Истина;
		Если Результат.ВидОтчета = ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.НДС") Тогда
			РегламентированнаяОтчетностьКлиентСервер.ИзменитьТаблицуВариантовЗаполнения(ФормаОтчета, Ложь);
		КонецЕсли;
	КонецЕсли;
	
	// Используем несуществующий вариант для гарантированной записи нового документа, заполненного по умолчанию.
	ФормаОтчета.НомерКорректировки = 999;
	ФормаОтчета.СтруктураРеквизитовФормы.ВидДокумента = -1;
	ФормаОтчета.СтруктураРеквизитовФормы.мВариант = ФормаОтчета.СтруктураРеквизитовФормы.ВидДокумента * ФормаОтчета.НомерКорректировки;
	ФормаОтчета.СохранитьНаКлиенте(Истина);
	ФормаОтчета.СтруктураРеквизитовФормы.мВариант = 0;
	Если ФормаОтчета.СтруктураРеквизитовФормы.мСохраненныйДок = Неопределено Тогда
		ФормаОтчета.СохранитьНаКлиенте(Истина);
	КонецЕсли;
	ФормаОтчета.НомерКорректировки = 0;
	ФормаОтчета.СтруктураРеквизитовФормы.ВидДокумента = 0;
	ФормаОтчета.Модифицированность = Ложь;
	
	НовыйСохраненныйДок = ФормаОтчета.СтруктураРеквизитовФормы.мСохраненныйДок;
	
	Если НовыйСохраненныйДок = Неопределено ИЛИ НовыйСохраненныйДок.Пустая() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось создать документ отчета для загрузки данных из файла в ""%1"".'"), ПредставлениеДокументаРеглОтч);
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	Если Результат.ВидОтчета = ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.НДС") Тогда
		ПараметрыФормыКонсолидиции = Новый Структура;
		ПараметрыФормыКонсолидиции.Вставить("СформироватьАвтоматически", Истина);
		ПараметрыФормыКонсолидиции.Вставить("ДанныеДляЗагрузки", Результат);
		ПараметрыФормыКонсолидиции.Вставить("СохраненныйДок", НовыйСохраненныйДок);
		ПараметрыФормыКонсолидиции.Вставить("Организация", ПараметрыФормыОтчета.Организация);
		ПараметрыФормыКонсолидиции.Вставить("Комментарий", ФормаОтчета.Комментарий);
		
		ФормаКонсолидацииОтчетностиПоНДС = ПолучитьФорму("Обработка.КонсолидацияОтчетностиПоНДС.Форма.КонсолидацияОтчетностиПоНДС",
			ПараметрыФормыКонсолидиции, , Истина);
		
		Если ФормаКонсолидацииОтчетностиПоНДС = Неопределено Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Не удалось загрузить данные с помощью обработки ""Консолидация отчетности по НДС"".'");
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;
		
		ФормаКонсолидацииОтчетностиПоНДС.ОткрытьФормуЗаполненногоОтчета(НовыйСохраненныйДок);
		
		ФормаКонсолидацииОтчетностиПоНДС = Неопределено;
		Если ЭтоФормаРеглОтчета Тогда
			Форма.Закрыть();
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	Если ФормаОтчета.ЗагрузкаОтчетаИзФайла(Результат) Тогда
		Если ЭтоФормаРеглОтчета Тогда
			
			Форма.СтруктураРеквизитовФормы.Организация     = ФормаОтчета.СтруктураРеквизитовФормы.Организация;
			Форма.СтруктураРеквизитовФормы.мСохраненныйДок = НовыйСохраненныйДок;
			Форма.СтруктураРеквизитовФормы.мДатаНачалаПериодаОтчета = ФормаОтчета.СтруктураРеквизитовФормы.мДатаНачалаПериодаОтчета;
			Форма.СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета  = ФормаОтчета.СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета;
			Если Форма.СтруктураРеквизитовФормы.Свойство("мПериодичность") Тогда
				Форма.СтруктураРеквизитовФормы.мПериодичность = ФормаОтчета.СтруктураРеквизитовФормы.мПериодичность;
			КонецЕсли;
			
			Форма.Инициализация(Форма.СтруктураРеквизитовФормы.мБезОткрытияФормы);
			ДобавитьДополнительныеФайлы(Форма, Результат);
			Форма.СтруктураРеквизитовФормы.мСохраненныйДок = СохраненныйДок;
			Форма.Модифицированность = Истина;
			
		Иначе // открываем новую форму регламентированного отчета
			
			ПараметрыФормыОтчета.мСохраненныйДок = НовыйСохраненныйДок;
			ПараметрыФормыОтчета.Вставить("БезОткрытияФормы", Ложь);
			ПараметрыФормыОтчета.Вставить("ПредставлениеВидаОтчета", ПредставлениеДокументаРеглОтч);
			
			ФормаОтчетаПослеЗагрузки = ПолучитьФорму(ФормаОтчета.ИмяФормы, ПараметрыФормыОтчета, , Истина);
			ДобавитьДополнительныеФайлы(ФормаОтчетаПослеЗагрузки, Результат);
			ФормаОтчетаПослеЗагрузки.СтруктураРеквизитовФормы.мСохраненныйДок = Неопределено;
			ФормаОтчетаПослеЗагрузки.Модифицированность = Истина;
			
			ФормаОтчетаПослеЗагрузки.Открыть();
			
		КонецЕсли;
	Иначе
		СообщениеОбОшибке = Неопределено;
		Если Результат.Свойство("СообщениеОбОшибке", СообщениеОбОшибке) И СообщениеОбОшибке <> Неопределено Тогда
			Если ТипЗнч(СообщениеОбОшибке) = Тип("Структура") Тогда
				СпособВывода   = СообщениеОбОшибке.Способ;
				ТекстСообщения = СообщениеОбОшибке.ТекстСообщения;
				Если СпособВывода = "Предупреждение" Тогда
					ПоказатьПредупреждение(, ТекстСообщения);
				ИначеЕсли СпособВывода = "Сообщение" Тогда
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = ТекстСообщения;
					Сообщение.Сообщить();
				Иначе
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Загрузка данных из файла в ""%1"" не выполнена.'"), ПредставлениеДокументаРеглОтч);
					Сообщение.Сообщить();
				КонецЕсли;
			Иначе
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СообщениеОбОшибке;
				Сообщение.Сообщить();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	РегламентированнаяОтчетностьВызовСервера.УдалитьСохраненныйДокумент(НовыйСохраненныйДок);
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ЖурналОтчетовСтатусы"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПолучениеФайловЭлектронныхПредставлений

Процедура ПолучениеФайловДляЗагрузкиНачало(Адрес, ФайлыДляЗагрузки = "", ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ФайлыДляЗагрузки", ФайлыДляЗагрузки);
	ДополнительныеПараметры.Вставить("Адрес", Адрес);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолучениеФайловДляЗагрузкиПослеВопросаОбУстановкеРасширенияРаботыСФайлами", ЭтотОбъект, ДополнительныеПараметры);
	ТекстСообщения = НСтр("ru='Для загрузки файлов электронных представлений необходимо установить расширение работы с файлами.'");
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения, ТекстСообщения);
	
КонецПроцедуры

Процедура ПолучениеФайловДляЗагрузкиПослеВопросаОбУстановкеРасширенияРаботыСФайлами(ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.Вставить("ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами", ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами);
	
	Если ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами Тогда
		Если НЕ ДополнительныеПараметры.Свойство("ФайлыДляЗагрузки") 
		 ИЛИ НЕ ЗначениеЗаполнено(ДополнительныеПараметры.ФайлыДляЗагрузки) Тогда
			ДиалогВыбора = ПолучитьДиалогВыбораФайла();
			ОписаниеОповещения = Новый ОписаниеОповещения("ПолучениеФайловДляЗагрузкиПослеВыбораФайлов", ЭтотОбъект, ДополнительныеПараметры);
			ДиалогВыбора.Показать(ОписаниеОповещения);
		Иначе
			ПолучениеФайловДляЗагрузкиПослеВыбораФайлов(ДополнительныеПараметры.ФайлыДляЗагрузки, ДополнительныеПараметры);
		КонецЕсли;
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолучениеФайловДляЗагрузкиПослеПомещенияФайла", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПомещениеФайла(ОписаниеОповещения,,, Истина, ДополнительныеПараметры.Адрес);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучениеФайловДляЗагрузкиПослеВыбораФайлов(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		
		ФайлыБылиВыбраны = Истина;
		ДополнительныеПараметры.Вставить("ВыбранныеФайлы", ВыбранныеФайлы);
		ПолучениеФайловДляЗагрузкиПослеПомещенияФайла(ФайлыБылиВыбраны, "", "", ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучениеФайловДляЗагрузкиПослеПомещенияФайла(ФайлыБылиВыбраны, АдресДанных, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами = ДополнительныеПараметры.ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами;
	ФайлыДляЗагрузки = ДополнительныеПараметры.ФайлыДляЗагрузки;
	
	Если ФайлыБылиВыбраны Тогда
		
		ОсновнойФайл = Неопределено;
		
		Если ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами Тогда
			Если Не ЗначениеЗаполнено(ФайлыДляЗагрузки) Тогда
				ВыбранныеФайлы = ДополнительныеПараметры.ВыбранныеФайлы;
			Иначе
				ВыбранныеФайлы = СтрРазделить(ФайлыДляЗагрузки, Символы.ПС, Ложь);
			КонецЕсли;
			Если ВыбранныеФайлы.Количество() > 0 Тогда
				ОсновнойФайл = ВыбранныеФайлы[0];
			КонецЕсли;
		Иначе
			ВыбранныеФайлы = Новый Массив;
			ВыбранныеФайлы.Добавить(ВыбранноеИмяФайла);
			ОсновнойФайл = ВыбранноеИмяФайла;
		КонецЕсли;
		
		Если ОсновнойФайл = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ДополнительныеПараметры.Вставить("ВыбранныеФайлы", ВыбранныеФайлы);
		ДополнительныеПараметры.Вставить("ОсновнойФайл", ОсновнойФайл);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПолучениеФайловДляЗагрузкиПослеОпределенияСвойствОсновногоФайла", 
			ЭтотОбъект, 
			ДополнительныеПараметры);
			
		Если ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами Тогда
			ПолучитьСвойстваФайла(ОписаниеОповещения, ОсновнойФайл);
		Иначе
			СвойстваФайла = СвойстваФайла(АдресДанных, ВыбранноеИмяФайла);
			Результат = Новый Структура();
			Результат.Вставить("Выполнено",     Истина);
			Результат.Вставить("СвойстваФайла", СвойстваФайла);
			
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, Результат);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучениеФайловДляЗагрузкиПослеОпределенияСвойствОсновногоФайла(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат.Выполнено Тогда
		Возврат;
	КонецЕсли;
	
	ОсновнойФайлНаДиске = Результат.СвойстваФайла;
	ДополнительныеПараметры.Вставить("ОсновнойФайлНаДиске", ОсновнойФайлНаДиске);
	
	ВыбранныеФайлы = ДополнительныеПараметры.ВыбранныеФайлы;
	
	ЭтоФайлВыгрузкиУведомленияОКонтролируемыхСделках = (ВРег(Лев(ОсновнойФайлНаДиске.Имя, 10)) = "UT_UVKNRSD");
	ДополнительныеПараметры.Вставить("ЭтоФайлВыгрузкиУведомленияОКонтролируемыхСделках", ЭтоФайлВыгрузкиУведомленияОКонтролируемыхСделках);
	
	Если ВыбранныеФайлы.Количество() = 1 Тогда
		
		МаксимальныйРазмер = 1024 * 1024 * 100;
		
		Если ЭтоФайлВыгрузкиУведомленияОКонтролируемыхСделках
		   И ОсновнойФайлНаДиске.Размер > МаксимальныйРазмер Тогда
			
			РазмерВМб = Цел(МаксимальныйРазмер / 1024 / 1024);
			ТекстСообщения = СтрШаблон(
				НСтр("ru='Согласно требованиям ФНС файл формата 5.01 больше %2 Мб должен быть разбит на файлы формата 5.02.%1Загрузить файл с разбивкой?'"),
				Символы.ПС,
				Строка(РазмерВМб));
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить("Да", "Да");
			Кнопки.Добавить("Нет", "Нет");
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ПолучениеФайловПослеВопросаОРазбиенииФайла", ЭтотОбъект, ДополнительныеПараметры);
			ПоказатьВопрос(ОписаниеОповещения, ТекстСообщения, Кнопки);
		Иначе
			ПолучениеФайловПослеВопросаОРазбиенииФайла("Нет", ДополнительныеПараметры);
		КонецЕсли;
	Иначе
		ПолучениеФайловПослеВопросаОРазбиенииФайла("Нет", ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучениеФайловПослеВопросаОРазбиенииФайла(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = "Да" Тогда
		ДополнительныеПараметры.Вставить("ВыполнитьРазделениеФайла",              Истина);
		ДополнительныеПараметры.Вставить("ВыполнятьПроверкуКомплектаУведомлений", Ложь);
	Иначе
		ДополнительныеПараметры.Вставить("ВыполнитьРазделениеФайла",              Ложь);
		Если ДополнительныеПараметры.ЭтоФайлВыгрузкиУведомленияОКонтролируемыхСделках Тогда
			ДополнительныеПараметры.Вставить("ВыполнятьПроверкуКомплектаУведомлений", Истина);
		Иначе
			ДополнительныеПараметры.Вставить("ВыполнятьПроверкуКомплектаУведомлений", Ложь);
		КонецЕсли;
	КонецЕсли;
	
	ОсновнойФайлНаДиске                                     = ДополнительныеПараметры.ОсновнойФайлНаДиске;
	ВыбранныеФайлы                                          = ДополнительныеПараметры.ВыбранныеФайлы;
	ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами     = ДополнительныеПараметры.ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами;
	
	Если ВыбранныеФайлы = Неопределено Тогда
		ПолучениеФайловДляЗагрузкиЗавершение(Ложь, ДополнительныеПараметры);
		Возврат;
	КонецЕсли;
	
	// Составляем массив с объектами Файл.
	Если ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами Тогда
		МассивФайлов    = Новый Массив;
		ПомещаемыеФайлы = Новый Массив;
		Для Каждого ЭлФайл Из ВыбранныеФайлы Цикл
			Файл = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ЭлФайл);
			МассивФайлов.Добавить(Новый Структура("Имя, ПолноеИмя, Расширение, АдресДанных", Файл.Имя, Файл.ПолноеИмя, Файл.Расширение));
			
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(Файл.ПолноеИмя);
			ПомещаемыеФайлы.Добавить(ОписаниеФайла);
		КонецЦикла;
		
		ДополнительныеПараметры.Вставить("МассивФайлов", МассивФайлов);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПолучениеФайловПослеПомещенияФайлов", 
			ЭтотОбъект, 
			ДополнительныеПараметры);
		
		НачатьПомещениеФайлов(ОписаниеОповещения, ПомещаемыеФайлы, , Ложь, ДополнительныеПараметры.Адрес);
	Иначе
		МассивФайлов = Новый Массив;
		МассивФайлов.Добавить(Новый Структура("Имя, ПолноеИмя, Расширение, АдресДанных", 
			ОсновнойФайлНаДиске.Имя, ОсновнойФайлНаДиске.ПолноеИмя, ОсновнойФайлНаДиске.Расширение, ОсновнойФайлНаДиске.АдресДанных));
		РезультатЗагрузки = Истина;
		
		ДополнительныеПараметры.Вставить("ФайлыДляЗагрузки", МассивФайлов);
		ПолучениеФайловДляЗагрузкиЗавершение(РезультатЗагрузки, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучениеФайловПослеПомещенияФайлов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Тогда
		РезультатЗагрузки = Ложь;
	Иначе
		МассивФайлов = ДополнительныеПараметры.МассивФайлов;
		
		Для каждого ЭлФайл Из МассивФайлов Цикл
			Для каждого ОписаниеПереданногоФайла Из ПомещенныеФайлы Цикл
				Если ОписаниеПереданногоФайла.Имя = ЭлФайл.ПолноеИмя Тогда
					ЭлФайл.АдресДанных = ОписаниеПереданногоФайла.Хранение;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		РезультатЗагрузки = Истина;
	КонецЕсли;
		
	ДополнительныеПараметры.Вставить("ФайлыДляЗагрузки", МассивФайлов);
	ПолучениеФайловДляЗагрузкиЗавершение(РезультатЗагрузки, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПолучениеФайловДляЗагрузкиЗавершение(ФайлПолучен, ВходящийКонтекст) Экспорт
	
	Если ФайлПолучен Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ФайлыДляЗагрузки",                                 ВходящийКонтекст.ФайлыДляЗагрузки);
		ДополнительныеПараметры.Вставить("ЭтоФайлВыгрузкиУведомленияОКонтролируемыхСделках", ВходящийКонтекст.ЭтоФайлВыгрузкиУведомленияОКонтролируемыхСделках);
		ДополнительныеПараметры.Вставить("ВыполнитьРазделениеФайла",                         ВходящийКонтекст.ВыполнитьРазделениеФайла);
		ДополнительныеПараметры.Вставить("ВыполнятьПроверкуКомплектаУведомлений",            ВходящийКонтекст.ВыполнятьПроверкуКомплектаУведомлений);
		
		Если ВходящийКонтекст.Свойство("ВыполняемоеОповещение") Тогда
			
			ВыполнитьОбработкуОповещения(ВходящийКонтекст.ВыполняемоеОповещение, ДополнительныеПараметры);
			
		Иначе
			// Получить заполненную форму электронного представления.
			ДополнительныеПараметры.Вставить("ФайлыДляИмпорта", ВходящийКонтекст.ФайлыДляЗагрузки);
			ФормаЭлектронногоПредставления = ПолучитьФорму("Справочник.ЭлектронныеПредставленияРегламентированныхОтчетов.Форма.ФормаЭлемента", ДополнительныеПараметры);
			Если ФормаЭлектронногоПредставления = Неопределено Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтрШаблон(
					НСтр("ru = 'Не удалось открыть форму электронного представления для файла: ""%1"".'"),
					ВходящийКонтекст.ОсновнойФайлНаДиске.Имя);
				Сообщение.Сообщить();
				Возврат;
			КонецЕсли;
			
			ВладелецФормы = Неопределено;
			ВходящийКонтекст.Свойство("ВладелецФормы", ВладелецФормы);
			
			ОповещениеОЗакрытииФормы = Неопределено;
			ВходящийКонтекст.Свойство("ОповещениеОЗакрытииФормы", ОповещениеОЗакрытииФормы);
			
			ПараметрыФормы = Новый Структура;
			ДополнитьПараметрыФормы(ПараметрыФормы, ФормаЭлектронногоПредставления);
			ОткрытьФорму("ОбщаяФорма.ЗагрузкаФайловОтчета", ПараметрыФормы, ВладелецФормы, , , 
						 ,ОповещениеОЗакрытииФормы, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьПараметрыФормы(ПараметрыФормы, Форма)
	
	Если ТипЗнч(ПараметрыФормы) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	РасширенныеПараметры = Новый Структура;
	
	РасширенныеПараметры.Вставить("ТипДокумента",                   РеквизитОбъектаЕслиСуществует(Форма, "ТипДокумента"));
	РасширенныеПараметры.Вставить("СвойстваФайлов",                 РеквизитОбъектаЕслиСуществует(Форма, "СвойстваФайлов"));
	РасширенныеПараметры.Вставить("ФайлАудиторскогоЗаключения",     РеквизитОбъектаЕслиСуществует(Форма, "ФайлАудиторскогоЗаключения"));
	РасширенныеПараметры.Вставить("ФайлЗаявленияРевизионногоСоюза", РеквизитОбъектаЕслиСуществует(Форма, "ФайлЗаявленияРевизионногоСоюза"));
	РасширенныеПараметры.Вставить("ФайлПояснительнойЗаписки",       РеквизитОбъектаЕслиСуществует(Форма, "ФайлПояснительнойЗаписки"));
	РасширенныеПараметры.Вставить("ФайлыКомплекта",                 РеквизитОбъектаЕслиСуществует(Форма, "ФайлыКомплекта"));
	РасширенныеПараметры.Вставить("ДополнительныеФайлы",            РеквизитОбъектаЕслиСуществует(Форма, "ДополнительныеФайлы"));
	
	РасширенныеПараметры.Вставить("Наименование",                   РеквизитОбъектаЕслиСуществует(Форма.Объект, "Наименование"));
	РасширенныеПараметры.Вставить("ВидОтчета",                      РеквизитОбъектаЕслиСуществует(Форма.Объект, "ВидОтчета"));
	РасширенныеПараметры.Вставить("Версия",                         РеквизитОбъектаЕслиСуществует(Форма.Объект, "Версия"));
	РасширенныеПараметры.Вставить("Организация",                    РеквизитОбъектаЕслиСуществует(Форма.Объект, "Организация"));
	РасширенныеПараметры.Вставить("ДатаНачала",                     РеквизитОбъектаЕслиСуществует(Форма.Объект, "ДатаНачала"));
	РасширенныеПараметры.Вставить("ДатаОкончания",                  РеквизитОбъектаЕслиСуществует(Форма.Объект, "ДатаОкончания"));
	РасширенныеПараметры.Вставить("Периодичность",                  РеквизитОбъектаЕслиСуществует(Форма.Объект, "Периодичность"));
	РасширенныеПараметры.Вставить("Комментарий",                    РеквизитОбъектаЕслиСуществует(Форма.Объект, "Комментарий"));
	РасширенныеПараметры.Вставить("ПредставлениеПериода",           РеквизитОбъектаЕслиСуществует(Форма.Объект, "ПредставлениеПериода"));
	РасширенныеПараметры.Вставить("ТипПолучателя",                  РеквизитОбъектаЕслиСуществует(Форма.Объект, "ТипПолучателя"));
	РасширенныеПараметры.Вставить("Получатель",                     РеквизитОбъектаЕслиСуществует(Форма.Объект, "Получатель"));
	
	ПараметрыФормы.Вставить("РасширенныеПараметры", РасширенныеПараметры);
	
КонецПроцедуры

Функция ПолучитьДиалогВыбораФайла()
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.Заголовок = НСтр("ru = 'Выберите файл(ы) для загрузки'");
	ДиалогВыбора.МножественныйВыбор = Истина;
	ДиалогВыбора.ПроверятьСуществованиеФайла = Истина;
	ДиалогВыбора.Фильтр = НСтр("ru='Все файлы'") + " (*.*)|*.*";
	
	Возврат ДиалогВыбора;
	
КонецФункции

#КонецОбласти

Функция ПолучитьЗаполненнуюПоУмолчаниюФормуОтчета(Знач ПолноеИмяФормыОтчета, ПараметрыФормыОтчета)
	
	Если ПараметрыФормыОтчета = "Недостаточно прав" Тогда
		ПоказатьПредупреждение(, НСтр("ru='Недостаточно прав!'"));
		Возврат Неопределено;
	ИначеЕсли ПараметрыФормыОтчета = "Форма отчета не найдена" Тогда
		ПоказатьПредупреждение(, НСтр("ru='Форма отчета не найдена в выбранном периоде!'"));
		Возврат Неопределено;
	ИначеЕсли ТипЗнч(ПараметрыФормыОтчета) <> Тип("Структура") Тогда
		ПоказатьПредупреждение(, НСтр("ru='Недостаточно параметров для создания отчета!'"));
		Возврат Неопределено;
	КонецЕсли;
	
	ПолноеИмяФормыОтчетаДляРазбора = ?(СтрНачинаетсяС(ПолноеИмяФормыОтчета, "Внешний"), Сред(ПолноеИмяФормыОтчета, 8), ПолноеИмяФормыОтчета);
	ИсточникОтчета = Сред(Лев(ПолноеИмяФормыОтчетаДляРазбора, СтрНайти(ПолноеИмяФормыОтчетаДляРазбора, ".Форма.") - 1), 7);
	ИмяФормыОтчета = Сред(ПолноеИмяФормыОтчетаДляРазбора, СтрНайти(ПолноеИмяФормыОтчетаДляРазбора, ".Форма.") + 7);
	
	// Для совместимости с универсальным отчетом статистики.
	Если ИсточникОтчета = "РегламентированныйОтчетСтатистикаПрочиеФормы" Тогда
		ПозицияРазделителя = СтрНайти(ИмяФормыОтчета, "_");
		Если ПозицияРазделителя > 0 Тогда
			ИмяФормыОтчетаДоРазделителя = Лев(ИмяФормыОтчета, ПозицияРазделителя - 1);
			ПолноеИмяФормыОтчета = СтрЗаменить(ПолноеИмяФормыОтчета, ИмяФормыОтчета, ИмяФормыОтчетаДоРазделителя);
			ИмяФормыОтчета = ИмяФормыОтчетаДоРазделителя;
		КонецЕсли;
	КонецЕсли;
	
	Если ИсточникОтчета = "РегламентированныйОтчетРСВ1" Тогда
		ИмяОсновнойФормыОтчета = РегламентированнаяОтчетностьКлиентСерверПереопределяемый.ИмяОсновнойФормыРСВ1();
	Иначе
		ИмяОсновнойФормыОтчета = "ОсновнаяФорма";
	КонецЕсли;
	
	ПараметрыФормыОтчета.Вставить("мСохраненныйДок");
	ПараметрыФормыОтчета.Вставить("мСкопированаФорма");
	
	ОсновнаяФормаОтчета = ПолучитьФорму(СтрЗаменить(ПолноеИмяФормыОтчета, ИмяФормыОтчета, ИмяОсновнойФормыОтчета), ПараметрыФормыОтчета, , Истина);
	Если ОсновнаяФормаОтчета = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru='Не удалось получить основную форму отчета!'"));
		Возврат Неопределено;
	КонецЕсли;
	
	СвойстваОсновнойФормы = Новый Структура("мПериодичность");
	ЗаполнитьЗначенияСвойств(СвойстваОсновнойФормы, ОсновнаяФормаОтчета);
	ПериодичностьОсновнойФормы = СвойстваОсновнойФормы.мПериодичность;
	
	ОрганизацияОсновнойФормы = ОсновнаяФормаОтчета.Организация;
	ЭлементОрганизация = ОсновнаяФормаОтчета.Элементы.Организация;
	Если ЭлементОрганизация.РежимВыбораИзСписка Тогда
		Если ЭлементОрганизация.СписокВыбора.Количество() > 0 Тогда
			Если ОрганизацияОсновнойФормы.Пустая() Тогда
				ОрганизацияОсновнойФормы = ЭлементОрганизация.СписокВыбора[0].Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если (ПараметрыФормыОтчета.Организация = Неопределено ИЛИ ПараметрыФормыОтчета.Организация.Пустая())
	   И (ОрганизацияОсновнойФормы <> Неопределено И НЕ ОрганизацияОсновнойФормы.Пустая())Тогда
		ПараметрыФормыОтчета.Организация = ОрганизацияОсновнойФормы;
	КонецЕсли;
	Если (ПараметрыФормыОтчета.Организация = Неопределено ИЛИ ПараметрыФормыОтчета.Организация.Пустая())
	   И (ПараметрыФормыОтчета.Свойство("ОрганизацияЮЛ"))Тогда
		Если ПараметрыФормыОтчета.ОрганизацияЮЛ = Неопределено ИЛИ ПараметрыФормыОтчета.ОрганизацияЮЛ.Пустая() Тогда
			ПоказатьПредупреждение(, НСтр("ru='Не удалось подобрать организацию для формы отчета!'"));
			Возврат Неопределено;
		Иначе
			ПараметрыФормыОтчета.Организация = ПараметрыФормыОтчета.ОрганизацияЮЛ;
		КонецЕсли;
	КонецЕсли;
	
	Если ОсновнаяФормаОтчета.Элементы.Найти("ПереключательСпособСозданияОрганизации") <> Неопределено Тогда
		ПараметрыФормыОтчета.Вставить("СпособСозданияОрганизации",
			?(ОсновнаяФормаОтчета.СпособСозданияОрганизации = 1, "Реорганизация", "ВновьСозданная"));
		ПараметрыФормыОтчета.Вставить("ДатаСозданияОрганизации", НачалоДня(ОсновнаяФормаОтчета.ОрганизацияДатаРегистрации));
	КонецЕсли;
	
	Если ОсновнаяФормаОтчета.Элементы.Найти("ПереключательНКО") <> Неопределено
		ИЛИ ОсновнаяФормаОтчета.Элементы.Найти("БалансНекоммерческойОрганизации") <> Неопределено Тогда
		Если ПараметрыФормыОтчета.ЭтоБалансНекоммерческойОрганизации = Неопределено Тогда
			ПараметрыФормыОтчета.ЭтоБалансНекоммерческойОрганизации = ОсновнаяФормаОтчета.БалансНекоммерческойОрганизации;
		КонецЕсли;
	КонецЕсли;
	
	ОсновнаяФормаОтчета = Неопределено;
	
	Если НЕ ПараметрыФормыОтчета.Свойство("мПериодичность") Тогда
		ПараметрыФормыОтчета.Вставить("мПериодичность", ПериодичностьОсновнойФормы);
	КонецЕсли;
	Если НЕ ПараметрыФормыОтчета.Свойство("мВыбраннаяФорма") Тогда
		ПараметрыФормыОтчета.Вставить("мВыбраннаяФорма", ПараметрыФормыОтчета.мФормаОтчета);
	КонецЕсли;
	Если НЕ ПараметрыФормыОтчета.Свойство("ДатаПодписи") Тогда
		ПараметрыФормыОтчета.Вставить("ДатаПодписи", ПараметрыФормыОтчета.мДатаКонцаПериодаОтчета);
	КонецЕсли;
	Если СтрНайти(ИсточникОтчета, "АлкоПриложение") > 0 Тогда
		ПараметрыФормыОтчета.Вставить("БезОткрытияФормы", Ложь);
	Иначе
		ПараметрыФормыОтчета.Вставить("БезОткрытияФормы", Истина);
	КонецЕсли;
	
	ПараметрыФормыОтчета.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417",
		РегламентированнаяОтчетностьКлиент.ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417());
	
	ВыбраннаяФормаОтчета = ПолучитьФорму(ПолноеИмяФормыОтчета, ПараметрыФормыОтчета, , Истина);
	
	Если ВыбраннаяФормаОтчета = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru='Не удалось получить заполненную по умолчанию форму отчета!'"));
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ВыбраннаяФормаОтчета;
	
КонецФункции

Функция СвойстваФайла(Знач АдресДанных, Знач ПолноеИмя) Экспорт
	
	Файл = Новый Файл(ПолноеИмя);
	
	СтруктураСвойств = Новый Структура("АдресДанных, Имя, ИмяБезРасширения, ПолноеИмя, Путь, Размер, Расширение");
	ЗаполнитьЗначенияСвойств(СтруктураСвойств, Файл);
	СтруктураСвойств.АдресДанных = АдресДанных;
	СтруктураСвойств.Размер      = РегламентированнаяОтчетностьВызовСервера.РазмерФайлаВоВременномХранилище(АдресДанных);
	
	Возврат СтруктураСвойств;
	
КонецФункции

Процедура ПолучитьСвойстваФайла(ОповещениеОЗавершении, ИмяФайла) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ИмяФайла", ИмяФайла);
	Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	Оповещение = Новый ОписаниеОповещения("ПолучитьСвойстваФайлаПослеИнициализацииФайла", ЭтотОбъект, Контекст);
	
	// Должно быть установлено расширение для работы с файлами.
	Файл = Новый Файл;
	Файл.НачатьИнициализацию(Оповещение, Контекст.ИмяФайла);
	
КонецПроцедуры

Процедура ПолучитьСвойстваФайлаПослеИнициализацииФайла(Файл, ВходящийКонтекст) Экспорт
	
	Свойства = "Имя,ИмяБезРасширения,ПолноеИмя,Путь,Расширение,Размер,Существует,ЭтоКаталог";
	СвойстваФайла = Новый Структура(Свойства);
	
	ЗаполнитьЗначенияСвойств(СвойстваФайла, Файл);
	ВходящийКонтекст.Вставить("СвойстваФайла", СвойстваФайла);
	ВходящийКонтекст.Вставить("Файл", Файл);
	
	Оповещение = Новый ОписаниеОповещения(
		"ПолучитьСвойстваФайлаПослеПроверкиСуществования", ЭтотОбъект, ВходящийКонтекст);
	Файл.НачатьПроверкуСуществования(Оповещение);
	
КонецПроцедуры

Процедура ПолучитьСвойстваФайлаПослеПроверкиСуществования(Существует, ВходящийКонтекст) Экспорт

	ВходящийКонтекст.СвойстваФайла.Существует = Существует;
	
	Если Существует Тогда
		Оповещение = Новый ОписаниеОповещения(
			"ПолучитьСвойстваФайлаПослеПроверкиЭтоФайл", ЭтотОбъект, ВходящийКонтекст);
			
		ВходящийКонтекст.Файл.НачатьПроверкуЭтоФайл(Оповещение);
	Иначе
		ВыполнитьОбработкуОповещения(
			ВходящийКонтекст.ОповещениеОЗавершении,
			ПодготовитьРезультат(Истина, "СвойстваФайла", ВходящийКонтекст.СвойстваФайла));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьСвойстваФайлаПослеПроверкиЭтоФайл(ЭтоФайл, ВходящийКонтекст) Экспорт
	
	ВходящийКонтекст.СвойстваФайла.ЭтоКаталог = Не ЭтоФайл;
	
	Если ЭтоФайл Тогда
		Оповещение = Новый ОписаниеОповещения(
			"ПолучитьСвойстваФайлаПослеПолученияРазмера", ЭтотОбъект, ВходящийКонтекст);
			
		ВходящийКонтекст.Файл.НачатьПолучениеРазмера(Оповещение);
	Иначе		
		ВыполнитьОбработкуОповещения(
			ВходящийКонтекст.ОповещениеОЗавершении,
			ПодготовитьРезультат(Истина, "СвойстваФайла", ВходящийКонтекст.СвойстваФайла));
	КонецЕсли;
		
КонецПроцедуры

Процедура ПолучитьСвойстваФайлаПослеПолученияРазмера(Размер, ВходящийКонтекст) Экспорт
	
	ВходящийКонтекст.СвойстваФайла.Размер = Размер;
	
	ВыполнитьОбработкуОповещения(
		ВходящийКонтекст.ОповещениеОЗавершении,
		ПодготовитьРезультат(Истина, "СвойстваФайла", ВходящийКонтекст.СвойстваФайла));
	
КонецПроцедуры

Процедура ДобавитьДополнительныеФайлы(ФормаОтчета, ДанныеДляЗагрузки)
	
	ТипДокументаБухгалтерскаяОтчетность = ПредопределенноеЗначение("Перечисление.ТипыОтправляемыхДокументов.БухгалтерскаяОтчетность");
	
	Если ДанныеДляЗагрузки.ТипДокумента = ТипДокументаБухгалтерскаяОтчетность Тогда
		
		ТипФайлаБухОтчетностиАудиторскоеЗаключение               = ПредопределенноеЗначение("Перечисление.ТипыФайловБухОтчетности.АудиторскоеЗаключение");
		ТипФайлаБухОтчетностиЗаявлениеСоюзаСельхозПроизводителей = ПредопределенноеЗначение("Перечисление.ТипыФайловБухОтчетности.ЗаявлениеСоюзаСельхозПроизводителей");
		ТипФайлаБухОтчетностиПояснительнаяЗаписка                = ПредопределенноеЗначение("Перечисление.ТипыФайловБухОтчетности.ПояснительнаяЗаписка");
		
		ДобавленыФайлы = Ложь;
		ВидДополнительногоФайла = "";
		Для Каждого СвойстваФайла Из ДанныеДляЗагрузки.СвойстваФайлов Цикл
			Если СвойстваФайла.ТипФайлаОтчетности = ТипФайлаБухОтчетностиАудиторскоеЗаключение Тогда
				ВидДополнительногоФайла = "ФайлАудиторскогоЗаключения";
				ДобавленыФайлы = Истина;
			ИначеЕсли СвойстваФайла.ТипФайлаОтчетности = ТипФайлаБухОтчетностиЗаявлениеСоюзаСельхозПроизводителей Тогда
				ВидДополнительногоФайла = "ФайлЗаявленияСоюзаСельхозпроизводителей";
				ДобавленыФайлы = Истина;
			ИначеЕсли СвойстваФайла.ТипФайлаОтчетности = ТипФайлаБухОтчетностиПояснительнаяЗаписка Тогда
				ВидДополнительногоФайла = "ФайлПояснительнойЗаписки";
				ДобавленыФайлы = Истина;
			Иначе
				Продолжить;
			КонецЕсли;
			ФормаОтчета.СтруктураРеквизитовФормы[ВидДополнительногоФайла].ИмяФайла = "";
			ФормаОтчета.ДобавитьФайлЗавершение(Истина, СвойстваФайла.АдресДанных, СвойстваФайла.ИмяФайла, ВидДополнительногоФайла);
		КонецЦикла;
		
		Если ДобавленыФайлы Тогда
			ИмяРаздела = "ДополнительныеФайлы";
			РазделФормаОтчета = РегламентированнаяОтчетностьКлиентСервер.НайтиЭлементВДанныхФормыДерево(ФормаОтчета.мДеревоВыбранныхСтраниц.ПолучитьЭлементы(), "ИмяСтраницы", ИмяРаздела);
			Если РазделФормаОтчета <> Неопределено Тогда
				РазделФормаОтчета.ПоказатьСтраницу = 1;
				РегламентированнаяОтчетностьКлиент.ПоказатьСтраницыОтчетаНаКлиенте(ФормаОтчета);
				ФормаОтчета.СформироватьДеревоРазделовОтчетаНаКлиенте();
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПодготовитьРезультат(Выполнено, ИмяПоляРезультат = Неопределено, ЗначениеРезультат = Неопределено, ВходящийКонтекст = Неопределено)
	
	Результат = Новый Структура("Выполнено", Выполнено);
	
	Если ВходящийКонтекст <> Неопределено Тогда
		Если ВходящийКонтекст.Свойство("ДвоичныеДанные") Тогда
			Результат.Вставить("ДвоичныеДанные", ВходящийКонтекст.ДвоичныеДанные);
		КонецЕсли;
		Если ВходящийКонтекст.Свойство("ОписаниеОшибки") Тогда
			Результат.Вставить("ОписаниеОшибки", ВходящийКонтекст.ОписаниеОшибки);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяПоляРезультат) Тогда
		Результат.Вставить(ИмяПоляРезультат, ЗначениеРезультат);
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Функция РеквизитОбъектаЕслиСуществует(Объект, ИмяРеквизита)
	
	Если НЕ РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Объект, ИмяРеквизита) Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не найдено свойство ""%1"" объекта ""%2"".'"), ИмяРеквизита, Строка(Объект));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Возврат Объект[ИмяРеквизита];
	
КонецФункции

Функция ЭтоФормаРегламентированногоОтчета(Форма) Экспорт
	
	СвойстваФормы = Новый Структура("СтруктураРеквизитовФормы");
	ЗаполнитьЗначенияСвойств(СвойстваФормы, Форма);
	
	Если ТипЗнч(СвойстваФормы.СтруктураРеквизитовФормы) = Тип("Структура") Тогда
		Если СвойстваФормы.СтруктураРеквизитовФормы.Свойство("мСохраненныйДок") Тогда
			
			Возврат Истина;
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти