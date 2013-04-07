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

- (NSInteger)indexOfObject:(TranslationMessage*)msg{
    return [self.masterTranslationMessageList indexOfObject:msg];
}

- (void)addTranslationMessageWithMessage:(TranslationMessage *)message{
    [self.masterTranslationMessageList addObject:message];
}

- (void)removeAllObjects{
    [self.masterTranslationMessageList removeAllObjects];
    _offset=0;
}

- (void)removeObjectAtIndex:(NSInteger)index{
    [self.masterTranslationMessageList removeObjectAtIndex:index];
}

-(void)addMessagesTupleUsingApi:(TWapi*) api andObjectContext:(NSManagedObjectContext*)managedObjectContext andIsProofread:(BOOL)isProof
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * tupSizeText = [defaults objectForKey:@"defaultTupleSize"];
    NSInteger numberOfMessagesRemaining = [tupSizeText integerValue];
    while(numberOfMessagesRemaining>0)
    {
        LoadUserDefaults();
        NSString* lang=getUserDefaultskey(LANG_key);
        NSString* proj=getUserDefaultskey(PROJ_key);
        NSInteger queryLimit=numberOfMessagesRemaining;
        NSMutableDictionary *result;
        if(isProof){
            result=[[NSMutableDictionary alloc] initWithDictionary:[ api TWTranslatedMessagesListRequestForLanguage:lang Project:proj Limitfor:numberOfMessagesRemaining OffsetToStart:_offset] copyItems:YES];
        }
        else{
            result=[[NSMutableDictionary alloc] initWithDictionary:[ api TWUntranslatedMessagesListRequestForLanguage:lang Project:proj Limitfor:numberOfMessagesRemaining OffsetToStart:_offset] copyItems:YES];
        }
       // LOG(result); //DEBUG
    
        NSMutableArray *newData = [[NSMutableArray alloc] initWithArray:result[@"query"][@"messagecollection"]];
        //we expect an array, otherwise will be runtime exception
        
        BOOL stopLoop=[newData count]<numberOfMessagesRemaining;
    
        for (NSDictionary* msg in newData) {
            BOOL isRejected=[TranslationMessageDataController checkIsRejectedMessageWithRevision:msg[@"properties"][@"revision"] byUserWithId:[[api user] userId] usingObjectContext:managedObjectContext];
            if(!isRejected){
                numberOfMessagesRemaining=numberOfMessagesRemaining-1;
                TranslationMessage* message=[[TranslationMessage alloc] initWithDefinition:msg[@"definition"] withTranslation:msg[@"translation"] withLanguage:lang withProject:proj withKey:msg[@"key"] withRevision:msg[@"properties"][@"revision"] withTitle:msg[@"title"] withAccepted:NO WithAceeptCount:[msg[@"properties"][@"reviewers"] count]];
                if(!isProof){
                    NSMutableDictionary* transAids=[api TWTranslationAidsForTitle:msg[@"title"] withProject:proj];
                    [message addSuggestionsFromResponse:transAids];
                }
                [self addTranslationMessageWithMessage:message];
            }
        }
        _offset=_offset+queryLimit;
        if(stopLoop)
            break;
    }
}

+(BOOL)checkIsRejectedMessageWithRevision:(NSString*)revision byUserWithId:(NSString*)userid usingObjectContext:(NSManagedObjectContext*)managedObjectContext{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RejectedMessage" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid == %@ AND revision==%@", userid, revision];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    return [mutableFetchResults count]>0;//message was rejected iff it appears in the database
}
/*
-(void) removeActive(){
    if (_activeMsgIndex>-1)
    {
        
        _activeMsgIndex=-1;
    }
}
 */
@end
