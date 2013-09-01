//
//  InputCell.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 6/4/13.
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
//*********************************************************************************
// InputCell - manages the cell that contains the text view plus the send button
// in a translate cell
//*********************************************************************************

#import "InputCell.h"

@implementation InputCell
@synthesize api, msg, inputText, sendBtn, BtnView, father;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        inputText.text = @"";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)textViewDidBeginEditing:(UITextView*)textView
{
    [father scrollTo];
    if(![sendBtn isUserInteractionEnabled])
    {
        [inputText setText:@""];
    }
    else
    {
        [self revealSendBtnOn:YES];
    }
    
    [inputText setTextColor:[UIColor blackColor]];
}

-(void)textViewDidEndEditing:(UITextView*)textView
{
    if([[inputText text] isEqualToString:@""])
    {
        [father clearTextBox];
    }
    [self revealSendBtnOn:NO];
}

- (void)textViewDidChange:(UITextView *)textView
{
    bool show = ![[inputText text] isEqualToString:@""];
    [sendBtn setUserInteractionEnabled:show];
    [self revealSendBtnOn:show];
    msg.userInput = textView.text;
}

// animated reveal or unveil send button
- (void) revealSendBtnOn:(bool) show{
    [UIView animateWithDuration:ANIMATION_DUR delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [BtnView   setFrame:CGRectMake( self.frame.size.width - (show?50:5)
                                      , 0
                                      , BtnView.frame.size.width
                                      , BtnView.frame.size.height )];
        [inputText setFrame:CGRectMake( 0
                                      , 0
                                      , self.frame.size.width - (show?50:5)
                                      , BtnView.frame.size.height )];
    } completion:nil];
}

- (IBAction)pushSendBtn:(id)sender {
    if (!father.msg.translated || ![father.msg.translationByUser isEqualToString:[inputText text]]) //send api request only if changed translation.
        [api TWEditRequestWithTitle:[msg title] andText:[inputText text] completionHandler:^(NSError * error, NSDictionary* responseData){
            //check errors etc.
            if(error){
                LoadDefaultAlertView();
                AlertSetMessage(connectivityProblem);
                AlertShow();
            }
            else if(responseData[@"error"]){
                LoadDefaultAlertView();
                AlertSetMessage(responseData[@"error"][@"info"]);
                AlertShow();
            }
            else if(responseData[@"warnings"]){
                //handle warnings
            }
        }];
    
    [inputText resignFirstResponder];
    father.msg.translated=TRUE;
    father.msg.translationByUser=[inputText text];
    [father setMinimized:@YES];
    [((UITableView*)father.superview) beginUpdates];
    [((UITableView*)father.superview) endUpdates];
}


@end
