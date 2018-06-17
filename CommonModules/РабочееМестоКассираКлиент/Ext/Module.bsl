﻿
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	// Для тех, у кого есть профиль "Рабочее место кассира" 
	Если ПараметрыРаботыКлиента.Свойство("ЕстьПрофильРМК") И ПараметрыРаботыКлиента.ЕстьПрофильРМК Тогда
		РабочееМестоКассираВызовСервера.УстановитьМинимальныйИнтерфейсРМК();
		ОбновитьИнтерфейс();
		ОткрытьФормуРМК();
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Запуск формы РМК

&НаКлиенте
Процедура ОткрытьФормуРМК() Экспорт
	
	ЗначенияЗаполнения = РабочееМестоКассираВызовСервера.ПолучитьКассуККМИТерминалПоУмолчанию();
	
	МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
	
	Если ТребуетсяОткрытьОкноВыбораКассы(ЗначенияЗаполнения) Тогда
		ОткрытьФорму("Документ.ЧекККМ.Форма.ФормаДокумента_РМК_ОкноВыбораКассы", 
		Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения));
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму(
	"Документ.ЧекККМ.Форма.ФормаДокумента_РМК",
	Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения));

КонецПроцедуры

&НаКлиенте
Функция ТребуетсяОткрытьОкноВыбораКассы(ЗначенияЗаполнения)
	
	Если Не ЗначениеЗаполнено(ЗначенияЗаполнения.КассаККМ) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗначенияЗаполнения.КоличествоЭквайринговыхТерминалов)
		И Не ЗначениеЗаполнено(ЗначенияЗаполнения.ЭквайринговыйТерминал) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции
