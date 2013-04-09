//
//  TranslationCell.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 6/4/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "TranslationCell.h"
#import "InputCell.h"

@implementation TranslationCell

@synthesize suggestionsData;
@synthesize srcLabel;
@synthesize frameImg;


- (void)setExpanded:(NSNumber*)expNumber
{
    BOOL exp=[expNumber boolValue];
    srcLabel.numberOfLines = (exp?0:1);

    [srcLabel setLineBreakMode:(exp?NSLineBreakByWordWrapping:NSLineBreakByTruncatingTail)];

    float h = [TranslationCell optimalHeightForLabel:srcLabel];
    [srcLabel sizeToFit];
    
    srcLabel.frame = CGRectMake(4, 0, self.frame.size.width - 4, (exp?h:28));
    frameImg.frame = CGRectMake(4, (exp?h+2:25), self.frame.size.width - 4, (exp?self.frame.size.height-h-10:25));
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
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return suggestionsData.count + 1;
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
        cell.textLabel.text = suggestionsData[indexPath.row];
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
        inCell.msg=_msg;
        inCell.father=self;
        self.inputCell=inCell;
    }
    
    return cell;
}

-(void)setActiveTextViewPointer:(UITextView *)newActive
{
    *_activeTextViewPtr=newActive;
}

-(void)removeFromList
{
    [_container removeObjectAtIndex:[_container indexOfObject:_msg]];
    
    [_msgTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<suggestionsData.count)
    {
        [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
        NSIndexPath * lastIP = [NSIndexPath indexPathForRow:suggestionsData.count inSection:0];
        InputCell * inCell = (InputCell*)[tableView cellForRowAtIndexPath:lastIP];
        [tableView beginUpdates];
        
     
        [inCell.inputText becomeFirstResponder];
        inCell.inputText.text = suggestionsData[indexPath.row];
        [inCell textViewDidChange:inCell.inputText];
        
        [tableView endUpdates];
        
    }
    
}


@end
