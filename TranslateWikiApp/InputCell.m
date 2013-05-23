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

#import "InputCell.h"

@implementation InputCell
@synthesize inputText;
@synthesize sendBtn;
@synthesize BtnView;


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
    [_father scrollTo]; 
    if(![sendBtn isUserInteractionEnabled])
    {
        [inputText setText:@""];
    }
    else
    {
        [UIView animateWithDuration:0.24f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [BtnView setFrame:CGRectMake(self.frame.size.width-50, 0, 50, BtnView.frame.size.height)];
            [inputText setFrame:CGRectMake(0, 0, self.frame.size.width-50, BtnView.frame.size.height)];
        } completion:nil];
    }
    
    [inputText setTextColor:[UIColor blackColor]];
}

-(void)textViewDidEndEditing:(UITextView*)textView
{
    if([[inputText text] isEqualToString:@""])
    {
        [_father clearTextBox];
    }
    [UIView animateWithDuration:0.24f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [BtnView setFrame:CGRectMake(self.frame.size.width-5, 0, 50, BtnView.frame.size.height)];
        [inputText setFrame:CGRectMake(0, 0, self.frame.size.width-5, BtnView.frame.size.height)];
    } completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(![[inputText text] isEqualToString:@""])
    {
        [sendBtn setUserInteractionEnabled:YES];
        [UIView animateWithDuration:0.24f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [BtnView setFrame:CGRectMake(self.frame.size.width-50, 0, BtnView.frame.size.width, BtnView.frame.size.height)];
            [inputText setFrame:CGRectMake(0, 0, self.frame.size.width-50, BtnView.frame.size.height)];
            } completion:nil];
    }
    else
    {
        [sendBtn setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.24f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [BtnView setFrame:CGRectMake(self.frame.size.width-5, 0, BtnView.frame.size.width, BtnView.frame.size.height)];
            [inputText setFrame:CGRectMake(0, 0, self.frame.size.width-5, BtnView.frame.size.height)];
        } completion:nil];

    }
    _msg.userInput = textView.text;
}

- (IBAction)pushSendBtn:(id)sender {
    if (!_father.msg.translated || ![_father.msg.translationByUser isEqualToString:[inputText text]]) //send api request only if changed translation.
        [_api TWEditRequestWithTitle:[_msg title] andText:[inputText text] completionHandler:^(BOOL success, NSError * error){
            //check errors etc.
        }];
    
    [inputText resignFirstResponder];
    _father.msg.translated=TRUE;
    _father.msg.translationByUser=[inputText text];
    [_father setMinimized:[NSNumber numberWithBool:TRUE]];
    [((UITableView*)_father.superview) beginUpdates];
    [((UITableView*)_father.superview) endUpdates];
    //[((UITableView*)_father.superview) reloadData];
    
    //[_father removeFromList]; //we probably won't simply remove it, maybe make it smaller.
}


@end
