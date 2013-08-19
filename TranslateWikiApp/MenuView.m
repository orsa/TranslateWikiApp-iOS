//
//  MenuView.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 26/4/13.
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
//*********************************************************************************
// MenuView handles the popup menu which is showed on tapping the top-left corner
// of the main view. it is implemented as UITableView delegate and data-source.
//*********************************************************************************

#import "MenuView.h"

@interface MenuView ()

@end

@implementation MenuView
@synthesize mainVC;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Translate";
            if (mainVC.translationState)
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            else
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            break;
        case 1:
            cell.textLabel.text = @"Proofread";
            if (mainVC.translationState)
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            else
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            break;
        case 2:
            cell.textLabel.text = @"Settings";
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            break;
        default: return nil;
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    switch (indexPath.row) {
        case 0: //click on "translte"
            if (!mainVC.translationState)
            {
                mainVC.translationState=YES;
                LoadUserDefaults();
                setBoolUserDefaultskey(NO, PRMODE_key);
                [mainVC clearMessages:self];
                [mainVC.menuBtn setTitle:@"Translate ▾" forState:UIControlStateNormal];
                [mainVC addMessagesTuple];
                
                [tableView reloadData];
            }
            break;
        case 1: //click on "proofread"
            if (mainVC.translationState)
            {
                mainVC.translationState=NO;
                LoadUserDefaults();
                setBoolUserDefaultskey(YES, PRMODE_key);
                [mainVC clearTextBoxes];
                [mainVC clearMessages:self];
                [mainVC.menuBtn setTitle:@"Proofread ▾" forState:UIControlStateNormal];
                [mainVC addMessagesTuple];
                
                [tableView reloadData];
            }
            
            break;
        case 2:
            [mainVC pushPrefs:self];
            break;
        
        default:
            break;
    }
    [UIView animateWithDuration:0.23f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{ [self setFrame:CGRectMake(0, 31, 90, 0)]; } completion:^(BOOL comp){
        if (comp) [self setHidden:YES];
    }];
}

@end
