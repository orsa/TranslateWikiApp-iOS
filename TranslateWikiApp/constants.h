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
#define LANG_key    @"defaultLanguage"
#define RECENT_LANG_key    @"recentLanguages"
#define PROJ_key    @"defaultProject"
#define TUPSIZE_key @"defaultTupleSize"
#define PRMODE_key  @"proofreadOnlyState"
#define RECENT_USER_key  @"recentLoginUserName"

//pseudo-static data
#define LANGUAGE_NAMES  @"Arabic", @"Armenian", @"Belarusian", @"Bosnian", @"Chamorro", @"Chinese", @"Croatian", @"Czech", @"Danish", @"English", @"Estonian", @"Finnish", @"French", @"Georgian", @"German", @"Greek, Modern", @"Hebrew", @"Hindi", @"Hungarian", @"Italian", @"Japanese", @"Korean", @"Kurdish", @"Lao", @"Latin", @"Lithuanian", @"Macedonian", @"Nepali", @"Norwegian", @"Persian", @"Slovak", @"Thai", @"Tibetan", @"Urdu", @"Yiddish", nil

#define LANGUAGE_CODES @"ar", @"hy", @"be", @"bs", @"ch", @"zh", @"hr", @"cs", @"da", @"en", @"et", @"fi", @"fr", @"ka", @"de", @"el", @"he", @"hi", @"hu", @"it", @"ja", @"ko", @"ku", @"lo", @"la", @"lt", @"mk", @"ne", @"no", @"fa", @"sk", @"th", @"bo", @"ur", @"yi", nil


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
