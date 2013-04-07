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
@synthesize translationState;



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
    self.GreetingMessage.text = [NSString stringWithFormat:@" Hello, %@!",_api.user.userName];
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
    [self.dataController addMessagesTupleUsingApi: _api andObjectContext:self.managedObjectContext andIsProofread:!translationState];
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
    static NSString *transCellIdentifier = @"translationCell";
    static NSString *CellIdentifier = @"myCell";
    static NSString *moreCellIdentifier = @"moreCell";

    if(indexPath.row<[self.dataController countOfList] && [self.dataController countOfList]>0)
    {
        if (translationState)
        {
            TranslationCell * trMsgCell = [tableView dequeueReusableCellWithIdentifier:transCellIdentifier forIndexPath:indexPath];
            
            if (!trMsgCell)
            {
                trMsgCell = [[TranslationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:transCellIdentifier];
               // [trMsgCell setNeedsDisplay];
            }
            trMsgCell.api=_api;
            trMsgCell.msg=[self.dataController objectInListAtIndex:indexPath.row];
            trMsgCell.container=self.dataController;
            trMsgCell.srcLabel.text = [trMsgCell.msg source];
            trMsgCell.msgTableView=self.msgTableView;
            if (trMsgCell.suggestionsData)
                [trMsgCell.suggestionsData removeAllObjects];
            else
                trMsgCell.suggestionsData = [[NSMutableArray alloc] init];
            for (NSDictionary *d in trMsgCell.msg.suggestions)
            {
                [trMsgCell.suggestionsData addObject:d[@"suggestion"]];
            }
            //[trMsgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:[NSNumber numberWithBool:(selectedIndexPath && indexPath.row==selectedIndexPath.row)] waitUntilDone:NO];
           [trMsgCell.inputTable reloadData];
            return trMsgCell;
        }
        else
        {
            MsgCell * msgCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            if (!msgCell)
            {
                msgCell = [[MsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            msgCell.srcLabel.text = [[self.dataController objectInListAtIndex:indexPath.row] source];
            msgCell.dstLabel.text = [[self.dataController objectInListAtIndex:indexPath.row] translation];
            msgCell.keyLabel.text = [[self.dataController objectInListAtIndex:indexPath.row] key];
            msgCell.acceptCount.text = [NSString  stringWithFormat:@"%d",[[self.dataController objectInListAtIndex:indexPath.row] acceptCount]];
         
            [msgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:[NSNumber numberWithBool:(selectedIndexPath && indexPath.row==selectedIndexPath.row)] waitUntilDone:NO];
            return msgCell;
        }
        
    }
    else
    {
        UITableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:moreCellIdentifier forIndexPath:indexPath];
        if (!moreCell)
        {
            moreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreCellIdentifier];
        }
        return moreCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [tableView numberOfRowsInSection:indexPath.section]-1)
    {
        if (translationState)
        {
            TranslationCell * trMsgCell;
            if(selectedIndexPath)
            {
                //do deselect precedures
                trMsgCell = (TranslationCell*)[tableView cellForRowAtIndexPath:selectedIndexPath];
               // [trMsgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:[NSNumber numberWithBool:FALSE] waitUntilDone:NO];
            }
            if (!selectedIndexPath || selectedIndexPath.row != indexPath.row)
            {
                selectedIndexPath = [indexPath copy];
                trMsgCell = (TranslationCell*)[tableView cellForRowAtIndexPath:indexPath];
               // [trMsgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:[NSNumber numberWithBool:TRUE] waitUntilDone:NO];
            }
            else
                selectedIndexPath = nil;
            
            [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
            [tableView beginUpdates];
            [tableView endUpdates];
        }
        else 
        {
            MsgCell * msgCell;
            if(selectedIndexPath)
            {
                //do deselect precedures
                msgCell = (MsgCell*)[tableView cellForRowAtIndexPath:selectedIndexPath];
                [msgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:[NSNumber numberWithBool:FALSE] waitUntilDone:NO];
            }
            if (!selectedIndexPath || selectedIndexPath.row != indexPath.row)
            {
                selectedIndexPath = [indexPath copy];
                msgCell = (MsgCell*)[tableView cellForRowAtIndexPath:indexPath];
                [msgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:[NSNumber numberWithBool:TRUE] waitUntilDone:NO];
            }
            else
                selectedIndexPath = nil;
            
            [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
            [tableView beginUpdates];
            [tableView endUpdates];
        }
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        // NSInteger previousCount=[tableData count];
        [self addMessagesTuple];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //check if the index actually exists
    if (translationState && indexPath.row<self.dataController.countOfList)
    {
     //   NSString * text1 = [self.dataController objectInListAtIndex:indexPath.row].source;
     //   float h1 = [text1 sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(tableView.frame.size.width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
     //   return ((h1+10)*(2+[self.dataController objectInListAtIndex:indexPath.row].suggestions.count) + 110);
        return 240;
    }
    if(selectedIndexPath && indexPath.row == selectedIndexPath.row) {
        
        NSString * text1 = [self.dataController objectInListAtIndex:indexPath.row].source;
        NSString * text2 = [self.dataController objectInListAtIndex:indexPath.row].translation;
        float h1 = [text1 sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(tableView.frame.size.width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
        float h2 = [text2 sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(tableView.frame.size.width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
        return (h1+h2+100); //expanded cell height
    }else if (indexPath.row<_dataController.countOfList && _dataController.countOfList>0)
        return 65;  //unexpanded cell height
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
