//
//  TWUser.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWUser : NSObject

@property(nonatomic, copy)NSString* userName;
@property(nonatomic, copy)NSString* userId;
@property BOOL isLoggedin;
@property(nonatomic, copy)NSString* preferredLang;
@property(nonatomic, copy)NSHTTPCookie* authCookie;

-(id) init;

@end
