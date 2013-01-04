//
//  ViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 31/12/12.
//  Copyright (c) 2012 translatewiki.net. All rights reserved.
//

#import <Security/Security.h>
#import "ViewController.h"
#import "TWapi.h"
#import "KeychainItemWrapper.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UILabel *ResultLabel;
- (IBAction)submitLogin:(id)sender;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    KeychainItemWrapper * loginKC = [[KeychainItemWrapper alloc] initWithIdentifier:@"login" accessGroup:nil];
    NSString *nameString  =  [loginKC objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *passwString = [loginKC objectForKey:(__bridge id)kSecValueData];
    
    if(nameString!=@"" && passwString!=@"")
    {
        NSString *resultString = [TWapi TWLoginRequestForUser:nameString WithPassword:passwString];
        if([resultString isEqualToString:@"Success"])
        {
            //then we can skip the login screen
        }
        else
        {
            [loginKC resetKeychainItem];
        }
    }
    
    
    NSLog(@"%@\n",[loginKC objectForKey:(__bridge id)(kSecAttrAccount)]);
    NSLog(@"%@\n", [loginKC objectForKey:(__bridge id)kSecValueData]);
    
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

    self.ResultLabel.text = [TWapi TWLoginRequestForUser:nameString WithPassword:passwString];
    
    if([ self.ResultLabel.text isEqualToString:@"Success"])
    {
        KeychainItemWrapper * loginKC = [[KeychainItemWrapper alloc] initWithIdentifier:@"login" accessGroup:nil];
        [loginKC setObject:nameString forKey:(__bridge id)kSecAttrAccount];
        [loginKC setObject:passwString forKey:(__bridge id)kSecValueData];
        //logged in - move to next screen
    }
}


@end
