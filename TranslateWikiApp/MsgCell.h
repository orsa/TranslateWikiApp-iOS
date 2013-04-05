//
//  MsgCell.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 27/3/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TWapi.h"
#import "TranslationMessage.h"
#import "RejectedMessage.h"

@interface MsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *srcLabel;
@property (weak, nonatomic) IBOutlet UILabel *dstLabel;
@property (weak, nonatomic) IBOutlet UILabel *acceptCount;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyinfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (retain, nonatomic) TWapi * api;
@property(nonatomic, retain)TranslationMessage * msg;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)setExpanded:(NSNumber*)expNumber;
+(float)optimalHeightForLabel:(UILabel*)lable;

@end
