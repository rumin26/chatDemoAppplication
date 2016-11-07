//
//  SignUpViewController.h
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate>
{
    UIImage *pickedImage;
    
}

@property(strong, nonatomic)IBOutlet UITextField *tf_username;
@property(strong, nonatomic)IBOutlet UITextField *tf_email;
@property(strong, nonatomic)IBOutlet UITextField *tf_password;

@property(strong, nonatomic)IBOutlet UIButton *btn_addImage;

-(IBAction)signUpPressed:(id)sender;
@end
