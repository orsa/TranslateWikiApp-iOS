//
//  TranslationCell.m
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
//*********************************************************************************
// TranslationCell - manages a displayed cell in a translate session for a
// specific message
//*********************************************************************************

#import "TranslationCell.h"
#import "InputCell.h"

@implementation TranslationCell

@synthesize srcLabel, frameImg, inputTable, inputCell, infoView, infoBtn, deleteBtn, suggestionCells, msg,  docWebView, isExpanded, isMinimized, translationState, originalSelectionStyle, msgTableView, container;


//*********************************************************************************
// Builds the necessary UI for a translation cell
// Input : array obj s.t:
//      obj[0] is a pointer to the linked message.
//      obj[1] NSNumber represents whether the cell should be expanded
// 
//*********************************************************************************
- (void)buildWithMsg:(NSArray *)obj
{
    msg = obj[0];
    isExpanded = [obj[1] boolValue];
    isMinimized = msg.minimized;
    
    //setup src label
    srcLabel.numberOfLines = (isExpanded?0:1);
    [srcLabel setLineBreakMode:(isExpanded?NSLineBreakByWordWrapping:NSLineBreakByTruncatingTail)];
    
    float sourceH = (isExpanded? [msg getExpandedHeightOfSourceUnderWidth:self.frame.size.width]: [msg getUnexpandedHeightOfSuggestion]);
    [srcLabel sizeToFit];
    
    srcLabel.frame = CGRectMake(2, 0, self.frame.size.width-20, sourceH);
    [inputTable sizeToFit];
    [frameImg sizeToFit];
    
    //setting frames of inside cells and calculating table height
    float cellOrigin=0;//origin of cell, relative to origin of table
    float cellHeight=0;
    int i=0;
    UITableViewCell* cell;
    UILabel* label;
    for(id obj in suggestionCells){
        cell=(UITableViewCell*)obj;
        label=[cell textLabel];
        label.numberOfLines=(isExpanded?0:1);
        [label setLineBreakMode:(isExpanded?NSLineBreakByWordWrapping:NSLineBreakByTruncatingTail)];
        
        cellHeight=(isExpanded ? [msg getExpandedHeightOfSuggestionNumber:i underWidth:self.frame.size.width]:[msg getUnexpandedHeightOfSuggestion]);
        
        cellOrigin+=cellHeight;
        i+=1;
    }
    
    float tableHeight = cellOrigin + 62; //the "+62" is for the header and the input cell
    
    frameImg.frame = CGRectMake(1,
                                sourceH,
                                self.frame.size.width - 2,
                                tableHeight*1.2);
    
    
    inputTable.frame = CGRectMake(frameImg.frame.origin.x + 0.025*frameImg.frame.size.width,
                                  sourceH + frameImg.frame.size.height*0.1 ,
                                  0.95*frameImg.frame.size.width,
                                  tableHeight);
    
    //setup gesture recognizers for the "swipe for info" feature
    UISwipeGestureRecognizer* gestureR;
    gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector (pushInfo:)];
    gestureR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:gestureR];
    
    gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pushInfo:)];
    gestureR.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:gestureR];
    
    BOOL hideInfo = !msg.infoState;
    [infoView setHidden:hideInfo];
    
    [[self inputTable] setUserInteractionEnabled:hideInfo];
    [[self inputView] setUserInteractionEnabled:hideInfo];
    
    if(hideInfo)
    {
        [self setSelectionStyle:originalSelectionStyle];
    }
    else
    {
        //disabling interactions
        originalSelectionStyle=[self selectionStyle];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //setting view
        [infoView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [[docWebView scrollView] setBounces:NO];
        [self bringSubviewToFront:infoView];
    }
    
    [self bringSubviewToFront:infoBtn];
    
    UIImage *buttonImage = [UIImage imageNamed:(translationState? @"trash_new.png" : @"cancel_edit.png")];
    [deleteBtn setImage:buttonImage forState:UIControlStateNormal];
}

-(void)displayHTML:(NSString*)html
{
    [docWebView loadHTMLString:html baseURL:nil];
}

- (IBAction)pushInfo:(id)sender {
    if([infoBtn isHidden])
        return;
    if([infoView isHidden])
    {
        msg.infoState = YES;

        //disabling interactions
        originalSelectionStyle=[self selectionStyle];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [[self inputTable] setUserInteractionEnabled:NO];
        [[self inputView] setUserInteractionEnabled:NO];
        
        //setting view
        [self performSelectorOnMainThread:@selector(displayHTML:) withObject:msg.documentation waitUntilDone:NO];
        [infoView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [infoView setHidden:NO];
        [docWebView setFrame:CGRectMake(docWebView.frame.origin.x, docWebView.frame.origin.y, docWebView.frame.size.width, self.frame.size.height-21-10-12)];//(10,21) are the origin and height of the first label - "Documentation:"
        [[docWebView scrollView] setBounces:NO];
        [UIView transitionWithView:self
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                        }
                        completion:^(BOOL comp){ [self bringSubviewToFront:infoBtn];} ];
    }
    else{
        msg.infoState = NO;
        
        //enabling interactions
        [self setSelectionStyle:originalSelectionStyle];
        [[self inputTable] setUserInteractionEnabled:YES];
        [[self inputView] setUserInteractionEnabled:YES];
        
        //setting view
        [infoView setHidden:YES];
        [UIView transitionWithView:self
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                        }
                        completion:nil];
    }
}

- (IBAction)pushDelete:(id)sender {
    if (translationState)
    {
        [self removeFromList];
    }else{ // we just cancelling an edit
        [msg setPrState:YES];
        [msgTableView reloadData];
    }
    
}

- (void)setMinimized:(NSNumber*)minNumber
{
    isMinimized = [minNumber boolValue];
    
    msg.minimized=isMinimized;
    
    [frameImg setHidden:isMinimized];
    [inputTable setHidden:isMinimized];
    [[self infoBtn] setHidden:(isMinimized || msg.noDocumentation)];
    [[self deleteBtn] setHidden:isMinimized];
    if(isMinimized){//change to minimized
        [srcLabel performSelectorOnMainThread:@selector(setText:) withObject:msg.translationByUser waitUntilDone:NO];
        [srcLabel setTextColor:[UIColor lightGrayColor]];
    }
    else//back to unminimized
    {
        [srcLabel performSelectorOnMainThread:@selector(setText:) withObject:msg.source waitUntilDone:NO];
        [srcLabel setTextColor:[UIColor blackColor]];
        [inputCell textViewDidChange:inputCell.inputText];
        [inputCell.inputText  becomeFirstResponder];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        isExpanded=FALSE;
        isMinimized=FALSE;
        suggestionCells=[[NSMutableSet alloc] init];
        [[docWebView scrollView] setBounces:NO];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        isExpanded=FALSE;
        isMinimized=FALSE;
        suggestionCells=[[NSMutableSet alloc] init];
        [[docWebView scrollView] setBounces:NO];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)removeFromList
{
    int index = [container indexOfObject:msg];
    [self removeFromSuperview];
    UITableView* table = (UITableView*)self.superview;
    [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [container removeObjectAtIndex:index];
    [self clearTextBox];
    [msgTableView reloadData];
}

-(void)scrollTo
{
    int index = [container indexOfObject:msg];
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
        cell = [tableView dequeueReusableCellWithIdentifier:suggestCellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:suggestCellIdentifier];
        }
        cell.textLabel.text = msg.suggestions[indexPath.row][@"suggestion"];
        //[_suggestionLabels addObject:cell.textLabel];
        [suggestionCells addObject:cell];
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
            [inCell.sendBtn setUserInteractionEnabled:NO];
            [inCell.inputText setTextColor:[UIColor grayColor]];
            inCell.inputText.text = @"Your translation";
        }
        else
        {
            [inCell.sendBtn setUserInteractionEnabled:YES];
            [inCell.inputText setTextColor:[UIColor blackColor]];
            inCell.inputText.text = msg.userInput;
        }
        inCell.father=self;
        //self.inputCell=inCell;  what is that for??? it made me some troubles [Or]
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
        
        [inCell.inputText becomeFirstResponder];//because pushSendBtn will resign it
        inCell.inputText.text = msg.suggestions[indexPath.row][@"suggestion"];
        [inCell textViewDidChange:inCell.inputText];
        
        [tableView endUpdates];
        
        [inCell pushSendBtn:self];  //automatic send the suggestion
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL isValid=indexPath.row<(msg.suggestions.count+1);
    if(!isValid)
        return 50;
    if(indexPath.row<msg.suggestions.count){
        if(!isExpanded)
            return [msg getUnexpandedHeightOfSuggestion];//unexpanded suggestion cell
        float ret=[msg getExpandedHeightOfSuggestionNumber:indexPath.row underWidth:self.frame.size.width];
        return ret;
    }
    else
        return 50;//textView height, expanded and unexpanded
}
@end
