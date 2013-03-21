//
//  TWUserPreferences.m
//  TranslateWikiApp
//
//  Created by Tomer Tuchner on 3/21/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "TWUserPreferences.h"

@implementation TWUserPreferences

-(id)init{
    self=[super init];
    if(self)
    {
        _preferredLang = [[NSLocale preferredLanguages] objectAtIndex:0];
        _preferredProj = @"!recent";
        return self;
    }
    return nil;
}

@end
