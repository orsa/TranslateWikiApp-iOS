//
//  ProofreadViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TranslationMessage;
@class TranslationMessageDataController;
@class TWUser;

@interface ProofreadViewController : UITableViewController
@property (strong, nonatomic) TranslationMessageDataController* dataController;
@property  (retain, nonatomic) TWUser* loggedUser;
@property (nonatomic) NSInteger msgIndex;
@property (weak, nonatomic) IBOutlet UILabel *messageKeyLable;
@property (weak, nonatomic) IBOutlet UILabel *definitionLable;
@property (weak, nonatomic) IBOutlet UILabel *translationLable;
- (IBAction)pushAccept:(id)sender;
- (IBAction)pushReject:(id)sender;
- (IBAction)pushDone:(id)sender;

@end
