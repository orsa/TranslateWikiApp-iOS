//
//  TranslationMessage.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <Foundation/Foundation.h>

@interface TranslationMessage : NSObject
@property(nonatomic, copy)NSString* source;
@property(nonatomic, copy)NSString* translation;
@property(nonatomic, copy)NSString* translationByUser;
@property BOOL translated;
@property BOOL minimized;
@property(nonatomic, copy)NSString* userInput;
@property(nonatomic, copy)NSString* language;
@property(nonatomic, copy)NSString* project;
@property(nonatomic, copy)NSString* key;
@property(nonatomic, copy)NSString* revision;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSMutableArray* suggestions;//each object in the array is NSMutableDictionary with the key "suggestion" and the optional keys "service" and "quality"
@property(nonatomic, copy)NSString* documentation;
@property(atomic) BOOL noDocumentation;
@property(nonatomic)BOOL isAccepted;
@property(nonatomic)NSInteger acceptCount;
@property BOOL infoState;

-(id) initWithDefinition:(NSString*) def withTranslation:(NSString*)trans withLanguage:(NSString*)lang withProject:(NSString*)proj withKey:(NSString*)k withRevision:(NSString*)rev withTitle:(NSString*)mTitle withAccepted:(BOOL)accepted WithAceeptCount:(NSInteger) ac;
-(void)addSuggestionsFromResponse:(NSMutableDictionary*)translationAids;
-(void)addDocumentationFromResponse:(NSMutableDictionary*)translationAids;

-(bool)needsExpansionUnderWidth:(CGFloat)width;
-(CGFloat)getUnexpandedHeightOfSource;
-(CGFloat)getUnexpandedHeightOfSuggestion;
-(CGFloat)getExpandedHeightOfSourceUnderWidth:(CGFloat)width;
-(CGFloat)getExpandedHeightOfSuggestionNumber:(NSInteger)i underWidth:(CGFloat)width;
-(CGFloat)getCombinedExpandedHeightOfSuggestionUnderWidth:(CGFloat)width;

@end


