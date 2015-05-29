//
//  AppDelegate.m
//  CNNoStoryboards
//
//  Created by Artem Stepanenko on 5/28/15.
//  Copyright (c) 2015 Artem Stepanenko. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "TopViewController.h"
#import "BottomViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // main view controller
    MainViewController *viewController = [[MainViewController alloc] init];
    
    // set auto-transitions
    viewController.leftClass = [LeftViewController class];
    viewController.topClass = [TopViewController class];
    viewController.rightClass = [RightViewController class];
    viewController.bottomClass = [BottomViewController class];
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
