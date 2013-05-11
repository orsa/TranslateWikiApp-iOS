//
//  MainViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 8/1/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <UIKit/UIKit.h>
#import "constants.h"
#import "TranslationMessageDataController.h"
#import "TranslationMessage.h"
#import "PrefsViewController.h"
#import "LoginViewController.h"
#import "TWUser.h"
#import "TWapi.h"
#import "KeychainItemWrapper.h"
#import "MsgCell.h"
#import "TranslationCell.h"
#import "InputCell.h"
#import "MenuView.h"

@class TranslationMessageDataController;
@class TWUser;
@class MenuView;

@interface MainViewController : UIViewController<UITableViewDataSource>{
    NSManagedObjectContext *managedObjectContext;
}

@property (retain) NSIndexPath* selectedIndexPath;
@property (nonatomic, retain) TranslationMessageDataController * dataController;
@property (retain, nonatomic) TWapi *api;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property BOOL translationState;
@property (nonatomic, copy) NSMutableSet* transCells;//needed for initializing textboxes after preferences change
@property (weak, nonatomic) IBOutlet UITableView *msgTableView;
@property (weak, nonatomic) IBOutlet MenuView *menuView;
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;



- (IBAction)bgTap:(UITapGestureRecognizer *)sender;
- (IBAction)pushAccept:(id)sender;
- (IBAction)pushReject:(id)sender;
- (IBAction)openMenu:(id)sender;
- (IBAction)pushPrefs:(id)sender;
- (IBAction)clearMessages:(id)sender;
- (void)coreDataRejectMessage;
-(void)addMessagesTuple;
-(void)clearTextBoxes;
@end
