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
        _translationByUser=@"";
        _translated=FALSE;
        _minimized=FALSE;
        _language=lang;
        _project=proj;
        _key=k;
        _revision=rev;
        _title=mTitle;
        _isAccepted=accepted;
        _acceptCount=ac;
        _suggestions=[[NSMutableArray alloc] init];
        _userInput = @"";
        _infoState = NO;
        
        
        return self;
    }
    return nil;
}

-(void)addSuggestionsFromResponse:(NSMutableDictionary*)translationAids
{
    //getting the machine translations
    int i=0;
    NSMutableArray* mt=translationAids[@"mt"];
    NSMutableArray* machineSuggestionArray=[[NSMutableArray alloc] init];
    for(NSMutableDictionary* suggElem in mt){
        machineSuggestionArray[i]=[[NSMutableDictionary alloc] init];
        NSString* service=suggElem[@"service"];
        machineSuggestionArray[i][@"suggestion"]=suggElem[@"target"];
        machineSuggestionArray[i][@"service"]=service;
        i=i+1;
    }
    NSMutableArray* ttmserver=translationAids[@"ttmserver"];
    NSMutableArray* TMsuggestionsArray=[[NSMutableArray alloc] init];
    
    //getting the translation memory suggestions
    i=0;
    for(NSMutableDictionary* suggElem in ttmserver){
        __block NSString* suggestion=suggElem[@"target"];
        NSNumber* quality=(NSNumber*)suggElem[@"quality"];
        if([quality doubleValue]<MESSAGE_ACCURACY_TRESHOLD)//if accuracy isn't enough
            continue;
        
        TMsuggestionsArray[i]=[[NSMutableDictionary alloc] init];
        TMsuggestionsArray[i][@"suggestion"]=suggestion;
        TMsuggestionsArray[i][@"quality"]=quality;
        i=i+1;
    }
    
    //sorting memory suggs according to quality
    [TMsuggestionsArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSMutableDictionary* sugg1=(NSMutableDictionary*)obj1;
        NSMutableDictionary* sugg2=(NSMutableDictionary*)obj2;
        double quality1=[(NSNumber*)sugg1[@"quality"] doubleValue];
        double quality2=[(NSNumber*)sugg2[@"quality"] doubleValue];
        
        if(quality1>quality2) return NSOrderedAscending; else{ if(quality1<quality2) return NSOrderedDescending; else return NSOrderedSame;}
    }];
    
    //combining machine and memory suggestions, with machine suggs first
    int j;
    NSMutableArray* tempSuggArray=[[NSMutableArray alloc] init];
    for(j=0; j<[machineSuggestionArray count]+[TMsuggestionsArray count]; j=j+1){
        if(j<[machineSuggestionArray count])
            tempSuggArray[j]=machineSuggestionArray[j];
        else
            tempSuggArray[j]=TMsuggestionsArray[j-[machineSuggestionArray count]];
    }
    
    //clearing duplicates
    NSMutableArray* uniqueSuggs=[[NSMutableArray alloc] init];
    for(j=0; j<[tempSuggArray count]; j=j+1){
        NSString* suggestion=tempSuggArray[j][@"suggestion"];
        if([[uniqueSuggs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSMutableDictionary* sugg=(NSMutableDictionary*)evaluatedObject;
            NSString* suggString=sugg[@"suggestion"];
            if([suggString isEqualToString:suggestion])
                return YES;
            else
                return NO;
        }]] count]==0)//if suggestion never appeared
            [uniqueSuggs addObject:tempSuggArray[j]];
    }
    //putting the final result inside _suggestions, up to the maxmimum capacity
    int iterations=min([uniqueSuggs count], MAX_NUMBER_OF_SUGGESTIONS);
    for(j=0; j<iterations; j=j+1){
        _suggestions[j]=uniqueSuggs[j];
    }
}

@end
