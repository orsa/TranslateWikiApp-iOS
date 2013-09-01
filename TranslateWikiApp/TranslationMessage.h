//
//  TranslationMessage.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <Foundation/Foundation.h>

@interface TranslationMessage : NSObject

@property(atomic) BOOL translated;
@property(atomic) BOOL minimized;
@property(atomic) BOOL prState;
@property(atomic) BOOL infoState;
@property(atomic) BOOL noDocumentation;
@property(atomic) NSInteger acceptCount;
@property(nonatomic, copy)NSString* source;
@property(nonatomic, copy)NSString* translation;
@property(nonatomic, copy)NSString* translationByUser;
@property(nonatomic, copy)NSString* userInput;
@property(nonatomic, copy)NSString* language;
@property(nonatomic, copy)NSString* project;
@property(nonatomic, copy)NSString* key;
@property(nonatomic, copy)NSString* revision;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* documentation;
@property(nonatomic, copy)NSMutableArray* suggestions; // each object in the array is NSMutableDictionary with the key "suggestion" and the optional keys "service" and "quality"

-(id) initWithDefinition:(NSString*) def withTranslation:(NSString*)trans withLanguage:(NSString*)lang withProject:(NSString*)proj withKey:(NSString*)k withRevision:(NSString*)rev withTitle:(NSString*)mTitle  WithAceeptCount:(NSInteger)ac InState:(BOOL)prState;
-(void)addSuggestionsFromResponse:(NSMutableDictionary*)translationAids;
-(void)addDocumentationFromResponse:(NSMutableDictionary*)translationAids;
-(bool)needsExpansionUnderWidth:(CGFloat)width;
-(CGFloat)getUnexpandedHeightOfSource;
-(CGFloat)getUnexpandedHeightOfSuggestion;
-(CGFloat)getExpandedHeightOfSourceUnderWidth:(CGFloat)width;
-(CGFloat)getExpandedHeightOfSuggestionNumber:(NSInteger)i underWidth:(CGFloat)width;
-(CGFloat)getCombinedExpandedHeightOfSuggestionUnderWidth:(CGFloat)width;
-(CGFloat)heightForImageView;

@end
