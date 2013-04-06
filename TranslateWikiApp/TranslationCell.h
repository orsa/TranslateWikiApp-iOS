//
//  TranslationCell.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 6/4/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputPaneView.h"

@interface TranslationCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet InputPaneView *inputTable;
@property (strong, nonatomic) IBOutlet NSMutableArray *suggestionsData;
@property (strong, nonatomic) IBOutlet UILabel *srcLabel;


@end
