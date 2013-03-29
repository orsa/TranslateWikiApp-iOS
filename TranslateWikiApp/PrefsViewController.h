//
//  PrefsViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 20/3/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class TranslationMessageDataController;
@class TWapi;

@interface PrefsViewController : UITableViewController
<UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UIPickerView *pickerView;
    IBOutlet UITextField *langTextField;
    IBOutlet UITextField *projTextField;
    IBOutlet UISwitch *proofreadOnlySwitch;
    NSArray *arrLang;
    NSArray *arrProj;
    NSArray *arrLangCodes;
    NSString *selectedProjCode;
    NSString *selectedLangCode;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UITextField *langTextField;
@property (nonatomic, retain) IBOutlet UISwitch *proofreadOnlySwitch;
@property (nonatomic, retain) IBOutlet UITextField *projTextField;
@property (nonatomic, retain) TWapi *api;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)pushDone:(id)sender;
- (IBAction)touchSwitch:(id)sender;
-(void)backgroundTap:(UITapGestureRecognizer *)tapGR;
-(NSString*)getNewLang;
-(NSString*)getNewProj;


@end
