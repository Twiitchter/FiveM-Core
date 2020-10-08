Locale = Merge(Locale, _Locale)
-- To avoid conflict of global variables, listing this one as _Locale and merging into Locale during compilation.
_Locale = {}

_Locale['en'] = {
	--[[Key/Value]]--
	['missing_locale'] = 'Locale Missing.',
	['not_boolean'] = 'Variable is not a boolean.',
	['not_string'] ='Variable is not a string.',
	['not_number'] ='Variable is not a number.',
	['not_float'] ='Variable is not a float.',
	['not_table'] ='Variable is not a table.',
}