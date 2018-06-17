﻿
// Процедура заполнения структуры настроек при выгрузке методом GetSettings web-сервиса EquipmentService
//  так же используется при выгрузке на ККМ Offline при использовании драйвера 1С:ККМ Offline
//  Для заполнения используются подготовленные пустые структуры получаемые функциями из модуля МенеджерОборудованияСервисыКлиентСервер
//  пример заполнения:
//  Настройки.НазваниеОрганизации = "ООО Ромашка";
//  Настройки.ИНН = "123456789012";
//  Настройки.Налогообложение = "Общая";
//  //  Настройки.Налогообложение = "Упрощенная";
//  
//  Настройки.ИспользоватьСкидки = Истина;
//  Настройки.ИспользоватьБанковскиеКарты = Истина;
//  
//  ЗаписьВидыОплаты = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваВидыОплаты();
//  ЗаписьВидыОплаты.Код = "00000001";
//  ЗаписьВидыОплаты.ТипОплаты = 1;
//  ЗаписьВидыОплаты.Наименование = "Visa";
//  
//  Настройки.ВидыОплаты.Добавить(ЗаписьВидыОплаты);
//  
//  ЗаписьВидыОплаты = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваВидыОплаты();
//  ЗаписьВидыОплаты.Код = "00000002";
//  ЗаписьВидыОплаты.ТипОплаты = 1;
//  ЗаписьВидыОплаты.Наименование = "Mastercard";
//  
//  Настройки.ВидыОплаты.Добавить(ЗаписьВидыОплаты);
Процедура ЗаполнитьНастройкиУстройства(ИДУстройства, Настройки) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодключаемоеОборудование.ПравилоОбмена
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.УстройствоИспользуется
	|	И ПодключаемоеОборудование.ИдентификаторWebСервисОборудования = &ИдентификаторWebСервисОборудования
	|	И ПодключаемоеОборудование.ТипОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.WebСервисОборудование)";
	
	Запрос.УстановитьПараметр("ИдентификаторWebСервисОборудования", ИДУстройства);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если НЕ Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	ПравилоОбмена = Выборка.ПравилоОбмена;
	ПодключаемоеОборудованиеOfflineВызовСервера.ЗаполнитьСтруктуруНастроекПоПравилуОбмена(Настройки, ПравилоОбмена);
	
КонецПроцедуры

//  Процедура заполнения структуры прайс-листа при выгрузке методом GetPriceList web-сервиса EquipmentService
//  так же используется при выгрузке на ККМ Offline при использовании драйвера 1С:ККМ Offline
//  Для заполнения используются подготовленные пустые структуры получаемые функциями из модуля МенеджерОборудованияСервисыКлиентСервер
//  
//  Пример заполнения:
//  //  ГРУППЫ ТОВАРОВ
//  	Группа1 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваГруппыТоваров();
//  	Группа1.Код          = "10001";
//  	Группа1.КодГруппы    = "";
//  	Группа1.Наименование = "Бытовая техника";
//  	СтруктураПрайсЛиста.ГруппыТоваров.Добавить(Группа1);
//  	
//  	Группа2 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваГруппыТоваров();
//  	Группа2.Код          = "10002";
//  	Группа2.КодГруппы    = "10001";
//  	Группа2.Наименование = "Холодильники";
//  	СтруктураПрайсЛиста.ГруппыТоваров.Добавить(Группа2);
//  	
//  	Группа3 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваГруппыТоваров();
//  	Группа3.Код          = "10003";
//  	Группа3.КодГруппы    = "10001";
//  	Группа3.Наименование = "Телевизоры";
//  	СтруктураПрайсЛиста.ГруппыТоваров.Добавить(Группа3);
//  	
//  	Группа4 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваГруппыТоваров();
//  	Группа4.Код          = "10004";
//  	Группа4.КодГруппы    = "10001";
//  	Группа4.Наименование = "Запасные части";
//  	СтруктураПрайсЛиста.ГруппыТоваров.Добавить(Группа4);
//  	
//  	//  ТОВАРЫ
// 	
// 	// номенклатура без упаковок и характеристик
// 	Номенклатура1 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваТовары();
// 	Номенклатура1.Наименование = "МИНСК-АТЛАНТ 126";
// 	Номенклатура1.Артикул = "МИНСК126";
// 	Номенклатура1.Весовой = Ложь;
// 	Номенклатура1.ЕдиницаИзмерения = "шт";
// 	Номенклатура1.ИмеетУпаковки = Ложь;
// 	Номенклатура1.ИмеетХарактеристики = Ложь;
// 	Номенклатура1.Код = "11001";
// 	Номенклатура1.КодГруппы = "10002";
// 	Номенклатура1.СтавкаНДС = "18";
// 	Номенклатура1.Услуга = Ложь;
// 	Номенклатура1.Цена = "18001.89";
// 	Номенклатура1.Штрихкод = "2900001575768";
// 	Номенклатура1.Остаток = "13";
// 	СтруктураПрайсЛиста.Товары.Добавить(Номенклатура1);
// 	
// 	// Номенклатура с упаковками, без характеристик
// 	Номенклатура2 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваТовары();
// 	Номенклатура2.Наименование = "Винт М4х20";
// 	Номенклатура2.Артикул = "арт вин";
// 	Номенклатура2.Весовой = Ложь;
// 	Номенклатура2.ЕдиницаИзмерения = "шт";
// 	Номенклатура2.ИмеетУпаковки = Истина;
// 	Номенклатура2.ИмеетХарактеристики = Ложь;
// 	Номенклатура2.КодГруппы = "10004";
// 	Номенклатура2.СтавкаНДС = "18";
// 	Номенклатура2.Услуга = Ложь;
// 	Номенклатура2.Упаковки = Новый Массив;
// 	
// 		// упаковка1
// 		Упаковка1 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваУпаковки();
// 		Упаковка1.Код = "11003";
// 		Упаковка1.Наименование = "Коробка (20шт)";
// 		Упаковка1.Коэффициент = "20";
// 		Упаковка1.Штрихкод = "87987454";
// 		Упаковка1.Цена = "20.15";
// 		Упаковка1.Остаток = "15";
// 		Номенклатура2.Упаковки.Добавить(Упаковка1);
// 		
// 		// упаковка2
// 		Упаковка2 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваУпаковки();
// 		Упаковка2.Код = "11004";
// 		Упаковка2.Наименование = "Коробка (40шт)";
// 		Упаковка2.Коэффициент = "40";
// 		Упаковка2.Штрихкод = "23321212333";
// 		Упаковка2.Цена = "40.15";
// 		Упаковка2.Остаток = "15";
// 		Номенклатура2.Упаковки.Добавить(Упаковка1);
// 		
// 	СтруктураПрайсЛиста.Товары.Добавить(Номенклатура2);
// 	
// 	// 
// 	// Номенклатура с характеристиками, без упаковок
// 	
// 	Номенклатура3 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваТовары();
// 	Номенклатура3.Наименование = "Изолента";
// 	Номенклатура3.Артикул = "Изо-125";
// 	Номенклатура3.Весовой = Ложь;
// 	Номенклатура3.ЕдиницаИзмерения = "шт";
// 	Номенклатура3.ИмеетУпаковки = Ложь;
// 	Номенклатура3.ИмеетХарактеристики = Истина;
// 	Номенклатура3.КодГруппы = "10004";
// 	Номенклатура3.СтавкаНДС = "10";
// 	Номенклатура3.Услуга = Ложь;
// 	Номенклатура3.Характеристики = Новый Массив;
// 	
// 		// характеристика1
// 		Характеристика1 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваХарактеристики();
// 		Характеристика1.Код = "11005";
// 		Характеристика1.Наименование = "черная";
// 		Характеристика1.Штрихкод = "2900001575769";
// 		Характеристика1.Цена = "20.15";
// 		Характеристика1.Остаток = "15";
// 		Характеристика1.ИмеетУпаковки = Ложь;
// 		Номенклатура3.Характеристики.Добавить(Характеристика1);
// 		
// 		// характеристика2
// 		Характеристика2 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваХарактеристики();
// 		Характеристика2.Код = "11006";
// 		Характеристика2.Наименование = "синяя";
// 		Характеристика2.Штрихкод = "2900001575770";
// 		Характеристика2.Цена = "20.15";
// 		Характеристика2.Остаток = "15";
// 		Характеристика2.ИмеетУпаковки = Ложь;
// 		Номенклатура3.Характеристики.Добавить(Характеристика2);
// 		
// 	СтруктураПрайсЛиста.Товары.Добавить(Номенклатура3);
// 	
// 	
// 	// Номенклатура с характеристиками, с упаковками
// 	
// 	Номенклатура4 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваТовары();
// 	Номенклатура4.Наименование = "Изолента широкая";
// 	Номенклатура4.Артикул = "Изо-126";
// 	Номенклатура4.Весовой = Ложь;
// 	Номенклатура4.ЕдиницаИзмерения = "шт";
// 	Номенклатура4.ИмеетУпаковки = Ложь;
// 	Номенклатура4.ИмеетХарактеристики = Истина;
// 	Номенклатура4.КодГруппы = "10004";
// 	Номенклатура4.СтавкаНДС = "10";
// 	Номенклатура4.Услуга = Ложь;
// 	Номенклатура4.Характеристики = Новый Массив;
// 	
// 		// характеристика1
// 		Характеристика1 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваХарактеристики();
// 		Характеристика1.Код = "11005";
// 		Характеристика1.Наименование = "черная";
// 		Характеристика1.ИмеетУпаковки = Истина;
// 		Характеристика1.Упаковки = Новый Массив;
// 		
// 			Упаковка1 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваУпаковки();
// 			Упаковка1.Код = "11003";
// 			Упаковка1.Наименование = "Коробка (20шт)";
// 			Упаковка1.Коэффициент = "20";
// 			Упаковка1.Штрихкод = "87987454у";
// 			Упаковка1.Цена = "20.15";
// 			Упаковка1.Остаток = "15";
// 			
// 			Характеристика1.Упаковки.Добавить(Упаковка1);
// 			
// 	Номенклатура4.Характеристики.Добавить(Характеристика1);
// 		
// 		// характеристика2
// 		Характеристика2 = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваХарактеристики();
// 		
// 		Характеристика2.Код = "11006";
// 		Характеристика2.Наименование = "синяя";
// 		Характеристика2.Штрихкод = "2900001575770";
// 		Характеристика2.Цена = "20.15";
// 		Характеристика2.Остаток = "15";
// 		Характеристика2.ИмеетУпаковки = Ложь;
// 		
// 	Номенклатура4.Характеристики.Добавить(Характеристика2);
// 	// Демо конец
Процедура ЗаполнитьПрайсЛист(ИДУстройства, СтруктураПрайсЛиста) Экспорт
	
	ТолькоИзмененные = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.УстройствоИспользуется
	|	И ПодключаемоеОборудование.ИдентификаторWebСервисОборудования = &ИдентификаторWebСервисОборудования
	|	И ПодключаемоеОборудование.ТипОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.WebСервисОборудование)";
	
	Запрос.УстановитьПараметр("ИдентификаторWebСервисОборудования", ИДУстройства);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если НЕ Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ОбновитьКодыТоваров(Выборка.Ссылка.ПравилоОбмена);
	
	Параметры = ПодключаемоеОборудованиеOfflineВызовСервера.ПолучитьПараметрыУстройства(Выборка.Ссылка);
	Параметры.Вставить("ЧастичнаяВыгрузка", ТолькоИзмененные);
	
	ТаблицаТоваров = ПодключаемоеОборудованиеOfflineВызовСервера.ПолучитьТаблицуТоваровКВыгрузке(Выборка.Ссылка, Параметры);
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ЗаполнитьСтруктуруПрайсЛистаИзДанныхКВыгрузке(СтруктураПрайсЛиста, ТаблицаТоваров);
	
КонецПроцедуры

//Процедура заполнения структуры товара при выгрузке методом GetGood web-сервиса EquipmentService
//
Процедура ЗагрузитьТовар(ИДУстройства, СтруктураТовара, Штрихкод) Экспорт
	
КонецПроцедуры

// Процедура заполнения ответа web-сервиса EquipmentService на вызов метода PostDocs
// В процедуру, через параметр "Документы", передается структура принимаемых документов
// 
// Пример заполнения:
// 	СтруктураОтвета.Успешно = Истина;
// 	СтруктураОтвета.Описание = "Документы успешно загружены";
// 	
// 	СтруктураОтвета.Успешно = Ложь;
// 	СтруктураОтвета.Описание = "Документы не загружены! Данный тип документа не поддерживается";
Процедура ЗагрузитьДокумент(ИДУстройства, СтруктураОтвета, СтруктураДокументов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.УстройствоИспользуется
	|	И ПодключаемоеОборудование.ИдентификаторWebСервисОборудования = &ИдентификаторWebСервисОборудования
	|	И ПодключаемоеОборудование.ТипОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.WebСервисОборудование)";
	
	Запрос.УстановитьПараметр("ИдентификаторWebСервисОборудования", ИДУстройства);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если НЕ Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураДокументов.ТипДокумента = "ОтчетОПродажах" Тогда
		
		МассивДокументов = ПодключаемоеОборудованиеOfflineВызовСервера.ПриЗагрузкеОтчетаОРозничныхПродажах(Выборка.Ссылка, СтруктураДокументов.Документы, Истина);
		
		Если МассивДокументов = Неопределено Тогда
			СтруктураОтвета.Успешно = Ложь;
			СтруктураОтвета.Описание = "Ошибка загрузки. Принимающая сторона не смогла обработать принятый отчет";
		Иначе
			СтруктураОтвета.Успешно = Истина;
			СтруктураОтвета.Описание = "Загружено отчетов о продажах: " + МассивДокументов.Количество();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполнения массива типов документов, поддерживаемых конфигурацией
// Вызывается методом GetDocTypes web-сервиса EquipmentService
// Пример заполнения:
// ТипОтчетОПродажах = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваТиповДокументов();
// ТипОтчетОПродажах.ТипДокумента   = "SalesReport";
// ТипОтчетОПродажах.МожноПолучать  = Ложь;
// ТипОтчетОПродажах.МожноЗагружать = Истина;
// 
// МассивТипов.Добавить(ТипОтчетОПродажах);
// 
Процедура ЗаполнитьТипыДокументов(МассивТипов) Экспорт
	
	ТипОтчетОПродажах = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваТиповДокументов();
	ТипОтчетОПродажах.ТипДокумента   = "SalesReport";
	ТипОтчетОПродажах.МожноПолучать  = Ложь;
	ТипОтчетОПродажах.МожноЗагружать = Истина;
	
	МассивТипов.Добавить(ТипОтчетОПродажах);
	
КонецПроцедуры
