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
    int flag;
}
@synthesize pickerView;
@synthesize langTextField;
@synthesize projTextField;
@synthesize proofreadOnlySwitch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [pickerView setHidden:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)]];
    
    arrLang = [[NSArray alloc] initWithObjects:@"Arabic", @"Armenian", @"Belarusian", @"Bosnian", @"Chamorro", @"Chinese", @"Croatian", @"Czech", @"Danish", @"English", @"Estonian", @"Finnish", @"French", @"Georgian", @"German", @"Greek, Modern", @"Hebrew", @"Hindi", @"Hungarian", @"Italian", @"Japanese", @"Korean", @"Kurdish", @"Lao", @"Latin", @"Lithuanian", @"Macedonian", @"Nepali", @"Norwegian", @"Persian", @"Slovak", @"Thai", @"Tibetan", @"Urdu", @"Yiddish", nil];
    
    arrLangCodes = [[NSArray alloc] initWithObjects:@"ar", @"hy", @"be", @"bs", @"ch", @"zh", @"hr", @"cs", @"da", @"en", @"et", @"fi", @"fr", @"ka", @"de", @"el", @"he", @"hi", @"hu", @"it", @"ja", @"ko", @"ku", @"lo", @"la", @"lt", @"mk", @"ne", @"no", @"fa", @"sk", @"th", @"bo", @"ur", @"yi", nil];
    
    //arrProj = [[NSArray alloc] initWithObjects:@"!recent", @"core", nil]; //can use api:action=query&meta=messagegroups to get them all
    arrProj = [_api TWProjectListMaxDepth:0];
    NSLog(@"%@",arrProj); //Debug
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    langTextField.text = [arrLang objectAtIndex:[arrLangCodes indexOfObject:[defaults objectForKey:@"defaultLanguage"]]];
    projTextField.text =  arrProj[[self indexOfProjCode:[defaults objectForKey:@"defaultProject"]]][@"label"];
    [proofreadOnlySwitch setOn:[defaults boolForKey:@"proofreadOnlyState"] animated:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushDone:(id)sender
{
    self.pickerView.hidden = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self getNewLang] forKey:@"defaultLanguage"];
    [defaults setObject:[self getNewProj] forKey:@"defaultProject"];
    bool state = [proofreadOnlySwitch state];
    [defaults setBool:state forKey:@"proofreadOnlyState"];
    
    [self performSegueWithIdentifier:@"setPrefs" sender:self];
}

- (IBAction)touchSwitch:(id)sender {
    self.pickerView.hidden = YES;
    flag = 0;
}

-(void)backgroundTap:(UITapGestureRecognizer *)tapGR{
    [self touchSwitch:self];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"setPrefs"])
    {
        MainViewController *ViewController = [segue destinationViewController];
        ViewController.api = _api;
        [ViewController.dataController removeAllObjects];
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

- (void)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
}

-(void)pickerView:(UIPickerView *)pickerV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
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

@end
