//
//  LoginViewController.h
//  TranslateWikiApp
//
//  Copyright 2013 Or Sagi, Tomer Tuchner
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
