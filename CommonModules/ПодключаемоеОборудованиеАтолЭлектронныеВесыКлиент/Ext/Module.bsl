﻿
#Область ПрограммныйИнтерфейс

// Функция возвращает возможность работы модуля в асинхронном режиме.
// Стандартные команды модуля:
// - ПодключитьУстройство
// - ОтключитьУстройство
// - ВыполнитьКоманду
// Команды модуля для работы асинхронном режиме (должны быть определены):
// - НачатьПодключениеУстройства
// - НачатьОтключениеУстройства
// - НачатьВыполнениеКоманды.
//
Функция ПоддержкаАсинхронногоРежима() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Функция осуществляет подключение устройства.
//
// Параметры:
//  ОбъектДрайвера   - <*>
//           - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ПараметрыПодключения.Вставить("ИДУстройства", "");

	ВыходныеПараметры = Новый Массив();

	// Проверка настроенных параметров.
	Порт            = Неопределено;
	Скорость        = Неопределено;
	Четность        = Неопределено;
	Модель          = Неопределено;
	Наименование    = Неопределено;
	ДесятичнаяТочка = Неопределено;
	
	Параметры.Свойство("Порт"           , Порт);
	Параметры.Свойство("Скорость"       , Скорость);
	Параметры.Свойство("Четность"       , Четность);
	Параметры.Свойство("Модель"         , Модель);
	Параметры.Свойство("Наименование"   , Наименование);
	Параметры.Свойство("ДесятичнаяТочка", ДесятичнаяТочка);
	
	Если Порт         = Неопределено
	 Или Скорость     = Неопределено
	 Или Четность     = Неопределено
	 Или Модель       = Неопределено
	 Или Наименование = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
		|Для корректной работы устройства необходимо задать параметры его работы.
		|Сделать это можно при помощи формы ""Настройка параметров"" модели
		|подключаемого оборудования в форме ""Подключение и настройка оборудования"".'"));

		Результат = Ложь;
	КонецЕсли;

	Если Результат Тогда
		ОбъектДрайвера.ДобавитьУстройство();
		Если ОбъектДрайвера.Результат = 0 Тогда
			ПараметрыПодключения.ИДУстройства = ОбъектДрайвера.НомерТекущегоУстройства;
			ОбъектДрайвера.НаименованиеТекущегоУстройства = Параметры.Наименование;
			ОбъектДрайвера.Модель           = Число(Параметры.Модель);
			ОбъектДрайвера.НомерПорта       = Параметры.Порт;
			ОбъектДрайвера.СкоростьОбмена   = Параметры.Скорость;
			ОбъектДрайвера.Четность         = Параметры.Четность;
			ОбъектДрайвера.АсинхронныйРежим = Ложь;
			Попытка
				ОбъектДрайвера.ДесятичнаяТочка  = ?(ДесятичнаяТочка = Неопределено, 0, ДесятичнаяТочка);
			Исключение
			КонецПопытки;
			
			ОбъектДрайвера.УстройствоВключено = Истина;
			Если ОбъектДрайвера.Результат <> 0 Тогда
				ВыходныеПараметры.Добавить(999);
				ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

				ОбъектДрайвера.УдалитьУстройство();
				ПараметрыПодключения.ИДУстройства = Неопределено;

				Результат = Ложь;
			КонецЕсли;
		Иначе
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отключение устройства.
//
// Параметры:
//  ОбъектДрайвера - <*>
//         - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;
	ОбъектДрайвера.УстройствоВключено = 0;
	ОбъектДрайвера.УдалитьУстройство();

	ПараметрыПодключения.ИДУстройства = Неопределено;

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу.
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	// Тарирование 
	Если Команда = "Тарировать" ИЛИ Команда = "Calibrate" Тогда
		ВесТары = ?(ТипЗнч(ВходныеПараметры) = Тип("Массив")
		            И ВходныеПараметры.Количество() > 0,
		            ВходныеПараметры[0],
		            Неопределено);

		Результат = Тарировать(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры, ВесТары);

	// Получение веса
	ИначеЕсли Команда = "ПолучитьВес" ИЛИ Команда = "GetWeight" Тогда
		Результат = ПолучитьВес(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Получение веса
	ИначеЕсли Команда = "УстановитьНоль" ИЛИ Команда = "SetZero" Тогда
		Результат = УстановитьНоль(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Тестирование устройства
	ИначеЕсли Команда = "CheckHealth" ИЛИ Команда = "ТестУстройства" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Получение версии драйвера
	ИначеЕсли Команда = "ПолучитьВерсиюДрайвера" Тогда
		Результат = ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Указанная команда не поддерживается данным драйвером.
	Иначе
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		Результат = Ложь;

	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция осуществляет установку веса тары на весах.
//
Функция Тарировать(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры, ВесТары = Неопределено)

	Результат = Истина;

	ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;

	Если ВесТары = Неопределено Тогда
		ОбъектДрайвера.Тара();
	Иначе
		ОбъектДрайвера.ВесТары = ВесТары;
		ОбъектДрайвера.УстановитьТару();
	КонецЕсли;

	Если ОбъектДрайвера.Результат <> 0 Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет получение веса груза, расположенного на весах.
//
Функция ПолучитьВес(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;

	ОбъектДрайвера.ПолучитьВес();
	Если ОбъектДрайвера.Результат = 0 Тогда
		ВыходныеПараметры.Добавить(ОбъектДрайвера.Вес);
	Иначе
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет установку нуля на весах.
//
Функция УстановитьНоль(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;

	ОбъектДрайвера.Ноль();
	Если ОбъектДрайвера.Результат <> 0 Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет тестирование устройства.
//
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;
	
	ВыходныеПараметрыВрем = Неопределено;
	
	Результат = ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметрыВрем);

	ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;

	ОбъектДрайвера.ПолучитьВес();
	
	Результат = ОбъектДрайвера.Результат = 0;
		
	ВыходныеПараметры.Очистить();
	ВыходныеПараметры.Добавить(?(Результат, 0, 999));
    ВыходныеПараметры.Добавить(?(Результат, 
		НСтр("ru='Текущий вес:'") + ОбъектДрайвера.Вес,
		НСтр("ru='Ошибка при подключении устройства'")));
	
	ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметрыВрем);

	Возврат Результат;

КонецФункции

// Функция возвращает версию установленного драйвера.
//
Функция ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	
	ВыходныеПараметры.Добавить(НСтр("ru='Установлен'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена'"));

	Попытка
		ВыходныеПараметры[1] = ОбъектДрайвера.Версия;
	Исключение
		Результат = Ложь;
	КонецПопытки;

	Возврат Результат;

КонецФункции

#КонецОбласти