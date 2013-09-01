//
//  MainViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 8/1/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

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
