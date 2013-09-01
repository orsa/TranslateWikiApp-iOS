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

@property (strong, nonatomic) IBOutlet UILabel *srcLabel;       // label of message source
@property (weak, nonatomic) IBOutlet UITableView *inputTable;   // the table holding suggestions and text view
@property (weak, nonatomic) IBOutlet UIImageView *frameImg;     // the image that contains the suggestions and text view
@property (retain, nonatomic) TranslationMessage * msg;         // the message object containg all the information about the message
@property (retain, nonatomic) TWapi* api;                       // api object for api requests
@property (retain, nonatomic) TranslationMessageDataController * container; // the data container in which the message is included 
@property (retain, nonatomic) UITableView* msgTableView; // the general table view in which the cell is included
@property (retain, nonatomic) InputCell* inputCell;      // the cell that contains the text view
@property (atomic) BOOL isExpanded;         // is the cell expanded (selected or not)
@property (atomic) BOOL isMinimized;        // is the cell minimized
@property (atomic) BOOL translationState;   // are we on translation session
@property (retain, nonatomic)NSMutableSet* suggestionCells;     // container for the cells of the suggestions
@property (strong, nonatomic) IBOutlet UIButton *infoBtn;       // button for documentation info
@property (strong, nonatomic) IBOutlet UIView *infoView;        // the documentation info view
@property (weak, nonatomic) IBOutlet UIWebView *docWebView;     // the web view in which the documentation is displayed
@property (nonatomic) UITableViewCellSelectionStyle originalSelectionStyle; // the original selection style, for restoring it after disabling interactions
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn; // trash button

- (IBAction)pushInfo:(id)sender;            // tap info button
- (IBAction)pushDelete:(id)sender;          // tap trash button
- (void)buildWithMsg:(NSArray *)obj;        // build the cell
- (void)displayHTML:(NSString*)html;        // display the html documentation in web view
- (void)setMinimized:(NSNumber*)minNumber;  // set the cell minimized, getting bool as a number
- (void)removeFromList;                     // remove the cell from table
- (void)scrollTo;                           // scroll the screen to this cell's start
- (void)clearTextBox;                       // clear the text view, and get "Your translation" back there

@end



