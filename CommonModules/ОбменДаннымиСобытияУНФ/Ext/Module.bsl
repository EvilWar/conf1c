﻿#Область ВыгрузкаЗагрузкаДанныхВСервисе

// Процедура-обработчик события "ПередЗагрузкойОбъекта" для механизма выгрузки/загрузки данных в сервисе
// Описание параметров см. в комментарии к ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковЗагрузкиДанных
// 
Процедура ПередЗагрузкойОбъекта(Контейнер, Объект, Артефакты, Отказ) Экспорт
	
	// Отключаем регистрацию дублей контрагентов при загрузке/выгрузке данных в сервисе
	Если ТипЗнч(Объект) = Тип("СправочникОбъект.Контрагенты") Тогда
		Объект.ДополнительныеСвойства.Вставить("РегистрироватьДублиКонтрагентов", Ложь);
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникОбъект.АвтоматическиеСкидки") Тогда
		Объект.ДополнительныеСвойства.Вставить("РегистрироватьСлужебныйАвтоматическиеСкидки", Ложь);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти
