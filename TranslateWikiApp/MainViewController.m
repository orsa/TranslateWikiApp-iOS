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

@property (weak, nonatomic) IBOutlet UILabel *GreetingMessage;

@end

@implementation MainViewController
@synthesize selectedIndexPath, managedObjectContext, translationState, dataController ,msgTableView, menuView, menuTable, menuBtn;


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPrefs"]) {
        PrefsViewController *detailViewController = [segue destinationViewController];
        detailViewController.api = _api;
        detailViewController.managedObjectContext = managedObjectContext;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    //self.GreetingMessage.text = [NSString stringWithFormat:@" Hello, %@!",_api.user.userName];
    //HideNetworkActivityIndicator();
    menuView.mainVC=self;
    [menuView setHidden:YES];
    [menuView setFrame:CGRectMake(0, 46, 90, 0)];
    [menuTable reloadData];
    [self.view bringSubviewToFront:menuView];
    //[menuView reloadInputViews];
    
    //makes the keyboard show the current language symbols
    LoadUserDefaults();
    translationState = !getBoolUserDefaultskey(PRMODE_key);
    [menuBtn setTitle:(translationState ? @"Translate  ▾" : @"Proofread  ▾" ) forState:UIControlStateNormal];
    //NSString * st = getUserDefaultskey(LANG_key);
    //NSMutableArray * arr = [NSMutableArray arrayWithArray:PREFERRED_LANG];
    //[arr removeObject:st];
    //[arr insertObject:st atIndex:0];
    //setUserDefaultskey(arr, @"AppleLanguages");
    //[[NSUserDefaults standardUserDefaults] synchronize];
    msgTableView.contentInset =  UIEdgeInsetsMake(0, 0, KEYBOARD_ROOM, 0); //make room for keyboard
    [msgTableView reloadData];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (!dataController)
    {
        dataController = [[TranslationMessageDataController alloc] init];
        selectedIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    }
}

-(void)addMessagesTuple
{
    __weak typeof(self) weakself = self; //avoid retain cycle
    ShowNetworkActivityIndicator();
    [dataController addMessagesTupleUsingApi: _api andObjectContext:self.managedObjectContext andIsProofread:!translationState completionHandler:^(){
        if (weakself.translationState!=weakself.dataController.translationState)
        {
            [weakself.dataController removeAllObjects];
        }
        else
        {
            HideNetworkActivityIndicator();
        }
        [weakself.msgTableView reloadData];
        
    }] ;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _transCells=[[NSMutableSet alloc] init];
    [menuView setHidden:YES];
    [menuView setFrame:CGRectMake(0, 46, 90, 0)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [msgTableView reloadData];
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
    static NSString *CellIdentifier = @"myCell";
    static NSString *moreCellIdentifier = @"moreCell";

    int i = indexPath.row;
    if(i<[dataController countOfList] && [dataController countOfList]>0)
    {
        TranslationMessage* msg = [dataController objectInListAtIndex:i];
        if (!msg.prState)//if (translationState)
        {
            
            NSString *transCellIdentifier = [NSString stringWithFormat:@"translationCell-%i",msg.suggestions.count];
            TranslationCell * trMsgCell = [tableView dequeueReusableCellWithIdentifier:transCellIdentifier];
            
            if (trMsgCell==nil)
            {
                trMsgCell = [[TranslationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:transCellIdentifier];
            }
            [_transCells addObject:trMsgCell];
            
            trMsgCell.msg=msg;
            trMsgCell.api=_api;
            trMsgCell.container=dataController;
            trMsgCell.msgTableView=self.msgTableView;
            trMsgCell.srcLabel.text = [trMsgCell.msg source];
            trMsgCell.suggestionCells=[[NSMutableSet alloc] init];
            trMsgCell.isExpanded=FALSE;
            trMsgCell.isMinimized = trMsgCell.msg.minimized;
            trMsgCell.translationState = translationState;
            
            [trMsgCell.infoView setHidden:!msg.infoState];
            [trMsgCell displayHTML:msg.documentation];
            
            [trMsgCell setMinimized:[NSNumber numberWithBool:trMsgCell.isMinimized]];
            
            if (!trMsgCell.isMinimized)
            {
                NSNumber * b = [NSNumber numberWithBool:(selectedIndexPath && i==selectedIndexPath.row)];
                NSArray * obj = @[msg,b];
                [trMsgCell performSelectorOnMainThread:@selector(buildWithMsg:) withObject:obj waitUntilDone:NO];
            }
            
            [trMsgCell.inputTable reloadData];
            
            return trMsgCell;
        }
        else //proofread mode
        {
            ProofreadCell * msgCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            if (!msgCell)
            {
                msgCell = [[ProofreadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            msgCell.srcLabel.text = [msg source];
            msgCell.dstLabel.text = [msg translation];
            msgCell.keyLabel.text = [msg key];
            NSInteger ac_cnt = [[dataController objectInListAtIndex:i] acceptCount];
            msgCell.acceptCount.text = (ac_cnt!=0 ? [NSString  stringWithFormat:@"%d", ac_cnt]: @"");
         
            [msgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:[NSNumber numberWithBool:(selectedIndexPath && i==selectedIndexPath.row)] waitUntilDone:NO];
            return msgCell;
        }
        
    }
    else //last cell - more button
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
        TranslationMessage* msg = [dataController objectInListAtIndex:indexPath.row];
        if(!msg.prState) //if (translationState)
        {
            TranslationCell * trMsgCell;
            trMsgCell = (TranslationCell*)[tableView cellForRowAtIndexPath:indexPath];
            if(trMsgCell.msg.infoState){
                goto end;
            }
            if(trMsgCell.isMinimized)
            {       //the selection was for minimizing
                [trMsgCell setMinimized:@NO];
                //[self.msgTableView reloadData];
            }
            else
            {       //the selection wasn't for minimizing
                if(selectedIndexPath && ![dataController objectInListAtIndex:selectedIndexPath.row].prState)
                {
                    //do deselect precedures
                    trMsgCell = (TranslationCell*)[tableView cellForRowAtIndexPath:selectedIndexPath];
                    if (trMsgCell)
                    {
                        NSArray * obj = @[trMsgCell.msg,@NO];
                        [trMsgCell performSelectorOnMainThread:@selector(buildWithMsg:) withObject:obj waitUntilDone:NO];
                
                        //[trMsgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:[NSNumber numberWithBool:FALSE] waitUntilDone:NO];
            
                        [self removeActiveKeyboard];
                        [self.msgTableView reloadData];
                        
                        //[trMsgCell.msgTableView reloadData];
                        [trMsgCell.msgTableView.inputView resignFirstResponder];
                    }
                }
                if (!selectedIndexPath || selectedIndexPath.row != indexPath.row)
                {
                    //selecting a cell
                    selectedIndexPath = [indexPath copy];
                    trMsgCell = (TranslationCell*)[tableView cellForRowAtIndexPath:indexPath];
                    //expand
                    NSArray * obj = @[trMsgCell.msg,@YES];
                    [trMsgCell performSelectorOnMainThread:@selector(buildWithMsg:) withObject:obj waitUntilDone:NO];
                    //[trMsgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:[NSNumber numberWithBool:TRUE] waitUntilDone:NO];
                    
                    [self removeActiveKeyboard];
                    [self.msgTableView reloadData];
                }
                else
                    selectedIndexPath = nil;
            }
            
        end: [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
        [self.msgTableView beginUpdates];
        [self.msgTableView endUpdates];
        //[self.msgTableView reloadData];
        }
        else //proofread state
        {
            ProofreadCell * msgCell;
            if(selectedIndexPath && [dataController objectInListAtIndex:selectedIndexPath.row].prState)
            {
                //do deselect precedures
                msgCell = (ProofreadCell*)[tableView cellForRowAtIndexPath:selectedIndexPath];
                [msgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:@NO waitUntilDone:NO];
            }
            if (!selectedIndexPath || selectedIndexPath.row != indexPath.row)
            {
                selectedIndexPath = [indexPath copy];
                msgCell = (ProofreadCell*)[tableView cellForRowAtIndexPath:indexPath];
                [msgCell performSelectorOnMainThread:@selector(setExpanded:) withObject:@YES waitUntilDone:NO];
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

-(bool)removeActiveKeyboard
{
    return [self recursiveRemoveActiveKeyboard:self.view];
}

-(bool)recursiveRemoveActiveKeyboard:(UIView*)highView
{
    for (UIView *view in [highView subviews]) {
        if ([view isFirstResponder]) {
            [view resignFirstResponder];
        }
        if([self recursiveRemoveActiveKeyboard:view])
            return true;
    }
    return false;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isSelected=selectedIndexPath && indexPath.row == selectedIndexPath.row;
    BOOL isValid=indexPath.row<dataController.countOfList && dataController.countOfList>0;
    //check if the index actually exists
    if(!isValid)
        return 40;
    TranslationMessage* msg=(TranslationMessage*)dataController.masterTranslationMessageList[indexPath.row];
    if (translationState || !msg.prState)
    {
        
        bool isMin = msg.minimized; //translated not enough because it can be translated but still unminimized for re-editing
        if (isMin)
            return 50;
        if(isSelected)
        {
            if(![msg needsExpansionUnderWidth:tableView.frame.size.width])
                goto unexpanded_trCell;
            float sourceHeight=[msg getExpandedHeightOfSourceUnderWidth:tableView.frame.size.width];
            float suggHeight=[msg getCombinedExpandedHeightOfSuggestionUnderWidth:tableView.frame.size.width];
            return sourceHeight+(suggHeight+62)*1.2+2+10;
        }
        else //not expanded translation cell
        {
        unexpanded_trCell: 
            return [msg heightForImageView]+50+20;
        }
    }
    else{   //proofread
        if(isSelected)
        {        
            NSString * text1 = [dataController objectInListAtIndex:indexPath.row].source;
            NSString * text2 = [dataController objectInListAtIndex:indexPath.row].translation;
            float h1 = [text1 sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(tableView.frame.size.width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
            float h2 = [text2 sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(tableView.frame.size.width, UINTMAX_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
            return (h1+h2+60); //expanded proofread cell height
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
    [_api TWTranslationReviewRequest:[dataController objectInListAtIndex:selectedIndexPath.row].revision completionHandler:^(NSError * error, NSDictionary* responseData){
        
       /* if (success)
        {
            [[dataController objectInListAtIndex:selectedIndexPath.row] setIsAccepted:YES];
            [[dataController objectInListAtIndex:selectedIndexPath.row] setAcceptCount:([[dataController objectInListAtIndex:selectedIndexPath.row] acceptCount]+1)];
        }*/
        if(responseData[@"error"]){
            LoadDefaultAlertView();
            AlertSetMessage(responseData[@"error"][@"info"]);
            AlertShow();
        }
        else if(responseData[@"warnings"]){
            if(responseData[@"warnings"][@"tokens"] && responseData[@"warnings"][@"tokens"][@"*"]){
                LoadDefaultAlertView();
                AlertSetMessage(responseData[@"warnings"][@"tokens"][@"*"]);
                AlertShow();
            }
            //handle warnings
        }
        else if(error){
            LoadDefaultAlertView();
            AlertSetMessage(connectivityProblem);
            AlertShow();
        }
    }]; 
    
    // here we'll take this cell away
    [self removeSelectedCell];
}

- (IBAction)pushReject:(id)sender
{
    //[[dataController objectInListAtIndex:selectedIndexPath.row] setIsAccepted:NO];
    [self coreDataRejectMessage];
    
    // here we'll take this cell away
    [self removeSelectedCell];
}

-(void)removeSelectedCell
{
    [self.dataController removeObjectAtIndex:selectedIndexPath.row];
    if([self.dataController countOfList]<1)//no more messages
        selectedIndexPath = nil;
    else{
        if(selectedIndexPath.row==[self.dataController countOfList])//we removed the last message
            selectedIndexPath=[NSIndexPath indexPathForRow:selectedIndexPath.row-1 inSection:selectedIndexPath.section];
    }
    [self.msgTableView reloadData];
    if([self.dataController countOfList]<1) [self addMessagesTuple];
}

- (IBAction)openMenu:(id)sender {
    [self.view bringSubviewToFront:menuView];
    if (menuView.hidden){ //closed
        [menuView setFrame:CGRectMake(0, 46, 90, 0)];
        [menuView setHidden:NO];
        [UIView animateWithDuration:0.24f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{ [menuView setFrame:CGRectMake(0, 46, 180, 105)]; } completion:^(BOOL comp){
            if (comp)[self.view bringSubviewToFront:menuView];
        }];
    }
    else{ //already opened
        [self closeMenu:sender];
    }
}

- (IBAction)closeMenu:(id)sender {
        [UIView animateWithDuration:0.23f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{ [menuView setFrame:CGRectMake(0, 46, 90, 0)]; } completion:^(BOOL comp){
            if (comp) [menuView setHidden:YES];
        }];
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


- (IBAction)pushEdit:(id)sender {
    int row = selectedIndexPath.row;
    TranslationMessage * m =[dataController objectInListAtIndex:row] ;
    [m setPrState:NO];
    [self.msgTableView reloadData];
    
    [_api TWTranslationAidsForTitle:m.title withProject:m.project completionHandler:^(NSDictionary* transAids, NSError* error){
        [m addSuggestionsFromResponse:transAids[@"helpers"]];
        [m addDocumentationFromResponse:transAids[@"helpers"]];
        [self.msgTableView reloadData];

    }];
}

- (IBAction)bgTap:(UITapGestureRecognizer *)sender {
    [self closeMenu:sender];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    UITouch *aTouch = [touches anyObject];
    if (aTouch.tapCount == 1)
    {
        CGPoint p = [aTouch locationInView:menuView.superview];
        if (!CGRectContainsPoint(menuView.frame, p))
        {
            // dismiss the popup
            [self closeMenu:nil];
        }
    }
}
@end
