//
//  LoginViewController.m
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import "LoginViewController.h"
#import "ViewController.h"
#import "SignUpViewController.h"
#import "UsersViewController.h"
#import "ByMeTableViewCell.h"
#import "SelectedUsersViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Submit
-(IBAction)submitPressed:(id)sender
{
    SelectedUsersViewController *viewController = [[SelectedUsersViewController alloc]init];
    
    
    [[NSUserDefaults standardUserDefaults]setValue:self.tf_username.text forKey:@"userName"];
    
    [PFUser logInWithUsernameInBackground:self.tf_username.text password:self.tf_password.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            
                                            PFInstallation *installation = [PFInstallation currentInstallation];
                                            installation[PF_INSTALLATION_USER] = [PFUser currentUser];
                                            [installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                                             {
                                                 if (error != nil)
                                                 {
                                                     NSLog(@"ParsePushUserAssign save error.");
                                                 }
                                             }];

                                            [self.navigationController pushViewController:viewController animated:YES];
                                        } else {
                                            // The login failed. Check error to see why.
                                        }
                                    }];

    
    
    
    
    
    
    
}
#pragma mark - SignUp

-(IBAction)signUpPressed:(id)sender
{
    SignUpViewController *signupVC = [[SignUpViewController alloc]init];
    [self.navigationController pushViewController:signupVC animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
