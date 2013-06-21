//
//  PrefsViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 20/3/13.
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

@interface PrefsViewController ()

@end

@implementation PrefsViewController
{
    BOOL didChange; //use to mark that preferenses were updated
    int flag;       //use to distinguish between active pickerviews
}

@synthesize langLabel;
@synthesize projLabel;
@synthesize tupleSizeTextView;
@synthesize didChange;
@synthesize selectedProjCode;
@synthesize maxMsgLengthTextField;
@synthesize api;


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Settings"];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    //[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)]];
    
    arrLang =  @[LANGUAGE_NAMES];
    arrLangCodes = @[LANGUAGE_CODES];
    LoadUserDefaults();
    //requesting project list via api - level-0 only
    
    arrProj = getUserDefaultskey(ALL_PROJ_key);
    if (!arrProj)
    {
        [api TWProjectListMaxDepth:0 completionHandler:^(NSArray *newArrProj, NSError *error) {
        
            if (error || newArrProj==nil)
            {
                NSLog(@"Error occured while loading projects.");
            }
            else if (newArrProj.count>0)
            {
                arrProj = [NSArray arrayWithArray:newArrProj];
                setUserDefaultskey(arrProj, ALL_PROJ_key);
                //load from NSUserDefaults
                int i = [self indexOfProjCode:getUserDefaultskey(PROJ_key)];
                if (i != -1)
                {
                    projLabel.text =  arrProj[i][@"label"];
                    selectedProjCode = arrProj[i][@"id"];
                }
                else{
                    //missing project from list
                    projLabel.text =  @"";
                    selectedProjCode = @"";
                }
            }
            else
                NSLog(@"No project loaded.");
            
        }];
    }
    else if (arrProj.count>0)
    {
        //load from NSUserDefaults
        int i = [self indexOfProjCode:getUserDefaultskey(PROJ_key)];
        if (i != -1)
        {
            projLabel.text =  arrProj[i][@"label"];
            selectedProjCode = arrProj[i][@"id"];
        }
        else{
            //missing project from list
            projLabel.text =  @"";
            selectedProjCode = @"";
        }
    }
    //LOG(arrProj); //Debug
    
    didChange = NO;
    
    NSInteger index = [arrLangCodes indexOfObject:getUserDefaultskey(LANG_key)];
    if (index!=NSNotFound)
        langLabel.text = [arrLang objectAtIndex:index];
    else
        NSLog(@"Unfound language: %@", getUserDefaultskey(LANG_key) );
    
    //load from NSUserDefaults
    tupleSizeTextView.text = getUserDefaultskey(TUPSIZE_key);
    maxMsgLengthTextField.text = getUserDefaultskey(MAX_MSG_LEN_key);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(void)backgroundTap:(UITapGestureRecognizer *)tapGR{
    [tupleSizeTextView resignFirstResponder];
    [maxMsgLengthTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}


-(NSString*)getNewLang
{
    NSInteger index = [arrLang indexOfObject:langLabel.text];
    if (index!=NSNotFound) {
        return [arrLangCodes objectAtIndex:index];
    }
    else{
        NSLog(@"no language found");
    }
    return nil;
}

-(NSString*)getNewProj
{
        return selectedProjCode;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [tupleSizeTextView resignFirstResponder];
    [maxMsgLengthTextField resignFirstResponder];
    
    [self.view endEditing:YES];
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
        if (ViewController.class == [MainViewController class])
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1; //always one column
}

-(int)indexOfProjCode:(NSString*)pcode{
    int i=0;
    for(NSDictionary * aproj in arrProj)
    {
        NSString * st = aproj[@"id"];
        if (st && [pcode isEqualToString:st]) {
            return i;
        }
        else i++;
    }
    return -1;
}

-(int)indexOfProjlabel:(NSString*)plabel{
    int i=0;
    for(NSDictionary * aproj in arrProj)
    {
        NSString * st = aproj[@"label"];
        if (st && [plabel isEqualToString:st]) {
            return i;
        }
        else i++;
    }
    return -1;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == tupleSizeTextView)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^(([5-9])|([1-4][0-9]?)|(50?))?$"; //regexp which restrics input to a range of 0 to 50
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                            error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
       
         if (![textField.text isEqualToString:@""])
               didChange=YES;
    }
    else if (textField==maxMsgLengthTextField)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^([1-9]?|[1-9][0-9]{0,5}+)$"; // numbers only regexp
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
        
        if (![textField.text isEqualToString:@""])
            didChange=YES;
    }
    return YES;
}

-(IBAction)logout:(id)sender
{
    //LoadAlertViewWithOthers(@"Alert", @"Do you really want to log out?", @"Oh, no", @"Yes");
    //[alert setTag:1];
    //[alert show];
    
    /* logout without prompting aproval */
    [api TWLogoutRequest:^(NSDictionary* response, NSError* error){
        //Handle the error
        NSLog(@"%@", error);
    }];
    KeychainItemWrapper * loginKC = [[KeychainItemWrapper alloc] initWithIdentifier:@"translatewikiapplogin" accessGroup:nil];
    [loginKC resetKeychainItem];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)restoreDefaults:(id)sender
{   //show alert
    LoadAlertViewWithOthers(@"Alert", @"Do you really mean that?", @"Cancel", @"Ok");
    [alert setTag:2];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1: //alert result for logout
            if (buttonIndex == 1)  //clicked ok at the alert
            {
                [api TWLogoutRequest:^(NSDictionary* response, NSError* error){
                    //Handle the error
                    NSLog(@"%@", error);
                }];
                KeychainItemWrapper * loginKC = [[KeychainItemWrapper alloc] initWithIdentifier:@"translatewikiapplogin" accessGroup:nil];
                [loginKC resetKeychainItem];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            break;
        case 2: //alert result for restore
            if (buttonIndex == 1)  //clicked ok at the alert
            {
                NSString* lang=PREFERRED_LANG(0);
                NSString* proj=@"!recent";
                NSString* tuple=INITIAL_TUPLE_SIZE;
                NSString* maxLen = INITIAL_MAX_LENGTH;
                
                selectedProjCode=proj;
                projLabel.text=@"Recent translations";
                langLabel.text=[arrLang objectAtIndex:[arrLangCodes indexOfObject:lang]];
                tupleSizeTextView.text=tuple;
                maxMsgLengthTextField.text = maxLen;
                
                didChange=YES;
                
            }
            break;
        default:
            break;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Logged as: %@",api.user.userName];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* customFooterView=[[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, 0,
                                                                      tableView.frame.size.width, 82)];
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    logoutButton.frame = CGRectMake(tableView.frame.origin.x + 10, 5, tableView.frame.size.width-20, 33);
    resetButton.frame = CGRectMake(tableView.frame.origin.x + 10, 42, tableView.frame.size.width-20, 33);
    
    [logoutButton setBackgroundColor:[UIColor colorWithRed:0.826782 green:0.840739 blue:1 alpha:1]];
    [resetButton setBackgroundColor:[UIColor colorWithRed:0.826782 green:0.840739 blue:1 alpha:1]];
    
    [logoutButton setTitleColor:[UIColor colorWithRed:0.333333 green:0.333333 blue:0.333333 alpha:1] forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor colorWithRed:0.333333 green:0.333333 blue:0.333333 alpha:1] forState:UIControlStateNormal];
    
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [resetButton setTitle:@"Restore Defaults" forState:UIControlStateNormal];
    
    [logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [resetButton addTarget:self action:@selector(restoreDefaults:) forControlEvents:UIControlEventTouchUpInside];
    
    [customFooterView addSubview:logoutButton];
    [customFooterView addSubview:resetButton];
    
    return customFooterView;
}

@end
