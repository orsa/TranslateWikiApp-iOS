//
//  MainViewController.h
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

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"
#import "TWapi.h"
#import "TranslationMessageDataController.h"
#import "TranslationMessage.h"
#import "PrefsViewController.h"
#import "LoginViewController.h"
#import "TWUser.h"
#import "ProofreadCell.h"
#import "TranslationCell.h"
#import "InputCell.h"
#import "MenuView.h"
#import "constants.h"

@class TranslationMessageDataController;
@class TWUser;
@class MenuView;

@interface MainViewController : UIViewController<UITableViewDataSource>

@property (retain) NSIndexPath* selectedIndexPath;
@property (retain, nonatomic) TranslationMessageDataController * dataController;
@property (retain, nonatomic) TWapi *api;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property BOOL translationState;
@property (nonatomic, copy) NSMutableSet* transCells;//needed for initializing textboxes after preferences change
@property (weak, nonatomic) IBOutlet UITableView *msgTableView;
@property (weak, nonatomic) IBOutlet MenuView *menuView;
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UILabel *GreetingMessage;

- (IBAction)pushEdit:(id)sender;
- (IBAction)bgTap:(UITapGestureRecognizer *)sender;
- (IBAction)pushAccept:(id)sender;
- (IBAction)pushReject:(id)sender;
- (IBAction)openMenu:(id)sender;
- (IBAction)pushPrefs:(id)sender;
- (IBAction)clearMessages:(id)sender;
- (void)coreDataRejectMessage;
- (void)addMessagesTuple;
- (void)clearTextBoxes;

@end
