﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление конфигурации".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму установки обновлений.
//
Процедура ПоказатьПоискИУстановкуОбновлений(ПараметрыФормы = Неопределено) Экспорт
	
	ОткрытьФорму("Обработка.УстановкаОбновлений.Форма.Форма", ПараметрыФормы);
	
КонецПроцедуры

// Отображает форму настроек создания резервной копии.
//
Процедура ПоказатьРезервноеКопирование(ПараметрыРезервногоКопирования, ОписаниеОповещения) Экспорт
	
	ОткрытьФорму("Обработка.УстановкаОбновлений.Форма.НастройкаРезервнойКопии", ПараметрыРезервногоКопирования,,,,, ОписаниеОповещения);
	
КонецПроцедуры

// Возвращает текст заголовка настроек резервного копирования для отображения на форме.
//
Функция ЗаголовокСозданияРезервнойКопии(Параметры) Экспорт
	
	Если Параметры.СоздаватьРезервнуюКопию = 0 Тогда
		Результат = НСтр("ru = 'Не создавать резервную копию ИБ'");
	ИначеЕсли Параметры.СоздаватьРезервнуюКопию = 1 Тогда
		Результат = НСтр("ru = 'Создавать временную резервную копию ИБ'");
	ИначеЕсли Параметры.СоздаватьРезервнуюКопию = 2 Тогда
		Результат = НСтр("ru = 'Создавать резервную копию ИБ'");
	КонецЕсли;
	
	Если Параметры.ВосстанавливатьИнформационнуюБазу Тогда
		Результат = Результат + " " + НСтр("ru = 'и выполнять откат при нештатной ситуации'");
	Иначе
		Результат = Результат + " " + НСтр("ru = 'и не выполнять откат при нештатной ситуации'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет возможность установи обновления. Если возможно, то запускает
// скрипт обновления или планирует обновление на указанное время.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма из которой устанавливается обновление.
//	Параметры - Структура со свойствами:
//	* РежимОбновления - Число - Вариант установки обновления. Принимаемые значения:
//								0 - сейчас, 1 - при завершении работы, 2 - планирование обновления.
//	* ДатаВремяОбновления - Дата - Дата планируемого обновления.
//	* ВыслатьОтчетНаПочту - Булево - Признак необходимости отправки отчета на почту.
//	* АдресЭлектроннойПочты - Строка - Адрес электронной почты для отправки обновления.
//	* КодЗадачиПланировщика - Число - Код задачи запланированного обновления.
//	* ИмяФайлаОбновления - Строка - Имя файла устанавливаемого обновления.
//	* СоздаватьРезервнуюКопию - Число - Признак необходимости создания резервной копии.
//	* ИмяКаталогаРезервнойКопииИБ - Строка - Каталог сохранения резервной копии.
//	* ВосстанавливатьИнформационнуюБазу - Булево - Признак необходимости восстановления базы.
//	* ЗавершениеРаботыСистемы - Булево - Признак того, что установка обновления происходит при завершении работы.
//	* ФайлыОбновления - Массив - Содержит значения типа Структура.
//	ПараметрыАдминистрирования - Структура - Содержит параметры администрирования информационной базы и кластера.
//
Процедура УстановитьОбновление(Форма, Параметры, ПараметрыАдминистрирования) Экспорт
	
	// Так же при проверке возможности установки обновления выполняется
	// планировка обновления на указанное время (если выбран этот вариант).
	Если Не ВозможнаУстановкаОбновления(Параметры, ПараметрыАдминистрирования) Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимОбновления = 0 Тогда // Обновить сейчас
		ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы", Истина);
		ЗавершитьРаботуСистемы(Ложь);
		ЗапуститьСкриптОбновления(Параметры, ПараметрыАдминистрирования);
	ИначеЕсли Параметры.РежимОбновления = 1 Тогда // При завершении работы
		ИмяПараметра = "СтандартныеПодсистемы.ПредлагатьОбновлениеИнформационнойБазыПриЗавершенииСеанса";
		ПараметрыПриложения.Вставить(ИмяПараметра, Истина);
		ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ИменаФайловОбновления", ИменаФайловОбновления(Параметры));
	КонецЕсли;
	
	ОбновлениеКонфигурацииВызовСервера.СохранитьНастройкиОбновленияКонфигурации(Параметры);
	
	Форма.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Обновляет конфигурацию базы данных.
//
// Параметры:
//  СтандартнаяОбработка - Булево - если в процедуре установить данному параметру значение Ложь, то инструкция по
//                                  "ручному" обновлению показана не будет.
Процедура УстановитьОбновлениеКонфигурации(ЗавершениеРаботыСистемы = Ложь) Экспорт
	
	ПараметрыФормы = Новый Структура("ЗавершениеРаботыСистемы, ПолученоОбновлениеКонфигурации",
		ЗавершениеРаботыСистемы, ЗавершениеРаботыСистемы);
	ПоказатьПоискИУстановкуОбновлений(ПараметрыФормы);
	
КонецПроцедуры

// Записывает в каталог скрипта файл-маркер ошибки.
//
Процедура ЗаписатьФайлПротоколаОшибки(КаталогСкрипта) Экспорт
	
	ФайлРегистрации = Новый ЗаписьТекста(КаталогСкрипта + "error.txt");
	ФайлРегистрации.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВозможнаУстановкаОбновления(Параметры, ПараметрыАдминистрирования)
	
	ЭтоФайловаяБаза = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	
	Если ЭтоФайловаяБаза И Параметры.СоздаватьРезервнуюКопию = 2 Тогда
		Файл = Новый Файл(Параметры.ИмяКаталогаРезервнойКопииИБ);
		Если Не Файл.Существует() Или Не Файл.ЭтоКаталог() Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Укажите существующий каталог для сохранения резервной копии ИБ.'"));
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.РежимОбновления = 0 Тогда // Обновить сейчас
		ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
		Если ЭтоФайловаяБаза И ОбновлениеКонфигурацииВызовСервера.НаличиеАктивныхСоединений(ПараметрыПриложения[ИмяПараметра]) Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Невозможно продолжить обновление конфигурации, так как не завершены все соединения с информационной базой.'"));
			Возврат Ложь;
		КонецЕсли;
	ИначеЕсли Параметры.РежимОбновления = 2 Тогда
		Если Не ДатаОбновленияУказанаВерно(Параметры) Тогда
			Возврат Ложь;
		КонецЕсли;
		Если Параметры.ВыслатьОтчетНаПочту
			И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(Параметры.АдресЭлектроннойПочты) Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Укажите допустимый адрес электронной почты.'"));
			Возврат Ложь;
		КонецЕсли;
		Если Не ВозможноЗапланироватьОбновление() Тогда
			Возврат Ложь;
		КонецЕсли;
		Если Не ЗапланироватьОбновлениеКонфигурации(Параметры, ПараметрыАдминистрирования) Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Не удалось запланировать обновление конфигурации. Сведения об ошибке сохранены в журнал регистрации.'"));
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ВозможноЗапланироватьОбновление()
	
	ВерсияWindowsВышеVista = ВерсияWindowsВышеVista();
	Попытка
		ОбъектAPI = ?(ВерсияWindowsВышеVista, СлужбаПланировщика(), ОбъектWMI());
		Возврат ОбъектAPI <> Неопределено;
	Исключение
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка", ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

Процедура ЗапуститьСкриптОбновления(Параметры, ПараметрыАдминистрирования)
	
	УдалитьЗадачуПланировщика(Параметры.КодЗадачиПланировщика);
	ИмяГлавногоФайлаСкрипта = СформироватьФайлыСкриптаОбновления(Истина, Параметры, ПараметрыАдминистрирования);
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Информация",
		НСтр("ru = 'Выполняется процедура обновления конфигурации:'") + " " + ИмяГлавногоФайлаСкрипта);
	ОбновлениеКонфигурацииВызовСервера.ЗаписатьСтатусОбновления(ИмяПользователя(), Истина, Ложь, Ложь,
		ИмяГлавногоФайлаСкрипта, ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"]);
	
	СтрокаЗапуска = "cmd /c """"%1"""" [p1]%2[/p1][p2]%3[/p2]";
	СтрокаЗапуска = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗапуска, ИмяГлавногоФайлаСкрипта,
		СтрокаUnicode(ПараметрыАдминистрирования.ПарольАдминистратораИнформационнойБазы),
		СтрокаUnicode(ПараметрыАдминистрирования.ПарольАдминистратораКластера));
	Оболочка = Новый COMОбъект("Wscript.Shell");
	Оболочка.RegWrite("HKCU\Software\Microsoft\Internet Explorer\Styles\MaxScriptStatements", 1107296255, "REG_DWORD");
	Оболочка.Run(СтрокаЗапуска, 0);
	
КонецПроцедуры

// Определяет что текущая версия windows больше Vista (Vista, Windows 7, Windows 8).
//
Функция ВерсияWindowsВышеVista()
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ВерсияОС = СистемнаяИнформация.ВерсияОС;
	
	ПозицияТочки = СтрНайти(ВерсияОС, ".");
	НомерВерсии = Сред(ВерсияОС, ПозицияТочки - 1, 1);
	
	Возврат Число(НомерВерсии) >= 6;
	
КонецФункции

Функция СлужбаПланировщика()
	СлужбаПланировщика = Новый COMObject("Schedule.Service");
	СлужбаПланировщика.Connect();
	Возврат СлужбаПланировщика;
КонецФункции

Функция ДатаОбновленияУказанаВерно(Параметры)
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	Если Параметры.ДатаВремяОбновления < ТекущаяДата Тогда
		ТекстСообщения = НСтр("ru = 'Обновление конфигурации может быть запланировано только на будущую дату и время.'");
	ИначеЕсли Параметры.ДатаВремяОбновления > ДобавитьМесяц(ТекущаяДата, 1) Тогда
		ТекстСообщения = НСтр("ru = 'Обновление конфигурации может быть запланировано не позднее, чем через месяц относительно текущей даты.'");
	КонецЕсли;
	
	ДатаУказанаВерно = ПустаяСтрока(ТекстСообщения);
	Если Не ДатаУказанаВерно Тогда
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;
	
	Возврат ДатаУказанаВерно;
	
КонецФункции

Функция ЗапланироватьОбновлениеКонфигурации(Параметры, ПараметрыАдминистрирования)
	Если Не УдалитьЗадачуПланировщика(Параметры.КодЗадачиПланировщика) Тогда
		Возврат Ложь;
	КонецЕсли;
	ИмяГлавногоФайлаСкрипта = СформироватьФайлыСкриптаОбновления(Ложь, Параметры, ПараметрыАдминистрирования);
	
	ИмяЗапускаемогоСкрипта = ОпределитьИмяСкрипта();
	ПутьЗапускаемогоСкрипта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 //nologo ""%2"" /p1:""%3"" /p2:""%4""",
		ИмяЗапускаемогоСкрипта, ИмяГлавногоФайлаСкрипта,
		СтрокаUnicode(ПараметрыАдминистрирования.ПарольАдминистратораИнформационнойБазы),
		СтрокаUnicode(ПараметрыАдминистрирования.ПарольАдминистратораКластера));
	
	Параметры.КодЗадачиПланировщика = СоздатьЗадачуПланировщика(ПутьЗапускаемогоСкрипта, Параметры.ДатаВремяОбновления);
	ОбновлениеКонфигурацииВызовСервера.ЗаписатьСтатусОбновления(ИмяПользователя(), Параметры.КодЗадачиПланировщика <> 0, Ложь, Ложь);
	Возврат Параметры.КодЗадачиПланировщика <> 0;
КонецФункции

Функция СформироватьФайлыСкриптаОбновления(Знач ИнтерактивныйРежим, Параметры, ПараметрыАдминистрирования)
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	ЭтоФайловаяБаза = ПараметрыРаботыКлиента.ИнформационнаяБазаФайловая;
	
	#Если Не ВебКлиент Тогда
	КаталогПлатформы = Неопределено;
	Параметры.Свойство("КаталогПлатформы", КаталогПлатформы);
	КаталогПрограммы = ?(ЗначениеЗаполнено(КаталогПлатформы), КаталогПлатформы, КаталогПрограммы());
	
	ИмяИсполняемогоФайлаКонфигуратора = КаталогПрограммы + СтандартныеПодсистемыКлиент.ИмяИсполняемогоФайлаПриложения(Истина);
	ИмяИсполняемогоФайлаКлиента = КаталогПрограммы + СтандартныеПодсистемыКлиент.ИмяИсполняемогоФайлаПриложения();
	
	ИспользоватьCOMСоединитель = Не (ПараметрыРаботыКлиента.ЭтоБазоваяВерсияКонфигурации Или ПараметрыРаботыКлиента.ЭтоУчебнаяПлатформа);
	
	ПараметрыСкрипта = ПолучитьПараметрыАутентификацииАдминистратораОбновления(ПараметрыАдминистрирования);
	СтрокаСоединенияИнформационнойБазы = ПараметрыСкрипта.СтрокаСоединенияИнформационнойБазы + ПараметрыСкрипта.СтрокаПодключения;
	Если СтрЗаканчиваетсяНа(СтрокаСоединенияИнформационнойБазы, ";") Тогда
		СтрокаСоединенияИнформационнойБазы = Лев(СтрокаСоединенияИнформационнойБазы, СтрДлина(СтрокаСоединенияИнформационнойБазы) - 1);
	КонецЕсли;
	
	// Определение пути к информационной базе.
	ПутьКИнформационнойБазе = СоединенияИБКлиентСервер.ПутьКИнформационнойБазе(, ПараметрыАдминистрирования.ПортКластера);
	ПараметрПутиКИнформационнойБазе = ?(ЭтоФайловаяБаза, "/F", "/S") + ПутьКИнформационнойБазе;
	СтрокаПутиКИнформационнойБазе = ?(ЭтоФайловаяБаза, ПутьКИнформационнойБазе, "");
	СтрокаПутиКИнформационнойБазе = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(СтрЗаменить(СтрокаПутиКИнформационнойБазе, """", "")) + "1Cv8.1CD";
	
	АдресЭлектроннойПочты = ?(Параметры.РежимОбновления = 2 И Параметры.ВыслатьОтчетНаПочту, Параметры.АдресЭлектроннойПочты, "");
	КаталогРезервнойКопии = ?(Параметры.СоздаватьРезервнуюКопию = 2, ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Параметры.ИмяКаталогаРезервнойКопииИБ), "");
	СоздаватьРезервнуюКопию = ЭтоФайловаяБаза И Параметры.СоздаватьРезервнуюКопию <> 0;
	
	ВыполнитьОтложенныеОбработчики = Ложь;
	ТекстыМакетов = ОбновлениеКонфигурацииВызовСервера.ТекстыМакетов(ИнтерактивныйРежим,
		ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"], ВыполнитьОтложенныеОбработчики);
	ИмяПользователя = ПараметрыАдминистрирования.ИмяАдминистратораИнформационнойБазы;
	
	ОбластьПараметров = ТекстыМакетов.ОбластьПараметров;
	ВставитьПараметрСкрипта("ИмяИсполняемогоФайлаКонфигуратора" , ИмяИсполняемогоФайлаКонфигуратора          , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("ИмяИсполняемогоФайлаКлиента"       , ИмяИсполняемогоФайлаКлиента                , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("ПараметрПутиКИнформационнойБазе"   , ПараметрПутиКИнформационнойБазе            , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("СтрокаПутиКФайлуИнформационнойБазы", СтрокаПутиКИнформационнойБазе              , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("СтрокаСоединенияИнформационнойБазы", СтрокаСоединенияИнформационнойБазы         , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("СобытиеЖурналаРегистрации"         , СобытиеЖурналаРегистрации()                , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("АдресЭлектроннойПочты"             , АдресЭлектроннойПочты                      , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("ИмяАдминистратораОбновления"       , ИмяПользователя                          , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("ИмяCOMСоединителя"                 , ПараметрыРаботыКлиента.ИмяCOMСоединителя   , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("КаталогРезервнойКопии"             , КаталогРезервнойКопии                      , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("СоздаватьРезервнуюКопию"           , СоздаватьРезервнуюКопию                    , Ложь  , ОбластьПараметров);
	ВставитьПараметрСкрипта("ВосстанавливатьИнформационнуюБазу" , Параметры.ВосстанавливатьИнформационнуюБазу, Ложь  , ОбластьПараметров);
	ВставитьПараметрСкрипта("БлокироватьСоединенияИБ"           , Не ЭтоФайловаяБаза                         , Ложь  , ОбластьПараметров);
	ВставитьПараметрСкрипта("ИспользоватьCOMСоединитель"        , ИспользоватьCOMСоединитель                 , Ложь  , ОбластьПараметров);
	ВставитьПараметрСкрипта("ЗапускСеансаПослеОбновления"       , Не Параметры.ЗавершениеРаботыСистемы       , Ложь  , ОбластьПараметров);
	ВставитьПараметрСкрипта("ВыполнятьСжатиеТаблицИБ"           , ЭтоФайловаяБаза                            , Ложь  , ОбластьПараметров);
	ВставитьПараметрСкрипта("ВыполнитьОтложенныеОбработчики"    , ВыполнитьОтложенныеОбработчики             , Ложь  , ОбластьПараметров);
	ОбластьПараметров = СтрЗаменить(ОбластьПараметров, "[ИменаФайловОбновления]", ИменаФайловОбновления(Параметры));
	
	ТекстыМакетов.МакетФайлаОбновленияКонфигурации = ОбластьПараметров + ТекстыМакетов.МакетФайлаОбновленияКонфигурации;
	ТекстыМакетов.Удалить("ОбластьПараметров");
	
	Возврат СоздатьФайлыСкрипта(ТекстыМакетов, ИнтерактивныйРежим);
	#КонецЕсли
	
КонецФункции

Процедура ВставитьПараметрСкрипта(Знач ИмяПараметра, Знач ЗначениеПараметра, Форматировать, ОбластьПараметров)
	Если Форматировать = Истина Тогда
		ЗначениеПараметра = Форматировать(ЗначениеПараметра);
	ИначеЕсли Форматировать = Ложь Тогда
		ЗначениеПараметра = ?(ЗначениеПараметра, "true", "false");
	КонецЕсли;
	ОбластьПараметров = СтрЗаменить(ОбластьПараметров, "[" + ИмяПараметра + "]", ЗначениеПараметра);
КонецПроцедуры

Функция ИменаФайловОбновления(Параметры)
	
	ИмяПараметра = "СтандартныеПодсистемы.ИменаФайловОбновления";
	Если ПараметрыПриложения.Получить(ИмяПараметра) <> Неопределено Тогда
		Возврат ПараметрыПриложения[ИмяПараметра];
	КонецЕсли;
	
	Если Параметры.Свойство("НуженФайлОбновления") И Не Параметры.НуженФайлОбновления Тогда
		ИменаФайловОбновления = "";
	Иначе
		Если ПустаяСтрока(Параметры.ИмяФайлаОбновления) Тогда
			ИменаФайлов = Новый Массив;
			Для Каждого ФайлОбновления Из Параметры.ФайлыОбновления Цикл
				ПрефиксФайлаОбновления = ?(ФайлОбновления.ВыполнитьОбработчикиОбновления, "+", "");
				ИменаФайлов.Добавить(Форматировать(ПрефиксФайлаОбновления + ФайлОбновления.ПолноеИмяФайлаОбновления));
			КонецЦикла;
			ИменаФайловОбновления = СтрСоединить(ИменаФайлов, ",");
		Иначе
			ИменаФайловОбновления = Форматировать(Параметры.ИмяФайлаОбновления);
		КонецЕсли;
	КонецЕсли;
	
	Возврат "[" + ИменаФайловОбновления + "]";
	
КонецФункции

Функция Форматировать(Знач Текст)
	Текст = СтрЗаменить(Текст, "\", "\\");
	Текст = СтрЗаменить(Текст, """", "\""");
	Текст = СтрЗаменить(Текст, "'", "\'");
	Возврат "'" + Текст + "'";
КонецФункции

Функция СоздатьФайлыСкрипта(ТекстыМакетов, ИнтерактивныйРежим)
	
	КаталогВременныхФайловОбновления = КаталогВременныхФайлов() + "1Cv8Update." + Формат(ОбщегоНазначенияКлиент.ДатаСеанса(), "ДФ=ггММддЧЧммсс") + "\";
	СоздатьКаталог(КаталогВременныхФайловОбновления);
	
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов.МакетФайлаОбновленияКонфигурации);
	
	ИмяФайлаСкрипта = КаталогВременныхФайловОбновления + "main.js";
	ФайлСкрипта.Записать(ИмяФайлаСкрипта, КодировкаТекста.UTF16);
	
	// Вспомогательный файл: helpers.js.
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов.ДопФайлОбновленияКонфигурации);
	ФайлСкрипта.Записать(КаталогВременныхФайловОбновления + "helpers.js", КодировкаТекста.UTF16);
	
	Если ИнтерактивныйРежим Тогда
		// Вспомогательный файл: splash.png.
		БиблиотекаКартинок.ЗаставкаВнешнейОперации.Записать(КаталогВременныхФайловОбновления + "splash.png");
		// Вспомогательный файл: splash.ico.
		БиблиотекаКартинок.ЗначокЗаставкиВнешнейОперации.Записать(КаталогВременныхФайловОбновления + "splash.ico");
		// Вспомогательный файл: progress.gif.
		БиблиотекаКартинок.ДлительнаяОперация48.Записать(КаталогВременныхФайловОбновления + "progress.gif");
		// Главный файл заставки: splash.hta.
		ИмяГлавногоФайлаСкрипта = КаталогВременныхФайловОбновления + "splash.hta";
		ФайлСкрипта = Новый ТекстовыйДокумент;
		ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
		ФайлСкрипта.УстановитьТекст(ТекстыМакетов.ЗаставкаОбновленияКонфигурации);
		ФайлСкрипта.Записать(ИмяГлавногоФайлаСкрипта, КодировкаТекста.UTF16);
	Иначе
		ИмяГлавногоФайлаСкрипта = КаталогВременныхФайловОбновления + "updater.js";
		ФайлСкрипта = Новый ТекстовыйДокумент;
		ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
		ФайлСкрипта.УстановитьТекст(ТекстыМакетов.НеинтерактивноеОбновлениеКонфигурации);
		ФайлСкрипта.Записать(ИмяГлавногоФайлаСкрипта, КодировкаТекста.UTF16);
	КонецЕсли;
	
	Возврат ИмяГлавногоФайлаСкрипта;
	
КонецФункции

Функция ПолучитьПараметрыАутентификацииАдминистратораОбновления(ПараметрыАдминистрирования)
	
	Результат = Новый Структура("СтрокаПодключения, СтрокаСоединенияИнформационнойБазы");
	
	ПортКластера = ПараметрыАдминистрирования.ПортКластера;
	ТекущиеСоединения = СоединенияИБВызовСервера.ИнформацияОСоединениях(Истина,
		ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"], ПортКластера);
		
	Результат.СтрокаСоединенияИнформационнойБазы = ТекущиеСоединения.СтрокаСоединенияИнформационнойБазы;
	Результат.СтрокаПодключения = "Usr=""{0}"";Pwd=""{1}""";
	
	Возврат Результат;
	
КонецФункции

Функция УдалитьЗадачуПланировщика(КодЗадачи)
	
	Если КодЗадачи = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Не СуществуетЗадачаПланировщика(КодЗадачи) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ВерсияWindowsВышеVista() Тогда
		Возврат УдалитьЗадачуПланировщикаScheduleService(КодЗадачи);
	Иначе
		Возврат УдалитьЗадачуПланировщикаScheduledJob(КодЗадачи);
	КонецЕсли;
	
КонецФункции

Функция УдалитьЗадачуПланировщикаScheduledJob(КодЗадачи)
	
	Попытка
		
		Сервис = ОбъектWMI();
		Задача = ПолучитьЗадачуПланировщикаScheduledJob(КодЗадачи);
		КодОшибки = Задача.Delete();
		
	Исключение
		
		ТекстСообщения = НСтр("ru = 'Ошибка при удалении задачи планировщика: %1'");
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ОписаниеОшибки()));
		Возврат Ложь;
	КонецПопытки;
	
	Результат = КодОшибки = 0;
	Если Не Результат Тогда // Коды ошибок: http://msdn2.microsoft.com/en-us/library/aa389957(VS.85).aspx.
		ТекстСообщения = НСтр("ru = 'Ошибка при удалении задачи планировщика: %1'");
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, КодОшибки));
		Возврат Результат;
	КонецЕсли;
	ТекстСообщения = НСтр("ru = 'Задача планировщика успешно удалена (код задачи: %1).'");
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Информация",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, КодЗадачи));
	КодЗадачи = 0;
	
	Возврат Результат;
	
КонецФункции

Функция УдалитьЗадачуПланировщикаScheduleService(КодЗадачи)
	
	ИмяЗадачи = ИмяЗадачиScheduleService(КодЗадачи);
	
	Попытка
		
		СлужбаПланировщика = СлужбаПланировщика();
		Корень = СлужбаПланировщика.GetFolder("\");
		Результат = Корень.DeleteTask(ИмяЗадачи, 0);
		
	Исключение
		
		ТекстСообщения = НСтр("ru = 'Ошибка при удалении задачи планировщика: %1'");
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ОписаниеОшибки()));
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ОбъектWMI()
	// WMI: http://www.microsoft.com/technet/scriptcenter/resources/wmifaq.mspx.
	Локатор = Новый COMObject("WbemScripting.SWbemLocator");
	Возврат Локатор.ConnectServer(".", "\root\cimv2");
КонецФункции

Функция СоздатьЗадачуПланировщика(Знач ИмяФайлаПрограммы, Знач ДатаВремя)
	
	Если ВерсияWindowsВышеVista() Тогда
		Возврат СоздатьЗадачуПланировщикаScheduleService(ИмяФайлаПрограммы, ДатаВремя);
	Иначе
		Возврат СоздатьЗадачуПланировщикаScheduledJob(ИмяФайлаПрограммы, ДатаВремя);
	КонецЕсли;
	
КонецФункции

// Создать задачу планировщика ОС Windows.
//
// Параметры:
//  ИмяФайлаПрограммы	- Строка	- путь к запускаемому приложению или файлу.
//  ДатаВремя  			- Дата		- Дата и время запуска. Значение даты может быть 
//									  в интервале [текущая дата, текущая дата + 30 дней).
//
// Возвращаемое значение:
//   Число   - код созданной задачи планировщика или "Неопределено" при ошибке.
//
Функция СоздатьЗадачуПланировщикаScheduledJob(Знач ИмяФайлаПрограммы, Знач ДатаВремя)
	
	Попытка
		
		Планировщик = ОбъектWMI().Get("Win32_ScheduledJob");
		КодЗадачи = 0;
		КодОшибки = Планировщик.Create(ИмяФайлаПрограммы, // Command
			ПреобразоватьВремяВФорматCIM(ДатаВремя), // StartTime
			Ложь, // RunRepeatedly
			, // DaysOfWeek
			Pow(2, День(ДатаВремя) - 1), // DaysOfMonth
			Ложь, // InteractWithDesktop
			КодЗадачи); // out JobId
		
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ошибка при создании задачи планировщика: %1'"), ОписаниеОшибки());
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка", ТекстСообщения);
		Возврат 0;
	КонецПопытки;
	
	Если КодОшибки <> 0 Тогда // Коды ошибок: http://msdn2.microsoft.com/en-us/library/aa389389(VS.85).aspx.
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ошибка при создании задачи планировщика: %1'"), КодОшибки);
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка", ТекстСообщения);
		Возврат 0;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru = 'Задача планировщика успешно запланирована (команда: %1; дата: %2; код задачи: %3).'");
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(),
		"Информация", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ИмяФайлаПрограммы, ДатаВремя, КодЗадачи));
	
	Возврат КодЗадачи;
	
КонецФункции

Функция СоздатьЗадачуПланировщикаScheduleService(Знач ИмяФайлаПрограммы, Знач ДатаВремя)
	
	ГенераторСлучайныхЧисел = Новый ГенераторСлучайныхЧисел;
	КодЗадачи = Формат(ГенераторСлучайныхЧисел.СлучайноеЧисло(1000, 9999), "ЧГ=0");
	ИмяЗадачи = ИмяЗадачиScheduleService(КодЗадачи);
	ДатаЗапуска = Формат(ДатаВремя, "ДФ=yyyy-MM-ddTHH:mm:ss");
	
	РазделительИмениИПараметров = СтрНайти(ИмяФайлаПрограммы, ".exe") + 3;
	ИмяПрограммы = Лев(ИмяФайлаПрограммы, РазделительИмениИПараметров);
	ПараметрыЗапуска = Сред(ИмяФайлаПрограммы, РазделительИмениИПараметров + 2);
	
	Попытка
		
		СлужбаПланировщика = СлужбаПланировщика();
		ОписаниеЗадачи = СлужбаПланировщика.NewTask(0);
		ОписаниеЗадачи.RegistrationInfo.Description = НСтр("ru = 'Обновление конфигурации 1С:Предприятие'");
	
		ОписаниеЗадачи.Principal.RunLevel = 1;
		
		ОписаниеЗадачи.Settings.Enabled = Истина;
		ОписаниеЗадачи.Settings.Hidden = Ложь;
		
		Триггер = ОписаниеЗадачи.Triggers.Create(1);
		Триггер.StartBoundary = ДатаЗапуска;
		Триггер.Enabled = Истина;
		
		Действие = ОписаниеЗадачи.Actions.Create(0);
		Действие.Path = ИмяПрограммы;
		Действие.Arguments = ПараметрыЗапуска;
		
		Корень = СлужбаПланировщика.GetFolder("\");
		Задача = Корень.RegisterTaskDefinition(ИмяЗадачи, ОписаниеЗадачи, 6, "SYSTEM", Неопределено, 4);
		
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ошибка при создании задачи планировщика: %1'"), ОписаниеОшибки());
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка", ТекстСообщения);
		Возврат 0;
	КонецПопытки;
	
	Возврат КодЗадачи;
	
КонецФункции

Функция ИмяЗадачиScheduleService(Знач КодЗадачи)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Обновление конфигурации (%1)'"), Формат(КодЗадачи, "ЧГ=0"));
	
КонецФункции

Функция ПреобразоватьВремяВФорматCIM(ДатаВремя)
	Локатор			= Новый COMObject("WbemScripting.SWbemLocator");
	Сервис			= Локатор.ConnectServer(".", "\root\cimv2");
	ComputerSystems	= Сервис.ExecQuery("Select * from Win32_ComputerSystem");
	Для Каждого ComputerSystem Из ComputerSystems Цикл
		Разница	= ComputerSystem.CurrentTimeZone;
		Час		= Формат(ДатаВремя,"ДФ=ЧЧ");
		Минута	= Формат(ДатаВремя,"ДФ=мм");
		Разница	= ?(Разница > 0, "+" + Формат(Разница, "ЧГ=0"), Формат(Разница, "ЧГ=0"));
		Возврат "********" + Час + Минута + "00.000000" + Разница;
	КонецЦикла;

	Возврат Неопределено;
КонецФункции

Функция ОпределитьИмяСкрипта()
	App = Новый COMОбъект("Shell.Application");
	Попытка
		Folder = App.Namespace(41);
		Возврат Folder.Self.Path + "\wscript.exe";
	Исключение
		Возврат "wscript.exe";
	КонецПопытки;
КонецФункции

Функция СтрокаUnicode(Строка)
	
	Результат = "";
	
	Для НомерСимвола = 1 По СтрДлина(Строка) Цикл
		
		Символ = Формат(КодСимвола(Сред(Строка, НомерСимвола, 1)), "ЧГ=0");
		Символ = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Символ, 4);
		Результат = Результат + Символ;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция СуществуетЗадачаПланировщика(Знач КодЗадачи) Экспорт
	
	Если КодЗадачи = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ВерсияWindowsВышеVista() Тогда
		ЗадачаПланировщика = ПолучитьЗадачуПланировщикаScheduleService(КодЗадачи);
	Иначе
		ЗадачаПланировщика = ПолучитьЗадачуПланировщикаScheduledJob(КодЗадачи);
	КонецЕсли;
	
	Возврат ЗадачаПланировщика <> Неопределено;
	
КонецФункции

Функция ПолучитьЗадачуПланировщикаScheduledJob(Знач КодЗадачи)
	
	Попытка
		Возврат ОбъектWMI().Get("Win32_ScheduledJob.JobID=" + КодЗадачи);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

Функция ПолучитьЗадачуПланировщикаScheduleService(Знач КодЗадачи)
	
	НайденнаяЗадача = Неопределено;
	ИмяЗадачи = ИмяЗадачиScheduleService(КодЗадачи);
	
	СлужбаПланировщика = СлужбаПланировщика();
	Корень = СлужбаПланировщика.GetFolder("\");
	СписокЗадач = Корень.GetTasks(0);
	
	Для Каждого Задача Из СписокЗадач Цикл
		Если Задача.Name = ИмяЗадачи Тогда
			НайденнаяЗадача = Задача;
		КонецЕсли;
	КонецЦикла;
	
	Возврат НайденнаяЗадача;
	
КонецФункции

// Возвращает имя события для записи журнала регистрации.
Функция СобытиеЖурналаРегистрации() Экспорт
	Возврат НСтр("ru = 'Обновление конфигурации'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
КонецФункции

// Проверяет наличие обновления конфигурации при запуске программы.
//
Процедура ПроверитьОбновлениеКонфигурации()
	
	Если Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		Возврат;
	КонецЕсли;
	
#Если НЕ ВебКлиент Тогда
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиента.РазделениеВключено Или Не ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиОбновления = ПараметрыРаботыКлиента.НастройкиОбновления;
	НаличиеОбновления = НастройкиОбновления.ПроверитьПрошлыеОбновленияБазы;
	
	Если НаличиеОбновления Тогда
		// Надо завершить предыдущее обновление.
		ПоказатьПоискИУстановкуОбновлений();
		Возврат;
	КонецЕсли;
	
	Если НастройкиОбновления.КонфигурацияИзменена Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление конфигурации'"),
			"e1cib/app/Обработка.УстановкаОбновлений",
			НСтр("ru = 'Конфигурация отличается от основной конфигурации информационной базы.'"), 
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
#КонецЕсли

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы.

// Проверяет легальность получения обновления. При отсутствии подсистемы
// проверки легальности возвращает Истина.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - содержит обработчик,
//               вызываемый после подтверждения легальности получения обновления.
//
Функция ПроверитьЛегальностьПолученияОбновления(Оповещение) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПроверкаЛегальностиПолученияОбновления") Тогда
		МодульПроверкаЛегальностиПолученияОбновленияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроверкаЛегальностиПолученияОбновленияКлиент");
		МодульПроверкаЛегальностиПолученияОбновленияКлиент.ПоказатьПроверкуЛегальностиПолученияОбновления(Оповещение);
	Иначе
		ВыполнитьОбработкуОповещения(Оповещение, Истина);
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП.

// Доопределяет список предупреждений пользователю перед завершением работы системы.
//
// Параметры:
//  Отказ - Булево - Признак отказа от выхода из программы. Если в теле процедуры-обработчика установить
//                   данному параметру значение Истина, то работа с программой не будет завершена.
//  Предупреждения - Массив - в массив можно добавить элементы типа Структура,
//                            свойства которой см. в СтандартныеПодсистемыКлиент.ПредупреждениеПриЗавершенииРаботы.
//
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
	// Предупреждение: при выставлении своего флажка подсистема "Обновление конфигурации" очищает список
	// всех ранее добавленных предупреждений.
	Если ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьОбновлениеИнформационнойБазыПриЗавершенииСеанса"] = Истина Тогда
		ПараметрыПредупреждения = СтандартныеПодсистемыКлиент.ПредупреждениеПриЗавершенииРаботы();
		ПараметрыПредупреждения.ТекстФлажка  = НСтр("ru = 'Установить обновление конфигурации'");
		ПараметрыПредупреждения.ТекстПредупреждения  = НСтр("ru = 'Запланирована установка обновления'");
		ПараметрыПредупреждения.Приоритет = 50;
		ПараметрыПредупреждения.ВывестиОдноПредупреждение = Истина;
		
		ДействиеПриУстановленномФлажке = ПараметрыПредупреждения.ДействиеПриУстановленномФлажке;
		ДействиеПриУстановленномФлажке.Форма = "Обработка.УстановкаОбновлений.Форма.Форма";
		ДействиеПриУстановленномФлажке.ПараметрыФормы = Новый Структура("ЗавершениеРаботыСистемы, ВыполнитьОбновление", Истина, Истина);
		
		Предупреждения.Добавить(ПараметрыПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при интерактивном начале работы пользователя с областью данных.
// Соответствует событию ПриНачалеРаботыСистемы модулей приложения.
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПроверитьОбновлениеКонфигурации();
	
КонецПроцедуры

#КонецОбласти