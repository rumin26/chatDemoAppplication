//
//  MyAudioTableViewCell.h
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MyAudioTableViewCell : UITableViewCell

@property(strong, nonatomic)IBOutlet UIImageView *imgv_myImage;

@property(strong, nonatomic)IBOutlet UILabel *lbl_myaudioTime;
@property(strong, nonatomic)IBOutlet UILabel *lbl_myTextDate;

@end
