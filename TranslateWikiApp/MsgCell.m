//
//  MsgCell.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 27/3/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "MsgCell.h"

@implementation MsgCell
@synthesize managedObjectContext;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.acceptBtn.hidden = TRUE;
        self.rejectBtn.hidden = TRUE;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setExpanded:(BOOL)exp
{
    [_acceptBtn setHidden:!exp];
    [_rejectBtn setHidden:!exp];
    [_infoLabel setHidden:!exp];
    [_acceptCount setHidden:!exp];
    [_srcLabel sizeToFit];
    [_dstLabel sizeToFit];
}

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
