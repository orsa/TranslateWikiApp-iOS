//
//  LanguagePickerViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 30/3/13.
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

#import "LanguagePickerViewController.h"

@interface LanguagePickerViewController ()

@end

@implementation LanguagePickerViewController{

}
@synthesize mySearchBar;
@synthesize LangTable;
@synthesize filteredArr;
@synthesize filteredRec;
@synthesize filteredLoc;
@synthesize srcArr;
@synthesize recentLanguages;
@synthesize localLanguages;
@synthesize isFiltered;
@synthesize didChange;
@synthesize dstLang;
@synthesize enteredFromLogin;

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
    self.title=@"Language Selection";
    srcArr = [[NSMutableArray alloc] initWithArray:@[LANGUAGE_NAMES]];
    NSArray * codes = @[LANGUAGE_CODES];
    NSArray * names = @[LANGUAGE_NAMES];
    isFiltered = NO;
    
    //prepare recent languages
    LoadUserDefaults();
    recentLanguages = [[NSMutableArray alloc] initWithArray: getUserDefaultskey(RECENT_LANG_key)];

    [srcArr removeObjectsInArray:recentLanguages]; //filter the duplicate
    
    //prepare local preferred languages
    localLanguages = [[NSMutableArray alloc] init];
    NSInteger index;
    for(NSString * l in PREFERRED_LANG){ //decode languages
        if (localLanguages.count<MAX_LOCAL_LANG)
        {
            index = [codes indexOfObject:l];
            if (index!=NSNotFound && ![recentLanguages containsObject:names[index]]) //we add it if not already in recents
            {
                [localLanguages addObject:names[index]];
                [srcArr removeObject:names[index]]; //filter the duplicate
            }
        }
        else
            break;
    }
    
    if (enteredFromLogin)
    {
        LoadAlertView(@"Choose Language", @"Please choose your translation language.", @"Ok");
        AlertShow();
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
    if (didChange )//&& ![[self.navigationController viewControllers] containsObject:self])
    {
        
        if (!enteredFromLogin){
            PrefsViewController *ViewController = (PrefsViewController *)[self.navigationController topViewController];
            ViewController.didChange = didChange;
            ViewController.langLabel.text = dstLang;
        }

        //update recent languages array
        NSMutableArray * updatedRecentLanguages = [[NSMutableArray alloc] init];
        [updatedRecentLanguages addObject:dstLang];  //insert selected language to be first in the queue
        for(int i=0; i<recentLanguages.count && i<MAX_RECENT_LANG-1; i++)
        {
            if (![dstLang isEqualToString:recentLanguages[i]]) //avoid duplicates
                [updatedRecentLanguages addObject:recentLanguages[i]];
        }
        LoadUserDefaults();
        setUserDefaultskey(updatedRecentLanguages, RECENT_LANG_key); //store updated
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;  // 1)recent languages  2)local languages  3)all the rest
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if (isFiltered)
                return filteredRec.count;
            else return recentLanguages.count;
            break;
        case 1:
            if (isFiltered)
                return filteredLoc.count;
            else
                return localLanguages.count;
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
            if (isFiltered)
                cell.textLabel.text = filteredRec[indexPath.row];
            else
                cell.textLabel.text = recentLanguages[indexPath.row];
            break;
        case 1:
            identifier=@"loc";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            if (isFiltered)
                cell.textLabel.text = filteredLoc[indexPath.row];
            else
                cell.textLabel.text = localLanguages[indexPath.row];
            break;
        default:
            identifier=@"a";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            if (isFiltered)
                cell.textLabel.text = filteredArr[indexPath.row];
            else
                cell.textLabel.text = srcArr[indexPath.row];
            break;
            
    }
    NSArray * codes = @[LANGUAGE_CODES];
    NSArray * names = @[LANGUAGE_NAMES];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:codes[[names indexOfObject:cell.textLabel.text]]];
    NSString *translated = [locale displayNameForKey:NSLocaleIdentifier value:codes[[names indexOfObject:cell.textLabel.text]]];
    cell.detailTextLabel.text = translated;
    
    return cell;
}

#pragma mark - Table view daelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    didChange = YES;
    switch (indexPath.section) {
        case 0:
            dstLang = (isFiltered ? filteredRec[indexPath.row] : recentLanguages[indexPath.row]);
            break;
        case 1:
            dstLang = (isFiltered ? filteredLoc[indexPath.row] : localLanguages[indexPath.row]);
            break;
        default:
            dstLang = (isFiltered ? filteredArr[indexPath.row] : srcArr[indexPath.row]);
    }
        if (enteredFromLogin)
        {
            [self performSegueWithIdentifier:@"StartAfterLang" sender:self];
        }
        else
            [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0); //we allow "editing mode" only for the recent languages section
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(isFiltered){
            [recentLanguages removeObject:[filteredRec objectAtIndex:indexPath.row]];
        }
        else{
            [recentLanguages removeObjectAtIndex:indexPath.row];
        }
        srcArr = [[NSMutableArray alloc] initWithArray:@[LANGUAGE_NAMES]];
        [srcArr removeObjectsInArray:recentLanguages];
        if (mySearchBar.text) [self searchBar:mySearchBar textDidChange:mySearchBar.text];
        [tableView reloadData];
        LoadUserDefaults();
        setUserDefaultskey(recentLanguages, RECENT_LANG_key); //store updated
    }
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
    filteredRec = [[NSMutableArray alloc] init];
    filteredLoc = [[NSMutableArray alloc] init];
    filteredArr = [[NSMutableArray alloc] init];
    
    //fast enumeration
    for (NSString * langName in recentLanguages)
    {
        NSRange langRange = [langName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (langRange.location != NSNotFound)
        {
            [filteredRec addObject:langName];
        }
    }
    for (NSString * langName in localLanguages)
    {
        NSRange langRange = [langName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (langRange.location != NSNotFound)
        {
            [filteredLoc addObject:langName];
        }
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"StartAfterLang"])
    {
        NSArray * arrLang = @[LANGUAGE_NAMES];
        NSArray * arrLangCodes = @[LANGUAGE_CODES];
        NSInteger index = [arrLang indexOfObject:dstLang];
        LoadUserDefaults();
        if (index!=NSNotFound) {
        
            
            setUserDefaultskey([arrLangCodes objectAtIndex:index], LANG_key);
        }
        else{
            NSLog(@"no language found");
        }
        
        MainViewController *vc = segue.destinationViewController;
        vc.translationState = !getBoolUserDefaultskey(PRMODE_key);
        [vc setApi:_api];
        [vc setManagedObjectContext:self.managedObjectContext];
        [vc addMessagesTuple]; //push TUPLE_SIZE-tuple of translation messages from server
    }
}

@end
