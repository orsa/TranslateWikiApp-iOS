//
//  PrefsViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 20/3/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TranslationMessageDataController;
@class TWapi;

@interface PrefsViewController : UITableViewController
<UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UIPickerView *pickerView;
    IBOutlet UITextField *langTextField;
    IBOutlet UITextField *projTextField;
    NSArray *arrLang;
    NSArray *arrProj;
}

@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UITextField *langTextField;
@property (nonatomic, retain) IBOutlet UITextField *projTextField;
@property (nonatomic, retain) TWapi *api;

- (IBAction)pushDone:(id)sender;
-(NSString*)getNewLang;
-(NSString*)getNewProj;


@end
