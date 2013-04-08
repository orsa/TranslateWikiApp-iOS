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
    [inputText setText:@""];
    [_father setActiveTextViewPointer:inputText];
}

- (IBAction)pushSendBtn:(id)sender {
    [_api TWEditRequestWithTitle:[_msg title] andText:[inputText text]];
    [inputText resignFirstResponder];
    [_father removeFromList];
    [_father setActiveTextViewPointer:[_father initialActiveTextView]];
}
@end
