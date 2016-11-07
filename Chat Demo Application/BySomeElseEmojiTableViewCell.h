//
//  BySomeElseEmojiTableViewCell.h
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface BySomeElseEmojiTableViewCell : UITableViewCell

@property(strong, nonatomic)IBOutlet PFImageView *imgv_someoneUploadedImage;
@property(strong, nonatomic)IBOutlet UIImageView *imgv_someoneImage;
@end
