﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.КлиентЛицензированияКлиент.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Подключает обработчик запроса настроек клиента лицензирования.
//
Процедура ПодключитьОбработчикБИПДляЗапросаНастроекКлиентаЛицензирования() Экспорт
	
	ИмяГлобальногоМетода = "ПриЗапросеНастроекКлиентаЛицензирования";
	ПодключитьОбработчикЗапросаНастроекКлиентаЛицензирования(ИмяГлобальногоМетода);
	
КонецПроцедуры

#КонецОбласти
