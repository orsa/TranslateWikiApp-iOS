//
//  MainViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 8/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "TWapi.h"
#import "KeychainItemWrapper.h"
#import "MainViewController.h"
#import "MessagesViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *GreetingMessage;
@end

@implementation MainViewController
@synthesize tableData;
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
    
    NSLog(@"%@",result); //DEBUG
    
    
    
    tableData = [[NSArray alloc] initWithArray:[[result objectForKey:@"query"] objectForKey:@"messagecollection"]];
    //we expect an array, otherwise will be runtimeexception
    
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[tableData objectAtIndex:indexPath.row] objectForKey:@"definition"];
    cell.detailTextLabel.text = [[tableData objectAtIndex:indexPath.row] objectForKey:@"translation"];
    
    return cell;
}


@end
