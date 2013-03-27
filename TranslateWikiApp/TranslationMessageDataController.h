//
//  TranslationMessageDataController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWapi.h"

@class TranslationMessage;
@interface TranslationMessageDataController : NSObject
@property (nonatomic, copy) NSMutableArray *masterTranslationMessageList;
@property (atomic) NSInteger offset;

- (NSInteger)countOfList;
- (TranslationMessage *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addTranslationMessageWithMessage:(TranslationMessage *)message;
- (void)removeAllObjects;
- (void)removeObjectAtIndex:(NSInteger)index;
- (void)addMessagesTupleUsingApi: (TWapi*) api andObjectContext:(NSManagedObjectContext*)managedObjectContext;
+(BOOL)checkIsRejectedMessageWithKey:(NSString*)key byUserWithId:(NSInteger)userid usingObjectContext:(NSManagedObjectContext*)managedObjectContext;
@end
