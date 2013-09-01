//
//  LoginViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 31/12/12.
//  Copyright (c) 2012 translatewiki.net. All rights reserved.
//

#import <Security/Security.h>
#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"
#import "TWapi.h"
#import "AppDelegate.h"
#import "TWUser.h"
#import "MainViewController.h"
#import "constants.h"

@class MainViewController;

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UILabel *ResultLabel;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *password;
@property (retain, nonatomic) TWUser *cur_user;
@property (retain, nonatomic) TWapi *api;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property BOOL langNeedsManualSelection;

- (IBAction)submitLogin:(id)sender;
- (IBAction)goToSignup:(id)sender;

+ (void) storeCredKCUser:(NSString *)nameString Password:(NSString*)passwString;

@end
