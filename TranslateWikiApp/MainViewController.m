//
//  MainViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 8/1/13.
//  Copyright (c) 2013 translatewiki.net. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{

}
@property (weak, nonatomic) IBOutlet UILabel *GreetingMessage;
@property (weak, nonatomic) IBOutlet UITableView *msgTableView;
@end

@implementation MainViewController
@synthesize selectedIndexPath;
@synthesize managedObjectContext;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPrefs"]) {
        PrefsViewController *detailViewController = [segue destinationViewController];
        detailViewController.api = _api;
    }
    if([[segue identifier] isEqualToString:@"gotoLogin"]) {
        LoginViewController *destViewController = [segue destinationViewController];
        destViewController.managedObjectContext = self.managedObjectContext;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    self.GreetingMessage.text = [NSString stringWithFormat:@"Hello, %@!",_api.user.userName];
    HideNetworkActivityIndicator();
    [super viewWillAppear:animated];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (!self.dataController)
    {
        self.dataController = [[TranslationMessageDataController alloc] init];
        selectedIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    }
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

- (IBAction)clearMessages:(UIButton *)sender
{
    selectedIndexPath = nil;
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
    if(indexPath.row<[self.dataController countOfList] && [self.dataController countOfList]>0)
    {
        identifier=CellIdentifier;
        MsgCell * msgCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (!msgCell)
        {
            msgCell = [[MsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [msgCell setExpanded:(selectedIndexPath && indexPath.row==selectedIndexPath.row)];
        msgCell.srcLabel.text = [[self.dataController objectInListAtIndex:indexPath.row] source];
        msgCell.dstLabel.text = [[self.dataController objectInListAtIndex:indexPath.row] translation];
        msgCell.keyLabel.text = [[self.dataController objectInListAtIndex:indexPath.row] key];
        msgCell.acceptCount.text = [NSString  stringWithFormat:@"%d",[[self.dataController objectInListAtIndex:indexPath.row] acceptCount]];
        
        //msgCell.acceptCount.text = [NSString  stringWithFormat:@"%d",msgCell.msg.acceptCount];
        
        return msgCell;
    }
    else
    {
        identifier=moreCellIdentifier;
        UITableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (!moreCell)
        {
            moreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return moreCell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [tableView numberOfRowsInSection:indexPath.section]-1)
    {
        MsgCell * msgCell;
        if(selectedIndexPath)
        {
            //do deselect precedures
            msgCell = (MsgCell*)[tableView cellForRowAtIndexPath:selectedIndexPath];
            [msgCell setExpanded:FALSE];
            
        }
        if (!selectedIndexPath || selectedIndexPath.row != indexPath.row) {
            selectedIndexPath = [indexPath copy];
            msgCell = (MsgCell*)[tableView cellForRowAtIndexPath:indexPath];
            [msgCell setExpanded:TRUE];
        }else
            selectedIndexPath = nil;
        
        [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
        [tableView beginUpdates];
        [tableView endUpdates];
        
    }else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        // NSInteger previousCount=[tableData count];
        [self addMessagesTuple];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //check if the index actually exists
    if(selectedIndexPath && indexPath.row == selectedIndexPath.row) {
        return 200; //expanded cell height
    }else if (indexPath.row<_dataController.countOfList && _dataController.countOfList>0)
        return 74;  //unexpanded cell height
    return 50;
}

#pragma mark - button actions

- (IBAction)pushAccept:(id)sender
{
    bool success = [_api TWTranslationReviewRequest:[_dataController objectInListAtIndex:selectedIndexPath.row].revision]; //accept this translation via API
    if (success)
    {
        [[_dataController objectInListAtIndex:selectedIndexPath.row] setIsAccepted:YES];
        [[_dataController objectInListAtIndex:selectedIndexPath.row] setAcceptCount:([[_dataController objectInListAtIndex:selectedIndexPath.row] acceptCount]+1)];
    }
    
    // here we'll take this cell away
    [self.dataController removeObjectAtIndex:selectedIndexPath.row];
    if([self.dataController countOfList]<1) selectedIndexPath = nil;
    [self.msgTableView reloadData];
}

- (IBAction)pushReject:(id)sender
{
    [[_dataController objectInListAtIndex:selectedIndexPath.row] setIsAccepted:NO];
    [self coreDataRejectMessage];
    // here we'll take this cell away
    [self.dataController removeObjectAtIndex:selectedIndexPath.row];
    if([self.dataController countOfList]<1) selectedIndexPath = nil;
    [self.msgTableView reloadData];
}

-(void)coreDataRejectMessage{
    RejectedMessage *mess = (RejectedMessage *)[NSEntityDescription insertNewObjectForEntityForName:@"RejectedMessage" inManagedObjectContext:managedObjectContext];
    
    [mess setRevision:[[_dataController objectInListAtIndex:selectedIndexPath.row] revision]];
    [mess setUserid:[[_api user] userId]];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        // Handle the error.
    }
}

- (IBAction)pushPrefs:(id)sender
{
    
}

@end
