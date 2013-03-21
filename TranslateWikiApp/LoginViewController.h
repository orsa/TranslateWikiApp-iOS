//
//  LoginViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 31/12/12.
//  Copyright (c) 2012 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWUser.h"
#import "TWapi.h"
#import "KeychainItemWrapper.h"
#import "MainViewController.h"

@class MainViewController;

@interface LoginViewController : UIViewController<UITextFieldDelegate>


@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *password;
@property (retain, nonatomic) TWUser *cur_user;
@property (retain, nonatomic) TWapi *api;

@end
