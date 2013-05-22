//
//  TranslationCell.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 6/4/13.
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

#import "TranslationCell.h"
#import "InputCell.h"

@implementation TranslationCell


@synthesize srcLabel;
@synthesize frameImg;
@synthesize msg;
@synthesize inputTable;
@synthesize inputCell;
@synthesize isMinimized;

- (void)setExpanded:(NSNumber*)expNumber
{
    BOOL exp=[expNumber boolValue];
    _isExpanded=exp;
    srcLabel.numberOfLines = (exp?0:1);
    [srcLabel setLineBreakMode:(exp?NSLineBreakByWordWrapping:NSLineBreakByTruncatingTail)];

    float sourceH = (exp? max([TranslationCell optimalHeightForLabel:srcLabel]+1, 40): 40);
    [srcLabel sizeToFit];
    
    frameImg.transform = CGAffineTransformIdentity;
    inputTable.transform = CGAffineTransformIdentity;
    
    srcLabel.frame = CGRectMake(2, 0, self.frame.size.width-4, sourceH);
    [inputTable sizeToFit];
    [frameImg sizeToFit];
    
    //setting frames of inside cells and calculating table height
    float cellOrigin=0;//origin of cell, relative to origin of table
    float cellHeight=0;
    int i=0;
    UITableViewCell* cell;
    UILabel* label;
    for(id obj in _suggestionCells){
        cell=(UITableViewCell*)obj;
        label=[cell textLabel];
        label.numberOfLines=(exp?0:1);
        [label setLineBreakMode:(exp?NSLineBreakByCharWrapping:NSLineBreakByTruncatingTail)];
        
        cellHeight=(exp ? [self getSizeOfSuggestionNumber:i]:50);
        
        cellOrigin+=cellHeight;
        i+=1;
    }
    
    float tableHeight = cellOrigin + 62; //the "+62" is for the header and the input cell
    
    //setting the origin & height
    
    //[UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{ [frameImg setFrame:CGRectMake(1,sourceH,self.frame.size.width - 2,tableHeight+15)]; } completion:nil];
    
    //[UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{ [inputTable setFrame:CGRectMake(frameImg.frame.origin.x+ 0.025* frameImg.frame.size.width,sourceH+14,0.95* frameImg.frame.size.width,tableHeight)]; } completion:nil];
    
    frameImg.frame = CGRectMake(1,
                                sourceH,
                                self.frame.size.width - 2,
                                tableHeight*1.2);
    
    
    inputTable.frame = CGRectMake(frameImg.frame.origin.x + 0.025*frameImg.frame.size.width,
                                  sourceH + frameImg.frame.size.height*0.1 ,
                                  0.95*frameImg.frame.size.width,
                                  tableHeight);
    
}

- (void)setMinimized:(NSNumber*)minNumber{
    
    BOOL previousMinimized=isMinimized;
    
    isMinimized = [minNumber boolValue];
    
    msg.minimized=isMinimized;
    
    if(previousMinimized==isMinimized)
        return;
    
    [frameImg setHidden:isMinimized];
    [inputTable setHidden:isMinimized];
    [_minimizeButton setHidden:isMinimized];
    if(isMinimized){//change to minimized
        [srcLabel performSelectorOnMainThread:@selector(setText:) withObject:msg.translationByUser waitUntilDone:NO];
        [srcLabel setTextColor:[UIColor lightGrayColor]];
    }
    else//back to unminimized
    {
        [srcLabel performSelectorOnMainThread:@selector(setText:) withObject:msg.source waitUntilDone:NO];
        [srcLabel setTextColor:[UIColor blackColor]];
        [inputCell textViewDidChange:inputCell.inputText];
    }
}

- (IBAction)pushMinimized:(id)sender {
    [self setMinimized:[NSNumber numberWithBool:TRUE]];
    [self.msgTableView reloadData];
}

+(float)optimalHeightForLabel:(UILabel*)lable
{
    return [lable.text sizeWithFont:lable.font constrainedToSize:CGSizeMake(lable.frame.size.width, UINTMAX_MAX) lineBreakMode:lable.lineBreakMode].height;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _isExpanded=FALSE;
        isMinimized=FALSE;
        _suggestionCells=[[NSMutableSet alloc] init];
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _isExpanded=FALSE;
        isMinimized=FALSE;
        _suggestionCells=[[NSMutableSet alloc] init];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)removeFromList
{
    int index = [_container indexOfObject:msg];
    [self removeFromSuperview];
    UITableView* table = (UITableView*)self.superview;
    [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [_container removeObjectAtIndex:index];
    [self clearTextBox];
    [_msgTableView reloadData];
}

-(void)scrollTo
{
    int index = [_container indexOfObject:msg];
    UITableView* table = (UITableView*)self.superview;
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)clearTextBox
{
    [inputCell.inputText setText:@"Your translation"];
    [inputCell.inputText setTextColor:[UIColor lightGrayColor]];
    [inputCell.sendBtn setUserInteractionEnabled:NO];
}

#pragma mark inputTable
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return msg.suggestions.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *suggestCellIdentifier = @"suggestionsCell";
    static NSString *inputCellIdentifier = @"inputCell";
    UITableViewCell * cell;
    if (indexPath.row < [tableView numberOfRowsInSection:0]-1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:suggestCellIdentifier forIndexPath:indexPath];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:suggestCellIdentifier];
        }
        cell.textLabel.text = msg.suggestions[indexPath.row][@"suggestion"];
        //[_suggestionLabels addObject:cell.textLabel];
        [_suggestionCells addObject:cell];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:inputCellIdentifier forIndexPath:indexPath];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inputCellIdentifier];
        }
        InputCell* inCell=(InputCell*)cell;
        inCell.api=_api;
        inCell.msg=msg;
        inCell.inputText.text = msg.userInput;
        if (!msg.userInput || [msg.userInput isEqualToString:@""])
        {
            [inCell.inputText setTextColor:[UIColor grayColor]];
            inCell.inputText.text = @"Your translation";
        }
        else
        {
            [inCell.inputText setTextColor:[UIColor blackColor]];
            inCell.inputText.text = msg.userInput;
        }
        inCell.father=self;
        self.inputCell=inCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<msg.suggestions.count)
    {
        [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
        NSIndexPath * lastIP = [NSIndexPath indexPathForRow:msg.suggestions.count inSection:0];
        InputCell * inCell = (InputCell*)[tableView cellForRowAtIndexPath:lastIP];
        
        [tableView beginUpdates];
        
        [inCell.inputText becomeFirstResponder];
        inCell.inputText.text = msg.suggestions[indexPath.row][@"suggestion"];
        [inCell textViewDidChange:inCell.inputText];
        
        [tableView endUpdates];
        
        //[inCell pushSendBtn:self];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL isValid=indexPath.row<(msg.suggestions.count+1);
    if(!isValid)
        return 50;
    if(indexPath.row<msg.suggestions.count){
        if(!_isExpanded)
            return 50;//unexpanded suggestion cell
        float ret=[self getSizeOfSuggestionNumber:indexPath.row];
        return ret;
    }
    else
        return 50;//textView height, expanded and unexpanded
}

//this method defines the header of the input table
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView;
    if (msg.suggestions.count==0)
    {
        customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,0)];
        return customView;
    }
    
    customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,12)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.826782 green:0.840739 blue:1 alpha:1];//or
    headerLabel.textColor = [UIColor colorWithRed:0.333333 green:0.333333 blue:0.333333 alpha:1];
    headerLabel.font = [UIFont boldSystemFontOfSize:9];
    headerLabel.frame = CGRectMake(0,0,customView.frame.size.width,12);
    headerLabel.text =  (msg.suggestions.count==1 ? @"suggestion" : @"suggestions");

    [customView addSubview:headerLabel];

    return customView;
}

/*-(CGFloat)tableHeight{
    float height=50;//height of textView
    for(int i=0; i<msg.suggestions.count; i++){
        height+=[self getSizeOfSuggestionNumber:i];
    }
    return height;
}*/

-(CGFloat)getSizeOfSuggestionNumber:(NSInteger)i{
    return max([msg.suggestions[i][@"suggestion"] sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(inputTable.frame.size.width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height+12, 50);
}

@end
