//
//  TranslationMessageDataController.h
//  TranslateWikiApp
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
//

#import <Foundation/Foundation.h>
#import "TWapi.h"
#import "constants.h"

@class TranslationMessage;

@interface TranslationMessageDataController : NSObject

@property (nonatomic, copy) NSMutableArray *masterTranslationMessageList; // a container for all the translation message objects
@property (atomic) NSInteger offset; // the current offset in the api requests sequence
@property BOOL translationState; // are we on translation mode

- (NSInteger)countOfList; // how many object in containers
- (TranslationMessage *)objectInListAtIndex:(NSUInteger)theIndex; // getting the object in the specific index in the container
- (NSInteger)indexOfObject:(TranslationMessage*)msg; // getting the index of a specific object in the container
- (void)addTranslationMessageWithMessage:(TranslationMessage *)message; // add to the end of the container a new message
- (void)removeAllObjects; // clear the container
- (void)removeObjectAtIndex:(NSInteger)index; // remove a specific object, at the given index
- (void)addMessagesTupleUsingApi:(TWapi*) api andObjectContext:(NSManagedObjectContext*)managedObjectContext andIsProofread:(BOOL)isProof completionHandler:(void (^)())completionBlock; // add another message tuple to the container. The parameters for the request specification are taken from user defaults.

+(BOOL)checkIsRejectedMessageWithRevision:(NSString*)revision byUserWithId:(NSString*)userid usingObjectContext:(NSManagedObjectContext*)managedObjectContext; // check if some message with the revision identification was rejected by user with userid using managedObjectContext
-(void) handleResponse:(NSDictionary*)response Error:(NSError*)error Api:(TWapi *)api ManagedObject:(NSManagedObjectContext*)managedObjectContext Language:(NSString *)lang Project:(NSString *)proj Proofread:(BOOL)isProof MaxMessageLength:(NSInteger)maxMsgLen MessRemain:(NSInteger)numberOfMessagesRemaining IterationsLeft:(NSInteger)iterationsToGo completionHandler:(void (^)())completionBlock;
-(void)doRequestsWithApi:(TWapi *)api ManagedObject:(NSManagedObjectContext*)managedObjectContext Language:(NSString *)lang Project:(NSString *)proj Proofread:(BOOL)isProof MaxMessageLength:(NSInteger)maxMsgLen MessRemain:(NSInteger)numberOfMessagesRemaining IterationsLeft:(NSInteger)iterationsToGo completionHandler:(void (^)())completionBlock;


@end
