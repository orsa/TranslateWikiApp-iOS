//
//  AboutViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 22/8/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1){
        NSString * goToUrl = [[tableView cellForRowAtIndexPath:indexPath] detailTextLabel].text;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:goToUrl]];
    }
    
}


@end
