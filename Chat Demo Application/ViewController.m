//
//  ViewController.m
//  Chat Demo Application
//
//  Created by Rumin Shah on 11/6/15.
//  Copyright © 2016 Rumin Shah. All rights reserved.
//


#import "ViewController.h"
#import "Parse/AppConstant.h"
//#import "UIBubbleTableView.h"
//#import "UIBubbleTableViewDataSource.h"
//#import "NSBubbleData.h"
#import "ByMeTableViewCell.h"
#import "BySomeElseTableViewCell.h"
#import "ByMeImageTableViewCell.h"
#import "BySomeElseImageTableViewCell.h"
#import "BySomeElseAudioTableViewCell.h"
#import "MyAudioTableViewCell.h"
#import "LoginViewController.h"
//#import "SelectedUsersViewController.h"
#import "MyEmojiTableViewCell.h"
#import "BySomeElseEmojiTableViewCell.h"


#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface ViewController ()

@end

@implementation ViewController
@synthesize selectedPFUser;

#pragma mark - View Life Cycle

- (id)initWith:(NSString *)groupId_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    groupId = groupId_;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.messageTextField.delegate = self;
    self.messageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self registerForKeyboardNotifications];

    arr_date = [[NSMutableArray alloc]init];
    arr_text = [[NSMutableArray alloc]init];
    arr_userName = [[NSMutableArray alloc]init];
    arr_receiverUserName = [[NSMutableArray alloc]init];
    arr_uploadedimages = [[NSMutableArray alloc]init];
    arr_uploadedaudios = [[NSMutableArray alloc]init];
    arr_audioTime = [[NSMutableArray alloc]init];
    arr_emojis = [[NSMutableArray alloc]init];
    arr_uploadedemojis = [[NSMutableArray alloc]init];
    
    
    self.fullView.hidden = YES;
    self.fullImageView.hidden  = YES;
    self.chatTableView.estimatedRowHeight = 150;
    self.chatTableView.rowHeight = UITableViewAutomaticDimension;
    self.txtview_message.delegate = self;
    self.txtview_message.clipsToBounds = YES;
    self.txtview_message.layer.cornerRadius = 5.0f;
    self.txtview_message.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.txtview_message setKeyboardAppearance:UIKeyboardAppearanceAlert];
    
    self.scrollView.contentSize = CGSizeMake(530, 42);
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"emojiscollection"];
//    FullyHorizontalFlowLayout *collectionViewLayout = [FullyHorizontalFlowLayout new];
//    
//    collectionViewLayout.itemSize = CGSizeMake(43, 43);
//    //collectionViewLayout.nbColumns = 5;
//    //collectionViewLayout.nbLines = 3;
//    
//    [self.collectionView setCollectionViewLayout:collectionViewLayout];
//    
//    self.collectionView.pagingEnabled = YES;
//
    
    UITapGestureRecognizer *tap_lbl_aegos = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lbl_aegos_tapped)];
    tap_lbl_aegos.delegate = self;
    self.lbl_aegos.userInteractionEnabled = YES;
    [self.lbl_aegos addGestureRecognizer:tap_lbl_aegos];
    
    UITapGestureRecognizer *tap_lbl_moods = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lbl_moods_tapped)];
    tap_lbl_moods.delegate = self;
    self.lbl_moods.userInteractionEnabled = YES;
    [self.lbl_moods addGestureRecognizer:tap_lbl_moods];
    
    
    UITapGestureRecognizer *tap_lbl_foods = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lbl_foods_tapped)];
    tap_lbl_foods.delegate = self;
    self.lbl_foods.userInteractionEnabled = YES;
    [self.lbl_foods addGestureRecognizer:tap_lbl_foods];
    
    [self lbl_aegos_tapped];
    
 }

-(void)viewWillAppear:(BOOL)animated
{
    //[self.collectionViewflowLayout invalidateLayout];
    className = @"ChatRoom";
    
    //selectedPFUser = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedPFUser"];
    
    
    
    ///For Selected User Data
    
    
    NSLog(@"selectedUser:%@",selectedPFUser.username);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self fetchUserData];
        
    });
    
    
    
    
    ///For Login User Data
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidAppear:animated];
    
   
//  UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onListTap:)];
//    
//    [self.chatTableView addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Chat TextView

-(IBAction) textViewdDoneEditing : (id) sender
{
    NSLog(@"the text content%@",self.messageTextField.text);
    [sender resignFirstResponder];
    [self.messageTextField resignFirstResponder];
}

-(IBAction) backgroundTap:(id) sender
{
    [self.self.messageTextField resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
//    CGFloat fixedWidth = textView.frame.size.width;
//    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
//    CGRect newFrame = textView.frame;
//    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//    newFrame.origin.y = textView.frame.size.height - newSize.height;
//    textView.frame = newFrame;
    
    if ([textView.text hasSuffix:@"\n"]) {
        
        [CATransaction setCompletionBlock:^{
            [self scrollToCaretInTextView:textView animated:NO];
        }];
        
    } else {
        [self scrollToCaretInTextView:textView animated:NO];
    }
}

- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    
    
    [textView scrollRectToVisible:rect animated:animated];
}

//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    CGRect textViewFrame = self.txtview_message.frame;
//    //textViewFrame.origin.y -=30;
//    [textView scrollRectToVisible:CGRectMake(0,0,1,1) animated:YES];
//    textView.frame = textViewFrame;
//    
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    //CGRect textViewFrame = CGRectInset(self.textFieldView.bounds, 20.0, 20.0);
//    CGRect textViewFrame = self.txtview_message.frame;
//    self.txtview_message.frame = textViewFrame;
//    [self.txtview_message endEditing:YES];
//    [super touchesBegan:touches withEvent:event];
//}

-(void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void) freeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void) keyboardWasShown:(NSNotification*)aNotification
{
    NSLog(@"Keyboard was shown");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
//    UIEdgeInsets inset = self.txtview_message.contentInset;
//    inset.bottom = keyboardFrame.size.height;
//    self.txtview_message.contentInset = inset;
//    self.txtview_message.scrollIndicatorInsets = inset;
//    
//    [self scrollToCaretInTextView:self.txtview_message animated:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y- keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    //self.chatTableView.frame= CGRectMake(self.chatTableView.frame.origin.x, self.chatTableView.frame.origin.y - keyboardFrame.size.height, self.chatTableView.frame.size.width, self.chatTableView.frame.size.height);
    
    int lastRowNumber = [self.chatTableView numberOfRowsInSection:0] - 1;
    
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [UIView commitAnimations];
    
}

-(void) keyboardWillHide:(NSNotification*)aNotification
{
    NSLog(@"Keyboard will hide");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"count:%lu", (unsigned long)[chatData count]);
    
    return arr_text.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *myArrayElement = [arr_receiverUserName objectAtIndex:indexPath.row];
    //do something useful with myArrayElement
//    NSLog(@"myarrayelement:%@",myArrayElement);
//    NSLog(@"login: %@",userName);
    
    if(![myArrayElement isEqualToString:userName])
    {
        
        if([[arr_text objectAtIndex:indexPath.row] isEqualToString:@"Image Attachment"])
        {
            ByMeImageTableViewCell *cell = (ByMeImageTableViewCell *)[self.chatTableView dequeueReusableCellWithIdentifier: @"myimagecell"];
            
            if (cell == nil) {
                
                [tableView registerNib:[UINib nibWithNibName:@"ByMeImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"myimagecell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"myimagecell"];
                
            }

            cell.backgroundColor = [UIColor greenColor];
            
            
            return cell;
            
            
        }
        
        else if([[arr_text objectAtIndex:indexPath.row]isEqualToString:@"Audio Attachment"])
        {
            MyAudioTableViewCell *cell = (MyAudioTableViewCell *)[self.chatTableView dequeueReusableCellWithIdentifier: @"myaudiocell"];
            
            if (cell == nil) {
                [tableView registerNib:[UINib nibWithNibName:@"MyAudioTableViewCell" bundle:nil] forCellReuseIdentifier:@"myaudiocell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"myaudiocell"];
            }
            
            
            
            return cell;
            
        }
        
        else if ([[arr_text objectAtIndex:indexPath.row]isEqualToString:@"Emoji Attachment"])
        {
            MyEmojiTableViewCell *cell = (MyEmojiTableViewCell *)[self.chatTableView dequeueReusableCellWithIdentifier: @"myemojicell"];
            
            if (cell == nil) {
                
                [tableView registerNib:[UINib nibWithNibName:@"MyEmojiTableViewCell" bundle:nil] forCellReuseIdentifier:@"myemojicell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"myemojicell"];
                
            }
            
            PFFile *imageFile = [arr_uploadedimages objectAtIndex:indexPath.row];
            cell.imgv_myUploadedImage.file = imageFile;
            
            [cell.imgv_myUploadedImage loadInBackground];
            cell.imgv_myImage.image = uploadedImage;
            
            return cell;
        }
        else
        {
            ByMeTableViewCell *cell = [self.chatTableView dequeueReusableCellWithIdentifier: @"mycell"];
            
            if (cell == nil) {
                [tableView registerNib:[UINib nibWithNibName:@"ByMeTableViewCell" bundle:nil] forCellReuseIdentifier:@"mycell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
            }
            
            
            if ([cell.contentView subviews]){
                for (UIView *subview in [cell.contentView subviews]) {
                    [subview removeFromSuperview];
                }
            }
            cell.backgroundColor = [UIColor blueColor];
            
            
            /// Return Cell
            return cell;
            
        }

    }
    
    else
    {
        if([[arr_text objectAtIndex:indexPath.row] isEqualToString:@"Image Attachment"])
        {
            BySomeElseImageTableViewCell *cell = (BySomeElseImageTableViewCell *)[self.chatTableView dequeueReusableCellWithIdentifier: @"someoneimagecell"];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BySomeElseImageTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            PFFile *imageFile = [arr_uploadedimages objectAtIndex:indexPath.row];
            
            cell.imgv_someoneUploadedImage.file = imageFile;
            [cell.imgv_someoneUploadedImage loadInBackground];
            cell.imgv_someoneImage.image = selectedUserUploadedImage;
            
            return cell;
            
            
        }
        
        else if([[arr_text objectAtIndex:indexPath.row]isEqualToString:@"Audio Attachment"])
        {
            BySomeElseAudioTableViewCell *cell = (BySomeElseAudioTableViewCell *)[self.chatTableView dequeueReusableCellWithIdentifier: @"someoneaudiocell"];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BySomeElseAudioTableViewCell" owner:self options:nil];
                            cell = [nib objectAtIndex:0];
            }
    
           
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *stringFromDate = [formatter stringFromDate:[arr_date objectAtIndex:indexPath.row]];
            
            cell.lbl_someoneTextDate.text = stringFromDate;
            cell.lbl_someoneaudioTime.text = [arr_audioTime objectAtIndex:indexPath.row];
            cell.imgv_someoneImage.image = selectedUserUploadedImage;

            return cell;
        }
        
        else if ([[arr_text objectAtIndex:indexPath.row]isEqualToString:@"Emoji Attachment"])
        {
            BySomeElseEmojiTableViewCell *cell = (BySomeElseEmojiTableViewCell *)[self.chatTableView dequeueReusableCellWithIdentifier: @"someoneemojicell"];
            
            if (cell == nil) {
                
                [tableView registerNib:[UINib nibWithNibName:@"BySomeElseEmojiTableViewCell" bundle:nil] forCellReuseIdentifier:@"someoneemojicell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"someoneemojicell"];
                
            }
            
            PFFile *imageFile = [arr_uploadedimages objectAtIndex:indexPath.row];
            cell.imgv_someoneUploadedImage.file = imageFile;
            
            [cell.imgv_someoneUploadedImage loadInBackground];
            cell.imgv_someoneImage.image = selectedUserUploadedImage;
            
            return cell;
        }

        else
        {
            BySomeElseTableViewCell *cell = (BySomeElseTableViewCell *)[self.chatTableView dequeueReusableCellWithIdentifier: @"someonecell"];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BySomeElseTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            if ([cell.contentView subviews]){
                for (UIView *subview in [cell.contentView subviews]) {
                    [subview removeFromSuperview];
                }
            }
            /// Set Text Label
            
            UILabel *lbl_myText = [[UILabel alloc]initWithFrame:CGRectZero];
            [lbl_myText setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_myText.minimumScaleFactor = FONT_SIZE;
            [lbl_myText setNumberOfLines:0];
            lbl_myText.textAlignment = NSTextAlignmentLeft;
            [lbl_myText setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            
            NSString *text = [arr_text objectAtIndex:indexPath.row];
            
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]];
            
            // Checks if text is multi-line
            if (size.width > lbl_myText.bounds.size.width)
            {
                CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
                
                CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
                
                [lbl_myText setText:text];
                [lbl_myText setFrame:CGRectMake(cell.imgv_someoneImage.frame.size.width+8, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - cell.imgv_someoneImage.frame.size.width -(CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
            }
            
            else
            {
                lbl_myText.frame = CGRectMake(10, 0, cell.frame.size.width - cell.imgv_someoneImage.frame.size.width - 18,18);
                lbl_myText.textAlignment = NSTextAlignmentLeft;
                [lbl_myText setText:text];
            }
            
            //lbl_myText.backgroundColor = [UIColor greenColor];
            
            [cell.contentView addSubview:lbl_myText];
            
            /// Set Date Label
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *stringFromDate = [formatter stringFromDate:[arr_date objectAtIndex:indexPath.row]];
            
            UILabel *lbl_myDate = [[UILabel alloc]initWithFrame:CGRectMake(cell.imgv_someoneImage.frame.size.width+8, lbl_myText.frame.size.height+10, cell.frame.size.width - cell.imgv_someoneImage.frame.size.width - 10 ,18)];
            lbl_myDate.text = stringFromDate;
            lbl_myDate.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0];
            lbl_myDate.textColor = [UIColor lightGrayColor];
            lbl_myDate.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lbl_myDate];
            
            /// Set User Image
            
            UIImageView *imgv_myImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, lbl_myText.frame.origin.y, 63, 63)];
            imgv_myImage.image = selectedUserUploadedImage;
            
            [cell.contentView addSubview:imgv_myImage];
            
            
            /// Return Cell
            return cell;
        }

    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *myArrayElement = [arr_receiverUserName objectAtIndex:indexPath.row];
    if(![myArrayElement isEqualToString:userName])
    {
        
        if([[arr_text objectAtIndex:indexPath.row] isEqualToString:@"Image Attachment"])
        {
            //ByMeImageTableViewCell *myimagecell = (ByMeImageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            
            
            ///Set User Photo
            UIImageView *imgv_myImage = [[UIImageView alloc]initWithFrame:CGRectMake(((ByMeImageTableViewCell *) cell).contentView.frame.size.width - 63, ((ByMeImageTableViewCell *) cell).contentView.frame.size.height-63, 63, 63)];
            imgv_myImage.image = uploadedImage;
            imgv_myImage.image = [UIImage imageNamed:@"mood1"];
            [((ByMeImageTableViewCell *) cell).contentView addSubview:imgv_myImage];
            
            
            ///Set Uploaded Image
            PFImageView *imageView = [[PFImageView alloc]initWithFrame:CGRectMake(((ByMeImageTableViewCell *) cell).contentView.frame.size.width - imgv_myImage.frame.size.width - 10-141, ((ByMeImageTableViewCell *) cell).contentView.frame.size.height-141, 141 , 141)];
            
            PFFile *imageFile = [arr_uploadedimages objectAtIndex:indexPath.row];
            imageView.file = imageFile;
            
            [imageView loadInBackground];
            
            [((ByMeImageTableViewCell *) cell).contentView addSubview:imageView];
            //((ByMeImageTableViewCell *) cell).
            
        }
        
        else if([[arr_text objectAtIndex:indexPath.row]isEqualToString:@"Audio Attachment"])
        {
            //MyAudioTableViewCell *myaudiocell = (MyAudioTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            /// Set Date Label
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *stringFromDate = [formatter stringFromDate:[arr_date objectAtIndex:indexPath.row]];
            
            UILabel *lbl_myDate = [[UILabel alloc]initWithFrame:CGRectMake(0, ((MyAudioTableViewCell *) cell).contentView.frame.size.height-10-18, ((MyAudioTableViewCell *) cell).frame.size.width - 63 - 10 ,18)];
            lbl_myDate.text = stringFromDate;
            lbl_myDate.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0];
            lbl_myDate.textColor = [UIColor lightGrayColor];
            lbl_myDate.textAlignment = NSTextAlignmentRight;
            [((MyAudioTableViewCell *) cell).contentView addSubview:lbl_myDate];
            
            ////
            ((MyAudioTableViewCell *) cell).lbl_myaudioTime.text = [arr_audioTime objectAtIndex:indexPath.row];
            ((MyAudioTableViewCell *) cell).imgv_myImage.image = uploadedImage;
        }
        
        else
        {
            //ByMeTableViewCell *mytextcell = (ByMeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            /// Set Text Label
            
            UILabel *lbl_myText = [[UILabel alloc]initWithFrame:CGRectZero];
            [lbl_myText setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_myText.minimumScaleFactor = FONT_SIZE;
            [lbl_myText setNumberOfLines:0];
            lbl_myText.textAlignment = NSTextAlignmentRight;
            [lbl_myText setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            
            NSString *text = [arr_text objectAtIndex:indexPath.row];
            
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]];
            
            // Checks if text is multi-line
            if (size.width > lbl_myText.bounds.size.width)
            {
                CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
                
                CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
                
                [lbl_myText setText:text];
                [lbl_myText setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, self.view.frame.size.width - ((ByMeTableViewCell *) cell).imgv_myImage.frame.size.width -(CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
            }
            
            else
            {
                lbl_myText.frame = CGRectMake(10, 0, self.view.frame.size.width - ((ByMeTableViewCell *) cell).imgv_myImage.frame.size.width - 18,18);
                lbl_myText.textAlignment = NSTextAlignmentRight;
                [lbl_myText setText:text];
            }
            
            //lbl_myText.backgroundColor = [UIColor greenColor];
            
            [((ByMeTableViewCell *) cell).contentView addSubview:lbl_myText];
            
            /// Set Date Label
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *stringFromDate = [formatter stringFromDate:[arr_date objectAtIndex:indexPath.row]];
            
            UILabel *lbl_myDate = [[UILabel alloc]initWithFrame:CGRectMake(0, lbl_myText.frame.size.height+10, ((ByMeTableViewCell *) cell).frame.size.width - ((ByMeTableViewCell *) cell).imgv_myImage.frame.size.width - 10 ,18)];
            lbl_myDate.text = stringFromDate;
            lbl_myDate.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0];
            lbl_myDate.textColor = [UIColor lightGrayColor];
            lbl_myDate.textAlignment = NSTextAlignmentRight;
            [((ByMeTableViewCell *) cell).contentView addSubview:lbl_myDate];
            
            /// Set User Image
            
            UIImageView *imgv_myImage = [[UIImageView alloc]initWithFrame:CGRectMake(((ByMeTableViewCell *) cell).contentView.frame.size.width - 63, lbl_myText.frame.origin.y, 63, 63)];
            imgv_myImage.image = uploadedImage;
            
            [((ByMeTableViewCell *) cell).contentView addSubview:imgv_myImage];
            

        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([[arr_text objectAtIndex:indexPath.row] isEqualToString:@"Image Attachment"])
    {
        return 150;
    }
    
    else if ([[arr_text objectAtIndex:indexPath.row] isEqualToString:@"Audio Attachment"] || [[arr_text objectAtIndex:indexPath.row] isEqualToString:@"Emoji Attachment"])
    {
        return 74;
    }
    
    else
    {
        NSString *cellText = [arr_text objectAtIndex:indexPath.row];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *cellDate = [formatter stringFromDate:[arr_date objectAtIndex:indexPath.row]];
        
       // NSString *text = [items objectAtIndex:[indexPath row]];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize labelsize = [cellText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize datelabelsize = [cellDate sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(labelsize.height + datelabelsize.height, 64.0f);
        
        if(height == 64.0f)
        {
           return 74;
        }
        
        else
        {
            return height + 10;
        }
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[arr_text objectAtIndex:indexPath.row]isEqualToString:@"Audio Attachment"])
    {
        
         PFFile *audioFile = [arr_uploadedaudios objectAtIndex:indexPath.row];
        
        [audioFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
            if(!error){
                player = [[AVAudioPlayer alloc] initWithData:result error:nil];
                [player setDelegate:self];
                [player play];
            } else{
                NSLog(@"ERROR!"); 
            } 
        }];
    }
    
    else if ([[arr_text objectAtIndex:indexPath.row]isEqualToString:@"Image Attachment"])
    {
        PFFile *imageFile = [arr_uploadedimages objectAtIndex:indexPath.row];
        [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
            if(!error){
                self.fullImageView.image = [UIImage imageWithData:result];
                self.fullImageView.alpha = 1.0;
                self.fullImageView.contentMode = UIViewContentModeScaleAspectFit;
                self.fullImageView.hidden = NO;
                self.fullView.hidden = NO;
                
            } else{
                NSLog(@"ERROR!");
            }
        }];
    }
        
}

#pragma mark - UICollection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arr_emojis.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emojiscollection" forIndexPath:indexPath];
    [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 43, 43)];
    
    NSLog(@"Image name:%@",[arr_emojis objectAtIndex:indexPath.row]);
    
    imgView.image = [UIImage imageNamed:[arr_emojis objectAtIndex:indexPath.row]];
    //cell.backgroundColor = [UIColor purpleColor];
    [cell.contentView addSubview:imgView];
    
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.emojiPreviewView.hidden = NO;
    self.emojiPreviewImageView.image = [UIImage imageNamed:[arr_emojis objectAtIndex:indexPath.row]];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
//    CGFloat pageWidth1 = self.collectionView.frame.size.width;
//    self.pageControl.currentPage = pageWidth1 / self.collectionView.contentOffset.x;
//    NSLog(@"pageoffset:%f",self.collectionView.contentOffset.x);
//    
//
//// self.pageControl.currentPage = [[[self.collectionView indexPathsForVisibleItems] firstObject] row];
    CGFloat pageWidth = self.collectionView.frame.size.width;
    self.pageControl.currentPage = self.collectionView.contentOffset.x / pageWidth;
    
    
    NSLog(@"currentpage:%ld", (long)self.pageControl.currentPage);
}
#pragma mark - Parse Load Chat

- (void)loadLocalChat
{

    PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGE_CLASS_NAME];
    PFQuery *query1 = [PFQuery queryWithClassName:PF_MESSAGE_CLASS_NAME];
    
    
    PFQuery *offlineQuery = [PFQuery queryWithClassName:PF_MESSAGE_CLASS_NAME];
    
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"connection"] isEqualToString:@"no"])
    {
        [offlineQuery fromLocalDatastore];
        [offlineQuery whereKey:PF_MESSAGE_GROUPID equalTo:groupId];
        [offlineQuery orderByAscending:@"createdAt"];
        [offlineQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)  {
        // Update the UI
            
            NSLog(@"objects:%@", objects);
            NSLog(@"%@", objects);
            arr_userName = [objects valueForKey:@"userName"];
            arr_text = [objects valueForKey:@"text"];
            arr_date = [objects valueForKey:@"date"];
            arr_receiverUserName = [objects valueForKey:@"receiverUserName"];
            arr_uploadedimages = [objects valueForKey:@"uploadedImage"];
            arr_uploadedaudios = [objects valueForKey:@"audioFile"];
            arr_audioTime = [objects valueForKey:@"audioTime"];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.chatTableView reloadData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    int lastRowNumber = [self.chatTableView numberOfRowsInSection:0] - 1;
                    
                    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
                    [self.chatTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
                });
            
            });
        
        }];
    }
    
    else
    {
        __block int totalNumberOfEntries = 0;
        
        [query whereKey:PF_MESSAGE_GROUPID equalTo:groupId];
        
       __block NSArray *fetched_objects;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
        {
                fetched_objects = objects;
                [PFObject pinAllInBackground:fetched_objects];
        }];
        
        
        
        ///Count objects in Parse
        [query1 whereKey:PF_MESSAGE_GROUPID equalTo:groupId];
        [query1 countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            //        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
            //        query1.cachePolicy = kPFCachePolicyCacheThenNetwork;
            
            totalNumberOfEntries = number;
            
            ///If > than data array, then fetch objects from Parse
            if (totalNumberOfEntries > [arr_text count]) {
                NSLog(@"Retrieving data");
                
                [query1 orderByAscending:@"createdAt"];
                
                [query1 whereKey:PF_MESSAGE_GROUPID equalTo:groupId];
                
                [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if(!error)
                    {
                        //[bubbleData removeAllObjects];
                        // Do something with the returned PFObject.
                        
                        NSLog(@"%@", objects);
                        arr_userName = [objects valueForKey:@"userName"];
                        arr_text = [objects valueForKey:@"text"];
                        arr_date = [objects valueForKey:@"date"];
                        arr_receiverUserName = [objects valueForKey:@"receiverUserName"];
                        arr_uploadedimages = [objects valueForKey:@"uploadedImage"];
                        arr_uploadedaudios = [objects valueForKey:@"audioFile"];
                        arr_audioTime = [objects valueForKey:@"audioTime"];
                        
                        [self.chatTableView reloadData];
                        
                        int lastRowNumber = [self.chatTableView numberOfRowsInSection:0] - 1;
                        
                        NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
                        [self.chatTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
                        
                    }
                    
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error Retrieving Chat" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [alert show];
                        
                    }
                }];
            }
            
            else
            {
                number = [arr_text count];
            }
            
        }];
    }
   // NSLog(@"bubbleData:%@",bubbleData);
    
    
    
}

#pragma mark - Back
-(IBAction)backPressed:(id)sender
{
    [PFUser logOut];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];

}

#pragma mark - Attach Image
-(IBAction)attachImage:(id)sender
{
    
    UIActionSheet *mediaSheet = [[UIActionSheet alloc]initWithTitle:@"What you want to do?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Upload Image",@"Upload Audio", nil];
    
    [mediaSheet showInView:self.view];
    
    
}

#pragma mark - ActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSLog(@"Image");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"What you want to do?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take Picture Using Camera",@"Choose From Library", nil];
        [alert show];
        
        
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"Audio");
        IQAudioRecorderController *controller = [[IQAudioRecorderController alloc] init];
        controller.delegate = self;
        
        //For overriding default colors:
        /*
         controller.normalTintColor = [UIColor redColor];
         controller.recordingTintColor = [UIColor purpleColor];
         controller.playingTintColor = [UIColor orangeColor];
         */
        
        if([timer isValid])
        {
            [timer invalidate];
            
            //set timer to nil after calling invalidate;
            timer = nil;
        }
        
        
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    else
    {
        return;
    }
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            
            if([timer isValid])
            {
                [timer invalidate];
                
                //set timer to nil after calling invalidate;
                timer = nil;
            }
            
            [self presentViewController:picker animated:YES completion:nil];
            
            
        }
        
        else
        {
            NSLog(@"No Camera");
        }
    
    }
    else if(buttonIndex == 2)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        
        if([timer isValid])
        {
            [timer invalidate];
        
            //set timer to nil after calling invalidate;
            timer = nil;
        }
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    else
        return;
    
}

#pragma mark - UIImagePicker
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    
    // Convert to JPEG with 50% quality
    NSData* data = UIImageJPEGRepresentation(pickedImage, 0.5f);
    
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
    
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"Image%@.jpg",guid] data:data];
    
    // Save the image to Parse
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The image has now been uploaded to Parse. Associate it with a new object
            PFObject *newMessage = [PFObject objectWithClassName:@"ChatRoom"];
            newMessage[@"text"] = @"Image Attachment";
            newMessage[@"userName"] = userName;
            newMessage[@"date"] = [NSDate date];
            newMessage[@"receiverUserName"] = selectedPFUser.username;
            NSLog(@"%@",selectedPFUser.username);
            newMessage[PF_MESSAGE_GROUPID] = groupId;
            newMessage[@"uploadedImage"] = imageFile;
            
            SendPushNotification(groupId, @"Image Attachment");
            UpdateRecentCounter(groupId, 1, @"Image Attachment");
            
            
            [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // The object has been saved.
                    NSLog(@"saved");
                    
                    [self loadLocalChat];
                    //[[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"enterPressed"];
                    
                    //                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:arr_text.count - 1 inSection:0];
                    //                //            [self.chatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    //                [self.chatTableView beginUpdates];
                    //                [self.chatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
                    //                [self.chatTableView endUpdates];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    // There was a problem, check error.description
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];

        }
    }];
 
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Audio Recorder

-(void)audioRecorderController:(IQAudioRecorderController *)controller didFinishWithAudioAtPath:(NSString *)filePath
{
    
    audioFilePath = filePath;
    NSLog(@"audiofilePath:%@",audioFilePath);
    
    NSData *soundData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    
//    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
//    CMTime audioDuration = audioAsset.duration;
//    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
//    NSLog(@"timeDuration:%f",audioDurationSeconds);
    
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
    
    PFFile *audioFile = [PFFile fileWithName:[NSString stringWithFormat:@"Audio%@",guid]data:soundData];
    
    NSString *audioTime = [[NSUserDefaults standardUserDefaults]valueForKey:@"audioTime"];
    NSLog(@"time:%@",audioTime);
    
    
    [audioFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"sound-upload Error: %@",[error localizedDescription]);
            
        } else {
            NSLog(@"sound-upload OK");
            PFObject *newMessage = [PFObject objectWithClassName:@"ChatRoom"];
            newMessage[@"text"] = @"Audio Attachment";
            newMessage[@"userName"] = userName;
            newMessage[@"date"] = [NSDate date];
            newMessage[@"receiverUserName"] = selectedPFUser.username;
            newMessage[@"audioFile"] = audioFile;
            newMessage[@"audioTime"] = audioTime;
            newMessage[PF_MESSAGE_GROUPID] = groupId;
            
            SendPushNotification(groupId, @"Audio Attachment");
            UpdateRecentCounter(groupId, 1, @"Audio Attachment");
            
            //[newMessage saveInBackground];
            
            [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // The object has been saved.
                    NSLog(@"saved");
                    
                    [self loadLocalChat];
                    
                } else {
                    // There was a problem, check error.description
                    
                }
            }];
            
            
        }
        
    }];
    
    
    
}

-(void)audioRecorderControllerDidCancel:(IQAudioRecorderController *)controller
{
    //buttonPlayAudio.enabled = NO;
}
//#pragma mark - Set Incoming Messages
//
//-(void)setIncomingMessages:(int)i
//{
//   
//    ///Set Image
//    if([[arr_text objectAtIndex:i] isEqualToString:@"Image Attachment"])
//    {
//        PFFile *imageFile = [arr_uploadedimages objectAtIndex:i];
////        [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
////        {
//    
//           // UIImage *image = [UIImage imageWithData:imageData];
//    
////        NSBubbleData *photoBubble = [NSBubbleData dataWithImage:imageFile date:[arr_date objectAtIndex:i] type:BubbleTypeSomeoneElse];
////        photoBubble.avatar = selectedUserUploadedImage;
////        
////        [self addTouchGestureToBubble:photoBubble.view];
////        
////        [bubbleData addObject:photoBubble];
//        [self.chatTableView reloadData];
//        
//        [arr_forloginUser_messages removeLastObject];
//        
//        
//            
////            [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"imageSet"];
////            
////    
////        }];
////        
////        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"imageSet"];
////        
//    
//    }
//    
//    else if([[arr_text objectAtIndex:i] isEqualToString:@"Audio Attachment"])
//    {
//        //[arr_audiobubble_ids_incoming removeAllObjects];
//        
//        NSBubbleData *audioBubble = [NSBubbleData dataWithAudioImage:[UIImage imageNamed:@"icon_Mic.png"] date:[arr_date objectAtIndex:i] type:BubbleTypeSomeoneElse];
//        audioBubble.avatar = uploadedImage;
//        
//       // UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchEventOnAudio:)];
//       // [audioBubble.view addGestureRecognizer:tapGesture];
//        audioBubble.view.userInteractionEnabled = YES;
//        
//        NSNumber *number = [NSNumber numberWithInt:i];
//        
//        [arr_audiobubble_ids_incoming addObject:number];
//        
//        [bubbleData addObject:audioBubble];
//        [self.chatTableView reloadData];
//        
//    }
//    
//    else
//    {
//        NSBubbleData *sayBubble = [NSBubbleData dataWithText:[arr_text objectAtIndex:i] date:[arr_date objectAtIndex:i] type:BubbleTypeSomeoneElse];
//        sayBubble.avatar = selectedUserUploadedImage;
//        [bubbleData addObject:sayBubble];
//        
//        [self.chatTableView reloadData];
//        [arr_forloginUser_messages removeLastObject];
//        
//    }
//    
//    
////    dispatch_async(dispatch_get_main_queue(), ^{
////        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:bubbleData.count inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
////    });
//    
//    NSLog(@"bubbleData:%@",bubbleData);
//    NSLog(@"arr:%@", arr_forloginUser_messages);
//
//}
//
//#pragma mark - Set Outgoing Message
//
//-(void)setOutgoingMessages:(int)i
//{
//    if([[arr_text objectAtIndex:i] isEqualToString:@"Image Attachment"])
//    {
//        PFFile *imageFile = [arr_uploadedimages objectAtIndex:i];
//                
//        NSBubbleData *photoBubble = [NSBubbleData dataWithImage:imageFile date:[arr_date objectAtIndex:i] type:BubbleTypeMine];
//        photoBubble.avatar = uploadedImage;
//        
//        
//        [self addTouchGestureToBubble:photoBubble.view];
//        
//        [bubbleData addObject:photoBubble];
//        [self.chatTableView reloadData];
//        
//        
//        //            [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"imageSet"];
//        //
//        //
//        //        }];
//        //
//        //        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"imageSet"];
//        //
//        
//    }
//    
//    else if([[arr_text objectAtIndex:i] isEqualToString:@"Audio Attachment"])
//    {
//    
//        //[arr_audiobubble_ids_outgoing removeAllObjects];
//        
//        NSBubbleData *audioBubble = [NSBubbleData dataWithAudioImage:[UIImage imageNamed:@"icon_Mic.png"] date:[arr_date objectAtIndex:i] type:BubbleTypeMine];
//        audioBubble.avatar = uploadedImage;
//        
//        NSNumber *number = [NSNumber numberWithInt:i];
//        [arr_audiobubble_ids_outgoing addObject:number];
//
//        //UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchEventOnAudio:)];
//        //[audioBubble.view addGestureRecognizer:tapGesture];
//        audioBubble.view.userInteractionEnabled = YES;
//        
//        [bubbleData addObject:audioBubble];
//        [self.chatTableView reloadData];
//    
//    }
//    
//    else
//    {
//        
//        
//        NSBubbleData *sayBubble = [NSBubbleData dataWithText:[arr_text objectAtIndex:i] date:[arr_date objectAtIndex:i] type:BubbleTypeMine];
//        [bubbleData addObject:sayBubble];
//        sayBubble.avatar = uploadedImage;
//        
//        [self.chatTableView reloadData];
//        
//        
//    }
//    
////    dispatch_async(dispatch_get_main_queue(), ^{
////        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:bubbleData.count inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
////    });
//    
//    
//    NSLog(@"bubbleData:%@",bubbleData);
//    [arr_forloginUser_messages removeLastObject];
//    
//    NSLog(@"arr:%@", arr_forloginUser_messages);
//}
//

#pragma mark - Fetch Chat Users

-(void)fetchUserData
{
    PFUser *user = [PFUser currentUser];
    
    userName = user.username;
    [self loadLocalChat];
    
    if (!timer)
        timer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(loadLocalChat) userInfo:nil repeats:YES];
    
    
//    [user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error)
//     {
//         NSLog(@"object:%@",object);
//         
//         PFFile *file = [object valueForKey:@"uploadedImage"];
//         
//         NSLog(@"file:%@",file);
//         
//         [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
//          {
//              uploadedImage  = [UIImage imageWithData:imageData];
//              selectedUser = selectedPFUser.username;
//              
////              NSLog(@"selectedPFuser: %@",selectedPFUser);
////              NSLog(@"%@",[selectedPFUser objectForKey:@"uploadedImage"]);
//              
//              PFFile *selectedUserFile = [selectedPFUser objectForKey:@"uploadedImage"];
//              [selectedUserFile getDataInBackgroundWithBlock:^(NSData *selectedUserImageData, NSError *error)
//               {
//                   selectedUserUploadedImage = [UIImage imageWithData:selectedUserImageData];
//                   
//                   [self loadLocalChat];
//                   if (!timer)
//                       timer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(loadLocalChat) userInfo:nil repeats:YES];
//               }];
// 
//              
//          }];
//         
//         
//         
//         
//     }];

}
#pragma mark - Close Full View
-(IBAction)closeFullView:(id)sender
{
    
    [self.fullView setHidden:YES];
    self.fullImageView.hidden = YES;
    
    
}

#pragma mark - Send Data
-(IBAction)sendDataPressed:(id)sender
{
    
    ///// For Emoji
    
    if (self.emojiPreviewImageView.image != nil) {
        
        NSLog(@"Emoji there");
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"connection"] isEqualToString:@"no"])
        {
            UIImage *picked_emoji = self.emojiPreviewImageView.image;
            
            // Convert to JPEG with 50% quality
            NSData* data = UIImageJPEGRepresentation(picked_emoji, 0.5f);
            
            NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
            
            PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"Image%@.jpg",guid] data:data];
            
            PFObject *newMessage = [PFObject objectWithClassName:PF_MESSAGE_CLASS_NAME];
            newMessage[@"text"] = @"Emoji Attachment";
            newMessage[@"userName"] = userName;
            newMessage[@"date"] = [NSDate date];
            newMessage[PF_MESSAGE_GROUPID] = groupId;
            newMessage[@"receiverUserName"] = selectedPFUser.username;
            newMessage[@"uploadedImage"] = imageFile;
            
            [newMessage saveEventually:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // The object has been saved.
                    NSLog(@"saved");
                    
                    [self loadLocalChat];
                    
                    
                    
                    //                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:arr_text.count - 1 inSection:0];
                    //                //            [self.chatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    //                [self.chatTableView beginUpdates];
                    //                [self.chatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
                    //                [self.chatTableView endUpdates];
                    
                    
                } else {
                    // There was a problem, check error.description
                }
            }];
            
            
            //[self.chatTableView reloadData];
            
            [self.txtview_message resignFirstResponder];
            
            [self.emojiPreviewImageView setImage:nil];
            
        }
        
        else
        {
            UIImage *picked_emoji = self.emojiPreviewImageView.image;
            
            // Convert to JPEG with 50% quality
            NSData* data = UIImageJPEGRepresentation(picked_emoji, 0.5f);
            
            NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
            
            PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"Image%@.jpg",guid] data:data];
            
            // Save the image to Parse
            
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // The image has now been uploaded to Parse. Associate it with a new object
                    PFObject *newMessage = [PFObject objectWithClassName:@"ChatRoom"];
                    newMessage[@"text"] = @"Emoji Attachment";
                    newMessage[@"userName"] = userName;
                    newMessage[@"date"] = [NSDate date];
                    newMessage[@"receiverUserName"] = selectedPFUser.username;
                    newMessage[PF_MESSAGE_GROUPID] = groupId;
                    newMessage[@"uploadedImage"] = imageFile;
                    
                    SendPushNotification(groupId, @"Image Attachment");
                    UpdateRecentCounter(groupId, 1, @"Image Attachment");
                    
                    
                    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            // The object has been saved.
                            NSLog(@"saved");
                            
                            [self loadLocalChat];
                            
                        } else {
                            
                        }
                    }];
                    
                }
            }];
            
            
            //[self.chatTableView reloadData];
            
            [self.txtview_message resignFirstResponder];
        }
    }
    
    
    //// For Text Message
    
    if (self.txtview_message.text.length>0) {
        
         if([[[NSUserDefaults standardUserDefaults]valueForKey:@"connection"] isEqualToString:@"no"])
        {
            PFObject *newMessage = [PFObject objectWithClassName:PF_MESSAGE_CLASS_NAME];
            newMessage[@"text"] = self.txtview_message.text;
            newMessage[@"userName"] = userName;
            newMessage[@"date"] = [NSDate date];
            newMessage[PF_MESSAGE_GROUPID] = groupId;
            newMessage[@"receiverUserName"] = selectedPFUser.username;
            
            
            [newMessage saveEventually:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // The object has been saved.
                    NSLog(@"saved");
                
                    [self loadLocalChat];
                    
                    //                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:arr_text.count - 1 inSection:0];
                    //                //            [self.chatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    //                [self.chatTableView beginUpdates];
                    //                [self.chatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
                    //                [self.chatTableView endUpdates];
                    
                    
                } else {
                    // There was a problem, check error.description
                }
            }];
            
            
            //[self.chatTableView reloadData];
            self.txtview_message.text = @"";
            
            [self.txtview_message resignFirstResponder];
        }
        
        else
        {
            PFObject *newMessage = [PFObject objectWithClassName:PF_MESSAGE_CLASS_NAME];
            newMessage[@"text"] = self.txtview_message.text;
            newMessage[@"userName"] = userName;
            newMessage[@"date"] = [NSDate date];
            newMessage[PF_MESSAGE_GROUPID] = groupId;
            newMessage[@"receiverUserName"] = selectedPFUser.username;
            SendPushNotification(groupId, self.txtview_message.text);
            UpdateRecentCounter(groupId, 1, self.txtview_message.text);

            
            [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // The object has been saved.
                    NSLog(@"saved");
                    
                    
                    [self loadLocalChat];
                    [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"enterPressed"];
                    
                    //                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:arr_text.count - 1 inSection:0];
                    //                //            [self.chatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    //                [self.chatTableView beginUpdates];
                    //                [self.chatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
                    //                [self.chatTableView endUpdates];
                    
                    
                } else {
                    // There was a problem, check error.description
                }
            }];
            
            
            //[self.chatTableView reloadData];
            self.txtview_message.text = @"";
            
            [self.txtview_message resignFirstResponder];
        }
        
        
        
    }
    self.emojiPreviewView.hidden = YES;
}

#pragma mark - Miscelleneous

void UpdateRecentCounter(NSString *groupId, NSInteger amount, NSString *lastMessage)
{
    PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
    [query whereKey:PF_RECENT_GROUPID equalTo:groupId];
    [query includeKey:PF_RECENT_USER];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             for (PFObject *recent in objects)
             {
                 PFUser *user1 = recent [PF_RECENT_USER];
                 PFUser *user2 =[PFUser currentUser];
                 if ([user1.objectId isEqualToString:user2.objectId] == NO)
                     [recent incrementKey:PF_RECENT_COUNTER byAmount:[NSNumber numberWithInteger:amount]];
                 //---------------------------------------------------------------------------------------------------------------------------------
                 recent[PF_RECENT_LASTUSER] = [PFUser currentUser];
                 recent[PF_RECENT_LASTMESSAGE] = lastMessage;
                 recent[PF_RECENT_UPDATEDACTION] = [NSDate date];
                 [recent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                  {
                      if (error != nil) NSLog(@"UpdateRecentCounter save error.");
                  }];
             }
         }
         else NSLog(@"UpdateRecentCounter query error.");
     }];
}


#pragma mark - Send Push
void SendPushNotification(NSString *groupId, NSString *text)
{
    PFUser *user = [PFUser currentUser];
    NSString *message = [NSString stringWithFormat:@"%@: %@", user[PF_USER_USERNAME], text];
    
    PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
    [query whereKey:PF_RECENT_GROUPID equalTo:groupId];
    [query whereKey:PF_RECENT_USER notEqualTo:user];
//    [query includeKey:PF_RECENT_USER];
//    [query setLimit:1000];
    
    PFQuery *queryInstallation = [PFInstallation query];
    [queryInstallation whereKey:PF_INSTALLATION_USER matchesKey:PF_RECENT_USER inQuery:query];
    
    PFPush *push = [[PFPush alloc] init];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          message, @"alert",
                          @"Increment", @"badge",
                          nil];
    [push setQuery:queryInstallation];
    [push setData:data];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error != nil)
         {
             NSLog(@"SendPushNotification send error.");
         }
     }];
}

#pragma mark - Copy
-(IBAction)copyPressed:(id)sender
{
//    UIPasteboard *pb = [UIPasteboard generalPasteboard];
//    
//    UIImage *image =  [UIImage imageNamed:@"missingAvatar.png"];
//    NSData *data = UIImagePNGRepresentation(image);
//    
//    [pb setData:data forPasteboardType:@"missingAvatar.png"];
    
    [UIPasteboard generalPasteboard].image = [UIImage imageNamed:@"missingAvatar.png"];
}


#pragma mark - Paste
-(IBAction)pastePressed:(id)sender
{
    UIImage *image = [UIPasteboard generalPasteboard].image;
    
    [self.logoutBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    
    
}

#pragma mark - Open Emoji View
-(IBAction)openEmojiView:(id)sender
{
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    
    if(screenRect.size.height == 480)
    {
    
        [self.chatTableView setFrame:CGRectMake(0, 59, self.view.frame.size.width, self.view.frame.size.height-230-59)];
        [self.textFieldView setFrame:CGRectMake(0, 248, self.view.frame.size.width, 40)];
    
        [self.emojiView setFrame:CGRectMake(0, 288, self.view.frame.size.width, 192)];
        
    }
    
    else if (screenRect.size.height == 568)
    {
        [self.chatTableView setFrame:CGRectMake(0, 59, self.view.frame.size.width, self.view.frame.size.height-230-59)];
        [self.textFieldView setFrame:CGRectMake(0, 338, self.view.frame.size.width, 40)];
        
        [self.emojiView setFrame:CGRectMake(0, 378, self.view.frame.size.width, 190)];
    }
    
    else if (screenRect.size.width == 375)
    {
        
    }
    
    [self.view addSubview:self.emojiView];
    
    
    //self.emojiBottomView.frame = CGRectMake(0, 440, self.view.frame.size.width, 100);
    
    //self.chatTableView.frame= CGRectMake(self.chatTableView.frame.origin.x, self.chatTableView.frame.origin.y - keyboardFrame.size.height, self.chatTableView.frame.size.width, self.chatTableView.frame.size.height);
    
    long lastRowNumber = [self.chatTableView numberOfRowsInSection:0] - 1;
    
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [UIView commitAnimations];
}

-(IBAction)emojiViewClose:(id)sender
{
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [self.chatTableView setFrame:CGRectMake(0, 59, self.view.frame.size.width, self.view.frame.size.height-40-59)];
    [self.textFieldView setFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
    
    //[self.emojiView setFrame:CGRectMake(0, 264, self.view.frame.size.width, 216)];
    
    [self.emojiView removeFromSuperview];
    self.emojiPreviewView.hidden = YES;
    
    
    
    
    //self.emojiBottomView.frame = CGRectMake(0, 440, self.view.frame.size.width, 100);
    
    //self.chatTableView.frame= CGRectMake(self.chatTableView.frame.origin.x, self.chatTableView.frame.origin.y - keyboardFrame.size.height, self.chatTableView.frame.size.width, self.chatTableView.frame.size.height);
    
    long lastRowNumber = [self.chatTableView numberOfRowsInSection:0] - 1;
    
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [UIView commitAnimations];

}

#pragma mark - Page Control
- (void)pageControlChanged:(id)sender
{
    UIPageControl *pageControl = sender;
    CGFloat pageWidth = self.collectionView.frame.size.width;
    CGPoint scrollTo = CGPointMake(pageWidth * pageControl.currentPage, 0);
    [self.collectionView setContentOffset:scrollTo animated:YES];
}

#pragma mark - Label Tapped
-(void)lbl_aegos_tapped
{
    [self.pageControl removeFromSuperview];
    [arr_emojis removeAllObjects];
    
    for (int i = 1; i<12; i++) {
        [arr_emojis addObject:[NSString stringWithFormat:@"Aego%d",i]]; 
    }
    
    NSLog(@"arr_emojis:%@",arr_emojis);
    
    [self.collectionView reloadData];
    //[self.collectionViewflowLayout invalidateLayout];
//    CGFloat w = self.view.frame.size.width;
//    CGFloat h = self.view.frame.size.height;
//    
//    // Set up the page control
//    CGRect frame = CGRectMake(0, h - 30, w, 30);
//    self.pageControl = [[UIPageControl alloc]
//                        initWithFrame:frame
//                        ];
//    
//    // Add a target that will be invoked when the page control is
//    // changed by tapping on it
//    [self.pageControl
//     addTarget:self
//     action:@selector(pageControlChanged:)
//     forControlEvents:UIControlEventValueChanged
//     ];
//    //self.pageControl.backgroundColor = [UIColor greenColor];
//    [self.pageControl setNumberOfPages:1];
//    //self.pageControl.numberOfPages = pages;
//    NSLog(@"pages:%d", self.pageControl.numberOfPages);
//    
//    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:self.pageControl];
    
    
}

-(void)lbl_foods_tapped
{
    [arr_emojis removeAllObjects];
    [self.pageControl removeFromSuperview];
    
    for (int i = 1; i<19; i++) {
        [arr_emojis addObject:[NSString stringWithFormat:@"food%d",i]];
        
    }
    
    [self.collectionView reloadData];
    //[self.collectionViewflowLayout invalidateLayout];
//    CGFloat w = self.view.frame.size.width;
//    CGFloat h = self.view.frame.size.height;
//    
//    // Set up the page control
//    CGRect frame = CGRectMake(0, h - 30, w, 30);
//    self.pageControl = [[UIPageControl alloc]
//                        initWithFrame:frame
//                        ];
//    
//    // Add a target that will be invoked when the page control is
//    // changed by tapping on it
//    [self.pageControl
//     addTarget:self
//     action:@selector(pageControlChanged:)
//     forControlEvents:UIControlEventValueChanged
//     ];
//    //self.pageControl.backgroundColor = [UIColor greenColor];
//    
//    [self.pageControl setNumberOfPages:1];
//    //self.pageControl.numberOfPages = pages;
//    NSLog(@"pages:%d", self.pageControl.numberOfPages);
//    
//    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:self.pageControl];
}

-(void)lbl_moods_tapped
{
    [arr_emojis removeAllObjects];
    [self.pageControl removeFromSuperview];
    
    for (int i = 1; i<33; i++) {
        [arr_emojis addObject:[NSString stringWithFormat:@"mood%d",i]];
        
    }
    
    [self.collectionView reloadData];
    //[self.collectionViewflowLayout invalidateLayout];
//    CGFloat w = self.view.frame.size.width;
//    CGFloat h = self.view.frame.size.height;
//    
//    // Set up the page control
//    CGRect frame = CGRectMake(0, h - 30, w, 30);
//    self.pageControl = [[UIPageControl alloc]
//                        initWithFrame:frame
//                        ];
//    
//    // Add a target that will be invoked when the page control is
//    // changed by tapping on it
//    [self.pageControl
//     addTarget:self
//     action:@selector(pageControlChanged:)
//     forControlEvents:UIControlEventValueChanged
//     ];
//    //self.pageControl.backgroundColor = [UIColor greenColor];
//    
//    [self.pageControl setNumberOfPages:2];
//    //self.pageControl.numberOfPages = pages;
//    NSLog(@"pages:%d", self.pageControl.numberOfPages);
//    
//    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:self.pageControl];
    
}
//#pragma mark - Image Bubble Tap
//- (void)addTouchGestureToBubble:(UIView *)bubbleImage
//{
//    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchEventOnImage:)];
//    [tapRecognizer setNumberOfTouchesRequired:1];
//    //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
//    bubbleImage.userInteractionEnabled = YES;
//    //tappedImage = [self imageFromView:bubbleImage];
//    [bubbleImage addGestureRecognizer:tapRecognizer];
//    
//    
//
//}
//
//- (void)touchEventOnImage:(id)sender
//{
//    if( [sender isKindOfClass:[UIGestureRecognizer class]] )
//    {
//        UIGestureRecognizer * recognizer = (UIGestureRecognizer *)sender;
//        
//        if( [recognizer.view isKindOfClass:[UIImageView class]    ] )
//        {
//            self.fullView.center = self.view.center;
//            
//            self.fullImageView.image=((UIImageView *)recognizer.view).image;
//            
//            self.fullView.hidden = NO;
//        }
//    }
//}
//
//- (float) screenScale {
//    if ([ [UIScreen mainScreen] respondsToSelector: @selector(scale)] == YES) {
//        return [ [UIScreen mainScreen] scale];
//    }
//    return 1;
//}
//
//- (UIImage *) imageFromView: (UIView *) view {
//    CGFloat scale = [self screenScale];
//    
//    if (scale > 1) {
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
//    } else {
//        UIGraphicsBeginImageContext(view.bounds.size);
//    }
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [view.layer renderInContext: context];
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return viewImage;
//}
//
//#pragma mark - Audio Bubble Tap
//- (void)addTouchGestureToAudioBubble:(UIView *)audiobubbleView
//{
//    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchEventOnAudio:)];
//    [tapRecognizer setNumberOfTouchesRequired:1];
//    //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
//    audiobubbleView.userInteractionEnabled = YES;
//    //tappedImage = [self imageFromView:bubbleImage];
//    [audiobubbleView addGestureRecognizer:tapRecognizer];
//    
//        
//}
//
//-(void)touchEventOnAudio:(UITapGestureRecognizer *)gestureRecognizer
//{
//    point = [gestureRecognizer locationInView:self.chatTableView];
//    
//    NSIndexPath *indexPath = [self.chatTableView indexPathForRowAtPoint:point];
//    
////    UITableViewCell* cell =
////    [self.chatTableView cellForRowAtIndexPath:indexPath];
//    
//    //NSLog(@"uploadedaudio:%@",[arr_uploadedaudios objectAtIndex:i]);
//    
//    NSLog(@"auploadedaudios:%@",arr_audiobubble_ids_incoming);
//    NSLog(@"auploadedaudios:%@",arr_audiobubble_ids_outgoing);
//
//    
//    NSLog(@"Row:%d",indexPath.row);
//}
//
//
//- (void)onListTap:(UIGestureRecognizer*)recognizer {
//    
//    if (recognizer.state == UIGestureRecognizerStateEnded)
//    { CGPoint tapLocation = [recognizer locationInView:self.chatTableView];
//        NSIndexPath *tapIndexPath = [self.chatTableView indexPathForRowAtPoint:tapLocation];
//        UIBubbleTableViewCell * cell = (UIBubbleTableViewCell*) [self.chatTableView cellForRowAtIndexPath:tapIndexPath];
//        NSLog(@"ROW:%d",tapIndexPath.row);
//        
//        // create new view here
//
//} }
@end
