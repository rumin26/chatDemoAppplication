//
//  AppDelegate.h
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    PFInstallation *currentInstallation;
    
}
@property (strong, nonatomic) UIWindow *window;


@end

