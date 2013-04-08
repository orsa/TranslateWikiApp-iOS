//
//  MainViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 8/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
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
#import "InputPaneView.h"
#import"TranslationCell.h"

@class TranslationMessageDataController;
@class TWUser;

@interface MainViewController : UIViewController<UITableViewDataSource>{
    NSManagedObjectContext *managedObjectContext;
}

@property (retain) NSIndexPath* selectedIndexPath;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PushMessages;
@property (nonatomic, retain) TranslationMessageDataController * dataController;
@property (nonatomic, retain) UITextView* initialActiveTextView;
@property (nonatomic, retain) UITextView* activeTextView;
@property (retain, nonatomic) TWapi *api;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property BOOL translationState;
@property (strong, nonatomic) IBOutlet TranslationCell *trCell;

- (IBAction)pushPrefs:(id)sender;
- (IBAction)pushAccept:(id)sender;
- (IBAction)pushReject:(id)sender;
- (void)coreDataRejectMessage;
-(void)addMessagesTuple;
@end
