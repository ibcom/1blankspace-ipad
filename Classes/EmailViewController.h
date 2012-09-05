//
//  EmailViewController.h
//  1blankspaceContactManager
//
//  Created by Vipin Jain on 18/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunctions.h"
#import "MBProgressHUD.h"


@interface EmailViewController : UIViewController <UITextViewDelegate,MBProgressHUDDelegate>{
	
	IBOutlet UITextField *subject;
	IBOutlet UITextView *message;
	
	IBOutlet UIScrollView *scrollView;
	
	IBOutlet UIButton *sendBtn;
	IBOutlet UIImageView *lineImg;
	
	NSString * contactId;
	
	CommonFunctions *cFunc;
	
	MBProgressHUD *HUD;

}

@property (nonatomic, retain) IBOutlet UITextField *subject;
@property (nonatomic, retain) IBOutlet UITextView *message;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *sendBtn;
@property (nonatomic, retain) IBOutlet UIImageView *lineImg;
@property (nonatomic, retain) NSString * contactId;

- (void)scrollViewToCenterOfScreen:(UIView *)theView ;
-(IBAction) sendBtnPressed:(id) sender;
-(void) sendEmail;
-(void)orientationChanged:(UIInterfaceOrientation)interfaceOrientation;
@end
