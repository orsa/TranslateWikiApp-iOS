//
//  TWUser.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "TWUser.h"

@implementation TWUser

-(id) init{
    self = [super init];
    if (self) {
        _userName=@"";
        _isLoggedin=NO;
        _userId=@"";
        
       // _userId = [TWapi TWUserIdRequestOfUserName:(NSString*)userName];
        if (!_userId)
            _userId=@"";
        
        _pref=[[TWUserPreferences alloc] init];
        
        return self;
    }
    return nil;
}

@end
