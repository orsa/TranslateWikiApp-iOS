//
//  MsgCell.h
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
