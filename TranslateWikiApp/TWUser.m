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
        if (!_userId) _userId=0;
        return self;
    }
    return nil;
}

@end
