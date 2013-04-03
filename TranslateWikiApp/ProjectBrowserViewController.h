//
//  ProjectBrowserViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 30/3/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"
#import "TWapi.h"
#import "PrefsViewController.h"

@interface ProjectBrowserViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UITableView *LangTable;
@property (strong, nonatomic) IBOutlet NSMutableArray *filteredArr;
@property (strong, nonatomic) IBOutlet NSMutableArray *filteredRec;
@property (strong, nonatomic) IBOutlet NSMutableArray *srcArr;
@property (strong, nonatomic) IBOutlet NSMutableArray *recentProj;
@property (weak, nonatomic) NSString * dstProjLabel;
@property (weak, nonatomic) NSString * dstProjID;
@property BOOL isFiltered;
@property BOOL didChange;

@end
