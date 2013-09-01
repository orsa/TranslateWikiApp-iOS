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

@end
