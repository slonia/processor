#encoding "utf-8"
Day -> Word<kwtype="день">;
Number -> OrdinalNumeral | Word<wfm="[0-9]{1,2}">;
DateName -> Day | Word<kwtype="дата"> | Number* Word<kwtype="месяц">;

Date -> DateName interp (Date.Name);
