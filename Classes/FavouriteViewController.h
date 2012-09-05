//
//  FavouriteViewController.h
//  1blankspaceiPad
//
//  Created by Vipin Jain on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunctions.h"
#import "MBProgressHUD.h"


@interface FavouriteViewController : UIViewController<MBProgressHUDDelegate> {
	
	CommonFunctions *cFunc;
	IBOutlet UITableView *tblView;
	
	NSMutableArray *contactArr;
	NSMutableArray *tmpContactArr;
	NSMutableArray *Indices;
	
	MBProgressHUD *HUD;

}

@property (nonatomic, retain) IBOutlet UITableView *tblView;

-(void) loadAllFavContacts;
-(IBAction) refreshBtnPressed:(id) sender;
-(void) syncAndLoadData;

@end
