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

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *GreetingMessage;
@property (weak, nonatomic) IBOutlet UITableView *msgTableView;

@end

@implementation MainViewController
@synthesize tableData;
@synthesize numOf10Tuples;

static NSInteger TUPLE_SIZE=10;

-(id)init
{
    self=[super init];
    if(self){
        numOf10Tuples=1;
        tableData=[[NSMutableArray alloc] initWithObjects: nil];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)add10Messages
{
    NSInteger offset=0;
    if(tableData!=nil)
        offset=[tableData count];
    NSDictionary *result = [TWapi TWMessagesListRequestForLanguage:@"es" Project:@"core" Limitfor:TUPLE_SIZE OffsetToStart:offset ByUserId:@"10323"];
    
    NSLog(@"%@",result); //DEBUG
    
    NSArray *newData = [[NSArray alloc] initWithArray:[[result objectForKey:@"query"] objectForKey:@"messagecollection"]];
    //we expect an array, otherwise will be runtime exception
    
    if(tableData==nil)
       tableData = [[NSMutableArray alloc]initWithArray:newData];
    else
        [tableData addObjectsFromArray:newData];
    
    NSLog(@"%@", tableData);//DEBUG
    
    [self.msgTableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.GreetingMessage.text = [NSString stringWithFormat:@"Hello, %@!",self.loggedUserName];
    
    [self add10Messages];
    
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
    return [tableData count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myCell";
    static NSString *moreCellIdentifier = @"moreCell";
    NSString *identifier;
    if(indexPath.row<[tableData count])
        identifier=CellIdentifier;
    else
        identifier=moreCellIdentifier;
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Configure the cell
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if(indexPath.row<[tableData count]){
        cell.textLabel.text = [[tableData objectAtIndex:indexPath.row] objectForKey:@"definition"];
        cell.detailTextLabel.text = [[tableData objectAtIndex:indexPath.row] objectForKey:@"translation"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:NO];

    if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
       // NSInteger previousCount=[tableData count];
        [self add10Messages];
        
       
       
       // NSMutableArray *insertIndexPaths=[[NSMutableArray alloc] initWithObjects: nil];
       // for(NSInteger i=0; i<TUPLE_SIZE; i++){
       //     [insertIndexPaths insertObject:[NSIndexPath indexPathForRow:previousCount+i inSection:0] atIndex:i];
       // }
        
       // [tableView beginUpdates];
       // [tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
       // [tableView endUpdates];
    }
}

- (IBAction)clearMessages:(UIButton *)sender {
    
    [tableData removeAllObjects];
    [self.msgTableView reloadData];
}


@end
