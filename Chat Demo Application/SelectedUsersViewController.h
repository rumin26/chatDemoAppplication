//
//  SelectedUsersViewController.h
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Parse/AppConstant.h"
#import "UsersViewController.h"

@interface SelectedUsersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SelectSingleUserDelegate>
{
    NSMutableArray *arr_userIds;
    NSMutableArray *arr_sections;
    NSMutableArray *arr_users;
}

@property(strong,nonatomic)IBOutlet UITableView *tbl_selectedUsers;

@end
