//
//  ProofreadViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TranslationMessage.h"
#import "TranslationMessageDataController.h"
#import "TWUser.h"
#import "TWapi.h"

@interface ProofreadViewController : UITableViewController{
    NSManagedObjectContext *managedObjectContext;
}

@property (strong, nonatomic) TranslationMessageDataController* dataController;
@property (nonatomic) NSInteger msgIndex;
@property (weak, nonatomic) IBOutlet UILabel *messageKeyLable;
@property (weak, nonatomic) IBOutlet UILabel *definitionLable;
@property (weak, nonatomic) IBOutlet UILabel *translationLable;
@property (weak, nonatomic) IBOutlet UILabel *acceptCount;
@property (retain, nonatomic) TWapi *api;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)pushAccept:(id)sender;
- (IBAction)pushReject:(id)sender;
- (IBAction)pushDone:(id)sender;
- (void)coreDataRejectMessage;

@end
