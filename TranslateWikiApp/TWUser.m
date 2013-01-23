//
//  TWUser.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "TWUser.h"
#import "TWapi.h"

@implementation TWUser

-(id) initWithUsreName:(NSString*) userName{
    self = [super init];
    if (self) {
        _userName=userName;
        _isLoggedin=NO;
        _userId = [TWapi TWUserIdRequestOfUserName:(NSString*)userName];
        if (!_userId)
            _userId=@"";
        
        return self;
    }
    return nil;
}

@end
