//
//  RejectedMessage.h
//  TranslateWikiApp
//
//  Created by Tomer Tuchner on 3/27/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RejectedMessage : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * userid;

@end
