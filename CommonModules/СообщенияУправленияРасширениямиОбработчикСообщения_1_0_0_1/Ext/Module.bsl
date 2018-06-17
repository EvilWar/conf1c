﻿#Область ПрограммныйИнтерфейс

// Возвращает пространство имен версии интерфейса сообщений
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/ConfigurationExtensions/Management/" + Версия();
	
КонецФункции

// Возвращает версию интерфейса сообщений, обслуживаемую обработчиком
Функция Версия() Экспорт
	
	Возврат "1.0.0.1";
	
КонецФункции

// Возвращает базовый тип для сообщений версии
Функция БазовыйТип() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипТело();
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса
//
// Параметры:
//  Сообщение - ОбъектXDTO, входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями, узел плана обмена, соответствующий отправителю сообщения
//  СообщениеОбработано - булево, флаг успешной обработки сообщения. Значение данного параметра необходимо
//    установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияУправленияРасширениямиИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеУстановитьРасширение(Пакет()) Тогда
		
		УстановитьРасширение(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеУдалитьРасширение(Пакет()) Тогда
		
		УдалитьРасширение(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеОтключитьРасширение(Пакет()) Тогда
		
		ОтключитьРасширение(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеВключитьРасширение(Пакет()) Тогда
		
		ВключитьРасширение(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеОтозватьРасширение(Пакет()) Тогда
		
		ОтозватьРасширение(Сообщение, Отправитель);
		
	Иначе
		
		СообщениеОбработано = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьРасширение(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	
	Попытка
	
		ОписаниеИнсталляции = Новый Структура(
			"Идентификатор, Представление, Инсталляция",
			ТелоСообщения.Extension,
			ТелоСообщения.Representation,
			ТелоСообщения.Installation);
		
		СообщенияУправленияРасширениямиРеализация.УстановитьРасширение(ОписаниеИнсталляции, ТелоСообщения.InitiatorServiceID);
		
	Исключение
		
		ТекстИсключения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПоставляемоеРасширение = Справочники.ПоставляемыеРасширения.ПолучитьСсылку(ТелоСообщения.Extension);
		РасширенияВМоделиСервиса.ОбработатьОшибкуУстановкиРасширенияВОбластьДанных(
			ПоставляемоеРасширение, ТелоСообщения.Installation, ТекстИсключения);
		
	КонецПопытки;
	
КонецПроцедуры

Процедура УдалитьРасширение(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияУправленияРасширениямиРеализация.УдалитьРасширение(ТелоСообщения.Extension);
	
КонецПроцедуры

Процедура ОтключитьРасширение(Знач Сообщение, Знач Отправитель)
	
	СообщенияУправленияРасширениямиРеализация.ОтключитьРасширение(Сообщение.Body.Extension);
	
КонецПроцедуры

Процедура ВключитьРасширение(Знач Сообщение, Знач Отправитель)
	
	СообщенияУправленияРасширениямиРеализация.ВключитьРасширение(Сообщение.Body.Extension);
	
КонецПроцедуры

Процедура ОтозватьРасширение(Знач Сообщение, Знач Отправитель)
	
	СообщенияУправленияРасширениямиРеализация.ОтозватьРасширение(Сообщение.Body.Extension);
	
КонецПроцедуры

#КонецОбласти