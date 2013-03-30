//
//  ProjectBrowserViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 30/3/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "ProjectBrowserViewController.h"

@interface ProjectBrowserViewController ()

@end

@implementation ProjectBrowserViewController

@synthesize mySearchBar;
@synthesize LangTable;
@synthesize filteredArr;
@synthesize srcArr;
@synthesize isFiltered;
@synthesize didChange;
@synthesize dstProjLabel;
@synthesize dstProjID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    isFiltered = NO;
    didChange = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (didChange && ![[self.navigationController viewControllers] containsObject:self])
    {
        //LoadUserDefaults();
        //setUserDefaultskey(dstProj, PROJ_key);
        PrefsViewController *ViewController = (PrefsViewController *)[self.navigationController topViewController];
        ViewController.didChange = didChange;
        ViewController.projTextField.text = dstProjLabel;
        ViewController.selectedProjCode =  dstProjID;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFiltered)
        return [filteredArr count];
    else
        return [srcArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier=@"b";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (isFiltered)
    {
        cell.textLabel.text = filteredArr[indexPath.row][@"label"];
    }
    else
    {
        cell.textLabel.text = srcArr[indexPath.row][@"label"];
    }
    
    return cell;
}

#pragma mark - Table view daelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    didChange = YES;
    dstProjLabel = (isFiltered?filteredArr[indexPath.row][@"label"]:srcArr[indexPath.row][@"label"]);
    dstProjID = (isFiltered?filteredArr[indexPath.row][@"id"]:srcArr[indexPath.row][@"id"]);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - search bar methods

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if(searchText.length==0)
    {
        isFiltered = NO;
    }
    else
    {
        isFiltered = YES;
    }
    filteredArr = [[NSMutableArray alloc] init];
    
    //fast enumeration
    for (NSDictionary * langName in srcArr)
    {
        NSRange langRange = [langName[@"label"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (langRange.location != NSNotFound)
        {
            [filteredArr addObject:langName];
        }
    }
    [LangTable reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [mySearchBar resignFirstResponder];
}


@end
