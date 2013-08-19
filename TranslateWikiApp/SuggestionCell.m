//
//  SuggestionCell.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 2/5/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//
//*********************************************************************************
// SuggestionCell is a customized UITableViewCell which has a property of
// knowing whether it should be displayed in "expanded mode or not.
//*********************************************************************************

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


@end
