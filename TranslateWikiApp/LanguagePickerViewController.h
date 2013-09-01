//
//  LanguagePickerViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 30/3/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

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
