//
//  ProjectBrowserViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 30/3/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

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
