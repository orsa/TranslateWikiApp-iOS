//
//  SearchViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 30/3/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController{
    NSMutableArray * recentLanguages;
    NSMutableArray * locallanguages;
}

@synthesize mySearchBar;
@synthesize LangTable;
@synthesize filteredArr;
@synthesize srcArr;
@synthesize isFiltered;
@synthesize didChange;
@synthesize dstLang;

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
    srcArr = [[NSMutableArray alloc] initWithObjects:LANGUAGE_NAMES];
    NSArray * codes = [[NSArray alloc] initWithObjects:LANGUAGE_CODES];
    isFiltered = NO;
    LoadUserDefaults();
    recentLanguages = getUserDefaultskey(RECENT_LANG_key);
    for(NSString * l in recentLanguages)
        [srcArr removeObject:l];
    locallanguages = [[NSMutableArray alloc] init];
    NSInteger index;
    for(NSString * l in [NSLocale preferredLanguages]){
        if (locallanguages.count<MAX_LOCAL_LANG)
        {
            index = [codes indexOfObject:l];
            if (index!=NSNotFound)
            {
                [locallanguages addObject:srcArr[index]];
                [srcArr removeObjectAtIndex:index];
            }
        }
        else break;
    }
    
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
        //setUserDefaultskey(dstLang, LANG_key);
        PrefsViewController *ViewController = (PrefsViewController *)[self.navigationController topViewController];
        ViewController.didChange = didChange;
        ViewController.langTextField.text = dstLang;
        if (![recentLanguages containsObject:dstLang]) //update recent languages array
        {
            NSMutableArray * updatedRecentLanguages = [[NSMutableArray alloc] init];
            [updatedRecentLanguages addObject:dstLang];
            for(int i=0; i<recentLanguages.count && i<MAX_RECENT_LANG-1; i++)
            {
                [updatedRecentLanguages addObject:recentLanguages[i]];
            }
            LoadUserDefaults();
            setUserDefaultskey(updatedRecentLanguages, RECENT_LANG_key);
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if (recentLanguages) return recentLanguages.count;
            else return 0;
            break;
        case 1:
            return locallanguages.count;
            break;
        default:
            if (isFiltered)
                return [filteredArr count];
            else
                return [srcArr count];
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier;
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            identifier=@"rec";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.textLabel.text = recentLanguages[indexPath.row];
            break;
        case 1:
            identifier=@"loc";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.textLabel.text = locallanguages[indexPath.row];
            break;
        default:
            identifier=@"a";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            if (isFiltered)
            {
                cell.textLabel.text = filteredArr[indexPath.row];
            }
            else
            {
                cell.textLabel.text = srcArr[indexPath.row];
            }
            break;
    }
    
    return cell;
}

#pragma mark - Table view daelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    didChange = YES;
    switch (indexPath.section) {
        case 0:
            dstLang = recentLanguages[indexPath.row];
            break;
        case 1:
            dstLang = locallanguages[indexPath.row];
            break;
        default:
            dstLang = (isFiltered?filteredArr[indexPath.row]:srcArr[indexPath.row]);
    }
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
    for (NSString * langName in srcArr)
    {
        NSRange langRange = [langName rangeOfString:searchText options:NSCaseInsensitiveSearch];
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
