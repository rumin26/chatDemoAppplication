//
//  ByMeTableViewCell.h
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ByMeTableViewCell : UITableViewCell

@property(strong, nonatomic)IBOutlet UIImageView *imgv_myImage;
@property(strong, nonatomic)IBOutlet UILabel *lbl_myText;
@property(strong, nonatomic)IBOutlet UILabel *lbl_myTextDate;

@property(strong, nonatomic)IBOutlet UITextView *txtview_myText;

@end
