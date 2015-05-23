#encoding "utf-8"

DateName -> Word<kwtype="дата"> | ((OrdinalNumeral | Word<wfm=/\d+>)* Word<kwtype="месяц">);

Date -> DateName interp (Date.Name);
