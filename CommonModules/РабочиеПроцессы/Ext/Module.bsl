﻿
#Область ПрограммныйИнтерфейс

// Обработчик подписки на событие "ВыполнитьРабочийПроцессПередЗаписьюИсточника"
//
Процедура ВыполнитьРабочийПроцессПередЗаписьюИсточника(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("НеВыполнятьПравилаРабочегоПроцесса") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ЗаказПокупателя") Тогда
		Если Источник.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд Тогда
			СобытиеРабочегоПроцесса = Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияЗаказНаряда;
		Иначе
			СобытиеРабочегоПроцесса = Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияЗаказаПокупателя;
		КонецЕсли;
	Иначе
		СобытиеРабочегоПроцесса = Перечисления.СобытияРабочегоПроцесса.СобытиеРабочегоПроцессаПоИмениОснования(Источник.Метаданные().ПолноеИмя());
	КонецЕсли;
	
	Если СобытиеРабочегоПроцесса = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЕстьПравилаПроцесса(СобытиеРабочегоПроцесса) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеРабочегоПроцесса = Новый Структура;
	ДанныеРабочегоПроцесса.Вставить("ЭтоНовый",					Источник.ЭтоНовый());
	ДанныеРабочегоПроцесса.Вставить("СобытиеРабочегоПроцесса",	СобытиеРабочегоПроцесса);
	
	Если Не ДанныеРабочегоПроцесса.ЭтоНовый Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Источник.Ссылка, КонтролируемыеРеквизитыИсточника(СобытиеРабочегоПроцесса));
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ДанныеРабочегоПроцесса, ЗначенияРеквизитов, Истина);
	КонецЕсли;
	
	Источник.ДополнительныеСвойства.Вставить("ДанныеРабочегоПроцесса", ДанныеРабочегоПроцесса);
	
КонецПроцедуры

// Обработчик подписки на событие "ВыполнитьРабочийПроцессПриЗаписиИсточника"
//
Процедура ВыполнитьРабочийПроцессПриЗаписиИсточника(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("НеВыполнятьПравилаРабочегоПроцесса") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеРабочегоПроцесса = Неопределено;
	
	Если Не Источник.ДополнительныеСвойства.Свойство("ДанныеРабочегоПроцесса", ДанныеРабочегоПроцесса) Тогда
		Возврат;
	КонецЕсли;
	
	НужноДобавитьВОчередьОбработки = ДанныеРабочегоПроцесса.ЭтоНовый;
	
	Если Не НужноДобавитьВОчередьОбработки Тогда
		
		КонтролируемыеРеквизиты = КонтролируемыеРеквизитыИсточника(ДанныеРабочегоПроцесса.СобытиеРабочегоПроцесса);
		
		Для Каждого КонтролируемыйРеквизит Из КонтролируемыеРеквизиты Цикл
			
			Если Источник[КонтролируемыйРеквизит] <> ДанныеРабочегоПроцесса[КонтролируемыйРеквизит] Тогда
				НужноДобавитьВОчередьОбработки = Истина;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если НужноДобавитьВОчередьОбработки Тогда
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.ОбработкаПравилРабочихПроцессов);
		Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.ОбработкаПравилРабочихПроцессов.ИмяМетода);
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		
		СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ПараметрыЗадания));
		
		ПараметрыЗадания.Вставить("Использование", Истина);
		
		Если СписокЗаданий.Количество() = 0 Тогда
			
			Расписание = Новый РасписаниеРегламентногоЗадания;
			Расписание.ДатаНачала = ТекущаяДата() + ?(ОбщегоНазначенияКлиентСервер.РежимОтладки(), 5, 30);
			ПараметрыЗадания.Вставить("Расписание", Расписание);
			
			ДанныеКОбработке = Новый ТаблицаЗначений;
			ДанныеКОбработке.Колонки.Добавить("Источник",			ТипыИсточниковПравилРабочегоПроцесса());
			ДанныеКОбработке.Колонки.Добавить("СобытиеПроцесса",	Новый ОписаниеТипов("ПеречислениеСсылка.СобытияРабочегоПроцесса"));
			ДанныеКОбработке.Колонки.Добавить("Автор",				Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
			
			СтрокаДанных = ДанныеКОбработке.Добавить();
			СтрокаДанных.Источник			= Источник.Ссылка;
			СтрокаДанных.СобытиеПроцесса	= ДанныеРабочегоПроцесса.СобытиеРабочегоПроцесса;
			СтрокаДанных.Автор				= Пользователи.ТекущийПользователь();
			
			ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 0);
			ПараметрыЗадания.Вставить("Параметры", Новый Массив);
			ПараметрыЗадания.Параметры.Добавить(ДанныеКОбработке);
			
			РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
			
		Иначе
			
			ПараметрыЗадания.Удалить("Метаданные");
			
			Для Каждого Задание Из СписокЗаданий Цикл
				
				Если Задание.Параметры[0].Найти(Источник.Ссылка, "Источник") = Неопределено Тогда
					
					ДанныеКОбработке = Задание.Параметры[0].Скопировать();
					
					СтрокаДанных = ДанныеКОбработке.Добавить();
					СтрокаДанных.Источник			= Источник.Ссылка;
					СтрокаДанных.СобытиеПроцесса	= ДанныеРабочегоПроцесса.СобытиеРабочегоПроцесса;
					СтрокаДанных.Автор				= Пользователи.ТекущийПользователь();
					
					ПараметрыЗадания.Вставить("Параметры", Новый Массив);
					ПараметрыЗадания.Параметры.Добавить(ДанныеКОбработке);
					
				КонецЕсли;
				
				РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, ПараметрыЗадания);
				
			КонецЦикла;
			
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

// Метод регламентного задания "ОбработкаПравилРабочихПроцессов"
//
Процедура ОбработатьПравилаРабочихПроцессов(ДанныеКОбработке) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОбработкаПравилРабочихПроцессов);
	
	ТекстСообщения = СтрШаблон(
		НСтр("ru='Старт обработки правил рабочих процессов. Количество источников к обработке: %1'"),
		ДанныеКОбработке.Количество()
	);
	ЗаписьЖурналаРегистрации(РабочиеПроцессы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Примечание,
		Метаданные.Справочники.ПравилаРабочегоПроцесса, , ТекстСообщения);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеОбработки.Источник,
		|	ДанныеОбработки.СобытиеПроцесса,
		|	ДанныеОбработки.Автор
		|ПОМЕСТИТЬ втДанные
		|ИЗ
		|	&ДанныеОбработки КАК ДанныеОбработки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПравилаРабочегоПроцесса.Ссылка КАК Правило,
		|	ПравилаРабочегоПроцесса.НастройкиОтбора,
		|	ПравилаРабочегоПроцесса.УсловиеСтарта
		|ПОМЕСТИТЬ втПравила
		|ИЗ
		|	Справочник.ПравилаРабочегоПроцесса КАК ПравилаРабочегоПроцесса
		|ГДЕ
		|	ПравилаРабочегоПроцесса.УсловиеСтарта В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				втДанные.СобытиеПроцесса
		|			ИЗ
		|				втДанные)
		|	И ПравилаРабочегоПроцесса.ПометкаУдаления = ЛОЖЬ
		|	И ПравилаРабочегоПроцесса.Включено = ИСТИНА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втДанные.Источник,
		|	втДанные.СобытиеПроцесса,
		|	втДанные.Автор,
		|	втПравила.Правило,
		|	втПравила.НастройкиОтбора,
		|	ПравилаРабочегоПроцесса.Действия.(
		|		Действие
		|	)
		|ИЗ
		|	втДанные КАК втДанные
		|		ЛЕВОЕ СОЕДИНЕНИЕ втПравила КАК втПравила
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПравилаРабочегоПроцесса КАК ПравилаРабочегоПроцесса
		|			ПО втПравила.Правило = ПравилаРабочегоПроцесса.Ссылка
		|		ПО втДанные.СобытиеПроцесса = втПравила.УсловиеСтарта";
	
	Запрос.УстановитьПараметр("ДанныеОбработки", ДанныеКОбработке);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НастройкиСКД = Выборка.НастройкиОтбора.Получить();
		Если НастройкиСКД <> Неопределено Тогда
			
			СКД = Справочники.ПравилаРабочегоПроцесса.ПолучитьСхемуКритериевОтбораПоСобытию(Выборка.СобытиеПроцесса);
			
			КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
			КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД));
			КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиСКД);
			КомпоновщикНастроек.Восстановить();
			КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Основание", Выборка.Источник);
			
			КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
			МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, КомпоновщикНастроек.ПолучитьНастройки(),,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
			
			ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Ложь);
			
			РезультатСКД = Новый ТаблицаЗначений;
			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
			ПроцессорВывода.УстановитьОбъект(РезультатСКД);
			ПроцессорВывода.Вывести(ПроцессорКомпоновки);
			
			Если РезультатСКД.Количество() = 0 Тогда
				// Источник не прошел критерий отбора правила, никаких действий по нему выполнять не требуется
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		ВыборкаДействий = Выборка.Действия.Выбрать();
		
		Если ВыборкаДействий.Количество() > 0 Тогда
			
			МассивДействий = Новый Массив;
			Пока ВыборкаДействий.Следующий() Цикл
				МассивДействий.Добавить(ВыборкаДействий.Действие);
			КонецЦикла;
			
			ТекстСообщения = СтрШаблон(НСтр("ru='Старт выполнения действий по правилу рабочего процесса: ""%1"",
				|для источника: ""%2""'"), Выборка.Правило, Выборка.Источник);
			ЗаписьЖурналаРегистрации(РабочиеПроцессы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Примечание,
				Метаданные.Справочники.ПравилаРабочегоПроцесса, Выборка.Правило, ТекстСообщения);
			
			Справочники.ДействияРабочегоПроцесса.ВыполнитьДействияПоИсточнику(МассивДействий, Выборка.Источник, Выборка.Правило, Выборка.Автор);
			
			ТекстСообщения = СтрШаблон(НСтр("ru='Завершение выполнения действий по правилу рабочего процесса: ""%1"",
				|для источника: ""%2""'"), Выборка.Правило, Выборка.Источник);
			ЗаписьЖурналаРегистрации(РабочиеПроцессы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Примечание,
				Метаданные.Справочники.ПравилаРабочегоПроцесса, Выборка.Правило, ТекстСообщения);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстСообщения = НСтр("ru='Завершение обработки правил рабочих процессов'");
	ЗаписьЖурналаРегистрации(РабочиеПроцессы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Примечание,
		Метаданные.Справочники.ПравилаРабочегоПроцесса, , ТекстСообщения);
	
	РегламентныеЗаданияСервер.УдалитьЗадание(Метаданные.РегламентныеЗадания.ОбработкаПравилРабочихПроцессов);
	
КонецПроцедуры

// Возвращает строковую константу для формирования сообщений журнала регистрации.
//
// Возвращаемое значение:
//   Строка
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru='Правила рабочего процесса'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЕстьПравилаПроцесса(СобытиеРабочегоПроцесса)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПравилаРабочегоПроцесса.Ссылка
		|ИЗ
		|	Справочник.ПравилаРабочегоПроцесса КАК ПравилаРабочегоПроцесса
		|ГДЕ
		|	ПравилаРабочегоПроцесса.Включено = ИСТИНА
		|	И ПравилаРабочегоПроцесса.ПометкаУдаления = ЛОЖЬ
		|	И ПравилаРабочегоПроцесса.УсловиеСтарта = &УсловиеСтарта";
	
	Запрос.УстановитьПараметр("УсловиеСтарта", СобытиеРабочегоПроцесса);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

Функция КонтролируемыеРеквизитыИсточника(СобытиеРабочегоПроцесса)
	
	КонтролируемыеРеквизиты = Новый Массив;
	
	Если СобытиеРабочегоПроцесса = Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияЗаказаПокупателя Тогда
		
		КонтролируемыеРеквизиты.Добавить("СостояниеЗаказа");
		
	ИначеЕсли СобытиеРабочегоПроцесса = Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияЗаказНаряда Тогда
		
		КонтролируемыеРеквизиты.Добавить("СостояниеЗаказа");
		
	ИначеЕсли СобытиеРабочегоПроцесса = Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияЗаказаПоставщику Тогда
		
		КонтролируемыеРеквизиты.Добавить("СостояниеЗаказа");
		
	ИначеЕсли СобытиеРабочегоПроцесса = Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияЗаказаНаПроизводство Тогда
		
		КонтролируемыеРеквизиты.Добавить("СостояниеЗаказа");
		
	ИначеЕсли СобытиеРабочегоПроцесса = Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияСобытия Тогда
		
		КонтролируемыеРеквизиты.Добавить("Состояние");
		
	ИначеЕсли СобытиеРабочегоПроцесса = Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияЗаданияНаРаботу Тогда
		
		КонтролируемыеРеквизиты.Добавить("Состояние");
		
	ИначеЕсли СобытиеРабочегоПроцесса = Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияРемонта Тогда
		
		КонтролируемыеРеквизиты.Добавить("СостояниеРемонта");
		
	КонецЕсли;
	
	Возврат КонтролируемыеРеквизиты;
	
КонецФункции

Функция ТипыИсточниковПравилРабочегоПроцесса()
	
	Типы = Новый Массив;
	
	Типы.Добавить(Тип("ДокументСсылка.ЗаказПокупателя"));
	Типы.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
	Типы.Добавить(Тип("ДокументСсылка.ЗаказНаПроизводство"));
	Типы.Добавить(Тип("ДокументСсылка.Событие"));
	Типы.Добавить(Тип("ДокументСсылка.ЗаданиеНаРаботу"));
	Типы.Добавить(Тип("ДокументСсылка.ПриемИПередачаВРемонт"));
	
	Возврат Новый ОписаниеТипов(Типы);
	
КонецФункции

#КонецОбласти
