//
//  AppDelegate.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 31/12/12.
//  Copyright 2013 Or Sagi, Tomer Tuchner
//

#import <UIKit/UIKit.h>
#import "constants.h"
#import "TWapi.h"
#import "TWUser.h"
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSManagedObjectModel         *managedObjectModel;
    NSManagedObjectContext       *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end
