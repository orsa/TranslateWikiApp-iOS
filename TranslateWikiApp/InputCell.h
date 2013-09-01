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

@property (weak, nonatomic) IBOutlet UITextView *inputText;     // text view to which the user can insert his translation
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;         // the button on which the user taps to send translation
@property (weak, nonatomic) IBOutlet UIView *BtnView;           // the view in which the the button is present
@property (retain, nonatomic) TranslationMessage * msg;         // the message object which contains all the info about the message
@property (retain, nonatomic) TWapi * api;                      // api object for api requests
@property (retain, nonatomic) TranslationCell * father;         // the father in the heirarchy - translation cell

- (IBAction) pushSendBtn:(id)sender;                            // handling the event of pushing the send button
- (void) textViewDidChange:(UITextView *)textView;              // handling the event of the text in text view changing

@end
