//
//  LoginViewController.h
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController


@property(strong, nonatomic)IBOutlet UITextField *tf_username;
@property(strong, nonatomic)IBOutlet UITextField *tf_password;

-(IBAction)submitPressed:(id)sender;

@end
