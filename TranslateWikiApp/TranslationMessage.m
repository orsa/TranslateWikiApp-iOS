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
#import "constants.h"

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
    NSMutableArray* mt=translationAids[@"mt"];
    for(NSMutableDictionary* suggElem in mt){
        _suggestions[i]=[[NSMutableDictionary alloc] init];
        NSString* service=suggElem[@"service"];
        _suggestions[i][@"suggestion"]=suggElem[@"target"];
        _suggestions[i][@"service"]=service;
        i=i+1;
    }
    NSMutableArray* ttmserver=translationAids[@"ttmserver"];
    NSMutableArray* TMsuggestionsArray=[[NSMutableArray alloc] init];
    int j=0;
    for(NSMutableDictionary* suggElem in ttmserver){
        __block NSString* suggestion=suggElem[@"target"];
        if([[TMsuggestionsArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSMutableDictionary* sugg=(NSMutableDictionary*)evaluatedObject;
            NSString* suggString=sugg[@"suggestion"];
            if([suggString isEqualToString:suggestion])
                return YES;
            else
                return NO;
        }]] count]>0)//if suggestion already appeared
            break;
        TMsuggestionsArray[j]=[[NSMutableDictionary alloc] init];
        TMsuggestionsArray[j][@"suggestion"]=suggestion;
        NSNumber* quality=(NSNumber*)suggElem[@"quality"];
        TMsuggestionsArray[j][@"quality"]=quality;
        j=j+1;
    }
    int suggCount=[TMsuggestionsArray count];
    [TMsuggestionsArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSMutableDictionary* sugg1=(NSMutableDictionary*)obj1;
        NSMutableDictionary* sugg2=(NSMutableDictionary*)obj2;
        double quality1=[(NSNumber*)sugg1[@"quality"] doubleValue];
        double quality2=[(NSNumber*)sugg2[@"quality"] doubleValue];
        
        if(quality1>quality2)
            return NSOrderedAscending;
        else{
            if(quality1<quality2)
                return NSOrderedDescending;
            else
                return NSOrderedSame;
        }
        
    }];//sorting array according to quality
    int iterations=min(suggCount, MAX_NUMBER_OF_SUGGESTIONS-[_suggestions count]);
    for(j=0; j<iterations; j=j+1){
        _suggestions[i]=TMsuggestionsArray[j];
        i=i+1;
    }
}

/*
 -(void)addSuggestionsFromResponse:(NSMutableDictionary*)translationAids
 {
 int i=0;
 NSMutableArray* mt=translationAids[@"mt"];
 for(NSMutableDictionary* suggElem in mt){
 _suggestions[i]=[[NSMutableDictionary alloc] init];
 NSString* service=suggElem[@"service"];
 _suggestions[i][@"suggestion"]=[NSString stringWithFormat:@"%@\nBy %@", suggElem[@"target"], service];
 _suggestions[i][@"service"]=service;
 i=i+1;
 }
 NSMutableArray* ttmserver=translationAids[@"ttmserver"];
 for(NSMutableDictionary* suggElem in ttmserver){
 _suggestions[i]=[[NSMutableDictionary alloc] init];
 NSString* quality=suggElem[@"quality"];//(int)number
 _suggestions[i][@"suggestion"]=[NSString stringWithFormat:@"%@\nFrom server memory, quality: %@", suggElem[@"target"], quality];
 _suggestions[i][@"quality"]=quality;
 i=i+1;
 }
 }
 */

@end
