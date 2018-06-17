﻿
#Область ПрограммныйИнтерфейс


Функция ПредставлениеДокументаОснования(ДокОснование) Экспорт
	
	// для пустых ссылок возвращаем неопределено
	Если НЕ ЗначениеЗаполнено(ДокОснование) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ОбщегоНазначения.СсылкаСуществует(ДокОснование) Тогда
		Возврат Строка(ДокОснование);
	Иначе
		Возврат "НетОбъекта";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьКомпоновщикНастроекСервер(СвойстваОтчета, ПараметрыИОтборы = Неопределено) Экспорт
	
	Если ПараметрыИОтборы = Неопределено Тогда
		ПараметрыИОтборы = Новый Массив;
	КонецЕсли;
	
	Возврат УправлениеНебольшойФирмойСервер.ПолучитьПереопределенныйКомпоновщикНастроек(СвойстваОтчета, ПараметрыИОтборы);
	
КонецФункции

Процедура УдалитьНедоступныеВидыОперацийДокументов(Операции) Экспорт
	
	//Комиссия
	Если НЕ ПолучитьФункциональнуюОпцию("ПриемТоваровНаКомиссию") Тогда
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийПриходнаяНакладная.ПриемНаКомиссию);
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийРасходнаяНакладная.ВозвратКомитенту);
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийСчетФактура.НаАвансКомитента);
	КонецЕсли;
	Если НЕ ПолучитьФункциональнуюОпцию("ПередачаТоваровНаКомиссию") Тогда
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратОтКомиссионера);
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийРасходнаяНакладная.ПередачаНаКомиссию);
	КонецЕсли;
	//Переработка
	Если НЕ ПолучитьФункциональнуюОпцию("ПередачаСырьяВПереработку") Тогда
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийЗаказПоставщику.ЗаказНаПереработку);
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратОтПереработчика);
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийРасходнаяНакладная.ПередачаВПереработку);
	КонецЕсли;
	Если НЕ ПолучитьФункциональнуюОпцию("ПереработкаДавальческогоСырья") Тогда
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаПереработку);
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийПриходнаяНакладная.ПриемВПереработку);
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийРасходнаяНакладная.ВозвратИзПереработки);
	КонецЕсли;
	//Ответхранение
	Если НЕ ПолучитьФункциональнуюОпцию("ПриемЗапасовНаОтветхранение") Тогда
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийПриходнаяНакладная.ПриемНаОтветхранение);
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийРасходнаяНакладная.ВозвратСОтветхранения);
	КонецЕсли;
	Если НЕ ПолучитьФункциональнуюОпцию("ПередачаЗапасовНаОтветхранение") Тогда
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратСОтветхранения);
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийРасходнаяНакладная.ПередачаНаОтветхранение);
	КонецЕсли;
	//Корректировки
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьКорректировкиРеализаций") Тогда
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийСчетФактура.Корректировка);
	КонецЕсли;
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьКорректировкиПоступлений") Тогда
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийСчетФактураПолученный.Корректировка);
	КонецЕсли;
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьКорректировкиРеализаций") И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьКорректировкиПоступлений") Тогда
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийИсправленияПоступленияРеализации.ИсправлениеОшибки);
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийИсправленияПоступленияРеализации.СогласованноеИзменение);
	КонецЕсли;	
	
	//Работы
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуРаботы") Тогда
		УдалитьОперацию(Операции, Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд);
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьОперацию(Операции, ЗначениеУдаления)
	
	Если ТипЗнч(Операции) = Тип("СписокЗначений") Тогда
		СтрокаДляУдаления = Операции.НайтиПоЗначению(ЗначениеУдаления);
		Если СтрокаДляУдаления<>Неопределено Тогда
			Операции.Удалить(СтрокаДляУдаления);
		КонецЕсли;
	ИначеЕсли ТипЗнч(Операции) = Тип("ДеревоЗначений") Тогда
		НайтиУдалитьВДереве(Операции, ЗначениеУдаления);
	КонецЕсли;

КонецПроцедуры

Функция НайтиУдалитьВДереве(Операции, ЗначениеУдаления)
	
	Для каждого Док Из Операции.Строки Цикл
		
		ПодчиненныеОперации = док.Строки;
		Для каждого операция Из ПодчиненныеОперации Цикл
			Если операция.ВидОперации = ЗначениеУдаления Тогда
				ПодчиненныеОперации.Удалить(операция);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Для каждого Док Из Операции.Строки Цикл
		Если Док.Строки.Количество()=0 Тогда
			Операции.Строки.Удалить(Док);
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

Функция СсылкаВариантаОтчета(ИмяОтчета, КлючВарианта) Экспорт
	
	Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Отчет."+ИмяОтчета);
	Возврат ВариантыОтчетов.ПолучитьСсылку(Отчет, КлючВарианта);
	
КонецФункции

#КонецОбласти

#Область РаботаССерийнымиНомерами

Функция ПолучитьСерийныеНомераИзХранилища(Объект, АдресЗапасовВХранилище, КлючСвязи, ПараметрыИменаПолей=Неопределено) Экспорт	
	
	ИмяТЧЗапасы="Запасы";
	ИмяТЧСерийныеНомера="СерийныеНомера";
	ИмяПоляКлючСвязи = "КлючСвязи";
	ЭтоОприходование = Ложь;
	
	Если ПараметрыИменаПолей<>Неопределено И ТипЗнч(ПараметрыИменаПолей)=Тип("Структура") Тогда
		Если ПараметрыИменаПолей.Свойство("ИмяТЧЗапасы") Тогда
			ИмяТЧЗапасы=ПараметрыИменаПолей.ИмяТЧЗапасы;
		КонецЕсли;
		Если ПараметрыИменаПолей.Свойство("ИмяТЧСерийныеНомера") Тогда
			ИмяТЧСерийныеНомера=ПараметрыИменаПолей.ИмяТЧСерийныеНомера;
		КонецЕсли;
		Если ПараметрыИменаПолей.Свойство("ИмяПоляКлючСвязи") Тогда
			ИмяПоляКлючСвязи=ПараметрыИменаПолей.ИмяПоляКлючСвязи;
		КонецЕсли;
		Если ПараметрыИменаПолей.Свойство("ЭтоОприходование") Тогда
			ЭтоОприходование=ПараметрыИменаПолей.ЭтоОприходование;
		КонецЕсли;
	КонецЕсли;
	
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	ВыбраноСерийныхНомеров = ТаблицаДляЗагрузки.Количество();
	ИзмененоКоличество = Ложь;
	
	//Очистить старые серии
	ОтборСерийныеНомераТекущейСтроки = Новый Структура("КлючСвязи", КлючСвязи);
	МассивУдалитьСтроки = Новый ФиксированныйМассив(Объект[ИмяТЧСерийныеНомера].НайтиСтроки(ОтборСерийныеНомераТекущейСтроки));
	Для каждого СтрокаУдалить Из МассивУдалитьСтроки Цикл
		Объект[ИмяТЧСерийныеНомера].Удалить(СтрокаУдалить);	
	КонецЦикла;
	
	//Сформировать представление для строки запасов
	СтроковоеПредставлениеСерийныхНомеров = "";
	Для каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		
		НоваяСтрока = Объект[ИмяТЧСерийныеНомера].Добавить();
		//+ ГИСМ
		// поддержка загрузки серий в МаркировкаТоваровГИСМ, расположено в цикле, 
		// потому что вне цикла нам не узнать наличие той или иной колонки
		КолонкаСерийныйНомер = "";
		Если НоваяСтрока.Свойство("СерийныйНомер") Тогда
			КолонкаСерийныйНомер = ?(ЭтоОприходование, "СерийныйНомерОприходование", "СерийныйНомер");
		Иначе
			КолонкаСерийныйНомер = "Серия";
			НоваяСтрока.Серия = СтрокаЗагрузки.СерийныйНомер;
		КонецЕсли;
		//- ГИСМ
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗагрузки);
		
		Если НоваяСтрока.Свойство("Серия") Тогда
			СтроковоеПредставлениеСерийныхНомеров = СтроковоеПредставлениеСерийныхНомеров + НоваяСтрока.Серия+"; ";
		Иначе
			СтроковоеПредставлениеСерийныхНомеров = СтроковоеПредставлениеСерийныхНомеров + НоваяСтрока.СерийныйНомер+"; ";
		КонецЕсли;
		
		НоваяСтрока.КлючСвязи = КлючСвязи;
	КонецЦикла;
	СтроковоеПредставлениеСерийныхНомеров = Лев(СтроковоеПредставлениеСерийныхНомеров, Мин(СтрДлина(СтроковоеПредставлениеСерийныхНомеров)-2,150));
	
	ОтборСерийныеНомераТЧ = Новый Структура(ИмяПоляКлючСвязи, КлючСвязи);
	СтрокиЗапасов = Объект[ИмяТЧЗапасы].НайтиСтроки(ОтборСерийныеНомераТЧ);
	Для каждого стр Из СтрокиЗапасов Цикл
		стр[ИмяПоляКлючСвязи] = КлючСвязи;
		Если ЭтоОприходование Тогда
			стр.СерийныеНомераОприходование = СтроковоеПредставлениеСерийныхНомеров;
		Иначе
			стр.СерийныеНомера = СтроковоеПредставлениеСерийныхНомеров;
		КонецЕсли;
		
		Если Стр.Свойство("ЕдиницаИзмерения") Тогда
			Если НЕ ЭтоОприходование Тогда
				Если ТипЗнч(стр.ЕдиницаИзмерения)=Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
					Коэффициент = стр.ЕдиницаИзмерения.Коэффициент;
				Иначе
					Коэффициент = 1;
				КонецЕсли;
			Иначе
				Если ТипЗнч(стр.ЕдиницаИзмеренияОприходование)=Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
					Коэффициент = стр.ЕдиницаИзмеренияОприходование.Коэффициент;
				Иначе
					Коэффициент = 1;
				КонецЕсли;
			КонецЕсли;
			
			КоличествоЦелыхЕдиниц = Цел(ВыбраноСерийныхНомеров / Коэффициент);
			
			Если стр.Количество < КоличествоЦелыхЕдиниц Тогда
				стр.Количество = КоличествоЦелыхЕдиниц;
				ИзмененоКоличество = Истина;
			КонецЕсли;
			
		ИначеЕсли ВыбраноСерийныхНомеров <> стр.Количество Тогда
			стр.Количество = ВыбраноСерийныхНомеров;
			ИзмененоКоличество = Истина;
		КонецЕсли;
		
		Прервать;
	КонецЦикла;
	
	Возврат ИзмененоКоличество;
	
КонецФункции // ПолучитьСерийныеНомераИзХранилища()

Функция ПолучитьСерийныеНомераИзХранилищаДляПоляВвода(Объект, АдресЗапасовВХранилище) Экспорт
	
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	ВыбраноСерийныхНомеров = ТаблицаДляЗагрузки.Количество();
	ИзмененоКоличество = Ложь;
	
	//Очистить старые серии
	Объект.СерийныеНомера.Очистить();
	
	//Сформировать представление для строки запасов
	СтроковоеПредставлениеСерийныхНомеров = "";
	Для каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		
		НоваяСтрока = Объект.СерийныеНомера.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗагрузки);
		
		СтроковоеПредставлениеСерийныхНомеров = СтроковоеПредставлениеСерийныхНомеров + НоваяСтрока.СерийныйНомер+"; ";
	КонецЦикла;
	СтроковоеПредставлениеСерийныхНомеров = Лев(СтроковоеПредставлениеСерийныхНомеров, Мин(СтрДлина(СтроковоеПредставлениеСерийныхНомеров)-2,150));
	
	Объект.СерийныеНомераПредставление = СтроковоеПредставлениеСерийныхНомеров;
	Если Объект.Количество < ВыбраноСерийныхНомеров Тогда
		Объект.Количество = ВыбраноСерийныхНомеров;
		ИзмененоКоличество = Истина;
	КонецЕсли;
	
	Возврат ИзмененоКоличество;
	
КонецФункции // ПолучитьСерийныеНомераИзХранилища()

Функция ПолучитьСерийныйНомерИзХранилища(Объект, АдресЗапасовВХранилище) Экспорт
	
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	Для каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		
		Объект.СерийныйНомер = СтрокаЗагрузки.СерийныйНомер;
		Прервать;
		
	КонецЦикла;
	
КонецФункции // ПолучитьСерийныеНомераИзХранилища()

Функция ПараметрыПодбораСерийныхНомеров(ДокОбъект, УИДФормы, ИДСтроки, РежимПодбора = Неопределено, ИмяТЧ="Запасы", ИмяТЧСерийныхНомеров="СерийныеНомера", ИмяПоляКлючСвязи = "КлючСвязи",
	ЭтоОприходование = Ложь) Экспорт
	
	ТекСтрокаДанные = ДокОбъект[ИмяТЧ].НайтиПоИдентификатору(ИДСтроки);	
	Если ТекСтрокаДанные[ИмяПоляКлючСвязи]=0 Тогда
		ЗаполнитьКлючиСвязи(ДокОбъект, ИмяТЧ, ИмяПоляКлючСвязи);
	КонецЕсли;
	
	ПараметрыСерийныхНомеров = РаботаСФормойДокумента.ПодготовитьПараметрыСерийныхНомеров(ДокОбъект, ТекСтрокаДанные, УИДФормы, ИмяТЧ, ИмяТЧСерийныхНомеров, ИмяПоляКлючСвязи, ЭтоОприходование);
	Если РежимПодбора=Неопределено И РаботаССерийнымиНомерами.ИспользоватьСерийныеНомераОстатки() = Истина Тогда
		РежимПодбора = Истина;
	ИначеЕсли РежимПодбора = Неопределено Тогда
		РежимПодбора = Ложь;
	КонецЕсли;
	ПараметрыСерийныхНомеров.Вставить("РежимПодбора", РежимПодбора);
	
	//+ ГИСМ
	ПараметрыСерийныхНомеров.Вставить("ЭтоМаркировкаГИСМ", 
		ТипЗнч(ДокОбъект.Ссылка)=Тип("ДокументСсылка.МаркировкаТоваровГИСМ"));
		
	ПараметрыСерийныхНомеров.Вставить("ЭтоПеремаркировкаТоваровГИСМ", 
		ТипЗнч(ДокОбъект.Ссылка)=Тип("ДокументСсылка.ПеремаркировкаТоваровГИСМ"));
	
	
	Если ПараметрыСерийныхНомеров.ЭтоМаркировкаГИСМ Тогда
		ПараметрыСерийныхНомеров.Вставить("НоменклатураКиЗ", ТекСтрокаДанные.НоменклатураКиЗ);
		ПараметрыСерийныхНомеров.Вставить("ХарактеристикаКиЗ", ТекСтрокаДанные.ХарактеристикаКиЗ);
		ПараметрыСерийныхНомеров.Вставить("ЭтоМаркировкаОстатков", ДокОбъект.ОперацияМаркировки = Перечисления.ОперацииМаркировкиГИСМ.МаркировкаОстатковНа01042016);
		ПараметрыСерийныхНомеров.GTIN = ТекСтрокаДанные.GTIN;
	КонецЕсли;
	
	ВидМаркировкиНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекСтрокаДанные.Номенклатура, "ВидМаркировки");
	НастройкиСерий = Новый Структура(
		"ИспользоватьНомерСерии, 
		|ИспользоватьRFIDМеткиСерии",
		ВидМаркировкиНоменклатуры = Перечисления.ВидыМаркировки.МаркируемаяПродукция,
		ВидМаркировкиНоменклатуры = Перечисления.ВидыМаркировки.МаркируемаяПродукция ИЛИ ВидМаркировкиНоменклатуры = Перечисления.ВидыМаркировки.КонтрольныйИдентификационныйЗнак);
	
	ПараметрыСерийныхНомеров.Вставить("НастройкиИспользованияСерий", НастройкиСерий);
	//- ГИСМ
	
	Возврат ПараметрыСерийныхНомеров;
	
КонецФункции

Функция ПодготовитьПараметрыСерийныхНомеров(ДокОбъект, ТекСтрокаДанные, УИДФормы, ИмяТЧ = "Запасы", ИмяТЧСерийныхНомеров="СерийныеНомера", ИмяПоляКлючСвязи = "КлючСвязи",
	ЭтоОприходование = Ложь) Экспорт
	
	ОтборСерийныеНомераТекущейСтроки = Новый Структура("КлючСвязи", ТекСтрокаДанные[ИмяПоляКлючСвязи]);
	ОтборСерийныеНомераТекущейСтроки = ДокОбъект[ИмяТЧСерийныхНомеров].НайтиСтроки(ОтборСерийныеНомераТекущейСтроки);
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДокОбъект[ИмяТЧСерийныхНомеров].Выгрузить(ОтборСерийныеНомераТекущейСтроки), УИДФормы);
	
	ПараметрыОткрытия = Новый Структура("Запасы, УникальныйИдентификаторФормыВладельца, АдресВоВременномХранилище, ДокСсылка", 
		Новый Структура("КлючСвязи, Номенклатура, Характеристика, Количество", 
			//ТекСтрокаДанные.КлючСвязи, 
			ТекСтрокаДанные[ИмяПоляКлючСвязи],
			?(ЭтоОприходование, ТекСтрокаДанные.НоменклатураОприходование, ТекСтрокаДанные.Номенклатура),
			?(ЭтоОприходование, ТекСтрокаДанные.ХарактеристикаОприходование, ТекСтрокаДанные.Характеристика),
			ТекСтрокаДанные.Количество),
			УИДФормы,
			АдресВоВременномХранилище,
			ДокОбъект.Ссылка
			);
			
	Если ДокОбъект.Свойство("Организация") Тогда
		ПараметрыОткрытия.Вставить("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(ДокОбъект.Организация));
	КонецЕсли; 
	Если ТекСтрокаДанные.Свойство("СтруктурнаяЕдиница") Тогда
		ПараметрыОткрытия.Вставить("СтруктурнаяЕдиница", ТекСтрокаДанные.СтруктурнаяЕдиница);
	ИначеЕсли ДокОбъект.Свойство("СтруктурнаяЕдиница") Тогда
		ПараметрыОткрытия.Вставить("СтруктурнаяЕдиница", ДокОбъект.СтруктурнаяЕдиница);
	ИначеЕсли ДокОбъект.Свойство("СтруктурнаяЕдиницаРезерв") Тогда
		ПараметрыОткрытия.Вставить("СтруктурнаяЕдиница", ДокОбъект.СтруктурнаяЕдиницаРезерв);
	КонецЕсли;
	Если ТекСтрокаДанные.Свойство("Ячейка") Тогда
		ПараметрыОткрытия.Вставить("Ячейка", ТекСтрокаДанные.Ячейка);
	ИначеЕсли ДокОбъект.Свойство("Ячейка") Тогда
		ПараметрыОткрытия.Вставить("Ячейка", ДокОбъект.Ячейка);
	КонецЕсли; 		
	Если ТекСтрокаДанные.Свойство("ЕдиницаИзмерения") Тогда
		ПараметрыОткрытия.Запасы.Вставить("ЕдиницаИзмерения", ТекСтрокаДанные.ЕдиницаИзмерения);
		Если ТипЗнч(ТекСтрокаДанные.ЕдиницаИзмерения)=Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
		    ПараметрыОткрытия.Запасы.Вставить("Коэффициент", ТекСтрокаДанные.ЕдиницаИзмерения.Коэффициент);
		Иначе
			ПараметрыОткрытия.Запасы.Вставить("Коэффициент", 1);
		КонецЕсли;
	КонецЕсли;
	Если ТекСтрокаДанные.Свойство("Партия") Тогда
		ПараметрыОткрытия.Запасы.Вставить("Партия", ТекСтрокаДанные.Партия);
	Иначе
		ПараметрыОткрытия.Запасы.Вставить("Партия", Справочники.ПартииНоменклатуры.ПустаяСсылка());
	КонецЕсли;
	
	Если ТекСтрокаДанные.Свойство("GTIN") Тогда
		ПараметрыОткрытия.Вставить("GTIN", ТекСтрокаДанные.GTIN);
	КонецЕсли;
	Если ТекСтрокаДанные.Свойство("НоменклатураКиЗ") Тогда
		ПараметрыОткрытия.Вставить("НоменклатураКиЗ", ТекСтрокаДанные.НоменклатураКиЗ);
	КонецЕсли;
	Если ТекСтрокаДанные.Свойство("ХарактеристикаКиЗ") Тогда
		ПараметрыОткрытия.Вставить("ХарактеристикаКиЗ", ТекСтрокаДанные.ХарактеристикаКиЗ);
	КонецЕсли;
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

Функция ПараметрыПодбораСерийныхНомеровВПолеВвода(ДокОбъект, УИДФормы, РежимПодбора = Неопределено) Экспорт
	
	//Если номенклатура одна на документ (в реквизитах, а не в табличной части)
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДокОбъект.СерийныеНомера.Выгрузить(), УИДФормы);
	
	ПараметрыСерийныхНомеров = Новый Структура("Запасы, УникальныйИдентификаторФормыВладельца, АдресВоВременномХранилище, ДокСсылка", 
		Новый Структура("Номенклатура, Характеристика", 
			ДокОбъект.Номенклатура,
			ДокОбъект.Характеристика),
			УИДФормы,
			АдресВоВременномХранилище,
			ДокОбъект.Ссылка
			);
			
	Если ДокОбъект.Свойство("Количество") Тогда
		ПараметрыСерийныхНомеров.Запасы.Вставить("Количество", ДокОбъект.Количество);
	Иначе
		ПараметрыСерийныхНомеров.Запасы.Вставить("Количество", 1);
	КонецЕсли;
			
	Если ДокОбъект.Свойство("СтруктурнаяЕдиница") Тогда
		ПараметрыСерийныхНомеров.Вставить("СтруктурнаяЕдиница", ДокОбъект.СтруктурнаяЕдиница);
	КонецЕсли;
	Если ДокОбъект.Свойство("Ячейка") Тогда
		ПараметрыСерийныхНомеров.Вставить("Ячейка", ДокОбъект.Ячейка);
	КонецЕсли; 		
	Если ДокОбъект.Свойство("Партия") Тогда
		ПараметрыСерийныхНомеров.Запасы.Вставить("Партия", ДокОбъект.Партия);
	Иначе
		ПараметрыСерийныхНомеров.Запасы.Вставить("Партия", Справочники.ПартииНоменклатуры.ПустаяСсылка());
	КонецЕсли; 		
	Если ДокОбъект.Свойство("ЕдиницаИзмерения") Тогда
		ПараметрыСерийныхНомеров.Запасы.Вставить("ЕдиницаИзмерения", ДокОбъект.ЕдиницаИзмерения);
		Если ТипЗнч(ДокОбъект.ЕдиницаИзмерения)=Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
		    ПараметрыСерийныхНомеров.Запасы.Вставить("Коэффициент", ДокОбъект.ЕдиницаИзмерения.Коэффициент);
		Иначе
			ПараметрыСерийныхНомеров.Запасы.Вставить("Коэффициент", 1);
		КонецЕсли;
	КонецЕсли;
	
	////////////////////////////////////////////////////
	Если РежимПодбора=Неопределено И ПолучитьФункциональнуюОпцию("КонтрольОстатковСерийныхНомеров") Тогда
		РежимПодбора = Истина;
	Иначе
		РежимПодбора = Ложь;
	КонецЕсли;
	ПараметрыСерийныхНомеров.Вставить("РежимПодбора", РежимПодбора);
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Организация", ДокОбъект.Ссылка.Метаданные()) Тогда
		ПараметрыСерийныхНомеров.Вставить("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(ДокОбъект.Организация));
	КонецЕсли; 
	
	Возврат ПараметрыСерийныхНомеров;
	
КонецФункции

Функция ПараметрыПодбораСерийныхНомеровДляРемонтов(ДокОбъект, УИДФормы, РежимПодбора = Неопределено) Экспорт
	
	//Если номенклатура одна на документ (в реквизитах, а не в табличной части)
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДокОбъект.СерийныйНомер, УИДФормы);
	
	ПараметрыСерийныхНомеров = Новый Структура("Запасы, УникальныйИдентификаторФормыВладельца, АдресВоВременномХранилище, ДокСсылка", 
		Новый Структура("Номенклатура, Характеристика", 
			ДокОбъект.Номенклатура,
			ДокОбъект.Характеристика),
			УИДФормы,
			АдресВоВременномХранилище,
			ДокОбъект.Ссылка
			);
			
	ПараметрыСерийныхНомеров.Запасы.Вставить("Количество", 1);
	
	Если ДокОбъект.Свойство("СтруктурнаяЕдиница") Тогда
		ПараметрыСерийныхНомеров.Вставить("СтруктурнаяЕдиница", ДокОбъект.СтруктурнаяЕдиница);
	КонецЕсли;
	ПараметрыСерийныхНомеров.Запасы.Вставить("Партия", Справочники.ПартииНоменклатуры.ПустаяСсылка());
	
	ПараметрыСерийныхНомеров.Запасы.Вставить("ЕдиницаИзмерения", ДокОбъект.Номенклатура.ЕдиницаИзмерения);
	ПараметрыСерийныхНомеров.Запасы.Вставить("Коэффициент", 1);
	
	////////////////////////////////////////////////////
	Если РежимПодбора=Неопределено И ПолучитьФункциональнуюОпцию("КонтрольОстатковСерийныхНомеров") Тогда
		РежимПодбора = Истина;
	Иначе
		РежимПодбора = Ложь;
	КонецЕсли;
	ПараметрыСерийныхНомеров.Вставить("РежимПодбора", РежимПодбора);
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Организация", ДокОбъект.Ссылка.Метаданные()) Тогда
		ПараметрыСерийныхНомеров.Вставить("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(ДокОбъект.Организация));
	КонецЕсли; 
	
	Возврат ПараметрыСерийныхНомеров;
	
КонецФункции

Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные) Экспорт
	
	Если СтруктураДанные.Свойство("Номенклатура") Тогда
		СтруктураДанные.Вставить("ЕдиницаИзмерения", СтруктураДанные.Номенклатура.ЕдиницаИзмерения);
	КонецЕсли;
	
	Если СтруктураДанные.Свойство("НалогообложениеНДС") 
		И НЕ СтруктураДанные.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДС Тогда
		
		Если СтруктураДанные.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НеОблагаетсяНДС Тогда
			СтруктураДанные.Вставить("СтавкаНДС", УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСБезНДС());
		Иначе
			СтруктураДанные.Вставить("СтавкаНДС", УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСНоль());
		КонецЕсли;	
																
	ИначеЕсли ЗначениеЗаполнено(СтруктураДанные.Номенклатура.СтавкаНДС) Тогда
		СтруктураДанные.Вставить("СтавкаНДС", СтруктураДанные.Номенклатура.СтавкаНДС);
	Иначе
		СтруктураДанные.Вставить("СтавкаНДС", СтруктураДанные.Организация.СтавкаНДСПоУмолчанию);
	КонецЕсли;
	
	Если СтруктураДанные.Свойство("ВидСкидкиНаценки") 
		И ЗначениеЗаполнено(СтруктураДанные.ВидСкидкиНаценки) Тогда
		СтруктураДанные.Вставить("ПроцентСкидкиНаценки", СтруктураДанные.ВидСкидкиНаценки.Процент);
	Иначе	
		СтруктураДанные.Вставить("ПроцентСкидкиНаценки", 0);
	КонецЕсли;
		
	Если СтруктураДанные.Свойство("ПроцентСкидкиПоДисконтнойКарте") 
		И ЗначениеЗаполнено(СтруктураДанные.ДисконтнаяКарта) Тогда
		ТекПроцент = СтруктураДанные.ПроцентСкидкиНаценки;
		СтруктураДанные.Вставить("ПроцентСкидкиНаценки", ТекПроцент + СтруктураДанные.ПроцентСкидкиПоДисконтнойКарте);
	КонецЕсли;

	Возврат СтруктураДанные;
	
КонецФункции

Процедура РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, СуммаВключаетНДС) Экспорт
	
	Если СтрокаТабличнойЧасти.ПроцентСкидкиНаценки = 100 Тогда
		СтрокаТабличнойЧасти.Сумма = 0;
	ИначеЕсли СтрокаТабличнойЧасти.ПроцентСкидкиНаценки <> 0
			И СтрокаТабличнойЧасти.Количество <> 0 Тогда
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Сумма * (1 - СтрокаТабличнойЧасти.ПроцентСкидкиНаценки / 100);
	КонецЕсли;
	
	РассчитатьСуммуНДС(СтрокаТабличнойЧасти, СуммаВключаетНДС);
	СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(СуммаВключаетНДС, 0, СтрокаТабличнойЧасти.СуммаНДС);
	
КонецПроцедуры // РассчитатьСуммуВСтрокеТабличнойЧасти()

Процедура РассчитатьСуммуНДС(СтрокаТабличнойЧасти, СуммаВключаетНДС)
	
	СтавкаНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(СтрокаТабличнойЧасти.СтавкаНДС);
	
	СтрокаТабличнойЧасти.СуммаНДС = ?(СуммаВключаетНДС, 
									  СтрокаТабличнойЧасти.Сумма - (СтрокаТабличнойЧасти.Сумма) / ((СтавкаНДС + 100) / 100),
									  СтрокаТабличнойЧасти.Сумма * СтавкаНДС / 100);
	
КонецПроцедуры

Процедура ЗаполнитьКлючиСвязи(Объект, ИмяТЧ, ИмяПоляКлючСвязи = "КлючСвязи") Экспорт
	
	Индекс = 0;
	Для Каждого СтрокаТЧ Из Объект[ИмяТЧ] Цикл
		Если Не ЗначениеЗаполнено(СтрокаТЧ[ИмяПоляКлючСвязи]) Тогда
			УправлениеНебольшойФирмойКлиентСервер.ЗаполнитьКлючСвязи(Объект[ИмяТЧ], СтрокаТЧ, ИмяПоляКлючСвязи);
		КонецЕсли;
		Если Индекс < СтрокаТЧ[ИмяПоляКлючСвязи] Тогда
			Индекс = СтрокаТЧ[ИмяПоляКлючСвязи];
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьКлючиСвязиВТабличнойЧастиТовары()

#КонецОбласти