//
//  TranslationMessage.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//
//  Copyright 2013 Or Sagi, Tomer Tuchner
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
