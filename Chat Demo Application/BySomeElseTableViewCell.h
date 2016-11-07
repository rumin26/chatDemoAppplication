//
//  BySomeElseTableViewCell.h
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface BySomeElseTableViewCell : UITableViewCell

@property(strong, nonatomic)IBOutlet UIImageView *imgv_someoneImage;
@property(strong, nonatomic)IBOutlet UILabel *lbl_someoneText;
@property(strong, nonatomic)IBOutlet UILabel *lbl_someoneTextDate;

@end
