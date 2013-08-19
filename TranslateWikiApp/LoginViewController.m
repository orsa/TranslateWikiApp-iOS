//
//  LoginViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 31/12/12.
//
//  Copyright 2013 Or Sagi, Tomer Tuchner
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "LoginViewController.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UILabel *ResultLabel;
- (IBAction)submitLogin:(id)sender;

@end

@class AppDelegate;

@implementation LoginViewController
@synthesize managedObjectContext, langNeedsManualSelection;

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

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
        __block BOOL didLogin=NO;
        //send login request to api
        [_api TWLoginRequestWithPassword:passwString isMainThreadBlocked:YES completionHandler:^(NSString * resultString, NSError * error)
        {
            if(error==nil && [resultString isEqualToString:@"Success"])
           {
               didLogin=YES;
               isDone=YES;
           }
           else
           {
               didLogin=NO;
               isDone=YES;
           }
        }];
        while(!isDone){
            [NSThread sleepForTimeInterval:0.1];
        }
        if(didLogin){
            //then we can skip the login screen
            _userName = nameString;
            [self performSegueWithIdentifier:@"FromLoginToMessages" sender:self];
        }
        else{//login fail, need to re-login and update credentials
            [loginKC resetKeychainItem];
            [_usernameText becomeFirstResponder];
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
         LoadDefaultAlertView();
         if(error){//request error
             AlertSetMessage(connectivityProblem);
             AlertShow();
         }
         else if([resultString isEqualToString:@"Success"])
         {
             [LoginViewController storeCredKCUser:nameString Password:passwString];//store credentials in keychain
             if (langNeedsManualSelection)
             {
                 [self performSegueWithIdentifier:@"FromLoginToLang" sender:self];
                 langNeedsManualSelection=NO;
                 
             }else
                 [self performSegueWithIdentifier:@"FromLoginToMessages" sender:self]; //logged in - move to next screen
         }
         else if(alertMessages[resultString]!=nil){
             AlertSetMessage(alertMessages[resultString]);
             AlertShow();
         }
         HideNetworkActivityIndicator();
     }];
}

- (IBAction)goToSignup:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://translatewiki.net/w/i.php?title=Special:UserLogin&type=signup"]];
    
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
    LoadUserDefaults();
    setUserDefaultskey(_userName,RECENT_USER_key);
    if ([[segue identifier] isEqualToString:@"FromLoginToMessages"])
    {
        MainViewController *vc = [segue destinationViewController];
        vc.translationState=!getBoolUserDefaultskey(PRMODE_key);
        [vc setApi:_api];
        [vc setManagedObjectContext:self.managedObjectContext];
        [vc addMessagesTuple]; //push TUPLE_SIZE-tuple of translation messages from server
    }
    else if ([[segue identifier] isEqualToString:@"FromLoginToLang"])
    {
        LanguagePickerViewController *vc = [segue destinationViewController];
        vc.enteredFromLogin = YES;
        vc.api = _api;
        vc.managedObjectContext =self.managedObjectContext;
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
