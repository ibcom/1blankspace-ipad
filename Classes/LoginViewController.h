//
//  LoginViewController.h
//  1blankspaceiPad
//
//  Created by Vipin Jain on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController 
{
	IBOutlet UITextField				*Username;
	IBOutlet UITextField				*Password;
	IBOutlet UILabel					*username_lbl;
	IBOutlet UILabel					*password_lbl;
	IBOutlet UILabel					*rememberMe_lbl;
	IBOutlet UISwitch					*rememberSwitch;
	IBOutlet UIImageView				*imgBgView;
	IBOutlet UIImageView				*img1;
	IBOutlet UIImageView				*img2;
	IBOutlet UIImageView				*img3;
	
	BOOL remember;
}

@property (nonatomic,retain) IBOutlet UITextField				*Username;
@property (nonatomic,retain) IBOutlet UITextField				*Password;
@property (nonatomic,retain) IBOutlet UILabel					*username_lbl;
@property (nonatomic,retain) IBOutlet UILabel					*password_lbl;
@property (nonatomic,retain) IBOutlet UILabel					*rememberMe_lbl;
@property (nonatomic,retain) IBOutlet UISwitch					*rememberSwitch;
@property (nonatomic,retain) IBOutlet UIImageView				*imgBgView;
@property (nonatomic,retain) IBOutlet UIImageView				*img1;
@property (nonatomic,retain) IBOutlet UIImageView				*img2;
@property (nonatomic,retain) IBOutlet UIImageView				*img3;

-(void) changeToOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(IBAction) switchValueChanged:(id) sender;
-(NSDictionary *) loginPressed;

@end
