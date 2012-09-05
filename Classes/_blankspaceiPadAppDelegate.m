//
//  _blankspaceiPadAppDelegate.m
//  1blankspaceiPad
//
//  Created by Vipin Jain on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_blankspaceiPadAppDelegate.h"
#import "LoginViewController.h"
#import "AutoLoginViewController.h"
#import "Config.h"

#define DataFilePath                [@"~/Documents/Username_Password.plist" stringByStandardizingPath]

@implementation _blankspaceiPadAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
	[self initGlobalVars];
	[self autoLogin];
    [self.window makeKeyAndVisible];
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    return YES;
}

-(void) initGlobalVars
{
	
	cFunc = [[CommonFunctions alloc] init];
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	DatabasePath = [[documentsDir stringByAppendingPathComponent:DatabaseName] retain];
	NSLog(@"%@",DatabasePath);
	[cFunc checkAndCreateDatabase];
	
}

-(void) autoLogin
{
	/* checking if PIN has been already setup */	
	NSData *data = [NSData dataWithContentsOfFile:DataFilePath];
	NSPropertyListFormat format;
	NSArray *array = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:nil];
	
	NSString *userName = [array objectAtIndex:0];
	NSString *passWord = [array objectAtIndex:1];
	NSLog(@"%@",array);
	NSLog(@"%@",DataFilePath);	
	
	if ([array count] > 0) 
	{
		remember = TRUE;
		alvc = [[AutoLoginViewController alloc] init];
		[self.window addSubview:alvc.view];
		
		HUD = [[MBProgressHUD alloc] initWithView:alvc.view];
		HUD.graceTime = 0.5;
		[alvc.view addSubview:HUD];
		HUD.delegate = self;
		[HUD showWhileExecuting:@selector(checkLogin:) onTarget:self withObject:[[NSDictionary alloc] initWithObjectsAndKeys:userName,@"username",passWord,@"password",nil] animated:YES]; 
		
	}
	else 
	{
		[self.window addSubview:navigationController.view];
		remember = FALSE;
	}
	
	
}


-(IBAction) logOnBtnPressed:(id) sender
{
	LoginViewController *lvc = (LoginViewController*)[self.navigationController topViewController];
	
	NSDictionary *dic = [lvc loginPressed];
	
	if (dic != nil) 
	{
		HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
		HUD.graceTime = 0.5;
		[self.navigationController.view addSubview:HUD];
		HUD.delegate = self;
		[HUD showWhileExecuting:@selector(checkLogin:) onTarget:self withObject:dic animated:YES];
	}
	
}


-(void) checkLogin:(NSDictionary*) data
{
	NSString *usernameTxt = [data valueForKey:@"username"];
	NSString *passwordTxt = [data valueForKey:@"password"];
	
	
	NSString *loginURL =  [SiteURL stringByAppendingFormat:@"logon.asp?logon=%@&password=%@", usernameTxt, passwordTxt];
	
	NSLog(@"%@",loginURL);
	
	NSString *URLContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:loginURL] encoding:NSUTF8StringEncoding error:nil];
	
	NSLog(@"%@",URLContent);
	
	loginError = FALSE;
	
	NSArray * resultArr = [URLContent componentsSeparatedByString:@"|"];
	if ([resultArr count]>= 4)
	{
		if ([[resultArr objectAtIndex:3] isEqualToString:@"PASSWORDOK"])
		{
			loginError	= FALSE;
			Sid			  	= [[resultArr objectAtIndex:2] retain];
			
			NSString *userIdURL =  [SiteURL stringByAppendingFormat:@"object.asp?method=CORE_GET_USER_DETAILS"];
			
			NSString *URLContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:userIdURL] encoding:NSUTF8StringEncoding error:nil];
			
			NSLog(@"%@",URLContent);
			
			NSArray * resultArr2 = [URLContent componentsSeparatedByString:@"|"];
			if ([resultArr2 count] >7) {
				UserID = [[resultArr2 objectAtIndex:7] retain];
				requestToReloadFav = TRUE;
				loginSuccess = TRUE;
			}
			else 
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Unable to get User Id" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[alert show];
				[alert release];
				
				loginSuccess = FALSE;
			}
			
		}
		else 
		{
			loginError = TRUE;
			loginSuccess = FALSE;
		}
		
		
	}
	else 
	{
		loginError = TRUE;
		loginSuccess = FALSE;
	}
	
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if ([alertView.title isEqualToString:@"Log Off"]) 
	{
		if (buttonIndex == 1) 
		{
			// Check for file existence
			if([[NSFileManager defaultManager] fileExistsAtPath:DataFilePath ])
			{
				[[NSFileManager defaultManager] removeItemAtPath:DataFilePath error:nil];
			}
			
			[self.tabBarController.view removeFromSuperview];
			[self.window addSubview:navigationController.view];
		}
	}
}

- (void)hudWasHidden 
{
	if (remember) 
	{
		[alvc.view removeFromSuperview];
		[self.tabBarController setSelectedIndex:0];
		[self.window addSubview:tabBarController.view];
	}
	
	if (loginError) 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Username or Password is incorrect." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	if (loginSuccess) 
	{
		[self.navigationController.view removeFromSuperview];
		[self.tabBarController setSelectedIndex:0];
		[self.window addSubview:tabBarController.view];
	}
	
	[HUD removeFromSuperview];
	[HUD release];
}

int selectedPrevTab;

- (void)tabBarController:(UITabBarController *)tabBarController1 didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController1.selectedIndex == 2) {
		
        UIAlertView * alertObj=[[UIAlertView alloc] initWithTitle:@"Log Off" message:@"Are you sure you want to Log Off?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertObj show];
        [alertObj release];    
		
        [tabBarController1 setSelectedIndex:selectedPrevTab];
        
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController1 shouldSelectViewController:(UIViewController *)viewController
{
    
    if ([tabBarController1 selectedIndex]!=2) {
        selectedPrevTab = [tabBarController1 selectedIndex];
    }
    
    //NSLog(@"test");
    // this is called when the user taps a tab bar button,
    // whether it's current or not
    return TRUE;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
