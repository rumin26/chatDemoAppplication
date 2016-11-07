//
//  UsersViewController.h
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@protocol SelectSingleUserDelegate
- (void)didSelectSingleUser:(PFUser *)user;

@end

@interface UsersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *arr_users;
//    NSArray *arr_pfUsers;
//    NSMutableArray *arr_objects;
//    NSMutableArray *userIds;
//    NSMutableArray *sections;
}
@property(strong, nonatomic)IBOutlet UITableView *tbl_users;
@property (nonatomic, assign) id<SelectSingleUserDelegate>delegate;

@end
