//
//  LanguagePickerViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 30/3/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"
#import "PrefsViewController.h"

@interface LanguagePickerViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UITableView *LangTable;
@property (strong, nonatomic) IBOutlet NSMutableArray *filteredArr;
@property (strong, nonatomic) IBOutlet NSMutableArray *filteredRec;
@property (strong, nonatomic) IBOutlet NSMutableArray *filteredLoc;
@property (strong, nonatomic) IBOutlet NSMutableArray *srcArr;
@property (strong, nonatomic) IBOutlet NSMutableArray *recentLanguages;
@property (strong, nonatomic) IBOutlet NSMutableArray *localLanguages;
@property (weak, nonatomic) NSString * dstLang;
@property BOOL isFiltered;
@property BOOL didChange;

@end
