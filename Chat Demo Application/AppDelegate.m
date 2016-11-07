//
//  AppDelegate.m
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/7/16.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"t2CyMIR58N3yecBfbJTUa789uvOerql55FQvEgQY"
                  clientKey:@"Bh4C69VlJjUQvovjCtfPguMP7G5nDCOq3bAGPn41"];
    
    // [Optional] Track statistics around application opens.
    [PFUser enableRevocableSessionInBackground];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    LoginViewController *viewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;
    [navigationController.navigationBar setHidden:YES];
    
    return YES;
}

#pragma mark - Push Notifications

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    
    currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
    
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ( application.applicationState == UIApplicationStateActive )
    {
        
    }
    else
    {
        [PFPush handlePush:userInfo];
        
        currentInstallation = [PFInstallation currentInstallation];
        if (currentInstallation.badge != 0)
        {
            currentInstallation.badge = 0;
            [currentInstallation saveEventually];
        }
    }
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
