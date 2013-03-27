//
//  MainViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 8/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//


#import "MainViewController.h"


@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *GreetingMessage;
@property (weak, nonatomic) IBOutlet UITableView *msgTableView;

@end

@implementation MainViewController
@synthesize managedObjectContext;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMessage"]) {
        ProofreadViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.msgIndex = [_msgTableView indexPathForSelectedRow].row;
        detailViewController.dataController  = _dataController;
        detailViewController.api = _api;
        detailViewController.managedObjectContext = self.managedObjectContext;
    }
    if ([[segue identifier] isEqualToString:@"showPrefs"]) {
        PrefsViewController *detailViewController = [segue destinationViewController];
    
        detailViewController.api = _api;
        detailViewController.managedObjectContext = self.managedObjectContext;
    }
}

- (void)viewWillAppear:(BOOL)animated {

    self.GreetingMessage.text = [NSString stringWithFormat:@"Hello, %@!",_api.user.userName];
    
    [super viewWillAppear:animated];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (!self.dataController)
        self.dataController = [[TranslationMessageDataController alloc] init];
    
}

-(id)init
{
    self=[super init];
    if(self){
        return self;
    }
    return nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addMessagesTuple
{
    [self.dataController addMessagesTupleUsingApi: _api andObjectContext:self.managedObjectContext];
    [self.msgTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_api.user.isLoggedin)
    {
        [self performSegueWithIdentifier:@"gotoLogin" sender:self];
    }
    else{
        [self addMessagesTuple]; //push TUPLE_SIZE-tuple of translation messages from server
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogoutButton:(id)sender {
    [_api TWLogoutRequest];
    KeychainItemWrapper * loginKC = [[KeychainItemWrapper alloc] initWithIdentifier:@"translatewikiapplogin" accessGroup:nil];
    [loginKC resetKeychainItem];
}

- (IBAction)clearMessages:(UIButton *)sender {
    
    [self.dataController removeAllObjects];
    [self.msgTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataController countOfList]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myCell";
    static NSString *moreCellIdentifier = @"moreCell";
    NSString *identifier;
    if(indexPath.row<[self.dataController countOfList])
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
    
    if(indexPath.row<[self.dataController countOfList]){
        cell.textLabel.text = [[self.dataController objectInListAtIndex:indexPath.row] source];
        cell.detailTextLabel.text = [[self.dataController objectInListAtIndex:indexPath.row] translation];
        if ([[self.dataController objectInListAtIndex:indexPath.row] isAccepted])
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        else
            [cell setAccessoryType:UITableViewCellAccessoryNone];
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
        [self addMessagesTuple];
        
    }
}

@end
