//
//  MainViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 8/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TranslationMessageDataController;
@class TWUser;

@interface MainViewController : UIViewController<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PushMessages;
@property (nonatomic, retain) TranslationMessageDataController * dataController;
@property  (retain, nonatomic) NSString *loggedUserName;
@property  (retain, nonatomic) TWUser* loggedUser;

-(void)setUserName:(NSString *)userName;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
