//
//  MessagesViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 7/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "KeychainItemWrapper.h"
#import "MessagesViewController.h"
#import "TWapi.h"

@interface MessagesViewController ()
- (IBAction)LogoutButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *GreetingMessage;

@end

@implementation MessagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.GreetingMessage.text = [NSString stringWithFormat:@"Hello, %@!",self.loggedUserName];
    
    NSDictionary *result = [TWapi TWMessagesListRequestForLanguage:@"es" Project:@"core" Limitfor:10 ByUserId:@"10323"];
    
    NSLog(@"%@",result);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogoutButton:(id)sender {
    [TWapi TWLogoutRequest];
    KeychainItemWrapper * loginKC = [[KeychainItemWrapper alloc] initWithIdentifier:@"translatewikiapplogin" accessGroup:nil];
    [loginKC resetKeychainItem];
}

-(void)setUserName:(NSString *)userName{
    self.loggedUserName = userName;
}

@end
