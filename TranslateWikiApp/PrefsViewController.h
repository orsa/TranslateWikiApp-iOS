//
//  PrefsViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 20/3/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TranslationMessageDataController;
@class TWapi;

@interface PrefsViewController : UITableViewController
@property (strong, nonatomic) TranslationMessageDataController* dataController;
@property (retain, nonatomic) TWapi *api;
@property (weak, nonatomic) IBOutlet UITextField *langTextField;
@property (weak, nonatomic) IBOutlet UITextField *projTextField;

- (IBAction)pushDone:(id)sender;
-(NSString*)getNewLang;
-(NSString*)getNewProj;

@end
