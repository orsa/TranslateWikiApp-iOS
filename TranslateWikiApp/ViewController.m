//
//  ViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 31/12/12.
//  Copyright (c) 2012 translatewiki.net. All rights reserved.
//

#import "ViewController.h"
#import "TWapi.h"

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
}
@end
