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


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushDone:(id)sender {
    [self performSegueWithIdentifier:@"setPrefs" sender:self];
}

-(NSString*)getNewLang
{
    NSString* newLang=_langTextField.text;
    
    if(!([newLang isEqualToString:@""]))
        return newLang;
    else
        return _api.user.preferredLang;
}

-(NSString*)getNewProj
{
    NSString* newProj=_projTextField.text;
    
    if(!([newProj isEqualToString:@""]))
        return newProj;
    else
        return _api.user.preferredProj;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"setPrefs"])
    {
        MainViewController *ViewController = [segue destinationViewController];
        
        _api.user.preferredLang=[self getNewLang];
        _api.user.preferredProj=[self getNewProj];
        
        [_dataController removeAllObjects];
        [_dataController addMessagesTupleUsingApi:_api];
        ViewController.dataController = _dataController;
        ViewController.api = _api;
    }
}@end
