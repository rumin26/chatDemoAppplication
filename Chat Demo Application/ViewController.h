//
//  ViewController.h
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

//#import "UIBubbleTableViewDataSource.h"
#import "IQAudioRecorderController.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "UIBubbleTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"
#import <Bolts/Bolts.h>
#import "FullyHorizontalFlowLayout.h"

//#define MAX_ENTRIES_LOADED 25

@interface ViewController : UIViewController<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate,IQAudioRecorderControllerDelegate, UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

{
    ///Arrays
    NSMutableArray *arr_userName;
    NSMutableArray *arr_text;
    NSMutableArray *arr_date;
    NSMutableArray *arr_receiverUserName;
    NSMutableArray *arr_uploadedimages;
    NSMutableArray *arr_uploadedaudios;
    NSMutableArray *arr_audioTime;
    NSMutableArray *arr_emojis;
    NSMutableArray *arr_uploadedemojis;
    
    
    ///Strings
    NSString *className;
    NSString *userName;
    NSString *selectedUser;
    NSString *audioFilePath;
    NSString *groupId;
    
    ///PFUser
    PFUser *selectedPFUser;
    
    ///UIImages
    UIImage *uploadedImage;
    UIImage *selectedUserUploadedImage;
    UIImage *tappedImage;
    
    
    ///NSTimer
    NSTimer *timer;
    
    
    ///CGPoint
    CGPoint point;
    
    
    ///AVAudio Player
    AVAudioPlayer *player;
    

    ///CGRect
    CGRect txtView_oldFrame;
    
    
    ///Reachability
    Reachability * localWiFiReach;
    

}

@property(strong,nonatomic)IBOutlet UITableView *chatTableView;

@property(strong, nonatomic)IBOutlet UIView *textFieldView;
@property(strong, nonatomic)IBOutlet UIView *fullView;
@property(strong, nonatomic)IBOutlet UIView *emojiView;
@property(strong, nonatomic)IBOutlet UIView *emojiBottomView;
@property(strong, nonatomic)IBOutlet UIView *emojiPreviewView;


@property(strong, nonatomic)IBOutlet UIImageView *fullImageView;
@property(strong, nonatomic)IBOutlet UIImageView *emojiPreviewImageView;

@property(strong,nonatomic)IBOutlet UITextField *messageTextField;

@property(strong,nonatomic) PFUser *selectedPFUser;

@property(strong, nonatomic)IBOutlet UITextView *txtview_message;

@property(strong, nonatomic)IBOutlet UIButton *logoutBtn;

@property(strong, nonatomic)IBOutlet UICollectionView *collectionView;
@property(strong, nonatomic)IBOutlet UICollectionViewFlowLayout *collectionViewflowLayout;

@property(strong, nonatomic)IBOutlet UIScrollView *scrollView;

@property(strong, nonatomic) UIPageControl *pageControl;


@property(strong, nonatomic)IBOutlet UILabel *lbl_aegos;
@property(strong, nonatomic)IBOutlet UILabel *lbl_moods;
@property(strong, nonatomic)IBOutlet UILabel *lbl_foods;

//Methods
-(void) registerForKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification*)aNotification;
-(void) keyboardWillHide:(NSNotification*)aNotification;
- (id)initWith:(NSString *)groupId_;
@end

