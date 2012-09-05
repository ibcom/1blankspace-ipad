//
//  _blankspaceiPadAppDelegate.h
//  1blankspaceiPad
//
//  Created by Vipin Jain on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommonFunctions.h"
#import "AutoLoginViewController.h"

@interface _blankspaceiPadAppDelegate : NSObject <UIApplicationDelegate,MBProgressHUDDelegate> {
    UIWindow *window;
	IBOutlet UINavigationController *navigationController;
	IBOutlet UITabBarController *tabBarController;
	
	MBProgressHUD *HUD;
	
	CommonFunctions *cFunc;
	
	BOOL remember;
	
	AutoLoginViewController *alvc;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

-(IBAction) logOnBtnPressed:(id) sender;
-(void) initGlobalVars;
-(void) autoLogin;

@end

