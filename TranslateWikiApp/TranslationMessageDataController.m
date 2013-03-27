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
        _offset=0;
        return self;
    }
    return nil;
}

- (NSInteger)countOfList{
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

-(void)addMessagesTupleUsingApi:(TWapi*) api andObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSInteger numberOfMessagesRemaining=TUPLE_SIZE;
    while(numberOfMessagesRemaining>0)
    {
        NSString* lang=[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguage"];
        NSString* proj=[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultProject"];
        NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:[ api TWMessagesListRequestForLanguage:lang Project:proj Limitfor:numberOfMessagesRemaining OffsetToStart:_offset] copyItems:YES];
        NSLog(@"%@",result); //DEBUG
    
        NSMutableArray *newData = [[NSMutableArray alloc] initWithArray:result[@"query"][@"messagecollection"]];
        //we expect an array, otherwise will be runtime exception
    
        for (NSDictionary* msg in newData) {
            BOOL isRejected=[TranslationMessageDataController checkIsRejectedMessageWithKey:msg[@"key"] byUserWithId:[[api user] userId] usingObjectContext:managedObjectContext];
            if(!isRejected){
                numberOfMessagesRemaining=numberOfMessagesRemaining-1;
                [self addTranslationMessageWithMessage:[[TranslationMessage alloc] initWithDefinition:msg[@"definition"] withTranslation:msg[@"translation"] withLanguage:lang withKey:msg[@"key"] withRevision:msg[@"revision"] withAccepted:NO WithAceeptCount:[msg[@"properties"][@"reviewers"] count]]];
            }
        }
        NSInteger numberOfMessagesNotRejected=TUPLE_SIZE-numberOfMessagesRemaining;
        _offset=_offset+numberOfMessagesNotRejected;
    }
}

+(BOOL)checkIsRejectedMessageWithKey:(NSString*)key byUserWithId:(NSInteger)userid usingObjectContext:(NSManagedObjectContext*)managedObjectContext{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RejectedMessage" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid == %d AND key==%@", userid, key];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    return [mutableFetchResults count]>0;//message was rejected iff it appears in the database
}

@end
