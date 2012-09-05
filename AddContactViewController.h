//
//  AddContactViewController.h
//  1blankspaceContactManager
//
//  Created by Vipin Jain on 19/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "CommonFunctions.h"

#import "ContactDetailViewController.h"

@interface AddContactViewController : UIViewController {
	
	IBOutlet UITextField *firstname_txt;
	IBOutlet UITextField *surname_txt;
	IBOutlet UITextField *streetadd1_txt;
	IBOutlet UITextField *streetadd2_txt;
	IBOutlet UITextField *streetsuburb_txt;
	IBOutlet UITextField *streetstate_txt;
	IBOutlet UITextField *streetpostcode_txt;
	IBOutlet UITextField *streetcountry_txt;
	IBOutlet UITextField *Email_txt;
	IBOutlet UITextField *Phone_txt;
	IBOutlet UITextField *Mobile_txt;
	
	IBOutlet UILabel	 *firstname_lbl;
	IBOutlet UILabel	 *surname_lbl;
	IBOutlet UILabel	 *streetadd1_lbl;
	IBOutlet UILabel	 *streetadd2_lbl;
	IBOutlet UILabel	 *streetsuburb_lbl;
	IBOutlet UILabel	 *streetstate_lbl;
	IBOutlet UILabel	 *streetpostcode_lbl;
	IBOutlet UILabel	 *streetcountry_lbl;
	IBOutlet UILabel	 *Email_lbl;
	IBOutlet UILabel	 *Phone_lbl;
	IBOutlet UILabel	 *Mobile_lbl;
	
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIImageView *bgImgView;
	
	Contact *contact;
	
	CommonFunctions *cFunc;
	
	ContactDetailViewController *cd;

	BOOL doneBtnExist;
	
	int MobLength;
	int PhoneLength;

}

@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) IBOutlet UITextField *firstname_txt;
@property (nonatomic, retain) IBOutlet UITextField *surname_txt;
@property (nonatomic, retain) IBOutlet UITextField *streetadd1_txt;
@property (nonatomic, retain) IBOutlet UITextField *streetadd2_txt;
@property (nonatomic, retain) IBOutlet UITextField *streetsuburb_txt;
@property (nonatomic, retain) IBOutlet UITextField *streetstate_txt;
@property (nonatomic, retain) IBOutlet UITextField *streetpostcode_txt;
@property (nonatomic, retain) IBOutlet UITextField *streetcountry_txt;
@property (nonatomic, retain) IBOutlet UITextField *Email_txt;
@property (nonatomic, retain) IBOutlet UITextField *Phone_txt;
@property (nonatomic, retain) IBOutlet UITextField *Mobile_txt;

@property (nonatomic, retain) IBOutlet UILabel	 *firstname_lbl;
@property (nonatomic, retain) IBOutlet UILabel	 *surname_lbl;
@property (nonatomic, retain) IBOutlet UILabel	 *streetadd1_lbl;
@property (nonatomic, retain) IBOutlet UILabel	 *streetadd2_lbl;
@property (nonatomic, retain) IBOutlet UILabel	 *streetsuburb_lbl;
@property (nonatomic, retain) IBOutlet UILabel	 *streetstate_lbl;
@property (nonatomic, retain) IBOutlet UILabel	 *streetpostcode_lbl;
@property (nonatomic, retain) IBOutlet UILabel	 *streetcountry_lbl;
@property (nonatomic, retain) IBOutlet UILabel	 *Email_lbl;
@property (nonatomic, retain) IBOutlet UILabel	 *Phone_lbl;
@property (nonatomic, retain) IBOutlet UILabel	 *Mobile_lbl;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *bgImgView;

@property (nonatomic, retain) ContactDetailViewController *cd;


- (void)scrollViewToCenterOfScreen:(UIView *)theView;
-(IBAction) saveAndSendContact:(id) sender;
-(void) displayDoneBtn;
-(IBAction) testValueChangeMob:(id) sender;
-(IBAction) testValueChangePhone:(id) sender;
-(void)orientationChanged:(UIInterfaceOrientation)interfaceOrientation;
@end
