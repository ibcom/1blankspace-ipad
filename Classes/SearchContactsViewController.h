//
//  SearchContactsViewController.h
//  1blankspaceiPad
//
//  Created by Vipin Jain on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface SearchContactsViewController : UIViewController <UISearchBarDelegate,MBProgressHUDDelegate>
{
	MBProgressHUD *HUD;
	IBOutlet UISearchBar *searchBar;
	IBOutlet UITableView *tblView;
	
	NSMutableArray *arr;
	
	BOOL HUDisActive;
}

@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;
@property(nonatomic,retain) IBOutlet UITableView *tblView;
@property(nonatomic,retain) NSMutableArray *arr;

-(void) search;

@end
