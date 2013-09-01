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
//
//*********************************************************************************
// TranslationMessage - contains all information about a message
//*********************************************************************************

#import "TranslationMessage.h"
#import "constants.h"

@implementation TranslationMessage
@synthesize source, translation, translationByUser, translated, minimized, language, project, key, revision, title, acceptCount, suggestions, documentation, noDocumentation, userInput, infoState, prState;

-(id) initWithDefinition:(NSString*) def withTranslation:(NSString*)trans withLanguage:(NSString*)lang withProject:(NSString*)proj withKey:(NSString*)k withRevision:(NSString*)rev withTitle:(NSString*)mTitle  WithAceeptCount:(NSInteger)ac InState:(BOOL)newPrState
{
    self = [super init];
    if (self) {
        source         = def;
        translation    = trans;
        translationByUser=@"";
        translated     = FALSE;
        minimized      = FALSE;
        language       = lang;
        project        = proj;
        key            = k;
        revision       = rev;
        title          = mTitle;
        acceptCount    = ac;
        suggestions    = [[NSMutableArray alloc] init];
        documentation  = @"";
        noDocumentation= YES;
        userInput      = @"";
        infoState      = NO;
        prState         = newPrState;
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
        if([suggestion length]>MAX_SUGEGSTION_LENGTH)//if suggestion is too long
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
        suggestions[j]=uniqueSuggs[j];
    }
}

-(void)addDocumentationFromResponse:(NSMutableDictionary*)translationAids
{
    NSMutableDictionary* doc=translationAids[@"documentation"];
    NSString* valueDocumentation = [self cutCollapsibleFromHtml:doc[@"html"]];//@"value" for templated text
    if([valueDocumentation isKindOfClass:[NSNull class]] || [valueDocumentation isEqualToString:@""]){
        documentation=@"";
        noDocumentation=YES;
    }
    else{
        documentation=valueDocumentation;
        noDocumentation=NO;
    }
}

//cutting all collapsible elements from the html documentation
-(NSString*)cutCollapsibleFromHtml:(NSString*)html{
    NSRange range=[html rangeOfString:startOfCollapsible1];
    if(range.location==NSNotFound){
        range=[html rangeOfString:startOfCollapsible2];
        if(range.location==NSNotFound)
            return html;
        else
            return [html substringToIndex:range.location];
    }
    else{
        return [html substringToIndex:range.location];
    }
}

#pragma mark TranslationCell heights
-(bool)needsExpansionUnderWidth:(CGFloat)width
{
    if([self getUnexpandedHeightOfSource]<[self getExpandedHeightOfSourceUnderWidth:width])
        return YES;
    for(int i=0; i<[suggestions count]; i++){
        if([self getUnexpandedHeightOfSuggestion]<[self getExpandedHeightOfSuggestionNumber:i underWidth:width])
            return YES;
    }
    return NO;
}

-(CGFloat)getUnexpandedHeightOfSource{ return 50; }

-(CGFloat)getUnexpandedHeightOfSuggestion{ return 50; }

-(CGFloat)getExpandedHeightOfSourceUnderWidth:(CGFloat)width{
    return max([source sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height, [self getUnexpandedHeightOfSource]);
}

-(CGFloat)getExpandedHeightOfSuggestionNumber:(NSInteger)i underWidth:(CGFloat)width{
    return 50;
}

-(CGFloat)getCombinedExpandedHeightOfSuggestionUnderWidth:(CGFloat)width{
    float h=0;
    for(int i=0; i<suggestions.count; i++){
        h+=[self getExpandedHeightOfSuggestionNumber:i underWidth:width];
    }
    return h;
}

// determine frame's height by number of suggestions
-(CGFloat)heightForImageView{
    int n=[suggestions count];
    switch (n) {            
        case 0: return 84;
        case 1: return 135;
        case 2: return 197;
        case 3: return 245;
    }
    return 245;//won't get here normally
}

@end
