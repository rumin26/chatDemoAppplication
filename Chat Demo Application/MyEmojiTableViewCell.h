//
//  MyEmojiTableViewCell.h
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface MyEmojiTableViewCell : UITableViewCell
@property(strong, nonatomic)IBOutlet PFImageView *imgv_myUploadedImage;
@property(strong, nonatomic)IBOutlet UIImageView *imgv_myImage;
@end
