﻿////////////////////////////////////////////////////////////////////////////////
// Проверка контрагентов в Декларации по НДС
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

Процедура ПроверитьКонтрагентовВОтчетеКоманда(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("ЭтоЗапускПроверкиКомандой", Истина);
		
		ЗапуститьПроверкуКонтрагентовВДекларации(Форма, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьКонтрагентовВОтчетеПоНДС(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		Если НЕ Форма.РеквизитыПроверкиКонтрагентов.Свойство("АдресРезультатаЗаполненияОтчета") Тогда
			// Значит в отчете заполнение не было выполнено.
			Возврат;
		КонецЕсли;
		
		АдресРезультатаЗаполненияОтчета = Форма.РеквизитыПроверкиКонтрагентов.АдресРезультатаЗаполненияОтчета;
		
		ПроверкаКонтрагентовБРОКлиентСервер.ИнициализироватьРеквизитыПроверкиКонтрагентов(Форма, Ложь);
		Форма.РеквизитыПроверкиКонтрагентов.Вставить("ВыведеныВсеСтроки", 				Истина);
		Форма.РеквизитыПроверкиКонтрагентов.Вставить("АдресРезультатаЗаполненияОтчета", 	АдресРезультатаЗаполненияОтчета);
		
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("АдресРезультатаЗаполненияОтчета", АдресРезультатаЗаполненияОтчета);
		ДополнительныеПараметры.Вставить("Форма", 							Форма);
		
		ЗапуститьПроверкуКонтрагентовВОтчетеПослеСохранения(Истина, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗапуститьПроверкуКонтрагентовПослеЗаполнения(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
	
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("ЭтоЗапускПроверкиПослеЗаполнения", Истина);
		
		ЗапуститьПроверкуКонтрагентовВДекларации(Форма, ДополнительныеПараметры);
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ЗапуститьПроверкуКонтрагентовВДекларации(Форма, ДополнительныеПараметры) Экспорт
	
	СохранитьОтчетПередПроверкой(Форма, ДополнительныеПараметры);
		
КонецПроцедуры

Процедура ЗапуститьПроверкуКонтрагентовВОтчетеПослеСохранения(РезультатСохранения, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	ДополнительныеПараметры.Удалить("Форма");
	
	ЭтоДекларация = Форма.РеквизитыПроверкиКонтрагентов.Свойство("ЭтоДекларацияПоНДС");
	
	// Проверяем только сохраненную декларацию или любой отчет.
	Если НЕ ЭтоДекларация
		ИЛИ ЭтоДекларация И ЗначениеЗаполнено(Форма.СтруктураРеквизитовФормы.мСохраненныйДок) Тогда
		
		ЭтоКонсолидация = ЭтоДекларация
			И РегламентированнаяОтчетностьВызовСервера.ОтчетСформированОбработкойКонсолидацияОтчетностиПоНДС(
				Форма.СтруктураРеквизитовФормы.мСохраненныйДок);
				
		Если ЭтоКонсолидация Тогда
			ДополнительныеПараметры.Вставить("ЭтоКонсолидация", Истина);
		КонецЕсли;
		
		// Проверяем только декларацию, заполненную по новому алгоритму или 
		// консолидированную декларацию или любой отчет.
		Если НЕ ЭтоДекларация ИЛИ ЭтоДекларация 
			И (Форма.ЗаполненоНовымАлгоритмом() ИЛИ ЭтоКонсолидация) Тогда
		
			ВывестиПанельПередПроверкой(Форма, ДополнительныеПараметры);
			
			Форма.ПроверитьКонтрагентовВОтчете(ДополнительныеПараметры);
		
			// Инициализируем параметры фонового задания
			Если ЗначениеЗаполнено(Форма.РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания) Тогда
				ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания);
			КонецЕсли;
			
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", 1, Истина);
			
		ИначеЕсли Форма.РеквизитыПроверкиКонтрагентов.Свойство("ЭтоДекларацияПоНДС") Тогда
			
			Если ДополнительныеПараметры.Свойство("ЭтоЗапускПроверкиКомандой") Тогда
				ПоказатьПредупреждение(, НСтр("ru = 'Для проверки контрагентов необходимо заполнить отчет.'"));
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		ЗавершитьПроверкуКонтрагентов(Форма, ДополнительныеПараметры);
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработатьРезультатПроверкиКонтрагентовВОтчете(Форма) Экспорт
	 
	Попытка

		ИдентификаторЗадания = Форма.РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания;
	
		Если ИдентификаторЗадания = Неопределено
			ИЛИ ПроверкаКонтрагентовБРОВызовСервера.ЗаданиеВыполнено(Форма.РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания) Тогда
			
			ЗавершитьПроверкуКонтрагентов(Форма);
			
		Иначе
			
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания);
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов",
				Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
				
		КонецЕсли;
			
	Исключение
		ВызватьИсключение;
	КонецПопытки;
		
КонецПроцедуры

Процедура ОткрытьОтчетПоНекорректнымКонтрагентам(Форма) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ПредставлениеОтчета", Форма.Заголовок);
	
	Если Форма.РеквизитыПроверкиКонтрагентов.Свойство("ЭтоДекларацияПоНДС") Тогда
		
		Ссылка 		= Форма.СтруктураРеквизитовФормы.мСохраненныйДок;
		АдресТабДок = ПроверкаКонтрагентовБРОВызовСервера.АдресТабДокОтчетаПоНекорретнымКонтрагентамИзРегистра(Ссылка);
		
		Если АдресТабДок = Неопределено Тогда
			Возврат;
		Иначе
			ДополнительныеПараметры.Вставить("АдресТабДок",	АдресТабДок);
		КонецЕсли;
	Иначе
		
		ТабДок = Форма.РеквизитыПроверкиКонтрагентов.ТабДок;
		
		Если ТабДок = Неопределено Тогда
			Возврат;
		Иначе
			ДополнительныеПараметры.Вставить("ТабДок",	ТабДок);
		КонецЕсли;
		
	КонецЕсли;
	
	ОткрытьФорму("Отчет.ОтчетПоНекорректнымКонтрагентам.Форма.Форма", ДополнительныеПараметры,,Новый УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СохранитьОтчетПередПроверкой(Форма, ДополнительныеПараметры)
	
	ДополнительныеПараметры.Вставить("Форма", Форма);
	// При проверке после заполнения выполняется своя процедура записи из формы отчета.
	Если Форма.Модифицированность Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ЗапуститьПроверкуКонтрагентовВОтчетеПослеСохранения", 
			ЭтотОбъект, 
			ДополнительныеПараметры);
			
		Форма.СохранитьНаКлиенте(,ОписаниеОповещения);
	Иначе
		ЗапуститьПроверкуКонтрагентовВОтчетеПослеСохранения(Истина, ДополнительныеПараметры);
	КонецЕсли;
		
КонецПроцедуры

#Область ОтображениеРезультатаПроверки

Процедура ЗавершитьПроверкуКонтрагентов(Форма, Знач ДополнительныеПараметры = Неопределено)
	
	// Если фоновое задание не запустилось, а вышло по какому-то условию (например, отчет
	// заполнен по старому алгоритму), то в хранилище результата проверки не будет.
	// По идентификатору задания нельзя проверять, потому что его может не быть если
	// фоновое задание отработало сразу.
	Если ЗначениеЗаполнено(Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища)
		И ЭтоАдресВременногоХранилища(Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища) Тогда
		ДополнительныеПараметры = Форма.ПолучитьРезультатРаботыФоновогоЗадания();
	КонецЕсли;
	
	Форма.РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания 	= Неопределено;
	Форма.РеквизитыПроверкиКонтрагентов.ПроверкаВыполнилась 	= Истина;
	
	Если Форма.РеквизитыПроверкиКонтрагентов.Свойство("ЭтоДекларацияПоНДС") Тогда
		// Сохраняем РеквизитыПроверкиКонтрагентов в регистр, чтобы
		// при открытии можно было восстановить ранее сохраненный результат.
		Форма.СохранитьНаКлиенте();
	КонецЕсли;
		
	ПоказатьРезультатПроверки(Форма, ДополнительныеПараметры);
	
КонецПроцедуры

Функция ЕстьПанель(Форма)
	
	Возврат Форма.Элементы.Найти("Проверка") <> Неопределено; 
			
КонецФункции

Процедура ВывестиПанельПередПроверкой(Форма, ДополнительныеПараметры)
	
	Если ЕстьПанель(Форма) Тогда
		
		ЭтоЗапускПроверкиКомандой = ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
			И ДополнительныеПараметры.Свойство("ЭтоЗапускПроверкиКомандой");
	
		ЭтоКонсолидация = ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
			И ДополнительныеПараметры.Свойство("ЭтоКонсолидация");
		
		Если ЭтоЗапускПроверкиКомандой Тогда
			
			// Бублик в консолидации выводим всегда.
			// В обычной декларации - только если есть панель.
			Если Форма.ПанельСРезультатамиПроверкиОтображена()
				ИЛИ ЭтоКонсолидация Тогда
				Форма.ВывестиПанельВыполненияПроверки();
			КонецЕсли;
			
		Иначе
			Форма.ВывестиПанельВыполненияПроверки();
		КонецЕсли;
		
	КонецЕсли;
			
КонецПроцедуры

Процедура ПоказатьРезультатПроверки(Форма, ДополнительныеПараметры)
	
	ЭтоЗапускПроверкиКомандой = ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ЭтоЗапускПроверкиКомандой");
	
	ЭтоКонсолидация = ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ЭтоКонсолидация");
	
	Если ЭтоЗапускПроверкиКомандой Тогда
		// По этой ветке пойдет только декларация.
		Если Форма.ПанельСРезультатамиПроверкиОтображена() 
			ИЛИ ЭтоКонсолидация Тогда
			ВывестиРезультатВПанель(Форма);
		КонецЕсли;
		ПоказатьРезультатПроверкиСразу(Форма);
	Иначе
		Если Форма.РеквизитыПроверкиКонтрагентов.Свойство("ЭтоДекларацияПоНДС") Тогда
			ВывестиРезультатВПанель(Форма);
		Иначе
			ПоказатьРезультатПроверкиСразу(Форма);
		КонецЕсли;
	КонецЕсли;
			
КонецПроцедуры

Процедура ВывестиРезультатВПанель(Форма)
	
	// Вывод в панель.
	Если ЕстьПанель(Форма) Тогда 
		Форма.ВывестиРезультатПроверки();
	КонецЕсли;

КонецПроцедуры

Процедура ПоказатьРезультатПроверкиСразу(Форма)
	
	Если Форма.РеквизитыПроверкиКонтрагентов.КоличествоНекорректныхКонтрагентов > 0 Тогда
		// Вывод отчета.
		ОткрытьОтчетПоНекорректнымКонтрагентам(Форма);
	ИначеЕсли НЕ Форма.РеквизитыПроверкиКонтрагентов.ЕстьДоступКВебСервисуФНС Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Проверка контрагентов сервисом ФНС не выполнена из-за ошибки подключения к сервису'"));
	ИначеЕсли Форма.РеквизитыПроверкиКонтрагентов.КоличествоНекорректныхКонтрагентов = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нет ошибок проверки контрагентов сервисом ФНС'"));
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти