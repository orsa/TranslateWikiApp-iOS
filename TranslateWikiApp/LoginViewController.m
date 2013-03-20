//
//  LoginViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 31/12/12.
//  Copyright (c) 2012 translatewiki.net. All rights reserved.
//

#import <Security/Security.h>
#import "LoginViewController.h"




@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UILabel *ResultLabel;
- (IBAction)submitLogin:(id)sender;

@end


@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:YES];
    
    _cur_user = [[TWUser alloc] init];
    _api = [[TWapi alloc] initForUser:_cur_user];
    
    //lookup credentials in keychain
    KeychainItemWrapper * loginKC = [[KeychainItemWrapper alloc] initWithIdentifier:@"translatewikiapplogin" accessGroup:nil];
    NSString *nameString  =  [loginKC objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *passwString = [loginKC objectForKey:(__bridge id)kSecValueData];
    
    if(![nameString isEqualToString:@""] && ![passwString isEqualToString:@""])
    { //found credentials
        
        _api.user.userName   =  nameString;
        
        NSString *resultString = [_api TWLoginRequestWithPassword:passwString]; //try login
        if([resultString isEqualToString:@"Success"])
        {
            //then we can skip the login screen
            self.userName = nameString;
            [self performSegueWithIdentifier:@"FromLoginToMessages" sender:self];
        }
        else
        { //login fail, need to re-login and update credentals
            [loginKC resetKeychainItem];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitLogin:(id)sender {
       
    self.userName = self.usernameText.text;
    self.password = self.passwordText.text;
    
    NSString *nameString = self.userName;
    NSString *passwString = self.password;
    _api.user.userName = nameString;

    self.ResultLabel.text = [_api TWLoginRequestWithPassword:passwString]; //login via API
    
    if([ self.ResultLabel.text isEqualToString:@"Success"])
    {
        //store credentials in keychain
        KeychainItemWrapper * loginKC = [[KeychainItemWrapper alloc] initWithIdentifier:@"translatewikiapplogin" accessGroup:nil];
        [loginKC resetKeychainItem];
        [loginKC setObject:nameString forKey:(__bridge id)kSecAttrAccount];
        [loginKC setObject:passwString forKey:(__bridge id)kSecValueData];
        
        [self performSegueWithIdentifier:@"FromLoginToMessages" sender:self]; //logged in - move to next screen
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"FromLoginToMessages"])
    {
        MainViewController *vc = [segue destinationViewController];
        
        //[vc setUserName:_userName];
        //[vc setLoggedUser:[[TWUser alloc] initWithUsreName:_userName]];
        //[[vc loggedUser] setUserId:(_userId)];
        [vc setApi:_api];
    }
}

@end
