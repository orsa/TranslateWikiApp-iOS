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
    NSArray * tableData;
    
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PushMessages;
@property (nonatomic, retain) NSArray * tableData;
@property  (retain, nonatomic) NSString *loggedUserName;

-(void)setUserName:(NSString *)userName;

@end
