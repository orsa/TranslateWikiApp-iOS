//
//  ProjectBrowserViewController.h
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
#import "TWapi.h"
#import "PrefsViewController.h"

@interface ProjectBrowserViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UITableView *projTable;
@property (strong, nonatomic) IBOutlet NSMutableArray *filteredArr;
@property (strong, nonatomic) IBOutlet NSMutableArray *filteredRec;
@property (strong, nonatomic) IBOutlet NSMutableArray *srcArr;
@property (strong, nonatomic) IBOutlet NSArray *originalSrc;
@property (strong, nonatomic) IBOutlet NSMutableArray *recentProj;
@property (weak, nonatomic) NSString * dstProjLabel;
@property (weak, nonatomic) NSString * dstProjID;
@property (nonatomic, retain) TWapi *api;
@property BOOL isFiltered;
@property BOOL didChange;

-(IBAction)refreshProjects:(id)sender;

+ (NSMutableArray *) filterProjects:(NSArray*)proj FromArray:(NSArray*)original;

@end
