//
//  TranslationMessageDataController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "TranslationMessageDataController.h"
#import "TranslationMessage.h"


@implementation TranslationMessageDataController

static NSInteger TUPLE_SIZE=10;

- (void)initializeDefaultDataList {
    NSMutableArray *MessageList = [[NSMutableArray alloc] init];
    self.masterTranslationMessageList = MessageList;
}

- (void)setMasterTranslationMessageList:(NSMutableArray *)newList {
    if (_masterTranslationMessageList != newList) {
        _masterTranslationMessageList = [newList mutableCopy];
    }
}

- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList {
    return [self.masterTranslationMessageList count];
}

- (TranslationMessage *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.masterTranslationMessageList objectAtIndex:theIndex];
}

- (void)addTranslationMessageWithMessage:(TranslationMessage *)message {
    [self.masterTranslationMessageList addObject:message];
}

- (void)removeAllObjects{
    [self.masterTranslationMessageList removeAllObjects];
}

- (void)removeObjectAtIndex:(NSInteger)index{
    [self.masterTranslationMessageList removeObjectAtIndex:index];
}

-(void)addMessagesTupleUsingApi:(TWapi*) api
{
    NSInteger offset=0;
    if(self.masterTranslationMessageList!=nil)
        offset=[self countOfList];
    NSInteger size=TUPLE_SIZE;
    NSString* lang=[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguage"];
    NSString* proj=[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultProject"];
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:[ api TWMessagesListRequestForLanguage:lang Project:proj Limitfor:size OffsetToStart:offset] copyItems:YES];
    NSLog(@"%@",result); //DEBUG
    
    NSMutableArray *newData = [[NSMutableArray alloc] initWithArray:result[@"query"][@"messagecollection"]];
    //we expect an array, otherwise will be runtime exception
    
    for (NSDictionary* msg in newData) {
        [self addTranslationMessageWithMessage:[[TranslationMessage alloc] initWithDefinition:msg[@"definition"] withTranslation:msg[@"translation"] withLanguage:lang withKey:msg[@"key"] withRevision:msg[@"revision"] withAccepted:NO WithAceeptCount:[msg[@"properties"][@"reviewers"] count]]];
    }
}
@end
