//
//  UsersViewController.m
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import "UsersViewController.h"
#import "ViewController.h"
#import "Parse/AppConstant.h"

@interface UsersViewController ()

@end

@implementation UsersViewController
@synthesize delegate;


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arr_users = [[NSMutableArray alloc]init];
//    arr_pfUsers = [[NSMutableArray alloc]init];
//    arr_objects = [[NSMutableArray alloc]init];
//    userIds = [[NSMutableArray alloc] init];
//    sections = [[NSMutableArray alloc]init];
    
    [self loadUsers];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return [arr_users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"cell"];
    
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
    
    
    PFUser *user = arr_users[indexPath.row];
    cell.textLabel.text = user[PF_USER_USERNAME];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ViewController *viewController = [[ViewController alloc]init];
//    [[NSUserDefaults standardUserDefaults]setValue:[arr_users objectAtIndex:indexPath.row] forKey:@"selectedUser"];
//    PFObject *object = [arr_objects objectAtIndex:indexPath.row];
//    
//    PFQuery * query1 = [PFUser query];
//    [query1 whereKey:@"objectId" equalTo:[object objectId]];
//
//    NSLog(@"Object id %@",[object objectId]);
////    PFQuery * query = [PFUser query];
////    [query whereKey:@"objectId" equalTo:@"A1B2Z3XX"];
//        arr_pfUsers = [[query1 findObjects] mutableCopy];
//    
//   // NSLog(@"results:%@",results);
//    
//    
//    NSLog(@"results:%@",[arr_pfUsers objectAtIndex:0]);
//    viewController.selectedPFUser = [arr_pfUsers objectAtIndex:0];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [self dismissViewControllerAnimated:YES completion:^{
        if (delegate != nil) [delegate didSelectSingleUser:arr_users[indexPath.row]];
    }];
    
//    [[NSUserDefaults standardUserDefaults] setObject:arr_pfUsers forKey:@"pfuser"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
   //[self.navigationController pushViewController:viewController animated:YES];
    
}

#pragma mark - Load Users
- (void)loadUsers

{
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query1 = [PFQuery queryWithClassName:PF_BLOCKED_CLASS_NAME];
    [query1 whereKey:PF_BLOCKED_USER1 equalTo:user];
    
    PFQuery *query2 = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
    [query2 whereKey:PF_USER_OBJECTID notEqualTo:user.objectId];
    [query2 whereKey:PF_USER_OBJECTID doesNotMatchKey:PF_BLOCKED_USERID2 inQuery:query1];
    [query2 orderByAscending:PF_USER_FULLNAME];
    [query2 setLimit:1000];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [arr_users removeAllObjects];
             [arr_users addObjectsFromArray:objects];
             [self.tbl_users reloadData];
         }
         else NSLog(@"Error");
     }];
}


#pragma mark - Back

-(IBAction)backbtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
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
