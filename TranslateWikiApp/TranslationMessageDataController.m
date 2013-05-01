//
//  TranslationMessageDataController.m
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

- (BOOL)isEmpty{
    return [self countOfList]==0;
}

- (void)removeAllObjects{
    [self.masterTranslationMessageList removeAllObjects];
    _offset=0;
}

- (void)removeObjectAtIndex:(NSInteger)index{
    [self.masterTranslationMessageList removeObjectAtIndex:index];
}


//***********************************************************
//This method is invoked when API responses with new messages
//***********************************************************
-(void) handleResponse:(NSDictionary*)response Error:(NSError*)error Api:(TWapi *)api ManagedObject:(NSManagedObjectContext*)managedObjectContext Language:(NSString *)lang Project:(NSString *)proj Proofread:(BOOL)isProof MessRemain:(NSInteger)numberOfMessagesRemaining completionHandler:(void (^)())completionBlock
{
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    NSLog(@"%@", response);
    
    NSMutableArray *newData = [[NSMutableArray alloc] initWithArray:response[@"query"][@"messagecollection"]];
    //we expect an array, otherwise will be runtime exception
    
    BOOL stopLoop=[newData count]<numberOfMessagesRemaining;
    
    for (NSDictionary* msg in newData) { //insert messages to datacontroller
        BOOL isRejected=[TranslationMessageDataController checkIsRejectedMessageWithRevision:msg[@"properties"][@"revision"] byUserWithId:[[api user] userId] usingObjectContext:managedObjectContext];
        if(!isRejected){
            numberOfMessagesRemaining=numberOfMessagesRemaining-1;
            TranslationMessage* message=[[TranslationMessage alloc] initWithDefinition:msg[@"definition"] withTranslation:msg[@"translation"] withLanguage:lang withProject:proj withKey:msg[@"key"] withRevision:msg[@"properties"][@"revision"] withTitle:msg[@"title"] withAccepted:NO WithAceeptCount:[msg[@"properties"][@"reviewers"] count]];
            if(!isProof){
                [api TWTranslationAidsForTitle:msg[@"title"] withProject:proj completionHandler:^(NSDictionary* transAids, NSError* error){
                    [message addSuggestionsFromResponse:transAids[@"helpers"]];
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        completionBlock();});
                }];
                
            }
            [self addTranslationMessageWithMessage:message];
        }
    }
    _offset=_offset+newData.count;
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        completionBlock();
        if([self isEmpty]){//if no messages were found, output an alert
            //need to get correct project name and language name
            LoadDefaultAlertView();
            NSString* alertMessage=[NSString stringWithFormat:@"No messages were found for project \"%@\" and language %@, in %@ mode", proj, lang, isProof ? @"proofread" : @"translation"];
            AlertSetMessage(alertMessage);
            AlertShow();
        }
    });
    if(!stopLoop && numberOfMessagesRemaining>0)
        [self doRequestsWithApi:api ManagedObject:managedObjectContext Language:lang Project:proj Proofread:isProof MessRemain:numberOfMessagesRemaining completionHandler:completionBlock];
    
}

//***********************************************************
// From here we prepare and call API asynchronous request
//***********************************************************
-(void)addMessagesTupleUsingApi:(TWapi*) api andObjectContext:(NSManagedObjectContext*)managedObjectContext andIsProofread:(BOOL)isProof completionHandler:(void (^)())completionBlock
{
    LoadUserDefaults();
    NSString * tupSizeText = [defaults objectForKey:@"defaultTupleSize"];
    NSInteger numberOfMessagesRemaining = [tupSizeText integerValue];
    NSString* lang=getUserDefaultskey(LANG_key);
    NSString* proj=getUserDefaultskey(PROJ_key);
    //NSInteger queryLimit=numberOfMessagesRemaining;
    //NSMutableDictionary *result;
    [self doRequestsWithApi:api ManagedObject:managedObjectContext Language:lang Project:proj Proofread:isProof MessRemain:numberOfMessagesRemaining completionHandler:completionBlock];

        //LOG(result); //DEBUG
    
             //  if(stopLoop)
    //        break;
}

//***********************************************************
// Actual invoke of API asynchronous request
//***********************************************************
-(void)doRequestsWithApi:(TWapi *)api ManagedObject:(NSManagedObjectContext*)managedObjectContext Language:(NSString *)lang Project:(NSString *)proj Proofread:(BOOL)isProof MessRemain:(NSInteger)numberOfMessagesRemaining completionHandler:(void (^)())completionBlock
 {
    if(isProof) //case of proofread mode;
    {
        [api TWTranslatedMessagesListRequestForLanguage:lang Project:proj Limitfor:numberOfMessagesRemaining OffsetToStart:_offset completionHandler:^(NSDictionary *response, NSError *error)
         {
             [self handleResponse:response Error:error Api:api ManagedObject:managedObjectContext Language:lang Project:proj Proofread:isProof MessRemain:numberOfMessagesRemaining completionHandler:completionBlock];
         }];
    }
    else{  //case of full translation mode
        [api TWUntranslatedMessagesListRequestForLanguage:lang Project:proj Limitfor:numberOfMessagesRemaining OffsetToStart:_offset completionHandler:^(NSDictionary *response, NSError *error)
         {
             [self handleResponse:response Error:error Api:api ManagedObject:managedObjectContext Language:lang Project:proj Proofread:isProof MessRemain:numberOfMessagesRemaining completionHandler:completionBlock];
         }];
        
    }
}

+(BOOL)checkIsRejectedMessageWithRevision:(NSString*)revision byUserWithId:(NSString*)userid usingObjectContext:(NSManagedObjectContext*)managedObjectContext
{
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

@end
