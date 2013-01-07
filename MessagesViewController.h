//
//  MessagesViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 7/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesViewController : UIViewController

-(void)setUserName:(NSString *)userName;

@property  (retain, nonatomic) NSString *loggedUserName;

@end
