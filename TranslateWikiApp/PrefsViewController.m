//
//  PrefsViewController.m
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

#import "PrefsViewController.h"

@implementation PrefsViewController

BOOL didChange; //use to mark that preferenses were updated
int flag;       //use to distinguish between active pickerviews


@synthesize langLabel, projLabel, tupleSizeTextView, didChange, selectedProjCode, maxMsgLengthTextField, api, managedObjectContext, arrLang, arrProj, arrLangCodes;


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.tableView reloadData]; // makes the GUI look pretty on rotation
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)LoadFromUserDefaults:(NSUserDefaults *)defaults
{
    //load from NSUserDefaults
    NSString * userDefaultProj = getUserDefaultskey(PROJ_key);
    if ([userDefaultProj isEqualToString:VAL_STRING_RE_CONTRIBUTIONS])
    {
        projLabel.text   = TITLE_STRING_RE_CONTRIBUTIONS;
        selectedProjCode = VAL_STRING_RE_CONTRIBUTIONS;
    }
    else
    {
        int i = [self indexOfProjCode:userDefaultProj];
        if (i != -1)
        {
            projLabel.text   = arrProj[i][@"label"];
            selectedProjCode = arrProj[i][@"id"];
        }
        else{ // missing project from list
            projLabel.text   = @"";
            selectedProjCode = @"";
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO]; // show navigation bar
    
    //[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)]];
    
    arrLang =  @[SUPPORTED_LANGUAGE_NAMES];         // init array of lang titles
    arrLangCodes = @[SUPPORTED_LANGUAGE_CODES];     // init array of lang values
    
    LoadUserDefaults();    
    arrProj = getUserDefaultskey(ALL_PROJ_key); // load projects from memory
    
    if (!arrProj)   // if no saved data for projects
    {               // requesting project list via api - level-0 only
        [api TWProjectListMaxDepth:0 completionHandler:^(NSArray *newArrProj, NSError *error) {
        
            if(error){
                LoadDefaultAlertView();
                AlertSetMessage(connectivityProblem);
                AlertShow();
            }
            if (error || newArrProj==nil)
            {
                NSLog(@"Error occured while loading projects.");
            }
            else if (newArrProj.count>0)
            {
                NSMutableArray * updatedProj = [ProjectBrowserViewController filterProjects:@[STRING_RE_TRANSLATIONS,STRING_RE_ADDITIONS] FromArray:newArrProj];
                [updatedProj addObject:@{@"id":VAL_STRING_RE_CONTRIBUTIONS,@"label":TITLE_STRING_RE_CONTRIBUTIONS}];
                arrProj = [NSArray arrayWithArray:updatedProj];
                setUserDefaultskey(arrProj, ALL_PROJ_key);
                
                [self LoadFromUserDefaults:defaults];
            }
            else
                NSLog(@"No project loaded.");
        }];
    }
    else if (arrProj.count>0)
    {
        [self LoadFromUserDefaults:defaults];
    }
    //LOG(arrProj); //Debug
    
    didChange = NO;
    
    NSInteger index = [arrLangCodes indexOfObject:getUserDefaultskey(LANG_key)];
    if (index!=NSNotFound)
        langLabel.text = arrLang[index];
    else
        NSLog(@"Unfound language: %@", getUserDefaultskey(LANG_key) );
    
    //load from NSUserDefaults
    tupleSizeTextView.text     = getUserDefaultskey(TUPSIZE_key);
    maxMsgLengthTextField.text = getUserDefaultskey(MAX_MSG_LEN_key);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"projBrowser"])
    {
        ProjectBrowserViewController *ViewController = [segue destinationViewController];
        ViewController.originalSrc = [[NSMutableArray alloc]initWithArray:arrProj];
        ViewController.api = api;
    }
}

- (NSString*)getNewLang {
    NSInteger index = [arrLang indexOfObject:langLabel.text];
    if (index!=NSNotFound) {
        return arrLangCodes[index];
    }
    else{
        NSLog(@"no language found");
    }
    return nil;
}

- (NSString*)getNewProj { return selectedProjCode; }

- (void)viewWillDisappear:(BOOL)animated // handles aplying changes on exit
{
    [super viewWillDisappear:animated];

    [self.view endEditing:YES]; // release keyboard
    
    if (didChange && ![[self.navigationController viewControllers] containsObject:self])
    { //set new preferences
        LoadUserDefaults();
        setUserDefaultskey([self getNewLang], LANG_key);
        setUserDefaultskey([self getNewProj], PROJ_key);
        if (![tupleSizeTextView.text isEqualToString:@""])
            setUserDefaultskey(tupleSizeTextView.text, TUPSIZE_key);
        if (![tupleSizeTextView.text isEqualToString:@""])
            setUserDefaultskey(maxMsgLengthTextField.text, MAX_MSG_LEN_key);
        MainViewController *ViewController = (MainViewController *)[self.navigationController topViewController];
        if (ViewController.class == [MainViewController class]) // in case we exit to main view, as opposed to about view
        {
            [ViewController.dataController removeAllObjects];
            [ViewController.msgTableView reloadData];
            [ViewController clearTextBoxes];
            [ViewController addMessagesTuple];
            if(ViewController.selectedIndexPath && ViewController.dataController.countOfList>0)
                ViewController.selectedIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            else
                ViewController.selectedIndexPath=nil;
        }
    }
}

- (int) indexOfProjVal:(NSString*)val inTag:(NSString*)tag{
    int i=0;
    for(NSDictionary * aproj in arrProj)
    {
        NSString * st = aproj[tag];
        if (st && [val isEqualToString:st]) {
            return i;
        }
        else i++;
    }
    return -1;
}
-(int)indexOfProjCode:(NSString*)pcode{
    return [self indexOfProjVal:pcode inTag:@"id"];
}

-(int)indexOfProjlabel:(NSString*)plabel{
    return [self indexOfProjVal:plabel inTag:@"label"];
}

-(void)logout
{
    /* logout without prompting aproval */
    [api TWLogoutRequest:^(NSDictionary* response, NSError* error){
        //Handle the error
        NSLog(@"%@", error);
        if(error){
            LoadDefaultAlertView();
            AlertSetMessage(connectivityProblem);
            AlertShow();
        }
    }];
    // reset credentials in keychain
    KeychainItemWrapper * loginKC = [[KeychainItemWrapper alloc] initWithIdentifier:@"translatewikiapplogin" accessGroup:nil];
    [loginKC resetKeychainItem];
    
    [self.navigationController popToRootViewControllerAnimated:YES]; // go back to start view (login)
}

-(void)restoreDefaults
{
    NSString* lang=PREFERRED_LANG[0];
    NSString* proj=@"!recent";
    NSString* tuple=INITIAL_TUPLE_SIZE;
    NSString* maxLen = INITIAL_MAX_LENGTH;
    
    LoadUserDefaults();
    setUserDefaultskey(nil, RECENT_PROJ_key);
    setUserDefaultskey(nil, RECENT_LANG_key);
    
    selectedProjCode=proj;
    projLabel.text=@"Recent Contributions";
    langLabel.text=[arrLang objectAtIndex:[arrLangCodes indexOfObject:lang]];
    tupleSizeTextView.text=tuple;
    maxMsgLengthTextField.text = maxLen;
    
    //deleting core data
    NSFetchRequest * allEntities = [[NSFetchRequest alloc] init];
    [allEntities setEntity:[NSEntityDescription entityForName:@"RejectedMessage" inManagedObjectContext:managedObjectContext]];
    [allEntities setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * rejs = [managedObjectContext executeFetchRequest:allEntities error:&error];
    //error handling goes here
    for (NSManagedObject * rej in rejs) {
        [managedObjectContext deleteObject:rej];
    }
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
    //more error handling here
    //finish deleting core data
    
    didChange=YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1: //alert result for logout
            if (buttonIndex == 1)  //clicked ok at the alert
                [self logout];
            break;
        case 2: //alert result for restore
            if (buttonIndex == 1)  //clicked ok at the alert
            {
                [self restoreDefaults];
            }
            break;
        default: break;
    }
}

#pragma mark - Text field

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *expression;
    if (textField == tupleSizeTextView)
    {
        expression = @"^(([5-9])|([1-4][0-9]?)|(50?))?$"; //regexp which restrics input to a range of 0 to 50
    }
    else if (textField==maxMsgLengthTextField)
    {
        expression = @"^([1-9]?|[1-9][0-9]{0,5}+)$"; // numbers only regexp
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
    if (numberOfMatches == 0)
        return NO;
    
    if (![textField.text isEqualToString:@""])
        didChange=YES;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{ return YES; }

#pragma mark - Table view

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
        return [NSString stringWithFormat:@"Logged as: %@",api.user.userName];
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1){
        UIAlertView *alert;
        switch (indexPath.row) {
            case 0:
                [self logout]; // we don't show alert because we want logout operation be quick
                break;
            case 1:
                //show alert
                alert = LoadAlertViewWithOthers(STRING_ALERT, STRING_PROMPT_RESTORE, STRING_CANCEL, STRING_OK);
                [alert setTag:2];
                [alert show];
                break;
            case 2:
                // goes to "about" page
                break;
            default: break;
        }
    }    
    [self.view endEditing:YES]; // release keyboard
}

@end
