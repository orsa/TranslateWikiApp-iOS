//
//  constants.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 30/3/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#ifndef TranslateWikiApp_constants_h
#define TranslateWikiApp_constants_h


//measures
#define INITIAL_TUPLE_SIZE @"10"  //esier to save as a string
#define MAX_RECENT_PROJ 3
#define MAX_RECENT_LANG 3
#define MAX_LOCAL_LANG 2

//keys for NSUserDefaults
#define LANG_key        @"defaultLanguage"
#define PROJ_key        @"defaultProject"
#define TUPSIZE_key     @"defaultTupleSize"
#define PRMODE_key      @"proofreadOnlyState"
#define RECENT_LANG_key @"recentLanguages"
#define RECENT_PROJ_key @"recentProjects"
#define RECENT_USER_key @"recentLoginUserName"

//pseudo-static data
#define LANGUAGE_NAMES @"Afar", @"Abkhazian", @"Avestan", @"Afrikaans", @"Akan", @"Amharic", @"Aragonese", @"Arabic", @"Assamese", @"Avaric", @"Aymara", @"Azerbaijani", @"Bashkir", @"Belarusian", @"Bulgarian", @"Bihari languages", @"Bislama", @"Bambara", @"Bengali", @"Tibetan", @"Breton", @"Bosnian", @"Catalan; Valencian", @"Chechen", @"Chamorro", @"Corsican", @"Cree", @"Czech", @"Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church Slavonic", @"Chuvash", @"Welsh", @"Danish", @"German", @"Divehi; Dhivehi; Maldivian", @"Dzongkha", @"Ewe", @"Greek, Modern (1453-)", @"English", @"Esperanto", @"Spanish; Castilian", @"Estonian", @"Basque", @"Persian", @"Fulah", @"Finnish", @"Fijian", @"Faroese", @"French", @"Western Frisian", @"Irish", @"Gaelic; Scottish Gaelic", @"Galician", @"Guarani", @"Gujarati", @"Manx", @"Hausa", @"Hebrew", @"Hindi", @"Hiri Motu", @"Croatian", @"Haitian; Haitian Creole", @"Hungarian", @"Armenian", @"Herero", @"Interlingua (International Auxiliary Language Association)", @"Indonesian", @"Interlingue; Occidental", @"Igbo", @"Sichuan Yi; Nuosu", @"Inupiaq", @"Ido", @"Icelandic", @"Italian", @"Inuktitut", @"Japanese", @"Javanese", @"Georgian", @"Kongo", @"Kikuyu; Gikuyu", @"Kuanyama; Kwanyama", @"Kazakh", @"Kalaallisut; Greenlandic", @"Central Khmer", @"Kannada", @"Korean", @"Kanuri", @"Kashmiri", @"Kurdish", @"Komi", @"Cornish", @"Kirghiz; Kyrgyz", @"Latin", @"Luxembourgish; Letzeburgesch", @"Ganda", @"Limburgan; Limburger; Limburgish", @"Lingala", @"Lao", @"Lithuanian", @"Luba-Katanga", @"Latvian", @"Malagasy", @"Marshallese", @"Maori", @"Macedonian", @"Malayalam", @"Mongolian", @"Marathi", @"Malay", @"Maltese", @"Burmese", @"Nauru", @"Bokmål, Norwegian; Norwegian Bokmål", @"Ndebele, North; North Ndebele", @"Nepali", @"Ndonga", @"Dutch; Flemish", @"Norwegian Nynorsk; Nynorsk, Norwegian", @"Norwegian", @"Ndebele, South; South Ndebele", @"Navajo; Navaho", @"Chichewa; Chewa; Nyanja", @"Occitan (post 1500)", @"Ojibwa", @"Oromo", @"Oriya", @"Ossetian; Ossetic", @"Panjabi; Punjabi", @"Pali", @"Polish", @"Pushto; Pashto", @"Portuguese", @"Quechua", @"Romansh", @"Rundi", @"Romanian; Moldavian; Moldovan", @"Russian", @"Kinyarwanda", @"Sanskrit", @"Sardinian", @"Sindhi", @"Northern Sami", @"Sango", @"Sinhala; Sinhalese", @"Slovak", @"Slovenian", @"Samoan", @"Shona", @"Somali", @"Albanian", @"Serbian", @"Swati", @"Sotho, Southern", @"Sundanese", @"Swedish", @"Swahili", @"Tamil", @"Telugu", @"Tajik", @"Thai", @"Tigrinya", @"Turkmen", @"Tagalog", @"Tswana", @"Tonga (Tonga Islands)", @"Turkish", @"Tsonga", @"Tatar", @"Twi", @"Tahitian", @"Uighur; Uyghur", @"Ukrainian", @"Urdu", @"Uzbek", @"Venda", @"Vietnamese", @"Volapük", @"Walloon", @"Wolof", @"Xhosa", @"Yiddish", @"Yoruba", @"Zhuang; Chuang", @"Chinese", @"Zulu", nil


#define LANGUAGE_CODES @"aa", @"ab", @"ae", @"af", @"ak", @"am", @"an", @"ar", @"as", @"av", @"ay", @"az", @"ba", @"be", @"bg", @"bh", @"bi", @"bm", @"bn", @"bo", @"br", @"bs", @"ca", @"ce", @"ch", @"co", @"cr", @"cs", @"cu", @"cv", @"cy", @"da", @"de", @"dv", @"dz", @"ee", @"el", @"en", @"eo", @"es", @"et", @"eu", @"fa", @"ff", @"fi", @"fj", @"fo", @"fr", @"fy", @"ga", @"gd", @"gl", @"gn", @"gu", @"gv", @"ha", @"he", @"hi", @"ho", @"hr", @"ht", @"hu", @"hy", @"hz", @"ia", @"id", @"ie", @"ig", @"ii", @"ik", @"io", @"is", @"it", @"iu", @"ja", @"jv", @"ka", @"kg", @"ki", @"kj", @"kk", @"kl", @"km", @"kn", @"ko", @"kr", @"ks", @"ku", @"kv", @"kw", @"ky", @"la", @"lb", @"lg", @"li", @"ln", @"lo", @"lt", @"lu", @"lv", @"mg", @"mh", @"mi", @"mk", @"ml", @"mn", @"mr", @"ms", @"mt", @"my", @"na", @"nb", @"nd", @"ne", @"ng", @"nl", @"nn", @"no", @"nr", @"nv", @"ny", @"oc", @"oj", @"om", @"or", @"os", @"pa", @"pi", @"pl", @"ps", @"pt", @"qu", @"rm", @"rn", @"ro", @"ru", @"rw", @"sa", @"sc", @"sd", @"se", @"sg", @"si", @"sk", @"sl", @"sm", @"sn", @"so", @"sq", @"sr", @"ss", @"st", @"su", @"sv", @"sw", @"ta", @"te", @"tg", @"th", @"ti", @"tk", @"tl", @"tn", @"to", @"tr", @"ts", @"tt", @"tw", @"ty", @"ug", @"uk", @"ur", @"uz", @"ve", @"vi", @"vo", @"wa", @"wo", @"xh", @"yi", @"yo", @"za", @"zh", @"zu", nil //183 items



#define COMMON_LANGUAGE_NAMES  @"Arabic", @"Armenian", @"Belarusian", @"Bosnian", @"Chamorro", @"Chinese", @"Croatian", @"Czech", @"Danish", @"English", @"Estonian", @"Finnish", @"French", @"Georgian", @"German", @"Greek, Modern", @"Hebrew", @"Hindi", @"Hungarian", @"Italian", @"Japanese", @"Korean", @"Kurdish", @"Lao", @"Latin", @"Lithuanian", @"Macedonian", @"Nepali", @"Norwegian", @"Persian", @"Slovak", @"Thai", @"Tibetan", @"Urdu", @"Yiddish", nil

#define COMMONLANGUAGE_CODES @"ar", @"hy", @"be", @"bs", @"ch", @"zh", @"hr", @"cs", @"da", @"en", @"et", @"fi", @"fr", @"ka", @"de", @"el", @"he", @"hi", @"hu", @"it", @"ja", @"ko", @"ku", @"lo", @"la", @"lt", @"mk", @"ne", @"no", @"fa", @"sk", @"th", @"bo", @"ur", @"yi", nil //35 items

#define alertMessages @{@"NoName": @"You left the user name field empty", @"Illegal":@"You provided an illegal user name", @"NotExists":@"The user name you provided doesn't exist", @"EmptyPass": @"You left the password field empty", @"WrongPass": @"The password you provided is incorrect", @"WrongPluginPass": @"Authentication plugin rejected the password", @"CreateBlocked": @"The wiki tried to automatically create a new account for you, but your IP address has been blocked from account creation", @"Throttled": @"You've logged in too many times in a short time. Please wait 5 minutes.", @"Blocked": @"Can't login. User is blocked"}

//code snippets
#define myAppDelegate       [[UIApplication sharedApplication] delegate]
#define PREFERRED_LANG(X)   [[NSLocale preferredLanguages] objectAtIndex:X]

#define ShowNetworkActivityIndicator()  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

#define LoadUserDefaults()          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]
#define getUserDefaultskey(X)       [defaults objectForKey:X]
#define setUserDefaultskey(X,Y)     [defaults setObject:X forKey:Y]
#define getBoolUserDefaultskey(X)   [defaults boolForKey:X]
#define setBoolUserDefaultskey(X,Y) [defaults setBool:X forKey:Y]


//DEBUG purpose
#define LOG(X)  NSLog(@"%@\n",X)

#endif
