﻿///////////////////////////////////////////////////////////////////////////////////
// РаботаВМоделиСервисаПовтИсп.
//
///////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает массив сериализуемых структурных типов, поддерживаемых в настоящее время.
//
// Возвращаемое значение:
// Фиксированный массив элементов типа Тип.
//
Функция СериализуемыеСтруктурныеТипы() Экспорт
	
	МассивТипов = Новый Массив;
	
	МассивТипов.Добавить(Тип("Структура"));
	МассивТипов.Добавить(Тип("ФиксированнаяСтруктура"));
	МассивТипов.Добавить(Тип("Массив"));
	МассивТипов.Добавить(Тип("ФиксированныйМассив"));
	МассивТипов.Добавить(Тип("Соответствие"));
	МассивТипов.Добавить(Тип("ФиксированноеСоответствие"));
	МассивТипов.Добавить(Тип("КлючИЗначение"));
	МассивТипов.Добавить(Тип("ТаблицаЗначений"));
	
	Возврат Новый ФиксированныйМассив(МассивТипов);
	
КонецФункции

// Возвращает конечную точку для отправки сообщений в менеджер сервиса.
//
// Возвращаемое значение:
//  ПланОбменСсылка.ОбменСообщениями - узел соответствующий менеджеру сервиса.
//
Функция КонечнаяТочкаМенеджераСервиса() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.КонечнаяТочкаМенеджераСервиса.Получить();
	
КонецФункции

// Возвращает соответствие видов контактной информации пользователя видам.
// КИ используемой в XDTO модели сервиса.
//
// Возвращаемое значение:
//  Соответствие - соответствие видов КИ.
//
Функция СоответствиеВидовКИПользователяXDTO() Экспорт
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить(Справочники.ВидыКонтактнойИнформации.EmailПользователя, "UserEMail");
	Соответствие.Вставить(Справочники.ВидыКонтактнойИнформации.ТелефонПользователя, "UserPhone");
	
	Возврат Новый ФиксированноеСоответствие(Соответствие);
	
КонецФункции

// Возвращает соответствие видов контактной информации XDTO видам.
// КИ пользователя.
//
// Возвращаемое значение:
//  Соответствие - соответствие видов КИ.
//
Функция СоответствиеВидовКИXDTOВидамКИПользователя() Экспорт
	
	Соответствие = Новый Соответствие;
	Для каждого КлючИЗначение Из РаботаВМоделиСервисаПовтИсп.СоответствиеВидовКИПользователяXDTO() Цикл
		Соответствие.Вставить(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Соответствие);
	
КонецФункции

// Возвращает соответствие прав XDTO используемым в модели сервиса возможным
// действиям с пользователем сервиса.
// 
// Возвращаемое значение:
//  Соответствие - соответствие прав действиям.
//
Функция СоответствиеПравXDTOДействиямСПользователемСервиса() Экспорт
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("ChangePassword", "ИзменениеПароля");
	Соответствие.Вставить("ChangeName", "ИзменениеИмени");
	Соответствие.Вставить("ChangeFullName", "ИзменениеПолногоИмени");
	Соответствие.Вставить("ChangeAccess", "ИзменениеДоступа");
	Соответствие.Вставить("ChangeAdmininstrativeAccess", "ИзменениеАдминистративногоДоступа");
	
	Возврат Новый ФиксированноеСоответствие(Соответствие);
	
КонецФункции

// Возвращает описание модели данных, относящихся к области данных.
//
// Возвращаемое значение:
//  ФиксированноеСоответствие,
//    Ключ - ОбъектМетаданных,
//    Значение - Строка, имя общего реквизита-разделителя.
//
Функция ПолучитьМодельДанныхОбласти() Экспорт
	
	Результат = Новый Соответствие();
	
	РазделительОсновныхДанных = ОбщегоНазначенияПовтИсп.РазделительОсновныхДанных();
	ОсновныеДанныеОбласти = ОбщегоНазначенияПовтИсп.РазделенныеОбъектыМетаданных(
		РазделительОсновныхДанных);
	Для Каждого ЭлементОсновныхДанныхОбласти Из ОсновныеДанныеОбласти Цикл
		Результат.Вставить(ЭлементОсновныхДанныхОбласти.Ключ, ЭлементОсновныхДанныхОбласти.Значение);
	КонецЦикла;
	
	РазделительВспомогательныхДанных = ОбщегоНазначенияПовтИсп.РазделительВспомогательныхДанных();
	ВспомогательныеДанныеОбласти = ОбщегоНазначенияПовтИсп.РазделенныеОбъектыМетаданных(
		РазделительВспомогательныхДанных);
	Для Каждого ЭлементВспомогательныхДанныхОбласти Из ВспомогательныеДанныеОбласти Цикл
		Результат.Вставить(ЭлементВспомогательныхДанныхОбласти.Ключ, ЭлементВспомогательныхДанныхОбласти.Значение);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

#КонецОбласти
