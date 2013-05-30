//
//  PrefsViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 20/3/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "constants.h"
#import "MainViewController.h"
#import "TranslationMessageDataController.h"
#import "TWapi.h"
#import "ProjectBrowserViewController.h"
#import "LanguagePickerViewController.h"

@class TranslationMessageDataController;
@class TWapi;

@interface PrefsViewController : UITableViewController
//<UIPickerViewDataSource, UIPickerViewDelegate>
{
    //IBOutlet UIPickerView *pickerView;
    IBOutlet UILabel *langLabel;
    IBOutlet UILabel *projLabel;

    NSArray *arrLang;
    NSArray *arrProj;
    NSArray *arrLangCodes;
    NSString *selectedProjCode;
    NSString *selectedLangCode;
}


@property (weak, nonatomic) IBOutlet UITextField *tupleSizeTextView;
@property (nonatomic, retain) IBOutlet UILabel *langLabel;
@property (nonatomic, retain) IBOutlet UILabel *projLabel;
@property (nonatomic, retain) TWapi *api;
@property (nonatomic, retain) NSString *selectedProjCode;
@property BOOL didChange;
@property (weak, nonatomic) IBOutlet UITextField *maxMsgLengthTextField;

-(void)backgroundTap:(UITapGestureRecognizer *)tapGR;
-(NSString*)getNewLang;
-(NSString*)getNewProj;

@end
