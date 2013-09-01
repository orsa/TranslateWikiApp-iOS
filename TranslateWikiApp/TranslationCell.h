//
//  TranslationCell.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 6/4/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <UIKit/UIKit.h>
#import "TranslationMessage.h"
#import "TWapi.h"
#import "TranslationMessageDataController.h"

@class InputCell;

@interface TranslationCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *srcLabel;
@property (weak, nonatomic) IBOutlet UITableView *inputTable;
@property (weak, nonatomic) IBOutlet UIImageView *frameImg;
@property (nonatomic, retain) TranslationMessage * msg;
@property (retain, nonatomic) TWapi* api;
@property (retain, nonatomic) TranslationMessageDataController * container;
@property (retain, nonatomic) UITableView* msgTableView;
@property (retain, nonatomic) InputCell* inputCell;
@property (atomic) BOOL isExpanded;
@property (atomic) BOOL isMinimized;
@property (atomic) BOOL translationState;
@property (retain, nonatomic)NSMutableSet* suggestionCells;
@property (strong, nonatomic) IBOutlet UIButton *infoBtn;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIWebView *docWebView;
@property (nonatomic) UITableViewCellSelectionStyle originalSelectionStyle;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

- (IBAction)pushInfo:(id)sender;
- (IBAction)pushDelete:(id)sender;
- (void)buildWithMsg:(NSArray *)obj;
- (void)displayHTML:(NSString*)html;
- (void)setMinimized:(NSNumber*)minNumber;
- (void)removeFromList;
- (void)scrollTo;
- (void)clearTextBox;

@end



