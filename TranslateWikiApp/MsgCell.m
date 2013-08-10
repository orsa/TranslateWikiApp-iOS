//
//  MsgCell.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 27/3/13.
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

#import "MsgCell.h"

@implementation MsgCell
@synthesize managedObjectContext;
@synthesize srcLabel;
@synthesize dstLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.acceptBtn.hidden = TRUE;
        self.rejectBtn.hidden = TRUE;
        self.editBtn.hidden = TRUE;
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
    [_acceptBtn setHidden:!exp];
    [_rejectBtn setHidden:!exp];
    [_editBtn setHidden:!exp];
    [_infoLabel setHidden:!exp];
    [_acceptCount setHidden:!exp];
    //[_keyinfoLabel setHidden:!exp]; we dont show key for now
    //[_keyLabel setHidden:!exp];
    
    srcLabel.numberOfLines = (exp?0:1);
    dstLabel.numberOfLines = (exp?0:1);
    [srcLabel setLineBreakMode:(exp?NSLineBreakByWordWrapping:NSLineBreakByTruncatingTail)];
    [dstLabel setLineBreakMode:(exp?NSLineBreakByWordWrapping:NSLineBreakByTruncatingTail)];
    
    float h1 = [MsgCell optimalHeightForLabel:srcLabel];
    float h2 = [MsgCell optimalHeightForLabel:dstLabel];
    [srcLabel sizeToFit];
    [dstLabel sizeToFit];
    srcLabel.frame = CGRectMake(4, 0, self.frame.size.width - 4, (exp?h1:25));
    dstLabel.frame = CGRectMake(4, (exp?h1:25), self.frame.size.width - 4, (exp?h2:25));
}


+(float)optimalHeightForLabel:(UILabel*)lable
{
    return [lable.text sizeWithFont:lable.font constrainedToSize:CGSizeMake(lable.frame.size.width, UINTMAX_MAX) lineBreakMode:lable.lineBreakMode].height;
}

/*
 CGSize srcSize = [srcLabel.text sizeWithFont:srcLabel.font constrainedToSize:CGSizeMake(308,FLT_MAX) lineBreakMode:srcLabel.lineBreakMode];
 CGSize dstSize = [dstLabel.text sizeWithFont:dstLabel.font constrainedToSize:CGSizeMake(308,FLT_MAX) lineBreakMode:dstLabel.lineBreakMode];
 
 srcLabel.frame = CGRectMake(5, 0, 308, (exp?srcSize.height:28));
 dstLabel.frame = CGRectMake(5, (exp?srcSize.height:28), 308, (exp?dstSize.height:28));
 keyLabel.frame = CGRectMake(keyLabel.frame.origin.x, srcSize.height+dstSize.height, keyLabel.frame.size.width, keyLabel.frame.size.height);
 keyinfoLabel.frame = CGRectMake(keyinfoLabel.frame.origin.x, srcSize.height+dstSize.height, keyinfoLabel.frame.size.width, keyinfoLabel.frame.size.height);
 acceptCount.frame = CGRectMake(acceptCount.frame.origin.x, srcSize.height+dstSize.height+21, acceptCount.frame.size.width, acceptCount.frame.size.height);
 infoLabel.frame = CGRectMake(infoLabel.frame.origin.x, srcSize.height+dstSize.height+21, infoLabel.frame.size.width, infoLabel.frame.size.height);
 acceptBtn.frame = CGRectMake(acceptBtn.frame.origin.x, srcSize.height+dstSize.height+42, acceptBtn.frame.size.width, acceptBtn.frame.size.height);
 rejectBtn.frame = CGRectMake(rejectBtn.frame.origin.x, srcSize.height+dstSize.height+42, rejectBtn.frame.size.width, rejectBtn.frame.size.height);
 self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 110+srcSize.height+dstSize.height);
 */

/*
- (IBAction)pushAccept:(id)sender
{
    bool success = [_api TWTranslationReviewRequest:_msg.revision]; //accept this translation via API
    if (success)
    {
        [_msg setIsAccepted:YES];
        [_msg setAcceptCount:([_msg acceptCount]+1)];
    }
    // here we'll take this cell away
}

- (IBAction)pushReject:(id)sender
{
    [_msg setIsAccepted:NO];
    [self coreDataRejectMessage];
    
    [self.dataController removeObjectAtIndex:(self.msgIndex)];
  //  
}

-(void)coreDataRejectMessage{
    RejectedMessage *mess = (RejectedMessage *)[NSEntityDescription insertNewObjectForEntityForName:@"RejectedMessage" inManagedObjectContext:managedObjectContext];
    
    [mess setKey:[_msg key]];
    NSNumber* userid=[NSNumber numberWithInteger:[[_api user] userId]];
    [mess setUserid:userid];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        // Handle the error.
    }
    
}
*/
@end
