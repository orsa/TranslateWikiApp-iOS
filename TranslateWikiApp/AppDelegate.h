//
//  AppDelegate.h
//  TranslateWikiApp
//
//  Created by Or Sagi on 31/12/12.
//  Copyright (c) 2012 translatewiki.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"
#import "TWapi.h"
#import "TWUser.h"
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (retain, nonatomic) TWapi *api;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end
