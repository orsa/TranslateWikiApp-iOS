//
//  TranslationCell.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 6/4/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputCell.h"

@interface TranslationCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet NSMutableArray *suggestionsData;
@property (strong, nonatomic) IBOutlet UILabel *srcLabel;
@property (weak, nonatomic) IBOutlet UITableView *inputTable;
@property (weak, nonatomic) IBOutlet UIImageView *frameImg;




- (void)setExpanded:(NSNumber*)expNumber;


@end
