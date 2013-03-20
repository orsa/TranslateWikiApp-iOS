//
//  ProofreadViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "ProofreadViewController.h"
#import "TranslationMessage.h"
#import "TranslationMessageDataController.h"
#import "TWapi.h"
#import "MainViewController.h"

@interface ProofreadViewController ()
- (void)configureView;
@end

@implementation ProofreadViewController


- (void)configureView
{
    // Update the user interface for the detail item.
    TranslationMessage *theMessage = [self activeMsg];
    
    if (theMessage) {
        self.messageKeyLable.text = theMessage.key;
        self.definitionLable.text = theMessage.source;
        self.translationLable.text = theMessage.translation;
        self.acceptCount.text = [NSString  stringWithFormat:@"%d",theMessage.acceptCount];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushAccept:(id)sender
{
    if (![self activeMsg].isAccepted)
    {
        bool success = [_api TWTranslationReviewRequest:([self activeMsg].revision)]; //accept this translation via API
    
        if (success)
        {
            [[self activeMsg] setIsAccepted:YES];
            [[self activeMsg] setAcceptCount:([[self activeMsg] acceptCount]+1)];
        }
    }
    [self performSegueWithIdentifier:@"setReview" sender:self];
}

- (IBAction)pushReject:(id)sender
{
    [[self activeMsg] setIsAccepted:NO];
    [self.dataController removeObjectAtIndex:(self.msgIndex)];
    [self performSegueWithIdentifier:@"setReview" sender:self]; 
}

- (IBAction)pushDone:(id)sender {
   [self performSegueWithIdentifier:@"setReview" sender:self]; 
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"setReview"])
    {
        MainViewController *ViewController = [segue destinationViewController];
        ViewController.dataController = self.dataController;
        ViewController.api = _api;
    }
}

- (TranslationMessage*)activeMsg
{
    return [self.dataController objectInListAtIndex:(self.msgIndex)];
}
@end
