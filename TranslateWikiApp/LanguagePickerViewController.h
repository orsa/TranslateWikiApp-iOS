//
//  LanguagePickerViewController.h
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
#import "constants.h"
#import "PrefsViewController.h"
#import "MainViewController.h"

@interface LanguagePickerViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UITableView *LangTable;
@property (strong, nonatomic) NSMutableArray *filteredArr;
@property (strong, nonatomic) NSMutableArray *filteredRec;
@property (strong, nonatomic) NSMutableArray *filteredLoc;
@property (strong, nonatomic) NSMutableArray *srcArr;
@property (strong, nonatomic) NSMutableArray *recentLanguages;
@property (strong, nonatomic) NSMutableArray *localLanguages;
@property (weak, nonatomic) NSString * dstLang;
@property BOOL isFiltered;
@property BOOL didChange;
@property BOOL enteredFromLogin;
@property (retain, nonatomic) TWapi *api;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
