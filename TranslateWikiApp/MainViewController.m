//
//  MainViewController.m
//  TranslateWikiApp
//
//  Created by Or Sagi on 8/1/13.
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

#import "MainViewController.h"

@class MenuView;

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
@synthesize menuView;
@synthesize menuTable;
@synthesize menuBtn;


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
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    //self.GreetingMessage.text = [NSString stringWithFormat:@" Hello, %@!",_api.user.userName];
    HideNetworkActivityIndicator();
    menuView.mainVC=self;
    [menuView setHidden:YES];
    [menuView setFrame:CGRectMake(0, 31, 31, 0)];
    [menuTable reloadData];
    [self.view bringSubviewToFront:menuView];
    //[menuView reloadInputViews];
    
    //makes the keyboard show the current language symbols
    LoadUserDefaults();
    translationState = !getBoolUserDefaultskey(PRMODE_key);
    [menuBtn setTitle:(translationState ? @"▾ Translate" : @"▾ Proofread" ) forState:UIControlStateNormal];
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
    _transCells=[[NSMutableSet alloc] init];
    [menuView setHidden:YES];
    [menuView setFrame:CGRectMake(0, 31, 31, 0)];
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
            [_transCells addObject:trMsgCell];
            
            trMsgCell.api=_api;
            trMsgCell.msg=[dataController objectInListAtIndex:indexPath.row];
            trMsgCell.container=dataController;
            trMsgCell.srcLabel.text = [trMsgCell.msg source];
            trMsgCell.msgTableView=self.msgTableView;
            trMsgCell.suggestionCells=[[NSMutableSet alloc] init];
            trMsgCell.isExpanded=FALSE;
            
            [trMsgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:[NSNumber numberWithBool:(selectedIndexPath && indexPath.row==selectedIndexPath.row)] waitUntilDone:NO];
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
    if(indexPath.row < [tableView numberOfRowsInSection:indexPath.section]-1)
    {
        if (translationState)
        {
            TranslationCell * trMsgCell;
            if(selectedIndexPath)
            {
                //do deselect precedures
                trMsgCell = (TranslationCell*)[tableView cellForRowAtIndexPath:selectedIndexPath];
                [trMsgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:[NSNumber numberWithBool:FALSE] waitUntilDone:NO];
                
                [trMsgCell.msgTableView reloadData];
                [trMsgCell.msgTableView.inputView resignFirstResponder];
            }
            if (!selectedIndexPath || selectedIndexPath.row != indexPath.row)
            {
                selectedIndexPath = [indexPath copy];
                trMsgCell = (TranslationCell*)[tableView cellForRowAtIndexPath:indexPath];
                [trMsgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:[NSNumber numberWithBool:TRUE] waitUntilDone:NO];
            }
            else
                selectedIndexPath = nil;
            
            [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
        }
        else //proofread state
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
        }
        [tableView beginUpdates];
        [tableView endUpdates];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else //"more" cell button 
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self addMessagesTuple];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isSelected=selectedIndexPath && indexPath.row == selectedIndexPath.row;
    BOOL isValid=indexPath.row<dataController.countOfList && dataController.countOfList>0;
    //check if the index actually exists
    if(!isValid)
        return 50;
    if (translationState)
    {
        if(isSelected)
        {
            NSString * text1 = [dataController objectInListAtIndex:indexPath.row].source;
            float h1 = max([text1 sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(tableView.frame.size.width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height, 50);
            float height=h1;
            float suggHeight;
            NSString* sugg;
            for(NSMutableDictionary* suggestion in [dataController objectInListAtIndex:indexPath.row].suggestions){
                sugg=suggestion[@"suggestion"];
                suggHeight=max([sugg sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(tableView.frame.size.width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height+12, 50);
                height+=suggHeight;
            }
            return height+80;
        }
        else //not expanded
        {
            float n = 2 + [dataController objectInListAtIndex:indexPath.row].suggestions.count;
            return 50*n+25;
        }
    }
    else{   //proofread
        if(isSelected)
        {        
            NSString * text1 = [dataController objectInListAtIndex:indexPath.row].source;
            NSString * text2 = [dataController objectInListAtIndex:indexPath.row].translation;
            float h1 = [text1 sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(tableView.frame.size.width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
            float h2 = [text2 sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(tableView.frame.size.width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
            return (h1+h2+100); //expanded proofread cell height
        }else
            return 65;  //unexpanded proofread cell height
    }
}

-(void)clearTextBoxes
{
    for(id obj in _transCells){
        TranslationCell* transCell=(TranslationCell*)obj;
        [transCell clearTextBox];
    }
    [_transCells removeAllObjects];
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
            LoadAlertView(@"Alert", @"Couldn't accept this message.", @"Ok");
            AlertShow();
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

- (IBAction)openMenu:(id)sender {
    [self.view bringSubviewToFront:menuView];
    if (menuView.hidden){ //closed
        [menuView setFrame:CGRectMake(0, 31, 31, 0)];
        [menuView setHidden:NO];
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{ [menuView setFrame:CGRectMake(0, 31, 200, 120)]; } completion:nil];
    }
    else{ //already opened
        [UIView animateWithDuration:0.24f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{ [menuView setFrame:CGRectMake(0, 31, 31, 0)]; } completion:^(BOOL comp){
            if (comp) [menuView setHidden:YES];
        }];
    }
}

- (IBAction)pushPrefs:(id)sender {
    [self performSegueWithIdentifier:@"showPrefs" sender:self];
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

- (IBAction)clearMessages:(id)sender
{
    selectedIndexPath = nil;
    [dataController removeAllObjects];
    [self.msgTableView reloadData];
}

@end
