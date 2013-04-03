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
//@synthesize pickerView;
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
    
  //  [pickerView setHidden:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)]];
    
    arrLang = [[NSArray alloc] initWithObjects:LANGUAGE_NAMES];
    arrLangCodes = [[NSArray alloc] initWithObjects:LANGUAGE_CODES];
    arrProj = [_api TWProjectListMaxDepth:0]; //requesting project list via api - level-0 only
    //LOG(arrProj); //Debug
    
    didChange = NO;
    //flag= 0;
    
   //load from NSUserDefaults
    LoadUserDefaults();
    langTextField.text = [arrLang objectAtIndex:[arrLangCodes indexOfObject:getUserDefaultskey(LANG_key)]];
    projTextField.text =  arrProj[[self indexOfProjCode:getUserDefaultskey(PROJ_key)]][@"label"];
    selectedProjCode = arrProj[[self indexOfProjCode:getUserDefaultskey(PROJ_key)]][@"id"];
    tupleSizeTextView.text = getUserDefaultskey(TUPSIZE_key);
    [proofreadOnlySwitch setOn:getBoolUserDefaultskey(PRMODE_key) animated:NO];
    
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
        ViewController.srcArr = arrProj;
    }
    /*if([[segue identifier] isEqualToString:@"langPicker"]) {
        SearchViewController * ViewController = [segue destinationViewController];
    }*/
}

- (IBAction)touchSwitch:(id)sender {
   // flag = 0;
    didChange = YES;
   // self.pickerView.hidden = YES;
    [tupleSizeTextView resignFirstResponder];
  //  [self.view endEditing:YES];
}

-(void)backgroundTap:(UITapGestureRecognizer *)tapGR{
   // flag = 0;
   // self.pickerView.hidden = YES;
    [tupleSizeTextView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //[textField resignFirstResponder];
    //[self.view endEditing:YES];
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField==langTextField)
    {
        [tupleSizeTextView resignFirstResponder];
        [self performSegueWithIdentifier:@"langPicker" sender:self];
        return NO;
    }
    else if (textField==projTextField)
    {
        [tupleSizeTextView resignFirstResponder];
        [self performSegueWithIdentifier:@"projBrowser" sender:self];
        return NO;
    }
    return YES;
    
}

-(NSString*)getNewLang
{
    return [arrLangCodes objectAtIndex:[arrLang indexOfObject:langTextField.text]];
}

-(NSString*)getNewProj
{
        return selectedProjCode;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // self.pickerView.hidden = YES;
    [tupleSizeTextView resignFirstResponder];
    [self.view endEditing:YES];
    if (didChange && ![[self.navigationController viewControllers] containsObject:self])
    { //set new preferences
        LoadUserDefaults();
        setUserDefaultskey([self getNewLang], LANG_key);
        setUserDefaultskey([self getNewProj], PROJ_key);
        setUserDefaultskey(tupleSizeTextView.text, TUPSIZE_key);
        bool state = [proofreadOnlySwitch state];
        setBoolUserDefaultskey(state, PRMODE_key);
        MainViewController *ViewController = (MainViewController *)[self.navigationController topViewController];
        [ViewController.dataController removeAllObjects];
        [ViewController addMessagesTuple];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}
/*
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (flag == 1)
        return arrLang.count;
    else if(flag == 2)
        return arrProj.count;
    else
        return nil;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (flag == 1)
        return arrLang[row];
    else if(flag == 2)
        return (arrProj[row][@"label"]);
    else
        return nil;
}


-(void)pickerView:(UIPickerView *)pickerV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    didChange = YES;
    NSString *text = [self pickerView:pickerV titleForRow:row forComponent:component];
    if (flag == 1)
    {
        self.langTextField.text = text;
        selectedLangCode = arrLangCodes[row];
    }
    else if (flag == 2)
    {
        self.projTextField.text = text;
        selectedProjCode = arrProj[row][@"id"];
    }
}
*/

-(int)indexOfProjCode:(NSString*)pcode{
    int i=0;
    for(NSDictionary * aproj in arrProj)
    {
        if ([pcode isEqualToString:aproj[@"id"]]) {
            return i;
        }
        else i++;
    }
    return 0;
}

-(int)indexOfProjlabel:(NSString*)plabel{
    int i=0;
    for(NSDictionary * aproj in arrProj)
    {
        if ([plabel isEqualToString:aproj[@"label"]]) {
            return i;
        }
        else i++;
    }
    return 0;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == tupleSizeTextView)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^0*(([0-4]?[0-9]?)|(50?))$"; //regexp which restrics input to a range of 0 to 50
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                            error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
    }
    didChange=YES;
    return YES;
}

@end
