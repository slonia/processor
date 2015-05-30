#encoding "utf-8"

Region -> Adj<gnc-agr[1],h-reg1> Word<kwtype="АдмЕдиница", gnc-agr[1]>;
CountryOrCity -> Word<kwtype="СтраныСтолицы">+;
AutoAlg ->  Word<gram="geo">;
Location -> CountryOrCity | AutoAlg | Region;
Place -> Location interp (Place.Place);

