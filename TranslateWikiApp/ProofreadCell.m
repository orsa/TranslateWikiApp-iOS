//
//  MsgCell.m
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
//*********************************************************************************
// ProofreadCell - manages a displayed cell in a proofread session for a
// specific message
//*********************************************************************************

#import "ProofreadCell.h"

@implementation ProofreadCell
@synthesize managedObjectContext, srcLabel, dstLabel, acceptBtn, rejectBtn,editBtn, editContainer,cellFrame, acceptCount;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        acceptBtn.hidden = TRUE;
        rejectBtn.hidden = TRUE;
        editBtn.hidden = TRUE;
        editContainer.hidden = TRUE;
        cellFrame.hidden = TRUE;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setExpanded:(NSNumber*)expNumber
{
    BOOL exp=[expNumber boolValue];
    
    acceptBtn.frame = CGRectMake (
                editContainer.frame.origin.x+editContainer.frame.size.width*0.25 - acceptBtn.frame.size.width*0.5,
                acceptBtn.frame.origin.y,
                acceptBtn.frame.size.width,
                acceptBtn.frame.size.height);
    
    rejectBtn.frame = CGRectMake (
                editContainer.frame.origin.x+editContainer.frame.size.width*0.75 - rejectBtn.frame.size.width*0.5,
                rejectBtn.frame.origin.y,
                rejectBtn.frame.size.width,
                rejectBtn.frame.size.height);
    
    acceptCount.frame = CGRectMake (
                    acceptBtn.frame.origin.x+acceptBtn.frame.size.width*0.6,
                    acceptCount.frame.origin.y,
                    acceptCount.frame.size.width,
                    acceptCount.frame.size.height);

    [acceptBtn setHidden:!exp];
    [rejectBtn setHidden:!exp];
    [editBtn setHidden:!exp];
    [acceptCount setHidden:!exp];
    //[_keyLabel setHidden:!exp]; //we don't show key for now
    [editContainer setHidden:!exp];
    
    [self setBackgroundColor: (exp ? [UIColor whiteColor] : [UIColor clearColor])];
    
    srcLabel.numberOfLines = (exp?0:1);
    dstLabel.numberOfLines = (exp?0:1);
    [srcLabel setLineBreakMode:(exp?NSLineBreakByWordWrapping:NSLineBreakByTruncatingTail)];
    [dstLabel setLineBreakMode:(exp?NSLineBreakByWordWrapping:NSLineBreakByTruncatingTail)];
    
    float h1 = [ProofreadCell optimalHeightForLabel:srcLabel];
    float h2 = [ProofreadCell optimalHeightForLabel:dstLabel];
    [srcLabel sizeToFit];
    [dstLabel sizeToFit];
    srcLabel.frame = CGRectMake(4, 0, self.frame.size.width - 20, (exp?h1:25));
    dstLabel.frame = CGRectMake(4, (exp?h1:25), self.frame.size.width - 4, (exp?h2:25));
}


+(float)optimalHeightForLabel:(UILabel*)lable
{
    return [lable.text sizeWithFont:lable.font constrainedToSize:CGSizeMake(lable.frame.size.width, UINTMAX_MAX) lineBreakMode:lable.lineBreakMode].height;
}

@end
