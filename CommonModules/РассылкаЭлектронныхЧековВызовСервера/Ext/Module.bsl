﻿#Область ПрограммныйИнтерфейс

// Проверка наличия посдсистем БСП
//
Функция ПараметрыИспользования() Экспорт
	
	Возврат РассылкаЭлектронныхЧеков.ПараметрыИспользования();
	
КонецФункции // ПараметрыИспользования()

// Процедура отправляет электронное сообщение на электронную почта и абонентский номер.
//
Процедура НачатьОтправкуЭлектронногоЧека(ПараметрыЧека, ТекстСообщения, ПокупательEmail, ПокупательНомер) Экспорт
	
	Если ЗначениеЗаполнено(ПокупательEmail) Тогда
		
		ПараметрыПисьма = Новый Структура;
		
		КомуСтруктура = Новый Структура("Адрес, Представление");
		КомуСтруктура.Адрес = ПокупательEmail;
		
		Кому = Новый Массив;
		Кому.Добавить(КомуСтруктура);
		
		ПараметрыПисьма.Вставить("Кому", Кому);
		Тема  = НСтр("ru = 'Пробит чек №%1'");
		Тема = СтрЗаменить(Тема, "%1", ПараметрыЧека.НомерЧека);
		
		ПараметрыПисьма.Вставить("Тема", Тема);
		ПараметрыПисьма.Вставить("Тело", ТекстСообщения);
		
		РассылкаЭлектронныхЧеков.НачатьОтправкуЭлектронногоЧека(ПокупательEmail,
													Перечисления.ТипыРассылкиЭлектронныхЧеков.ЭлектронноеПисьмо,
													ПараметрыПисьма);
		
	ИначеЕсли ЗначениеЗаполнено(ПокупательНомер) Тогда
		
		ПараметрыПисьма = Новый Структура;
		ПараметрыПисьма.Вставить("НомерПолучателя", ПокупательНомер);
		ПараметрыПисьма.Вставить("ТекстСообщения" , ТекстСообщения);
		
		РассылкаЭлектронныхЧеков.НачатьОтправкуЭлектронногоЧека(ПокупательНомер,
													Перечисления.ТипыРассылкиЭлектронныхЧеков.СообщениеSMS,
													ПараметрыПисьма);
		
	КонецЕсли;

	
КонецПроцедуры

#КонецОбласти
