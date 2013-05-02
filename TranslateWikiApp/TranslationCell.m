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


- (void)setExpanded:(NSNumber*)expNumber
{
    BOOL exp=[expNumber boolValue];
    _isExpanded=exp;
    srcLabel.numberOfLines = (exp?0:1);
    
    [srcLabel setLineBreakMode:(exp?NSLineBreakByWordWrapping:NSLineBreakByTruncatingTail)];

    float sourceH = max([TranslationCell optimalHeightForLabel:srcLabel], 50);
    if(!exp)
        sourceH=50;
    [srcLabel sizeToFit];
    
    frameImg.transform = CGAffineTransformIdentity;
    inputTable.transform = CGAffineTransformIdentity;
    
    srcLabel.frame = CGRectMake(4, 0, self.frame.size.width, sourceH);
    
    [inputTable sizeToFit];
    [frameImg sizeToFit];
    
    //setting the origin
    frameImg.frame = CGRectMake(frameImg.frame.origin.x,
                                sourceH,
                                frameImg.frame.size.width,
                                frameImg.frame.size.height);
    inputTable.frame = CGRectMake(inputTable.frame.origin.x,
                                  sourceH + 13 ,
                                  inputTable.frame.size.width,
                                  inputTable.frame.size.height);
    
    //setting frames of inside cells and calculating table height
    
    float tableHeight=50;//height of textView
    float cellOrigin=0;//origin of cell, relative to origin of table
    int i=0;
    for(id obj in _suggestionCells){
        UITableViewCell* cell=(UITableViewCell*)obj;
        UILabel* label=[cell textLabel];
        label.numberOfLines=(exp?0:1);
        [label setLineBreakMode:(exp?NSLineBreakByCharWrapping:NSLineBreakByTruncatingTail)];
        
        float cellHeight=(exp?[self getSizeOfSuggestionNumber:i]:50);
        tableHeight+=cellHeight;
        cell.frame = CGRectMake(cell.frame.origin.x,
                                cellOrigin,
                                cell.frame.size.width,
                                cellHeight);
        cellOrigin+=cellHeight;
        i+=1;
    }
    inputCell.frame = CGRectMake(inputCell.frame.origin.x,
                                 cellOrigin,
                                 inputCell.frame.size.width,
                                 50);
    
    //setting height
    frameImg.frame = CGRectMake(frameImg.frame.origin.x,
                                frameImg.frame.origin.y,
                                frameImg.frame.size.width,
                                tableHeight+16);
    inputTable.frame = CGRectMake(inputTable.frame.origin.x,
                                  inputTable.frame.origin.y ,
                                  inputTable.frame.size.width,
                                  tableHeight);
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
        _suggestionCells=[[NSMutableSet alloc] init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _isExpanded=FALSE;
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
    [_container removeObjectAtIndex:[_container indexOfObject:msg]];
    [self clearTextBox];
    [_msgTableView reloadData];
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
