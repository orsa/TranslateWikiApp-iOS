//
//  TWUser.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <Foundation/Foundation.h>

@interface TWUser : NSObject

@property(nonatomic, copy)NSString* userName;
@property(nonatomic, copy)NSString* userId;
@property(nonatomic, copy)NSHTTPCookie* authCookie;
@property BOOL isLoggedin;

-(id) init;

@end
