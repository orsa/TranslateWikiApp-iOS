//
//  TWUser.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <Foundation/Foundation.h>

@interface TWUser : NSObject

@property(nonatomic, copy)NSString* userName; // the user name
@property(nonatomic, copy)NSString* userId; // the user id
@property BOOL isLoggedin; // did the authentication succeed, and the user is logged in

-(id) init;

@end
