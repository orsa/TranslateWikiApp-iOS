//
//  MainViewController.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 8/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITableViewDataSource>
{
    NSMutableArray * tableData;
    int numOf10Tuples;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PushMessages;
@property (nonatomic, retain) NSMutableArray * tableData;
@property (assign) int numOf10Tuples;
@property  (retain, nonatomic) NSString *loggedUserName;

-(void)setUserName:(NSString *)userName;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
