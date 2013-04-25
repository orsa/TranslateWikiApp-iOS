//
//  PrefsViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 20/3/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "PrefsViewController.h"

@interface PrefsViewController ()

@end

@implementation PrefsViewController
{
    BOOL didChange; //use to mark that preferenses were updated
    int flag;       //use to distinguish between active pickerviews
}

@synthesize langTextField;
@synthesize projTextField;
@synthesize proofreadOnlySwitch;
@synthesize tupleSizeTextView;
@synthesize didChange;
@synthesize selectedProjCode;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Preferences"];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)]];
    
    arrLang = [[NSArray alloc] initWithObjects:LANGUAGE_NAMES];
    arrLangCodes = [[NSArray alloc] initWithObjects:LANGUAGE_CODES];
    LoadUserDefaults();
    //requesting project list via api - level-0 only
    [_api TWProjectListMaxDepth:0 completionHandler:^(NSArray *newArrProj, NSError *error) {
        
        if (error || newArrProj==nil)
        {
            NSLog(@"Error occured while loading projects.");
        }
        else if (newArrProj.count>0)
        {
            arrProj = [NSArray arrayWithArray:newArrProj];
            //load from NSUserDefaults
            projTextField.text =  arrProj[[self indexOfProjCode:getUserDefaultskey(PROJ_key)]][@"label"];
            selectedProjCode = arrProj[[self indexOfProjCode:getUserDefaultskey(PROJ_key)]][@"id"];
        }
        else
            NSLog(@"No project loaded.");
            
    }]; 
    //LOG(arrProj); //Debug
    
    didChange = NO;
    
    NSInteger index = [arrLangCodes indexOfObject:getUserDefaultskey(LANG_key)];
    if (index!=NSNotFound)
        langTextField.text = [arrLang objectAtIndex:index];
    else
        NSLog(@"Unfound language: %@", getUserDefaultskey(LANG_key) );
    
    //load from NSUserDefaults
    tupleSizeTextView.text = getUserDefaultskey(TUPSIZE_key);
    bool state = getBoolUserDefaultskey(PRMODE_key);
    [proofreadOnlySwitch setOn:state animated:NO];
    
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
    }
}

- (IBAction)touchSwitch:(id)sender {
    didChange = YES;
    [tupleSizeTextView resignFirstResponder];
}

-(void)backgroundTap:(UITapGestureRecognizer *)tapGR{
    [tupleSizeTextView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [tupleSizeTextView resignFirstResponder];
    if (textField==langTextField) //go to language picker
    {
        [self performSegueWithIdentifier:@"langPicker" sender:self];
        return NO;
    }
    else if (textField==projTextField) //go to project broser
    {
        [self performSegueWithIdentifier:@"projBrowser" sender:self];
        return NO;
    }
    return YES;
    
}

-(NSString*)getNewLang
{
    NSInteger index = [arrLang indexOfObject:langTextField.text];
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
    [self.view endEditing:YES];
    if (didChange && ![[self.navigationController viewControllers] containsObject:self])
    { //set new preferences
        LoadUserDefaults();
        setUserDefaultskey([self getNewLang], LANG_key);
        setUserDefaultskey([self getNewProj], PROJ_key);
        if (![tupleSizeTextView.text isEqualToString:@""])
            setUserDefaultskey(tupleSizeTextView.text, TUPSIZE_key);
        BOOL state = [proofreadOnlySwitch isOn];
        setBoolUserDefaultskey(state, PRMODE_key);
        MainViewController *ViewController = (MainViewController *)[self.navigationController topViewController];
        ViewController.translationState=!state;
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
    return YES;
}

-(IBAction)restoreDefaults:(id)sender
{   //show alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you really mean that?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1)  //clicked ok at the alert
    {
        NSString* lang=PREFERRED_LANG(0);
        NSString* proj=@"!recent";
        NSString* tuple=INITIAL_TUPLE_SIZE;
        BOOL mode=YES;//proofread ON
        
        selectedProjCode=proj;
        projTextField.text=@"Recent translations";
        langTextField.text=[arrLang objectAtIndex:[arrLangCodes indexOfObject:lang]];
        tupleSizeTextView.text=tuple;
        [proofreadOnlySwitch setOn:mode animated:YES];
        didChange=YES;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* customFooterView=[[UIView alloc] initWithFrame:CGRectMake(5.0, 198, 300, 80)];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    myButton.frame = CGRectMake(8, 0, 200, 40);
    //[myButton setBackgroundColor:[UIColor redColor]];
    [myButton setTintColor:[UIColor redColor]];
    [myButton setTitle:@"Restore Defaults" forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(restoreDefaults:) forControlEvents:UIControlEventTouchUpInside];
    
    [customFooterView addSubview:myButton];
    
    return customFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 53.0;
}

@end
