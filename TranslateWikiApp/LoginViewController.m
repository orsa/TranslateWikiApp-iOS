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

@class AppDelegate;

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
        
        _api.user.userName  =  nameString;
        
        NSString *resultString = [_api TWLoginRequestWithPassword:passwString]; //try login
        if([resultString isEqualToString:@"Success"])
        {
            //then we can skip the login screen
            _userName = nameString;
            [self performSegueWithIdentifier:@"FromLoginToMessages" sender:self];
        }
        else
        { //login fail, need to re-login and update credentals
            [loginKC resetKeychainItem];
        }
    }
    else if([[NSUserDefaults standardUserDefaults] objectForKey:@"recentLoginUserName"]!=nil)
    {
        _usernameText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentLoginUserName"];
        [_passwordText becomeFirstResponder];
    }
    else
    {
        [_usernameText becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitLogin:(id)sender {
       
    _userName = _usernameText.text;
    _password = _passwordText.text;
    
    NSString *nameString = _userName;
    NSString *passwString = _password;
    _api.user.userName = nameString;

    _ResultLabel.text = [_api TWLoginRequestWithPassword:passwString]; //login via API
    
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
        [[NSUserDefaults standardUserDefaults] setObject:_userName forKey:@"recentLoginUserName"];
        MainViewController *vc = [segue destinationViewController];
        [vc setApi:_api];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if(textField == _usernameText){
        [_passwordText becomeFirstResponder];
    }
    else if(textField == _passwordText){
        [_passwordText resignFirstResponder];
        [self submitLogin:self];
    }
    return YES;
}


@end
