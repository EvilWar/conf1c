﻿///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ СВЯЗАННЫЕ С РЕГЛАМЕНТИРОВАННОЙ ОТЧЕТНОСТЬЮ ПО ЕНВД

// функция находит документ ПоказателиЕНВД, соответствующей Организации за требуемый период
//
Функция ПолучитьДокументПоказателейЕНВД(Организация, ДатаПериода) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПоказателиЕНВДДок.Ссылка
	|ИЗ
	|	Документ.ПоказателиЕНВД КАК ПоказателиЕНВДДок
	|ГДЕ
	|	ПоказателиЕНВДДок.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ПоказателиЕНВДДок.Организация = &Организация
	|	И НЕ ПоказателиЕНВДДок.ПометкаУдаления");
	
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаНачала", НачалоКвартала(ДатаПериода));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецКвартала(ДатаПериода));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат СоздатьДокументПоказателейЕНВД(Организация,ДатаПериода);
	КонецЕсли;
	
КонецФункции

// создает, заполняет, записывает и проводит документ Показателей ЕНВД
// по определенной организации за требуемый период
Функция СоздатьДокументПоказателейЕНВД(Организация, ДатаПериода) Экспорт
	
	Объект = Документы.ПоказателиЕНВД.СоздатьДокумент();
	Объект.Организация = Организация;
	Объект.Дата = КонецКвартала(ДатаПериода);
	Объект.ЗаполнитьДанныеДокумента();
	Объект.Записать();
	
	Возврат Объект.Ссылка;
	
КонецФункции

// Процедура формирует декларацию по УСН
//
// Параметры:
//		Организация - СправочникСсылка - Организация, по которой необходимо провести формирования
//		ПериодРасчета - Дата - дата окончания квартала, за который нужно провести формирования
//		СобытиеКалендаря - СправочникСсылка.КалендарьПодготовкиОтчетности - событие, по которому зафиксировать 
//			статус того, что событие рассчитано
//
Функция СформироватьДекларациюПоЕНВД(Организация, ПериодРасчета, СобытиеКалендаря = Неопределено) Экспорт
	
	СтруктураДекларацииПоЕНВД = Новый Структура(
		"Организация,
		|СобытиеКалендаря,
		|ДокументОтчетности,
		|ДатаДокументаОбработкиСобытия,
		|ПараметрыФормыДокумента", 
		Организация,
		СобытиеКалендаря,
		Неопределено,
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СобытиеКалендаря, "ДатаДокументаОбработкиСобытия"));
	
	Если СобытиеКалендаря = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Формирование декларации по ЕНВД невозможно без соответствующего события календаря'");
	КонецЕсли;
	
	СтруктураДекларацииПоЕНВД.ДокументОтчетности = РегламентированнаяОтчетностьУСН.ПолучитьДокументРегламентированнойОтчетностиПоСобытиюКалендаря(Организация, СобытиеКалендаря);
	
	Если СтруктураДекларацииПоЕНВД.ДокументОтчетности <> Неопределено Тогда
		СтруктураДекларацииПоЕНВД.ПараметрыФормыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			СтруктураДекларацииПоЕНВД.ДокументОтчетности,
			"ДатаНачала,ДатаОкончания,Периодичность,ВыбраннаяФорма");
			Если Год(СтруктураДекларацииПоЕНВД.ДатаДокументаОбработкиСобытия)> 2013 И СтруктураДекларацииПоЕНВД.ПараметрыФормыДокумента.ВыбраннаяФорма = "ФормаОтчета2012Кв1"
				ИЛИ Год(СтруктураДекларацииПоЕНВД.ДатаДокументаОбработкиСобытия)> 2014 И СтруктураДекларацииПоЕНВД.ПараметрыФормыДокумента.ВыбраннаяФорма = "ФормаОтчета2013Кв4" 
				ИЛИ Год(СтруктураДекларацииПоЕНВД.ДатаДокументаОбработкиСобытия)> 2015 И СтруктураДекларацииПоЕНВД.ПараметрыФормыДокумента.ВыбраннаяФорма = "ФормаОтчета2015Кв1"
				ИЛИ Год(СтруктураДекларацииПоЕНВД.ДатаДокументаОбработкиСобытия)> 2016 И СтруктураДекларацииПоЕНВД.ПараметрыФормыДокумента.ВыбраннаяФорма = "ФормаОтчета2016Кв1" Тогда
				// Форма документа отчетности не соответствует периоду формирования
				ДокументОбъект = СтруктураДекларацииПоЕНВД.ДокументОтчетности.ПолучитьОбъект();
				ДокументОбъект.УстановитьПометкуУдаления(Истина);
				ДокументОбъект.Записать();
				
				СтруктураДекларацииПоЕНВД.ДокументОтчетности = Неопределено;
				СтруктураДекларацииПоЕНВД.ПараметрыФормыДокумента = Неопределено;
			КонецЕсли;
	КонецЕсли;
	
	КалендарьОтчетности.ЗаписатьСостояниеСобытияКалендаря(
		Организация,
		СобытиеКалендаря,
		Перечисления.СостоянияСобытийКалендаря.Отправить,
		"");
	
	Возврат СтруктураДекларацииПоЕНВД;
	
КонецФункции

// Процедура формирует записи по расчету ЕНВД налога
//
// Параметры:
//		Организация - СправочникСсылка - Организация, по которой необходимо провести формирования
//		ПериодРасчета - Дата - дата окончания квартала, за который нужно провести формирования
//		СобытиеКалендаря - СправочникСсылка.КалендарьПодготовкиОтчетности - событие, по которому зафиксировать 
//			статус того, что событие рассчитано
//
Функция ВыполнитьРасчетЕНВД(Организация, ПериодРасчета, СобытиеКалендаря = Неопределено) Экспорт
	
	СтруктураРасчетаЕНВД = Новый Структура(
		"Организация,
		|СобытиеКалендаря,
		|ПериодОтчетности,
		|К1ЕНВД,
		|хзТаблицаЕНВД,
		|хзТаблицаЕНВДПоОкато,
		|УплаченоСтраховыхВзносовЕНВД,
		|ВидВзаиморасчетовСБюджетом,
		|ОКАТОВзаиморасчетов,
		|СуммаВзаиморасчетовСБюджетом,
		|ДокументВзаиморасчетовСБюджетом",
		Организация,
		СобытиеКалендаря,
		ПериодРасчета,
		0,
		Неопределено,
		Неопределено,
		0,
		Справочники.ВидыНалогов.ЕНВД,
		"",
		0,
		Неопределено);
	
	
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "ЮридическоеФизическоеЛицо,ИПИспользуетТрудНаемныхРаботников");
	ИспользуетсяТрудНаемныхРаботников = (РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо) ИЛИ РеквизитыОрганизации.ИПИспользуетТрудНаемныхРаботников;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПоказателиЕНВДПоказателиЕНВД.ВидДеятельностиЕНВД.КодПоОКАТО КАК КодОКАТО,
	|	ПоказателиЕНВДПоказателиЕНВД.ВидДеятельностиЕНВД.Ссылка КАК ВидДеятельности,
	|	ПоказателиЕНВДПоказателиЕНВД.ВидДеятельностиЕНВД.ВидПредпринимательскойДеятельности.БазоваяДоходность КАК БазоваяДоходность,
	|	ПоказателиЕНВДПоказателиЕНВД.ЗначениеФизическогоПоказателя1 + ПоказателиЕНВДПоказателиЕНВД.ЗначениеФизическогоПоказателя2 + ПоказателиЕНВДПоказателиЕНВД.ЗначениеФизическогоПоказателя3 КАК ФизПоказатель,
	|	ПоказателиЕНВДПоказателиЕНВД.ВидДеятельностиЕНВД.КоэффициентК2 КАК КоэффициентК2,
	|	ПоказателиЕНВДПоказателиЕНВД.ВидДеятельностиЕНВД.СтавкаЕНВД КАК СтавкаЕНВД,
	|	ПоказателиЕНВДПоказателиЕНВД.ВыработкаДней1 + ПоказателиЕНВДПоказателиЕНВД.ВыработкаДней2 + ПоказателиЕНВДПоказателиЕНВД.ВыработкаДней3 КАК ВыработкаДней,
	|	ПоказателиЕНВДПоказателиЕНВД.Ссылка.ДнейВсего1 + ПоказателиЕНВДПоказателиЕНВД.Ссылка.ДнейВсего2 + ПоказателиЕНВДПоказателиЕНВД.Ссылка.ДнейВсего3 КАК ДнейВсего,
	|	ПоказателиЕНВДПоказателиЕНВД.ВидДеятельностиЕНВД.КодНалоговогоОрганаПолучателя КАК КодИФНС,
	|	ВЫБОР
	|		КОГДА ПоказателиЕНВДПоказателиЕНВД.ВидДеятельностиЕНВД.ДатаНачала = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА &НачалоПериода
	|		ИНАЧЕ ПоказателиЕНВДПоказателиЕНВД.ВидДеятельностиЕНВД.ДатаНачала
	|	КОНЕЦ КАК ДатаНачала,
	|	ВЫБОР
	|		КОГДА ПоказателиЕНВДПоказателиЕНВД.ВидДеятельностиЕНВД.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|				ИЛИ ПоказателиЕНВДПоказателиЕНВД.ВидДеятельностиЕНВД.Актуально
	|			ТОГДА &ОкончаниеПериода
	|		ИНАЧЕ ПоказателиЕНВДПоказателиЕНВД.ВидДеятельностиЕНВД.ДатаОкончания
	|	КОНЕЦ КАК ДатаОкончания
	|ИЗ
	|	Документ.ПоказателиЕНВД.ПоказателиЕНВД КАК ПоказателиЕНВДПоказателиЕНВД
	|ГДЕ
	|	НЕ ПоказателиЕНВДПоказателиЕНВД.Ссылка.ПометкаУдаления
	|	И ПоказателиЕНВДПоказателиЕНВД.Ссылка.Организация = &Организация
	|	И ПоказателиЕНВДПоказателиЕНВД.Ссылка.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КоэффициентДефляторСрезПоследних.Значение КАК К1
	|ИЗ
	|	РегистрСведений.КоэффициентДефлятор.СрезПоследних(&ОкончаниеПериода, ) КАК КоэффициентДефляторСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасчетыПоНалогамОбороты.СуммаРасход КАК СуммаУплачено
	|ИЗ
	|	РегистрНакопления.РасчетыПоНалогам.Обороты(
	|			&НачалоПериода,
	|			&ОкончаниеПериода,
	|			,
	|			Организация = &Организация
	|				И ВидНалога В (&ВидыВзаиморасчетовВзносыВПФРИФСС)) КАК РасчетыПоНалогамОбороты
	|;
	|");
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоКвартала(ПериодРасчета));
	Запрос.УстановитьПараметр("ОкончаниеПериода", КонецДня(ПериодРасчета));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	
	ВидыВзаиморасчетовВзносыВПФРИФСС = Новый Массив;
	
	Если ИспользуетсяТрудНаемныхРаботников Тогда
		ВидыВзаиморасчетовВзносыВПФРИФСС.Добавить(Справочники.ВидыНалогов.ПФРНакопительнаяСотрудники);
		ВидыВзаиморасчетовВзносыВПФРИФСС.Добавить(Справочники.ВидыНалогов.ПФРСтраховаяСотрудники);
		ВидыВзаиморасчетовВзносыВПФРИФСС.Добавить(Справочники.ВидыНалогов.ФСССотрудники);
		ВидыВзаиморасчетовВзносыВПФРИФСС.Добавить(Справочники.ВидыНалогов.ФССТравматизмСотрудники);
		ВидыВзаиморасчетовВзносыВПФРИФСС.Добавить(Справочники.ВидыНалогов.ФОМССотрудники);
	Иначе
		ВидыВзаиморасчетовВзносыВПФРИФСС.Добавить(Справочники.ВидыНалогов.ПФРНакопительная);
		ВидыВзаиморасчетовВзносыВПФРИФСС.Добавить(Справочники.ВидыНалогов.ПФРСтраховая);
		ВидыВзаиморасчетовВзносыВПФРИФСС.Добавить(Справочники.ВидыНалогов.ПФРСвыше300тр);
		ВидыВзаиморасчетовВзносыВПФРИФСС.Добавить(Справочники.ВидыНалогов.ТФОМС);
		ВидыВзаиморасчетовВзносыВПФРИФСС.Добавить(Справочники.ВидыНалогов.ФФОМС);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ВидыВзаиморасчетовВзносыВПФРИФСС", ВидыВзаиморасчетовВзносыВПФРИФСС);

	// страховые взносы
	Результат = Запрос.ВыполнитьПакет();
	Выборка = Результат[1].Выбрать();
	Выборка.Следующий();
	
	К1 = Выборка.К1;
	СтруктураРасчетаЕНВД.К1ЕНВД = К1;
	
	// страховые взносы
	СистемаНалогообложения = РегистрыСведений.СистемыНалогообложенияОрганизаций.ПолучитьПоследнее(КонецДня(ПериодРасчета), Новый Структура("Организация", Организация));
	
	Если НЕ (СистемаНалогообложения.ПлательщикЕНВД И СистемаНалогообложения.ПлательщикУСН И Организация.ВидУчетаСтраховыхВзносов = Перечисления.ВидыУчетаСтраховыхВзносов.УчитыватьВУСН) Тогда
		// получение значения страховых взносов
		// страховые взносы
		Выборка = Результат[2].Выбрать();
		Если Выборка.Следующий() Тогда
			СтруктураРасчетаЕНВД.УплаченоСтраховыхВзносовЕНВД = Окр(Выборка.СуммаУплачено);
		КонецЕсли;
	Иначе
		СтруктураРасчетаЕНВД.УплаченоСтраховыхВзносовЕНВД = 0;
	КонецЕсли;
	
	
	Выборка = Результат[0].Выбрать();
	
	ВременнаяТаблица = Новый ТаблицаЗначений;
	
	ВременнаяТаблица.Колонки.Добавить("ВидДеятельности");
	ВременнаяТаблица.Колонки.Добавить("КодИФНС");
	ВременнаяТаблица.Колонки.Добавить("ОКАТО");
	ВременнаяТаблица.Колонки.Добавить("К2Установленный");
	ВременнаяТаблица.Колонки.Добавить("ДнейВсего");
	ВременнаяТаблица.Колонки.Добавить("ДнейОтработано");
	ВременнаяТаблица.Колонки.Добавить("К2Скорректированный");
	ВременнаяТаблица.Колонки.Добавить("БазоваяДоходность");
	ВременнаяТаблица.Колонки.Добавить("ФизПоказатель");
	ВременнаяТаблица.Колонки.Добавить("СтавкаЕНВД",Новый ОписаниеТипов(Новый КвалификаторыЧисла(3,1)));
	ВременнаяТаблица.Колонки.Добавить("СуммаНалога", Новый ОписаниеТипов(Новый КвалификаторыЧисла(15,2)));
	
	
	
	Пока Выборка.Следующий() Цикл
		ДатаНачала = НачалоМесяца(Выборка.ДатаНачала);
		ДатаОкончания = КонецМесяца(Выборка.ДатаОкончания);
		КоличествоДнейКВычету = 0;
		
		Если ДатаНачала >  НачалоКвартала(ПериодРасчета) Тогда
			КоличествоДнейКВычету = КоличествоДнейКВычету + (ДатаНачала - НачалоКвартала(ПериодРасчета))/ 86400;
		КонецЕсли;
		
		Если ДатаОкончания < КонецДня(ПериодРасчета) Тогда
			КоличествоДнейКВычету = КоличествоДнейКВычету + (КонецДня(ПериодРасчета) - ДатаОкончания)/ 86400;
		КонецЕсли;
		
		ДнейВсего = Выборка.ДнейВсего - КоличествоДнейКВычету;
		
		Строка = ВременнаяТаблица.Добавить();
		Строка.ОКАТО = Выборка.КодОКАТО;
		Строка.КодИФНС = Выборка.КодИФНС;
		Строка.ВидДеятельности = Выборка.ВидДеятельности;
		Строка.К2Установленный = Выборка.КоэффициентК2;
		Строка.ДнейВсего = ДнейВсего;
		Строка.ДнейОтработано = Выборка.ВыработкаДней;
		Строка.БазоваяДоходность = Выборка.БазоваяДоходность;
		Строка.СтавкаЕНВД = Выборка.СтавкаЕНВД;
		Строка.К2Скорректированный = Выборка.КоэффициентК2*Выборка.ВыработкаДней/ДнейВсего;
		Строка.ФизПоказатель = Выборка.ФизПоказатель;
		Строка.СуммаНалога = Окр(Строка.ФизПоказатель * Строка.БазоваяДоходность * К1 * Строка.К2Скорректированный * Строка.СтавкаЕНВД/100);
	КонецЦикла;
	
	
	СтруктураРасчетаЕНВД.хзТаблицаЕНВД = Новый ХранилищеЗначения(ВременнаяТаблица);
	
	// готовим свернутую табличку
	СвернутаяЕНВД = ВременнаяТаблица.Скопировать(,"ОКАТО,КодИФНС,СуммаНалога");
	СвернутаяЕНВД.Свернуть("ОКАТО,КодИФНС", "СуммаНалога");
	СвернутаяЕНВД.Колонки.Добавить("ДокументВзаиморасчетовСБюджетом", Новый ОписаниеТипов("ДокументСсылка.НачислениеНалогов"));
	СвернутаяЕНВД.Колонки.Добавить("ВычетСтраховыхВзносов", Новый ОписаниеТипов(Новый КвалификаторыЧисла(15,3)));
	СвернутаяЕНВД.Колонки.Добавить("СуммаНалогаДоВычетаВзносов", Новый ОписаниеТипов(Новый КвалификаторыЧисла(15,3)));
	
	Для Каждого Строка Из СвернутаяЕНВД Цикл
		Строка.СуммаНалогаДоВычетаВзносов = Строка.СуммаНалога;
	КонецЦикла;
	
	// распределяем страховые взносы
	Если СтруктураРасчетаЕНВД.УплаченоСтраховыхВзносовЕНВД > 0 Тогда
		
		ОбщаяСуммаЕНВД = СвернутаяЕНВД.Итог("СуммаНалога");
		Коэффициент =  СтруктураРасчетаЕНВД.УплаченоСтраховыхВзносовЕНВД/ОбщаяСуммаЕНВД;
		Коэффициент = Мин(1, Коэффициент);
		РазрешенКоэффициентБольше05 = (Не ИспользуетсяТрудНаемныхРаботников 
			И ПериодРасчета >= '20130101'
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация,  "ЮридическоеФизическоеЛицо") = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);
		
		// расчет исходя из не превышения 50%
		Если Коэффициент > 0.5
			И НЕ РазрешенКоэффициентБольше05 Тогда
			
			Коэффициент = 0.5;
		КонецЕсли;
		
		// служит для учета копеек
		ВременныйИтератор = ОбщаяСуммаЕНВД*Коэффициент;
		ПоследняяСтрока = Неопределено;
		
		Для Каждого Строка Из СвернутаяЕНВД Цикл
			
			
			Строка.СуммаНалога = Окр(Строка.СуммаНалогаДоВычетаВзносов-Строка.СуммаНалогаДоВычетаВзносов*Коэффициент);
			ВременныйИтератор = ВременныйИтератор-(Строка.СуммаНалогаДоВычетаВзносов-Строка.СуммаНалога);
			ПоследняяСтрока = Строка;
			
		КонецЦикла;
		
		// корректируем копейки
		ПоследняяСтрока.СуммаНалога = Окр(ПоследняяСтрока.СуммаНалога - ВременныйИтератор);
		
	КонецЕсли;
	
	НачатьТранзакцию();
	
	ЗарегистрироватьВзаиморасчетыСБюджетомПоЕНВД(СвернутаяЕНВД, СтруктураРасчетаЕНВД);
	СтруктураРасчетаЕНВД.хзТаблицаЕНВДПоОкато = Новый ХранилищеЗначения(СвернутаяЕНВД);
	РегламентированнаяОтчетностьУСН.ОтразитьЗначенияПоказателейОтчетности(СтруктураРасчетаЕНВД);
	
	// запись состояние события календаря
	Если СобытиеКалендаря <> Неопределено Тогда
		
		КалендарьОтчетности.ЗаписатьСостояниеСобытияКалендаря(
			Организация,
			СобытиеКалендаря,
			Перечисления.СостоянияСобытийКалендаря.Ознакомиться,
			"");
		
	КонецЕсли;
	
	
	
	ЗафиксироватьТранзакцию();
	
	СтруктураРасчетаЕНВД.хзТаблицаЕНВД = Неопределено;
	СтруктураРасчетаЕНВД.хзТаблицаЕНВДПоОкато = Неопределено;
	
	Возврат СтруктураРасчетаЕНВД;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗарегистрироватьВзаиморасчетыСБюджетомПоЕНВД(ТаблицаПоЕНВДСвернутая, СтруктураРасчетаЕНВД)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НачислениеНалоговНалоги.Ссылка,
	|	НачислениеНалоговНалоги.ВидНалога,
	|	НачислениеНалоговНалоги.КодИФНС КАК КодИФНС,
	|	НачислениеНалоговНалоги.КодПоОКАТО КАК ОКАТО,
	|	НачислениеНалоговНалоги.Сумма
	|ИЗ
	|	Документ.НачислениеНалогов.Налоги КАК НачислениеНалоговНалоги
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.НачислениеНалогов КАК НачислениеНалогов
	|		ПО НачислениеНалоговНалоги.Ссылка = НачислениеНалогов.Ссылка
	|			И (НачислениеНалогов.Организация = &Организация)
	|			И (НачислениеНалоговНалоги.ВидНалога = &ВидВзаиморасчетов)
	|			И (НачислениеНалоговНалоги.НомерСтроки = 1)
	|			И (НачислениеНалогов.Дата = &ПериодВзаиморасчетов)
	|			И (НЕ НачислениеНалогов.ПометкаУдаления)");
	
	Запрос.УстановитьПараметр("Организация", СтруктураРасчетаЕНВД.Организация);
	Запрос.УстановитьПараметр("ВидВзаиморасчетов", СтруктураРасчетаЕНВД.ВидВзаиморасчетовСБюджетом);
	Запрос.УстановитьПараметр("ПериодВзаиморасчетов", КонецДня(СтруктураРасчетаЕНВД.ПериодОтчетности));
	
	ТаблицаВзаиморасчетов = Запрос.Выполнить().Выгрузить();
	
	// найдем все самые подходящие и заполним их в таблице по ЕНВД
	Для Каждого Строка Из ТаблицаПоЕНВДСвернутая Цикл
		
		Найденные = ТаблицаВзаиморасчетов.НайтиСтроки(
			Новый Структура("ОКАТО,КодИФНС,Сумма",
			Строка.ОКАТО,
			Строка.КодИФНС,
			Строка.СуммаНалога));
		
		// больше одной по логике не должно находиться
		Если Найденные.Количество() > 0 Тогда
			
			Строка.ДокументВзаиморасчетовСБюджетом = Найденные[0].Ссылка;
			
		КонецЕсли;
		
		Если Найденные.Количество() > 1 Тогда
			ЗаписьЖурналаРегистрации(
				НСтр("ru='ЕНВД.Внутренняя логика'"),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				НСтр("ru='Нарушение логики работы алгоритма поиска документов взаиморасчетов по ЕНВД'"));
		КонецЕсли;
		
		// удалим из обработки найденные
		Для Каждого СтрокаКУдалению ИЗ Найденные Цикл
			ТаблицаВзаиморасчетов.Удалить(ТаблицаВзаиморасчетов.Индекс(СтрокаКУдалению));
		КонецЦикла;
		
	КонецЦикла;
	
	// найдем близко  подходящие и заполним их в таблице по ЕНВД
	Для Каждого Строка Из ТаблицаПоЕНВДСвернутая Цикл
		
		// пропускаем заполненные
		Если НЕ Строка.ДокументВзаиморасчетовСБюджетом.Пустая() Тогда
			Продолжить;
		КонецЕсли;
		
		Найденные = ТаблицаВзаиморасчетов.НайтиСтроки(
			Новый Структура("ОКАТО,КодИФНС",
			Строка.ОКАТО,
			Строка.КодИФНС));
		
		// больше одной по логике не должно находиться
		Если Найденные.Количество() > 0 Тогда
			
			Объект = Найденные[0].Ссылка.ПолучитьОбъект();
			Объект.Налоги[0].Сумма = Строка.СуммаНалога;
			
			Объект.Записать(РежимЗаписиДокумента.Проведение);
			
			Строка.ДокументВзаиморасчетовСБюджетом = Объект.Ссылка;
			
			// удалим из обработки найденные
			ТаблицаВзаиморасчетов.Удалить(ТаблицаВзаиморасчетов.Индекс(Найденные[0]));
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Создадим новые взаиморасчет
	Найденные = ТаблицаПоЕНВДСвернутая.НайтиСтроки(Новый Структура("ДокументВзаиморасчетовСБюджетом", Документы.НачислениеНалогов.ПустаяСсылка()));
	ДатаОкончанияСобытия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураРасчетаЕНВД.СобытиеКалендаря, "ДатаОкончанияСобытия");
	
	Для Каждого Строка Из Найденные Цикл
		
		Объект = Документы.НачислениеНалогов.СоздатьДокумент();
		Объект.Организация = СтруктураРасчетаЕНВД.Организация;
		Объект.ВидОперации = Перечисления.ВидыОперацийНачислениеНалогов.Начисление;
		Объект.Дата = КонецДня(СтруктураРасчетаЕНВД.ПериодОтчетности);
		
		СтрокаСНалогом = Объект.Налоги.Добавить();
		СтрокаСНалогом.ВидНалога = СтруктураРасчетаЕНВД.ВидВзаиморасчетовСБюджетом;
		СтрокаСНалогом.СрокУплаты = ДатаОкончанияСобытия;
		СтрокаСНалогом.Корреспонденция = ПланыСчетов.Управленческий.ПрочиеРасходы;
		СтрокаСНалогом.КодИФНС = Строка.КодИФНС;
		СтрокаСНалогом.КодПоОКАТО = Строка.ОКАТО;
		СтрокаСНалогом.Сумма = Строка.СуммаНалога;
		Объект.Записать(РежимЗаписиДокумента.Проведение);
		
		Строка.ДокументВзаиморасчетовСБюджетом = Объект.Ссылка;
	КонецЦикла;
	
КонецПроцедуры