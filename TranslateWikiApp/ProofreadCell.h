//
//  MsgCell.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 27/3/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TWapi.h"
#import "TranslationMessage.h"
#import "RejectedMessage.h"

@interface ProofreadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel  *srcLabel;    // label of message source
@property (weak, nonatomic) IBOutlet UILabel  *dstLabel;    // label of message destination (translation)
@property (weak, nonatomic) IBOutlet UILabel  *acceptCount; // label of accept count
@property (weak, nonatomic) IBOutlet UILabel  *keyLabel;    // label of the key - not currently used
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;   // button for accept action
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;   // button for reject action
@property (strong, nonatomic) IBOutlet UIButton *editBtn;   // button for edit action (pen)
@property (weak, nonatomic) IBOutlet UIImageView *editContainer;// container for accept and reject buttons
@property (strong, nonatomic) IBOutlet UIImageView *cellFrame;  // container for all the cell
@property (retain, nonatomic) TWapi * api;             // api object for api requests
@property(nonatomic, retain) TranslationMessage * msg; // the translation message object containing all the information about the message
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext; // object for core data operations

- (void)setExpanded:(NSNumber*)expNumber; // expanding and de-expanding the cell

+(float)optimalHeightForLabel:(UILabel*)lable; // giving the optimal height for the label in regard with this cell

@end
