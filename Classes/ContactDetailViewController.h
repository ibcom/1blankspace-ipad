//
//  ContactDetailViewController.h
//  1blankspaceiPad
//
//  Created by Vipin Jain on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"


@interface ContactDetailViewController : UIViewController<UIActionSheetDelegate> {

	Contact *contact;
	IBOutlet UITableView *tblView;
	UIButton *addAsfavBtn;
	IBOutlet UIImageView *imgBgView;
	
	BOOL isFav;
}

@property (nonatomic,retain) Contact *contact;
@property (nonatomic,retain) IBOutlet UITableView *tblView;
@property (nonatomic,retain) IBOutlet UIImageView *imgBgView;

-(IBAction) emailBtnPressed:(id) sender;
-(IBAction) favBtnPressed:(id) sender;
-(IBAction) mapBtnPressed:(id) sender;
-(void) checkForFav;

@end
