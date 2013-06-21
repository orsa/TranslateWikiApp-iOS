//
//  prefsCustomCell.m
//  TranslateWikiApp
//
//  Created by Tomer Tuchner on 6/21/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "prefsCustomCell.h"

@implementation prefsCustomCell

-(void)awakeFromNib{
    [super awakeFromNib];
    for(NSLayoutConstraint *cellConstraint in self.constraints){
        [self removeConstraint:cellConstraint];
        id firstItem = cellConstraint.firstItem == self ? self.contentView : cellConstraint.firstItem;
        id seccondItem = cellConstraint.secondItem == self ? self.contentView : cellConstraint.secondItem;
        NSLayoutConstraint* contentViewConstraint =
        [NSLayoutConstraint constraintWithItem:firstItem
                                     attribute:cellConstraint.firstAttribute
                                     relatedBy:cellConstraint.relation
                                        toItem:seccondItem
                                     attribute:cellConstraint.secondAttribute
                                    multiplier:cellConstraint.multiplier
                                      constant:cellConstraint.constant];
        [self.contentView addConstraint:contentViewConstraint];
    }
}

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

@end
