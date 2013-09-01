//
//  TranslationMessage.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <Foundation/Foundation.h>

@interface TranslationMessage : NSObject

@property(atomic) BOOL translated; // was the message translated by user
@property(atomic) BOOL minimized; // is the message's cell minimized
@property(atomic) BOOL prState; // is the message in proofread state
@property(atomic) BOOL infoState; // is the documentation of the message currently shown on screen
@property(atomic) BOOL noDocumentation; // does the message have no documentation (collpaisbles are removed from documentation)
@property(atomic) NSInteger acceptCount; // how many people already accepted the message (proofread)
@property(nonatomic, copy)NSString* source; // the source of the message
@property(nonatomic, copy)NSString* translation; // the translation of the message (proofread)
@property(nonatomic, copy)NSString* translationByUser; // the translation that the user submitted (translate)
@property(nonatomic, copy)NSString* userInput; // the temporal inpur the user entered to the text-field, keeping itss content (translate)
@property(nonatomic, copy)NSString* language; // the working language
@property(nonatomic, copy)NSString* project; // the working project
@property(nonatomic, copy)NSString* key; // the identification key of the message
@property(nonatomic, copy)NSString* revision; // the revision linked to the message
@property(nonatomic, copy)NSString* title; // the title of the message page
@property(nonatomic, copy)NSString* documentation; // the html documentation of the message, for showing in a web view
@property(nonatomic, copy)NSMutableArray* suggestions; // each object in the array is NSMutableDictionary with the key "suggestion" and the optional keys "service" and "quality"

-(id) initWithDefinition:(NSString*) def withTranslation:(NSString*)trans withLanguage:(NSString*)lang withProject:(NSString*)proj withKey:(NSString*)k withRevision:(NSString*)rev withTitle:(NSString*)mTitle  WithAceeptCount:(NSInteger)ac InState:(BOOL)prState;
-(void)addSuggestionsFromResponse:(NSMutableDictionary*)translationAids;
-(void)addDocumentationFromResponse:(NSMutableDictionary*)translationAids;
//TranslationCell heights related functions:
-(bool)needsExpansionUnderWidth:(CGFloat)width;
-(CGFloat)getUnexpandedHeightOfSource;
-(CGFloat)getUnexpandedHeightOfSuggestion;
-(CGFloat)getExpandedHeightOfSourceUnderWidth:(CGFloat)width;
-(CGFloat)getExpandedHeightOfSuggestionNumber:(NSInteger)i underWidth:(CGFloat)width;
-(CGFloat)getCombinedExpandedHeightOfSuggestionUnderWidth:(CGFloat)width;
-(CGFloat)heightForImageView;

@end
