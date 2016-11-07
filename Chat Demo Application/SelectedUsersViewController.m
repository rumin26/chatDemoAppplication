//
//  SelectedUsersViewController.m
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import "SelectedUsersViewController.h"
#import "ViewController.h"


@interface SelectedUsersViewController ()

@end

@implementation SelectedUsersViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arr_users = [[NSMutableArray alloc]init];
    arr_userIds = [[NSMutableArray alloc] init];
    arr_sections = [[NSMutableArray alloc]init];
    
    [self fetchUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetch Users
-(void)fetchUsers
{
    //    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    //
    //
    //
    //
    //
    //    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    //        // Do something with the returned PFObject.
    //        NSLog(@"%@", objects);
    //        arr_users = [[objects valueForKey:@"username"]mutableCopy];
    //        arr_objects = [objects mutableCopy];
    //
    //
    //
    ////        NSLog(@"arr:%@",arr_pfUsers);
    //
    //
    //        PFUser *user = [PFUser currentUser];
    //        NSLog(@"Currentuser%@",user.username);
    //        int i;
    //        int remove_index = 0;
    //
    //        for (i=0; i< arr_users.count; i++) {
    //
    //            if([[arr_users objectAtIndex:i] isEqualToString:user.username])
    //            {
    //                remove_index = i;
    //                [arr_users removeObject:user.username];
    //
    //            }
    //        }
    //
    //        [arr_objects removeObjectAtIndex:remove_index];
    //
    //        NSLog(@"arr_users:%@", arr_users);
    //        NSLog(@"arr_objects:%@",arr_objects);
    //
    //
    //        [self.tbl_users reloadData];
    //    }];
    
    PFQuery *query = [PFQuery queryWithClassName:PF_PEOPLE_CLASS_NAME];
    [query whereKey:PF_PEOPLE_USER1 equalTo:[PFUser currentUser]];
    [query includeKey:PF_PEOPLE_USER2];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [arr_users removeAllObjects];
             [arr_userIds removeAllObjects];
             for (PFObject *people in objects)
             {
                 PFUser *user = people[PF_PEOPLE_USER2];
                 [arr_users addObject:user];
                 [arr_userIds addObject:user.objectId];
             }
             [self setObjects:arr_users];
             [self.tbl_selectedUsers reloadData];
         }
         else NSLog(@"Error");
     }];
    
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return [arr_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [arr_sections[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    NSMutableArray *userstemp = arr_sections[indexPath.section];
    PFUser *user = userstemp[indexPath.row];
    cell.textLabel.text = user[PF_USER_USERNAME];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PFUser *user1 = [PFUser currentUser];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    NSMutableArray *userstemp = arr_sections[indexPath.section];
    PFUser *user2 = userstemp[indexPath.row];
    
    NSLog(@"selectedUsername:%@",user2.username);
    
    [[NSUserDefaults standardUserDefaults]setValue:user2.username forKey:@"selectedUser"];
    NSString *groupId = StartPrivateChat(user1, user2);
    ViewController *vc = [[ViewController alloc]initWith:groupId];
    vc.selectedPFUser = userstemp[indexPath.row];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    
    NSLog(@"groupId:%@",groupId);
    
    
   
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

#pragma mark - Add User
-(IBAction)addUserPressed:(id)sender
{
    UsersViewController *userVC = [[UsersViewController alloc]init];
    userVC.delegate = self;
    
    [self presentViewController:userVC animated:YES completion:nil];
    
}

#pragma mark - SelectSingleDelegate & Methods

- (void)didSelectSingleUser:(PFUser *)user
{
    [self addUser:user];
}

- (void)addUser:(PFUser *)user
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if ([arr_userIds containsObject:user.objectId] == NO)
    {
        PeopleSave([PFUser currentUser], user);
        [arr_users addObject:user];
        [arr_userIds addObject:user.objectId];
        [self setObjects:arr_users];
        [self.tbl_selectedUsers reloadData];
    }
}

- (void)setObjects:(NSArray *)objects
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (arr_sections != nil) [arr_sections removeAllObjects];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    NSInteger sectionTitlesCount = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
    arr_sections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    for (NSUInteger i=0; i<sectionTitlesCount; i++)
    {
        [arr_sections addObject:[NSMutableArray array]];
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    NSArray *sorted = [objects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                       {
                           PFUser *user1 = (PFUser *)obj1;
                           PFUser *user2 = (PFUser *)obj2;
                           return [user1[PF_USER_USERNAME] compare:user2[PF_USER_USERNAME]];
                       }];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    for (PFUser *object in sorted)
    {
        NSInteger section = [[UILocalizedIndexedCollation currentCollation] sectionForObject:object collationStringSelector:@selector(username)];
        [arr_sections[section] addObject:object];
    }
}

- (NSString *)username
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return PF_USER_USERNAME;
}


void PeopleSave(PFUser *user1, PFUser *user2)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [PFQuery queryWithClassName:PF_PEOPLE_CLASS_NAME];
    [query whereKey:PF_PEOPLE_USER1 equalTo:user1];
    [query whereKey:PF_PEOPLE_USER2 equalTo:user2];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             if ([objects count] == 0)
             {
                 PFObject *object = [PFObject objectWithClassName:PF_PEOPLE_CLASS_NAME];
                 object[PF_PEOPLE_USER1] = user1;
                 object[PF_PEOPLE_USER2] = user2;
                 [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                  {
                      if (error != nil) NSLog(@"PeopleSave save error.");
                  }];
             }
         }
         else NSLog(@"PeopleSave query error.");
     }];
}

#pragma mark - Start Chat
NSString* StartPrivateChat(PFUser *user1, PFUser *user2)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSString *id1 = user1.objectId;
    NSString *id2 = user2.objectId;
    //---------------------------------------------------------------------------------------------------------------------------------------------
    NSString *groupId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@", id1, id2] : [NSString stringWithFormat:@"%@%@", id2, id1];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    NSArray *members = @[user1.objectId, user2.objectId];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    CreateRecentItem(user1, groupId, members, user2[PF_USER_USERNAME]);
    CreateRecentItem(user2, groupId, members, user1[PF_USER_USERNAME]);
    //---------------------------------------------------------------------------------------------------------------------------------------------
    return groupId;
}

void CreateRecentItem(PFUser *user, NSString *groupId, NSArray *members, NSString *description)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
    [query whereKey:PF_RECENT_USER equalTo:user];
    [query whereKey:PF_RECENT_GROUPID equalTo:groupId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             if ([objects count] == 0)
             {
                 PFObject *recent = [PFObject objectWithClassName:PF_RECENT_CLASS_NAME];
                 recent[PF_RECENT_USER] = user;
                 recent[PF_RECENT_GROUPID] = groupId;
                 recent[PF_RECENT_MEMBERS] = members;
                 recent[PF_RECENT_DESCRIPTION] = description;
                 recent[PF_RECENT_LASTUSER] = [PFUser currentUser];
                 recent[PF_RECENT_LASTMESSAGE] = @"";
                 recent[PF_RECENT_COUNTER] = @0;
                 recent[PF_RECENT_UPDATEDACTION] = [NSDate date];
                 [recent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                  {
                      if (error != nil) NSLog(@"CreateRecentItem save error.");
                  }];
             }
         }
         else NSLog(@"CreateRecentItem query error.");
     }];
}


#pragma mark - Back Button 
-(IBAction)backbtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
