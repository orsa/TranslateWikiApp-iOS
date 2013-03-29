//
//  PrefsViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 20/3/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "PrefsViewController.h"
#import "MainViewController.h"
#import "TranslationMessageDataController.h"
#import "TWapi.h"

@interface PrefsViewController ()

@end

@implementation PrefsViewController
{
    BOOL didChange; //use to mark that preferenses were updated
    int flag;       //use to distinguish between active pickerviews
}
@synthesize pickerView;
@synthesize langTextField;
@synthesize projTextField;
@synthesize proofreadOnlySwitch;
@synthesize managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Preferences"];
    [self.navigationController setNavigationBarHidden:NO];
    
    [pickerView setHidden:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)]];
    
    arrLang = [[NSArray alloc] initWithObjects:@"Arabic", @"Armenian", @"Belarusian", @"Bosnian", @"Chamorro", @"Chinese", @"Croatian", @"Czech", @"Danish", @"English", @"Estonian", @"Finnish", @"French", @"Georgian", @"German", @"Greek, Modern", @"Hebrew", @"Hindi", @"Hungarian", @"Italian", @"Japanese", @"Korean", @"Kurdish", @"Lao", @"Latin", @"Lithuanian", @"Macedonian", @"Nepali", @"Norwegian", @"Persian", @"Slovak", @"Thai", @"Tibetan", @"Urdu", @"Yiddish", nil];
    
    arrLangCodes = [[NSArray alloc] initWithObjects:@"ar", @"hy", @"be", @"bs", @"ch", @"zh", @"hr", @"cs", @"da", @"en", @"et", @"fi", @"fr", @"ka", @"de", @"el", @"he", @"hi", @"hu", @"it", @"ja", @"ko", @"ku", @"lo", @"la", @"lt", @"mk", @"ne", @"no", @"fa", @"sk", @"th", @"bo", @"ur", @"yi", nil];
    
    arrProj = [_api TWProjectListMaxDepth:0];
    NSLog(@"%@",arrProj); //Debug
    
    didChange = NO;
    flag= 0;
    
    [langTextField setInputView:pickerView];
    [projTextField setInputView:pickerView];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    langTextField.text = [arrLang objectAtIndex:[arrLangCodes indexOfObject:[defaults objectForKey:@"defaultLanguage"]]];
    projTextField.text =  arrProj[[self indexOfProjCode:[defaults objectForKey:@"defaultProject"]]][@"label"];
    _tupleSizeTextView.text = [defaults objectForKey:@"defaultTupleSize"];
    [proofreadOnlySwitch setOn:[defaults boolForKey:@"proofreadOnlyState"] animated:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchSwitch:(id)sender {
    self.pickerView.hidden = YES;
    didChange = YES;
    flag = 0;
}

-(void)backgroundTap:(UITapGestureRecognizer *)tapGR{
    self.pickerView.hidden = YES;
    flag = 0;
    [_tupleSizeTextView resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)editingEnded:(id)sender{
    [sender resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [pickerView setHidden:YES];
    NSInteger i = 0;
    if (langTextField.editing == YES)
    {
        flag = 1;
        [langTextField resignFirstResponder];
        [pickerView setHidden:NO];
        i = [arrLang indexOfObject:langTextField.text];
        [pickerView selectRow:i inComponent:0 animated:NO];
    }
    else if (projTextField.editing == YES)
    {
        flag = 2;
        [projTextField resignFirstResponder];
        [pickerView setHidden:NO];
        i = [self indexOfProjlabel:projTextField.text];
    }
    [pickerView reloadAllComponents];
    [pickerView selectRow:i inComponent:0 animated:NO];
}

-(NSString*)getNewLang
{
 //   NSString* newLang=langTextField.text;
    
    if(selectedLangCode)
        return selectedLangCode;
    else
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguage"];
}

-(NSString*)getNewProj
{
    if(selectedProjCode)
        return selectedProjCode;
    else
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultProject"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.pickerView.hidden = YES;
    [_tupleSizeTextView resignFirstResponder];
    if (didChange && ![[self.navigationController viewControllers] containsObject:self])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[self getNewLang] forKey:@"defaultLanguage"];
        [defaults setObject:[self getNewProj] forKey:@"defaultProject"];
        [defaults setObject:_tupleSizeTextView.text forKey:@"defaultTupleSize"];
        bool state = [proofreadOnlySwitch state];
        [defaults setBool:state forKey:@"proofreadOnlyState"];
        MainViewController *ViewController = (MainViewController *)[self.navigationController topViewController];
        [ViewController.dataController removeAllObjects];
        // ViewController.managedObjectContext = self.managedObjectContext;
        [ViewController addMessagesTuple];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

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
    if (textField == _tupleSizeTextView)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^0*(([0-4]?[0-9]?)|(50?))$"; //regexp which restrics input to a range of 0 to 50
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
    }    
    return YES;
}

@end
