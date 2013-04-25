//
//  InputCell.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 6/4/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <UIKit/UIKit.h>
#import "TranslationMessage.h"
#import "TranslationCell.h"
#import "TWapi.h"

@interface InputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *inputText;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property(nonatomic, retain)TranslationMessage * msg;
@property (retain, nonatomic) TWapi * api;
@property (retain, nonatomic) TranslationCell * father;
@property (weak, nonatomic) IBOutlet UIView *BtnView;

- (void)textViewDidChange:(UITextView *)textView;
- (IBAction)pushSendBtn:(id)sender;

@end
