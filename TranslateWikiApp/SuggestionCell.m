//
//  SuggestionCell.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 2/5/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "SuggestionCell.h"

@implementation SuggestionCell
@synthesize expanded;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        expanded = FALSE;
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UILabel* label=[self textLabel];
    return (expanded? label.frame.size.height+12 : 50);
}

@end
