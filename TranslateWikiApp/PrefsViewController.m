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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [pickerView setHidden:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)]];
    arrLang = [[NSArray alloc] initWithObjects:@"en", @"es", @"he", @"fr", nil];
    arrProj = [[NSArray alloc] initWithObjects:@"core", @"!recent", nil]; //can use api:action=query&meta=messagegroups to get them all
    langTextField.text = _api.user.pref.preferredLang;
    projTextField.text = _api.user.pref.preferredProj;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushDone:(id)sender {
    _api.user.pref.preferredLang=[self getNewLang];
    _api.user.pref.preferredProj=[self getNewProj];
    [self performSegueWithIdentifier:@"setPrefs" sender:self];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [pickerView setHidden:YES];
    if (langTextField.editing == YES) {
        [langTextField resignFirstResponder];
        [pickerView setHidden:NO];
        flag = 1;
    }else if (projTextField.editing == YES) {
        [projTextField resignFirstResponder];
        [pickerView setHidden:NO];
        flag = 2;
    }
    [pickerView reloadAllComponents];
}

-(NSString*)getNewLang
{
    NSString* newLang=langTextField.text;
    
    if(!([newLang isEqualToString:@""]))
        return newLang;
    else
        return _api.user.pref.preferredLang;
}

-(NSString*)getNewProj
{
    NSString* newProj=projTextField.text;
    
    if(!([newProj isEqualToString:@""]))
        return newProj;
    else
        return _api.user.pref.preferredProj;
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
        return [arrLang objectAtIndex:row];
    else if(flag == 2)
        return [arrProj objectAtIndex:row];
    else
        return nil;
}

- (void)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
}

-(void)backgroundTap:(UITapGestureRecognizer *)tapGR{
    self.pickerView.hidden = YES;
    flag = 0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *text = [self pickerView:pickerView titleForRow:row forComponent:component];
    UITextField *current = nil;
    if (flag == 1) current = self.langTextField;
    else if (flag == 2) current = self.projTextField;
    current.text = text;
}
@end
