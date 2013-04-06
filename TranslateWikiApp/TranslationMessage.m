//
//  TranslationMessage.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "TranslationMessage.h"

@implementation TranslationMessage

-(id) initWithDefinition:(NSString*) def withTranslation:(NSString*)trans withLanguage:(NSString*)lang withProject:(NSString*)proj withKey:(NSString*)k withRevision:(NSString*)rev withTitle:(NSString*)mTitle withAccepted:(BOOL)accepted WithAceeptCount:(NSInteger) ac
{
    self = [super init];
    if (self) {
        _source=def;
        _translation=trans;
        _language=lang;
        _project=proj;
        _key=k;
        _revision=rev;
        _title=mTitle;
        _isAccepted=accepted;
        _acceptCount=ac;
        _suggestions=[[NSMutableArray alloc] init];
        
        return self;
    }
    return nil;
}

-(void)addSuggestionsFromResponse:(NSMutableDictionary*)translationAids
{
    int i=0;
    NSMutableArray* sugg=translationAids[@"mt"];
    for(NSMutableDictionary* suggElem in sugg){
        _suggestions[i]=[[NSMutableDictionary alloc] init];
        _suggestions[i][@"suggestion"]=suggElem[@"target"];
        _suggestions[i][@"service"]=suggElem[@"service"];
        i=i+1;
    }
}

@end
