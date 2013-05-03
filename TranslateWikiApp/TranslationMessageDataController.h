//
//  TranslationMessageDataController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <Foundation/Foundation.h>
#import "TWapi.h"
#import "constants.h"

@class TranslationMessage;
@interface TranslationMessageDataController : NSObject
@property (nonatomic, copy) NSMutableArray *masterTranslationMessageList;
@property (atomic) NSInteger offset;

- (NSInteger)countOfList;
- (TranslationMessage *)objectInListAtIndex:(NSUInteger)theIndex;
- (NSInteger)indexOfObject:(TranslationMessage*)msg;
- (void)addTranslationMessageWithMessage:(TranslationMessage *)message;
- (void)removeAllObjects;
- (void)removeObjectAtIndex:(NSInteger)index;
- (void)addMessagesTupleUsingApi:(TWapi*) api andObjectContext:(NSManagedObjectContext*)managedObjectContext andIsProofread:(BOOL)isProof completionHandler:(void (^)())completionBlock;
+(BOOL)checkIsRejectedMessageWithRevision:(NSString*)revision byUserWithId:(NSString*)userid usingObjectContext:(NSManagedObjectContext*)managedObjectContext;

-(void) handleResponse:(NSDictionary*)response Error:(NSError*)error Api:(TWapi *)api ManagedObject:(NSManagedObjectContext*)managedObjectContext Language:(NSString *)lang Project:(NSString *)proj Proofread:(BOOL)isProof MaxMessageLength:(NSInteger)maxMsgLen MessRemain:(NSInteger)numberOfMessagesRemaining completionHandler:(void (^)())completionBlock;
-(void)doRequestsWithApi:(TWapi *)api ManagedObject:(NSManagedObjectContext*)managedObjectContext Language:(NSString *)lang Project:(NSString *)proj Proofread:(BOOL)isProof MaxMessageLength:(NSInteger)maxMsgLen MessRemain:(NSInteger)numberOfMessagesRemaining completionHandler:(void (^)())completionBlock;

@end
