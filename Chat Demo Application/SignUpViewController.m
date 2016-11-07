//
//  SignUpViewController.m
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import "SignUpViewController.h"
#import "ViewController.h"
#import "UsersViewController.h"
#import "SelectedUsersViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController
#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tf_password setDelegate:self];
    [self.tf_username setDelegate:self];
    [self.tf_email setDelegate:self];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma -mark SignUp

-(IBAction)signUpPressed:(id)sender
{
    PFUser *user = [PFUser user];
    user.username = self.tf_username.text;
    user.password = self.tf_password.text;
    user.email = self.tf_email.text;
    
    
    // other fields can be set just like with PFObject
    //user[@"phone"] = @"415-392-0202";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            SelectedUsersViewController *vc = [[SelectedUsersViewController alloc]init];
            
                // Convert to JPEG with 50% quality
                NSData* data = UIImageJPEGRepresentation(pickedImage, 0.5f);
                PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
                user[@"uploadedImage"] = imageFile;
            
                // Save the image to Parse
            
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error)
                    {
                        
                        // The object has been saved.
                        NSLog(@"saved");
                       [self.navigationController pushViewController:vc animated:YES];
            
        
                    }
                    else
                            
                    {
                        // There was a problem, check error.description
                        
                    }

                }];

           
            
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString;
            errorString= [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
        }
    }];
}

#pragma mark - Pick Image
-(IBAction)addImagePressed:(id)sender
{
    UIActionSheet *mediaSheet = [[UIActionSheet alloc]initWithTitle:@"What you want to do?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Picture From Library",@"Take Picture From Camera", nil];
    
    [mediaSheet showInView:self.view];
    
    
}

#pragma mark - UIActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
        
        else
        {
            NSLog(@"No Camera");
        }
        
    }
    else if(buttonIndex == 0)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    else
        return;
    
}
#pragma mark - UIImagePicker
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    pickedImage = info[UIImagePickerControllerOriginalImage];
    
    [self.btn_addImage setImage:pickedImage forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Back Button
-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIText Field

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
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
