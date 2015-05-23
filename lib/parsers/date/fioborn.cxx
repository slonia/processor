#encoding "utf-8"

Number -> OrdinalNumeral | Word<wfm="[0-9]{1,2}">;
DateName -> Word<kwtype="дата"> | Number* Word<kwtype="месяц">;

Date -> DateName interp (Date.Name);
