//
//  TWUserPreferences.h
//  TranslateWikiApp
//
//  Created by Tomer Tuchner on 3/21/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWUserPreferences : NSObject

@property(nonatomic, copy)NSString* preferredLang;
@property(nonatomic, copy)NSString* preferredProj;

@end
