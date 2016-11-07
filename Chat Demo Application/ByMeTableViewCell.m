//
//  ByMeTableViewCell.m
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import "ByMeTableViewCell.h"

@implementation ByMeTableViewCell
@synthesize lbl_myText, lbl_myTextDate, imgv_myImage,txtview_myText;

- (void)awakeFromNib {
    // Initialization code
//    lbl_myText.numberOfLines = 0;
//    [lbl_myText sizeToFit];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
