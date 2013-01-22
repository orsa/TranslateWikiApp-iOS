//
//  TranslationMessageDataController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TranslationMessage;
@interface TranslationMessageDataController : NSObject
@property (nonatomic, copy) NSMutableArray *masterTranslationMessageList;

- (NSUInteger)countOfList;
- (TranslationMessage *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addTranslationMessageWithMessage:(TranslationMessage *)message;
- (void)removeAllObjects;
- (void)addMessagesTupleOfSize:(int)size ByUserId:(NSString*)userId;
@end
