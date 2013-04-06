//
//  TranslationMessage.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranslationMessage : NSObject
@property(nonatomic, copy)NSString* source;
@property(nonatomic, copy)NSString* translation;
@property(nonatomic, copy)NSString* language;
@property(nonatomic, copy)NSString* project;
@property(nonatomic, copy)NSString* key;
@property(nonatomic, copy)NSString* revision;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSMutableArray* suggestions;
@property(nonatomic)BOOL isAccepted;
@property(nonatomic)NSInteger acceptCount;


-(id) initWithDefinition:(NSString*) def withTranslation:(NSString*)trans withLanguage:(NSString*)lang withProject:(NSString*)proj withKey:(NSString*)k withRevision:(NSString*)rev withTitle:(NSString*)mTitle withAccepted:(BOOL)accepted WithAceeptCount:(NSInteger) ac;
-(void)addSuggestionsFromResponse:(NSMutableDictionary*)translationAids;
/*
//getters
-(NSString*) source;
-(NSString*) translation;
-(NSString*) language;
-(int) key;
-(int) revision;
-(BOOL) isAccepted;

//setters
-(void) setSource:(NSString*)input;
-(void) setTranslation:(NSString*)input;
-(void) setLanguage:(NSString*)input;
-(void) setKey:(int)input;
-(void) setRevision:(int)input;
-(void) setIsAccepted:(BOOL)input;
 */
@end


