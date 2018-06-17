﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Функции и процедуры для работы с хранилищем сертификатов".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция ПолучитьСертификаты(Хранилище = Неопределено) Экспорт
	
	Сертификаты = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХранилищеСертификатовБРО.ЛогическоеХранилище,
	|	ХранилищеСертификатовБРО.Отпечаток,
	|	ХранилищеСертификатовБРО.ДействителенС,
	|	ХранилищеСертификатовБРО.ДействителенДо,
	|	ХранилищеСертификатовБРО.Издатель,
	|	ХранилищеСертификатовБРО.СерийныйНомер,
	|	ХранилищеСертификатовБРО.Субъект,
	|	ХранилищеСертификатовБРО.Наименование,
	|	ХранилищеСертификатовБРО.ИспользоватьДляПодписи,
	|	ХранилищеСертификатовБРО.ИспользоватьДляШифрования,
	|	ИСТИНА КАК ЭтоЭлектроннаяПодписьВМоделиСервиса
	|ИЗ
	|	РегистрСведений.ХранилищеСертификатовБРО КАК ХранилищеСертификатовБРО
	|ГДЕ
	|	ХранилищеСертификатовБРО.ЛогическоеХранилище В(&ЛогическиеХранилища)";
	Запрос.УстановитьПараметр("ЛогическиеХранилища", ОтборЛогическоеХранилище(Хранилище));
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Новый Массив;
	Иначе
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			СвойстваСертификата = Новый Структура;
			СвойстваСертификата.Вставить("Отпечаток"            , Выборка.Отпечаток);
			СвойстваСертификата.Вставить("ДействителенС"        , Выборка.ДействителенС);
			СвойстваСертификата.Вставить("ДействителенПо"       , Выборка.ДействителенДо);
			СвойстваСертификата.Вставить("Поставщик"            , Выборка.Издатель);
			СвойстваСертификата.Вставить("СерийныйНомер"        , Выборка.СерийныйНомер);
			СвойстваСертификата.Вставить("Владелец"             , Выборка.Субъект);
			СвойстваСертификата.Вставить("Наименование"         , Выборка.Наименование);
			СвойстваСертификата.Вставить("ИспользоватьДляПодписи"   , Выборка.ИспользоватьДляПодписи);
			СвойстваСертификата.Вставить("ИспользоватьДляШифрования", Выборка.ИспользоватьДляШифрования);		
			СвойстваСертификата.Вставить("Хранилище"             , XMLСтрока(Выборка.ЛогическоеХранилище));
			СвойстваСертификата.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса", Выборка.ЭтоЭлектроннаяПодписьВМоделиСервиса);
			
			Сертификаты.Добавить(Новый ФиксированнаяСтруктура(СвойстваСертификата));
		КонецЦикла;
	КонецЕсли;
	
	Возврат Сертификаты;

КонецФункции

Функция НайтиСертификаты(Сертификаты, ВыполнятьПроверку = Ложь) Экспорт

	СерийныеНомера = Новый Массив;
	Поставщики = Новый Массив;
	Отпечатки = Новый Массив;
	Для Каждого Сертификат Из Сертификаты Цикл
		Если Сертификат.Свойство("СерийныйНомер") И Сертификат.Свойство("Поставщик") 
			И ЗначениеЗаполнено(Сертификат.СерийныйНомер) И ЗначениеЗаполнено(Сертификат.Поставщик) Тогда
			СерийныеНомера.Добавить(Сертификат.СерийныйНомер);
			Поставщики.Добавить(Сертификат.Поставщик);		
		ИначеЕсли ЗначениеЗаполнено(Сертификат.Отпечаток) Тогда
			Отпечатки.Добавить(Сертификат.Отпечаток);
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ХранилищеСертификатовБРО.ЛогическоеХранилище,
	|	ХранилищеСертификатовБРО.Отпечаток,
	|	ХранилищеСертификатовБРО.Сертификат,
	|	ХранилищеСертификатовБРО.Версия,
	|	ХранилищеСертификатовБРО.ДействителенС,
	|	ХранилищеСертификатовБРО.ДействителенДо КАК ДействителенПо,
	|	ХранилищеСертификатовБРО.Издатель КАК Поставщик,
	|	ХранилищеСертификатовБРО.СерийныйНомер,
	|	ХранилищеСертификатовБРО.Субъект КАК Владелец,
	|	ХранилищеСертификатовБРО.Наименование,
	|	ХранилищеСертификатовБРО.ИспользоватьДляПодписи,
	|	ХранилищеСертификатовБРО.ИспользоватьДляШифрования,
	|	ИСТИНА КАК ЭтоЭлектроннаяПодписьВМоделиСервиса
	|ИЗ
	|	РегистрСведений.ХранилищеСертификатовБРО КАК ХранилищеСертификатовБРО
	|ГДЕ
	|	(ХранилищеСертификатовБРО.Отпечаток В (&Отпечатки)
	|			ИЛИ ХранилищеСертификатовБРО.Издатель В (&Поставщики)
	|				И ХранилищеСертификатовБРО.СерийныйНомер В (&СерийныеНомера))";
	Запрос.УстановитьПараметр("СерийныеНомера", СерийныеНомера);
	Запрос.УстановитьПараметр("Поставщики", Поставщики);
	Запрос.УстановитьПараметр("Отпечатки", Отпечатки);
	
	СертификатыДляПоиска = Запрос.Выполнить().Выгрузить();
	СписокСвойств = Новый Массив;
	Для Каждого Колонка Из СертификатыДляПоиска.Колонки Цикл
		СписокСвойств.Добавить(Колонка.Имя);
	КонецЦикла;
	СписокСвойствСтрокой = СтрСоединить(СписокСвойств, ",");
	
	НайденныеСертификаты = Новый Массив;
	НенайденныеСертификаты = Новый Массив;
	
	Для Каждого Сертификат Из Сертификаты Цикл
		Если Сертификат.Свойство("СерийныйНомер") И Сертификат.Свойство("Поставщик") 
			И ЗначениеЗаполнено(Сертификат.СерийныйНомер) И ЗначениеЗаполнено(Сертификат.Поставщик) Тогда
			ОтборПоСертификату = Новый Структура("СерийныйНомер, Поставщик", Сертификат.СерийныйНомер, Сертификат.Поставщик);
		ИначеЕсли ЗначениеЗаполнено(Сертификат.Отпечаток) Тогда
			ОтборПоСертификату = Новый Структура("Отпечаток", Сертификат.Отпечаток);
		Иначе
			НенайденныеСертификаты.Добавить(Сертификат);
			Продолжить;
		КонецЕсли;
		
		НайденныеСтроки = СертификатыДляПоиска.НайтиСтроки(ОтборПоСертификату);
		Если НайденныеСтроки.Количество() = 1 Тогда
			СвойстваСертификата = Новый Структура(СписокСвойствСтрокой);
			ЗаполнитьЗначенияСвойств(СвойстваСертификата, НайденныеСтроки[0]);
			Если ВыполнятьПроверку Тогда
				СертификатВалиден = КриптосервисВМоделиСервиса.ПроверитьСертификат(СвойстваСертификата);
				СвойстваСертификата.Вставить("Валиден", СертификатВалиден);
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(СвойстваСертификата, НайденныеСтроки[0]);
			НайденныеСертификаты.Добавить(СвойстваСертификата);
		Иначе
			НенайденныеСертификаты.Добавить(Сертификат); 
		КонецЕсли;	
	КонецЦикла;

	Возврат Новый Структура("Сертификаты,НенайденныеСертификаты", НайденныеСертификаты, НенайденныеСертификаты);
	 
КонецФункции

Функция ОтпечатокСертификатаПоСерийномуНомеруИПоставщику(СерийныйНомер, Поставщик) Экспорт
	
	Если Не ЗначениеЗаполнено(СерийныйНомер) 
		ИЛИ Не ЗначениеЗаполнено(Поставщик) Тогда
		Возврат "";
	Иначе 
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ХранилищеСертификатовБРО.Отпечаток
		|ИЗ
		|	РегистрСведений.ХранилищеСертификатовБРО КАК ХранилищеСертификатовБРО
		|ГДЕ
		|	ХранилищеСертификатовБРО.СерийныйНомер = &СерийныйНомер
		|	И ХранилищеСертификатовБРО.Издатель = &Поставщик";
		Запрос.УстановитьПараметр("СерийныйНомер", СерийныйНомер);
		Запрос.УстановитьПараметр("Поставщик", Поставщик);
		
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Возврат "";
		Иначе
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			Возврат Выборка.Отпечаток;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСвойстваСертификатаПоОтпечатку(Отпечаток, Хранилище = Неопределено, ВыполнятьПроверку = Ложь) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Отпечаток) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХранилищеСертификатовБРО.ЛогическоеХранилище,
	|	ХранилищеСертификатовБРО.Отпечаток,
	|	ХранилищеСертификатовБРО.Сертификат,
	|	ХранилищеСертификатовБРО.ДействителенС,
	|	ХранилищеСертификатовБРО.ДействителенДо,
	|	ХранилищеСертификатовБРО.Издатель,
	|	ХранилищеСертификатовБРО.СерийныйНомер,
	|	ХранилищеСертификатовБРО.Субъект,
	|	ХранилищеСертификатовБРО.Наименование,
	|	ХранилищеСертификатовБРО.ИспользоватьДляПодписи,
	|	ХранилищеСертификатовБРО.ИспользоватьДляШифрования
	|ИЗ
	|	РегистрСведений.ХранилищеСертификатовБРО КАК ХранилищеСертификатовБРО
	|ГДЕ
	|	ХранилищеСертификатовБРО.Отпечаток ПОДОБНО &Отпечаток
	|	И ХранилищеСертификатовБРО.ЛогическоеХранилище В(&ЛогическиеХранилища)";
	Запрос.УстановитьПараметр("Отпечаток", Отпечаток);
	Запрос.УстановитьПараметр("ЛогическиеХранилища", ОтборЛогическоеХранилище(Хранилище));
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		СвойстваСертификата = Новый Структура;
		СвойстваСертификата.Вставить("Отпечаток"            , Выборка.Отпечаток);
		СвойстваСертификата.Вставить("ДействителенС"        , Выборка.ДействителенС);
		СвойстваСертификата.Вставить("ДействителенПо"       , Выборка.ДействителенДо);
		СвойстваСертификата.Вставить("Поставщик"            , Выборка.Издатель);
		СвойстваСертификата.Вставить("СерийныйНомер"        , Выборка.СерийныйНомер);
		СвойстваСертификата.Вставить("Владелец"             , Выборка.Субъект);
		СвойстваСертификата.Вставить("Наименование"         , Выборка.Наименование);
		СвойстваСертификата.Вставить("ВозможностьПодписи"   , Выборка.ИспользоватьДляПодписи);
		СвойстваСертификата.Вставить("ВозможностьШифрования", Выборка.ИспользоватьДляШифрования);
		Если ВыполнятьПроверку Тогда
			СвойстваСертификата.Вставить("Валиден", КриптосервисВМоделиСервиса.ПроверитьСертификат(Выборка.Сертификат.Получить()));
		КонецЕсли;
		
		Возврат СвойстваСертификата;		
	КонецЕсли;
	
КонецФункции

Функция ЗарегистрироватьСертификат(Сертификат, ЛогическоеХранилище) Экспорт
	
	СвойстваСертификата = КриптосервисВМоделиСервиса.ПолучитьСвойстваСертификата(Сертификат);
	
	МенеджерЗаписи = РегистрыСведений.ХранилищеСертификатовБРО.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ЛогическоеХранилище = ЛогическоеХранилище;
	МенеджерЗаписи.Отпечаток = НРег(СвойстваСертификата.Отпечаток);
	
	МенеджерЗаписи.Сертификат = Новый ХранилищеЗначения(Сертификат);
	МенеджерЗаписи.Версия                    = СвойстваСертификата.Версия;
	МенеджерЗаписи.ДействителенС             = СвойстваСертификата.ДействителенС;
	МенеджерЗаписи.ДействителенДо            = СвойстваСертификата.ДействителенПо;
	МенеджерЗаписи.Издатель                  = СвойстваСертификата.Поставщик;
	МенеджерЗаписи.СерийныйНомер             = СвойстваСертификата.СерийныйНомер;
	МенеджерЗаписи.Субъект                   = СвойстваСертификата.Владелец;
	МенеджерЗаписи.Наименование              = СвойстваСертификата.Наименование;
	МенеджерЗаписи.ИспользоватьДляПодписи    = СвойстваСертификата.ИспользоватьДляПодписи;
	МенеджерЗаписи.ИспользоватьДляШифрования = СвойстваСертификата.ИспользоватьДляШифрования;
	МенеджерЗаписи.Записать();
		
	Возврат СвойстваСертификата;
	
КонецФункции

Функция ПолучитьСвойстваСертификатовПоОтпечаткам(Отпечатки, Хранилище = Неопределено, ВыполнятьПроверку = Ложь) Экспорт
	
	Сертификаты = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХранилищеСертификатовБРО.ЛогическоеХранилище,
	|	ХранилищеСертификатовБРО.Отпечаток,
	|	ХранилищеСертификатовБРО.Сертификат,
	|	ХранилищеСертификатовБРО.ДействителенС,
	|	ХранилищеСертификатовБРО.ДействителенДо,
	|	ХранилищеСертификатовБРО.Издатель,
	|	ХранилищеСертификатовБРО.СерийныйНомер,
	|	ХранилищеСертификатовБРО.Субъект,
	|	ХранилищеСертификатовБРО.Наименование,
	|	ХранилищеСертификатовБРО.ИспользоватьДляПодписи,
	|	ХранилищеСертификатовБРО.ИспользоватьДляШифрования
	|ИЗ
	|	РегистрСведений.ХранилищеСертификатовБРО КАК ХранилищеСертификатовБРО
	|ГДЕ
	|	ХранилищеСертификатовБРО.Отпечаток В(&Отпечатки)
	|	И ХранилищеСертификатовБРО.ЛогическоеХранилище В(&ЛогическиеХранилища)";
	Запрос.УстановитьПараметр("Отпечатки", Отпечатки);
	Запрос.УстановитьПараметр("ЛогическиеХранилища", ОтборЛогическоеХранилище(Хранилище));
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Новый Массив;
	Иначе
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			СвойстваСертификата = Новый Структура;
			СвойстваСертификата.Вставить("Отпечаток"            , Выборка.Отпечаток);
			СвойстваСертификата.Вставить("ДействителенС"        , Выборка.ДействителенС);
			СвойстваСертификата.Вставить("ДействителенПо"       , Выборка.ДействителенДо);
			СвойстваСертификата.Вставить("Поставщик"            , Выборка.Издатель);
			СвойстваСертификата.Вставить("СерийныйНомер"        , Выборка.СерийныйНомер);
			СвойстваСертификата.Вставить("Владелец"             , Выборка.Субъект);
			СвойстваСертификата.Вставить("Наименование"         , Выборка.Наименование);
			СвойстваСертификата.Вставить("ВозможностьПодписи"   , Выборка.ИспользоватьДляПодписи);
			СвойстваСертификата.Вставить("ВозможностьШифрования", Выборка.ИспользоватьДляШифрования);
			Если ВыполнятьПроверку Тогда
				СвойстваСертификата.Вставить("Валиден", КриптосервисВМоделиСервиса.ПроверитьСертификат(Выборка.Сертификат.Получить()));
			КонецЕсли;
						
			Сертификаты.Вставить(СвойстваСертификата.Отпечаток, СвойстваСертификата);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Сертификаты;
	
КонецФункции

Функция ПолучитьСертификат(СвойстваСертификата) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХранилищеСертификатовБРО.Сертификат
	|ИЗ
	|	РегистрСведений.ХранилищеСертификатовБРО КАК ХранилищеСертификатовБРО
	|ГДЕ
	|	ХранилищеСертификатовБРО.Отпечаток = &Отпечаток";
	Запрос.УстановитьПараметр("Отпечаток", СвойстваСертификата.Отпечаток);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Возврат ДвоичныеДанныеСертификата(Выборка.Сертификат.Получить());		
	КонецЕсли;
	
КонецФункции

Функция ПроверитьСертификат(Сертификат) Экспорт
	
	Возврат Истина;
	
КонецФункции

Функция ДвоичныеДанныеСертификата(ИсходныйСертификат) Экспорт
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(".cer");
	ИсходныйСертификат.Записать(ИмяВременногоФайла);
	
	Текст = Новый ТекстовыйДокумент;
	Текст.Прочитать(ИмяВременногоФайла);
	СертификатТекст = Текст.ПолучитьТекст();
	
	Попытка
		УдалитьФайлы(ИмяВременногоФайла);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Хранилище сертификатов в модели сервиса.Ошибка при удалении файла'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
		
	Если СтрНайти(СертификатТекст, "-----BEGIN CERTIFICATE-----") > 0 Тогда
		СертификатТекст = СтрЗаменить(СертификатТекст, "-----BEGIN CERTIFICATE-----", "");
		СертификатТекст = СтрЗаменить(СертификатТекст, "-----END CERTIFICATE-----", "");
		Возврат Base64Значение(СертификатТекст);
	Иначе
		
		Возврат ИсходныйСертификат;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОтборЛогическоеХранилище(Хранилище)
	
	ЛогическиеХранилища = Новый Массив;
	Если Не ЗначениеЗаполнено(Хранилище) Тогда
		ЛогическиеХранилища.Добавить(Перечисления.ЛогическиеХранилищаСертификатов.MY);
		ЛогическиеХранилища.Добавить(Перечисления.ЛогическиеХранилищаСертификатов.AddressBook);
		ЛогическиеХранилища.Добавить(Перечисления.ЛогическиеХранилищаСертификатов.CA);
		ЛогическиеХранилища.Добавить(Перечисления.ЛогическиеХранилищаСертификатов.ROOT);
	ИначеЕсли ТипЗнч(Хранилище) = Тип("Структура") Тогда
		Для Каждого ЭлементСтруктуры Из Хранилище Цикл
			ЛогическиеХранилища.Добавить(XMLЗначение(Тип("ПеречислениеСсылка.ЛогическиеХранилищаСертификатов"), ЭлементСтруктуры.Ключ));
		КонецЦикла;
	ИначеЕсли ТипЗнч(Хранилище) = Тип("Массив") Тогда
		Для Каждого ЭлементМассива Из Хранилище Цикл
			ЛогическиеХранилища.Добавить(XMLЗначение(Тип("ПеречислениеСсылка.ЛогическиеХранилищаСертификатов"), ЭлементМассива));
		КонецЦикла;
	ИначеЕсли ТипЗнч(Хранилище) = Тип("Строка") Тогда
		СтруктураХранилища = Новый Структура(Хранилище);
		Для Каждого ЭлементСтруктуры Из СтруктураХранилища Цикл
			ЛогическиеХранилища.Добавить(XMLЗначение(Тип("ПеречислениеСсылка.ЛогическиеХранилищаСертификатов"), ЭлементСтруктуры.Ключ));
		КонецЦикла;
	ИначеЕсли ТипЗнч(Хранилище) = Тип("ПеречислениеСсылка.ЛогическиеХранилищаСертификатов") Тогда
		Возврат Хранилище;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ЛогическиеХранилища;	
	
КонецФункции

#КонецОбласти