//
//  InputCell.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 6/4/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

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
    if(![sendBtn isUserInteractionEnabled])
    {
        [inputText setText:@""];
    }
    else
    {
        [UIView animateWithDuration:0.24f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [BtnView setFrame:CGRectMake(self.frame.size.width-50, 0, BtnView.frame.size.width, BtnView.frame.size.height)];
            [inputText setFrame:CGRectMake(0, 0, self.frame.size.width-50, BtnView.frame.size.height)];
        } completion:nil];
    }
    
    [inputText setTextColor:[UIColor blackColor]];
    [_father setActiveTextViewPointer:inputText];
}

-(void)textViewDidEndEditing:(UITextView*)textView
{
    if([[inputText text] isEqualToString:@""])
    {
        [inputText setTextColor:[UIColor lightGrayColor]];
        [inputText setText:@"Your translation"];
    }
    [UIView animateWithDuration:0.24f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [BtnView setFrame:CGRectMake(self.frame.size.width-5, 0, BtnView.frame.size.width, BtnView.frame.size.height)];
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

}

- (IBAction)pushSendBtn:(id)sender {
    [_api TWEditRequestWithTitle:[_msg title] andText:[inputText text]];
    [inputText resignFirstResponder];
    
    [_father removeFromList]; //we probably won't simply remove it, maybe make it smaller.
    
    [_father setActiveTextViewPointer:[_father initialActiveTextView]];
}
@end
