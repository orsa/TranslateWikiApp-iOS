//
//  TranslationMessage.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "TranslationMessage.h"

@implementation TranslationMessage

-(id) initWithDefinition:(NSString*) def withTranslation:(NSString*)trans withLanguage:(NSString*)lang withKey:(NSString*)k withRevision:(NSString*)rev withAccepted:(BOOL)accepted{
    self = [super init];
    if (self) {
        _source=def;
        _translation=trans;
        _language=lang;
        _key=k;
        _revision=rev;
        _isAccepted=accepted;
        return self;
    }
    return nil;
}

@end
