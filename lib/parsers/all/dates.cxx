#encoding "utf-8"

Day -> Word<kwtype="День">;
Number -> OrdinalNumeral | Word<wfm="[0-9]{1,2}">;
DateName -> Day | Word<kwtype="Дата"> | (Number) Word<kwtype="Месяц">;

Date -> DateName interp (Date.Date);
