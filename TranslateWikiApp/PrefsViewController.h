//
//  PrefsViewController.h
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
