//
//  MenuView.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 26/4/13.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "PrefsViewController.h"
#import "constants.h"

@class MainViewController;
@class PrefsViewController;
@interface MenuView : UIView <UITableViewDelegate, UITableViewDataSource>{
    
}

@property (retain, nonatomic) MainViewController *mainVC;

@end
