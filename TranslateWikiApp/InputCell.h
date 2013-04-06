//
//  InputCell.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 6/4/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TranslationMessage.h"
#import "TWapi.h"

@interface InputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITextView *inputText;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
- (IBAction)pushSend:(id)sender;
@property(nonatomic, retain)TranslationMessage * msg;
@property (retain, nonatomic) TWapi * api;

@end
