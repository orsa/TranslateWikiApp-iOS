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

@end

@implementation MainViewController
@synthesize selectedIndexPath;
@synthesize managedObjectContext;
@synthesize translationState;
@synthesize dataController;
@synthesize msgTableView;
//@synthesize msgTableView;



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
    
    //makes the keyboard show the current language symbols
    LoadUserDefaults();
    NSString * st = getUserDefaultskey(LANG_key);
    NSArray * arr = [NSArray arrayWithObjects: st, nil];
    setUserDefaultskey(arr, @"AppleLanguages");
    [[NSUserDefaults standardUserDefaults] synchronize];
    msgTableView.contentInset =  UIEdgeInsetsMake(0, 0, 210, 0); //make room for keyboard
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (!dataController)
    {
        dataController = [[TranslationMessageDataController alloc] init];
        if(selectedIndexPath && dataController.countOfList>0)
            selectedIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    }
}

-(void)addMessagesTuple
{
    __weak typeof(self) weakself = self; //avoid retain cycle
    
    [dataController addMessagesTupleUsingApi: _api andObjectContext:self.managedObjectContext andIsProofread:!translationState completionHandler:^(){
    	[weakself.msgTableView reloadData];
    }] ;
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataController countOfList]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *transCellIdentifier = @"translationCell";
    static NSString *CellIdentifier = @"myCell";
    static NSString *moreCellIdentifier = @"moreCell";

    if(indexPath.row<[dataController countOfList] && [dataController countOfList]>0)
    {
        if (translationState)
        {
            TranslationCell * trMsgCell = [tableView dequeueReusableCellWithIdentifier:transCellIdentifier];
            
            if (trMsgCell==nil)
            {
                trMsgCell = [[TranslationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:transCellIdentifier];
            }
            trMsgCell.api=_api;
            trMsgCell.msg=[dataController objectInListAtIndex:indexPath.row];
            trMsgCell.container=dataController;
            trMsgCell.srcLabel.text = [trMsgCell.msg source];
            trMsgCell.msgTableView=self.msgTableView;
            
            float h1 = trMsgCell.inputTable.rowHeight*(trMsgCell.msg.suggestions.count+1) + 1;
            trMsgCell.frameImg.transform = CGAffineTransformIdentity;
            trMsgCell.inputTable.transform = CGAffineTransformIdentity;
            trMsgCell.frameImg.frame = CGRectMake(trMsgCell.frameImg.frame.origin.x,
                                                  trMsgCell.srcLabel.frame.size.height,
                                                  trMsgCell.frameImg.frame.size.width,
                                                  h1+16);
            trMsgCell.inputTable.frame = CGRectMake(trMsgCell.inputTable.frame.origin.x,
                                                    trMsgCell.frameImg.frame.origin.y + 13 ,
                                                    trMsgCell.inputTable.frame.size.width,
                                                    h1);
            
            
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
            msgCell.srcLabel.text = [[dataController objectInListAtIndex:indexPath.row] source];
            msgCell.dstLabel.text = [[dataController objectInListAtIndex:indexPath.row] translation];
            msgCell.keyLabel.text = [[dataController objectInListAtIndex:indexPath.row] key];
            msgCell.acceptCount.text = [NSString  stringWithFormat:@"%d",[[dataController objectInListAtIndex:indexPath.row] acceptCount]];
         
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
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES]; 
    
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
                
                [trMsgCell.msgTableView reloadData];
                [trMsgCell.msgTableView.inputView resignFirstResponder];
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
        [self addMessagesTuple];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //check if the index actually exists
    if (translationState && indexPath.row<dataController.countOfList)
    {
     //   NSString * text1 = [dataController objectInListAtIndex:indexPath.row].source;
     //   float h1 = [text1 sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(tableView.frame.size.width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
     //   return ((h1+10)*(2+[dataController objectInListAtIndex:indexPath.row].suggestions.count) + 110);
        float n = 2 + [dataController objectInListAtIndex:indexPath.row].suggestions.count;
        return 50*n+30;
      //  return 240;
    }
    if(selectedIndexPath && indexPath.row == selectedIndexPath.row) {
        
        NSString * text1 = [dataController objectInListAtIndex:indexPath.row].source;
        NSString * text2 = [dataController objectInListAtIndex:indexPath.row].translation;
        float h1 = [text1 sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(tableView.frame.size.width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
        float h2 = [text2 sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(tableView.frame.size.width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
        return (h1+h2+100); //expanded cell height
    }else if (indexPath.row<dataController.countOfList && dataController.countOfList>0)
        return 65;  //unexpanded cell height
    return 50;
}

#pragma mark - button actions

- (IBAction)pushAccept:(id)sender
{
    //accept this translation via API
    [_api TWTranslationReviewRequest:[dataController objectInListAtIndex:selectedIndexPath.row].revision completionHandler:^(BOOL success, NSError * error){
        
       /* if (success)
        {
            [[dataController objectInListAtIndex:selectedIndexPath.row] setIsAccepted:YES];
            [[dataController objectInListAtIndex:selectedIndexPath.row] setAcceptCount:([[dataController objectInListAtIndex:selectedIndexPath.row] acceptCount]+1)];
        }*/
        if(!success || error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Couldn't accept this message." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            NSLog(@"%@", error);
        }
        
    }]; 
    
    
    // here we'll take this cell away
    [self.dataController removeObjectAtIndex:selectedIndexPath.row];
    if([self.dataController countOfList]<1) selectedIndexPath = nil;
    [self.msgTableView reloadData];
    if([self.dataController countOfList]<1) [self addMessagesTuple];
}

- (IBAction)pushReject:(id)sender
{
    [[dataController objectInListAtIndex:selectedIndexPath.row] setIsAccepted:NO];
    [self coreDataRejectMessage];
    // here we'll take this cell away
    [self.dataController removeObjectAtIndex:selectedIndexPath.row];
    if([self.dataController countOfList]<1) selectedIndexPath = nil;
    [self.msgTableView reloadData];
    if([self.dataController countOfList]<1) [self addMessagesTuple];
}

-(void)coreDataRejectMessage{
    RejectedMessage *mess = (RejectedMessage *)[NSEntityDescription insertNewObjectForEntityForName:@"RejectedMessage" inManagedObjectContext:managedObjectContext];
    
    [mess setRevision:[[dataController objectInListAtIndex:selectedIndexPath.row] revision]];
    [mess setUserid:[[_api user] userId]];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        // Handle the error.
        NSLog(@"%@", error);
    }
}

- (IBAction)LogoutButton:(id)sender {
    [_api TWLogoutRequest:^(NSDictionary* response, NSError* error){
        //Handle the error
        NSLog(@"%@", error);
    }];
    KeychainItemWrapper * loginKC = [[KeychainItemWrapper alloc] initWithIdentifier:@"translatewikiapplogin" accessGroup:nil];
    [loginKC resetKeychainItem];
    
}

- (IBAction)clearMessages:(UIButton *)sender
{
    selectedIndexPath = nil;
    [dataController removeAllObjects];
    [self.msgTableView reloadData];
}

@end
