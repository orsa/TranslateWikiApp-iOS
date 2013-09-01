//
//  InputCell.h
//  TranslateWikiApp
//
//  Copyright 2013 Or Sagi, Tomer Tuchner
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
