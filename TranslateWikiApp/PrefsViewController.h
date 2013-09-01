//
//  PrefsViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 20/3/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "constants.h"
#import "TWapi.h"
#import "MainViewController.h"
#import "TranslationMessageDataController.h"
#import "ProjectBrowserViewController.h"
#import "LanguagePickerViewController.h"

@interface PrefsViewController : UITableViewController

@property BOOL didChange;
@property (nonatomic, retain) TWapi *api;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *selectedProjCode;
@property (nonatomic, retain) NSString *selectedLangCode;
@property (nonatomic, retain) NSArray *arrLang;
@property (nonatomic, retain) NSArray *arrProj;
@property (nonatomic, retain) NSArray *arrLangCodes;
@property (weak, nonatomic) IBOutlet UITextField *tupleSizeTextView;
@property (nonatomic, retain) IBOutlet UILabel *langLabel;
@property (nonatomic, retain) IBOutlet UILabel *projLabel;
@property (weak, nonatomic) IBOutlet UITextField *maxMsgLengthTextField;

-(void)backgroundTap:(UITapGestureRecognizer *)tapGR;
-(NSString*)getNewLang;
-(NSString*)getNewProj;
-(IBAction)logout:(id)sender;
-(IBAction)restoreDefaults:(id)sender;

@end
