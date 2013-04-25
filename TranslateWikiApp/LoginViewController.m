//
//  LoginViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 31/12/12.
//  Copyright (c) 2012 translatewiki.net. All rights reserved.
//

#import "LoginViewController.h"
#import "constants.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UILabel *ResultLabel;
- (IBAction)submitLogin:(id)sender;

@end

@class AppDelegate;

@implementation LoginViewController
@synthesize managedObjectContext;

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
    LoadUserDefaults();
    if(![nameString isEqualToString:@""] && ![passwString isEqualToString:@""]) //we have s.t in keychain
    { //found credentials
        
        _api.user.userName  =  nameString;
        
        __block BOOL isDone=NO;
        [_api TWLoginRequestWithPassword:passwString isMainThreadBlocked:YES completionHandler:^(NSString * resultString, NSError * error)
        {
            isDone=YES;
            if(error==nil && [resultString isEqualToString:@"Success"])
           {
               //then we can skip the login screen
               _userName = nameString;
               [self performSegueWithIdentifier:@"FromLoginToMessages" sender:self];
           }
           else
           { //login fail, need to re-login and update credentials
               [loginKC resetKeychainItem];
           }
        }]; //try login
        while(!isDone){
            [NSThread sleepForTimeInterval:0.1];
        }
    }
    else if(getUserDefaultskey(RECENT_USER_key)!=nil)//known user but not password
    {
        _usernameText.text = getUserDefaultskey(RECENT_USER_key);
        [_passwordText becomeFirstResponder];
    }
    else //unknown recent user
    {
        [_usernameText becomeFirstResponder]; //set focus on username text field 
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitLogin:(id)sender
{
    ShowNetworkActivityIndicator();
    _userName = _usernameText.text;
    _password = _passwordText.text;
    NSString *nameString = _userName;
    NSString *passwString = _password;
    _api.user.userName = nameString;

    //[_api TWLoginRequestWithPassword:passwString]; //login via API
     [_api TWLoginRequestWithPassword:passwString completionHandler:^(NSString * resultString, NSError * error){
         _ResultLabel.text = resultString;
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         if(error){//request error
             alert.message=@"Couldn't complete request. Please check your connectivity.";
             [alert show];
         }
         else if([resultString isEqualToString:@"Success"])
         {
             [LoginViewController storeCredKCUser:nameString Password:passwString];//store credentials in keychain
             [self performSegueWithIdentifier:@"FromLoginToMessages" sender:self]; //logged in - move to next screen
         }
         else if(alertMessages[resultString]!=nil){
             alert.message=alertMessages[resultString];
             [alert show];
         }
         HideNetworkActivityIndicator();
     }];
}

+ (void) storeCredKCUser:(NSString *)nameString Password:(NSString*)passwString
{
    KeychainItemWrapper * loginKC = [[KeychainItemWrapper alloc] initWithIdentifier:@"translatewikiapplogin" accessGroup:nil];
    [loginKC resetKeychainItem];
    [loginKC setObject:nameString forKey:(__bridge id)kSecAttrAccount];
    [loginKC setObject:passwString forKey:(__bridge id)kSecValueData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"FromLoginToMessages"])
    {
        LoadUserDefaults();
        setUserDefaultskey(_userName,RECENT_USER_key);
        MainViewController *vc = [segue destinationViewController];
        vc.translationState=!getBoolUserDefaultskey(PRMODE_key);
        [vc setApi:_api];
        [vc setManagedObjectContext:self.managedObjectContext];
        [vc addMessagesTuple]; //push TUPLE_SIZE-tuple of translation messages from server
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
