    //
//  LoginViewController.m
//  1blankspaceiPad
//
//  Created by Vipin Jain on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "_blankspaceiPadAppDelegate.h"
#import "Config.h"

#define DataFilePath                [@"~/Documents/Username_Password.plist" stringByStandardizingPath]

@implementation LoginViewController

@synthesize Username;
@synthesize Password;
@synthesize username_lbl;
@synthesize password_lbl;
@synthesize rememberMe_lbl;
@synthesize rememberSwitch;
@synthesize imgBgView;
@synthesize img1;
@synthesize img2;
@synthesize img3;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[Username setText:@""];
	[Password setText:@""];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationItem setTitle:@"1blankspace"];
	
	remember = FALSE;
	[rememberSwitch setOn:FALSE];
	
}

-(void) changeToOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) 
	{
		[imgBgView setFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 768.0f)];
		[imgBgView setImage:[UIImage imageNamed:@"bg.png"]];
		[img1 setFrame:CGRectMake(155.0f, 40.0f, 714.0f, 55.0f)];
		[username_lbl setFrame:CGRectMake(165.0f, 57.0f, 100.0f, 21.0f)];
		[Username setFrame:CGRectMake(273.0f, 52.0f, 579.0f, 31.0f)];
		[img2 setFrame:CGRectMake(155.0f, 145.0f, 714.0f, 55.0f)];
		[password_lbl setFrame:CGRectMake(165.0f, 162.0f, 100.0f, 21.0f)];
		[Password setFrame:CGRectMake(273.0f, 157.0f, 579.0f, 31.0f)];
		[img3 setFrame:CGRectMake(155.0f, 250.0f, 714.0f, 55.0f)];
		[rememberMe_lbl setFrame:CGRectMake(165.0f, 267.0f, 120.0f, 21.0f)];
		[rememberSwitch setFrame:CGRectMake(293.0f, 264.0f, 94.0f, 27.0f)];
	}
	else 
	{
		[imgBgView setFrame:CGRectMake(0.0f, 0.0f, 768.0f, 1024.0f)];
		[imgBgView setImage:[UIImage imageNamed:@"bg_blue.png"]];
		[img1 setFrame:CGRectMake(27.0f, 40.0f, 714.0f, 55.0f)];
		[username_lbl setFrame:CGRectMake(37.0f, 57.0f, 100.0f, 21.0f)];
		[Username setFrame:CGRectMake(145.0f, 52.0f, 579.0f, 31.0f)];
		[img2 setFrame:CGRectMake(27.0f, 145.0f, 714.0f, 55.0f)];
		[password_lbl setFrame:CGRectMake(37.0f, 162.0f, 100.0f, 21.0f)];
		[Password setFrame:CGRectMake(145.0f, 157.0f, 579.0f, 31.0f)];
		[img3 setFrame:CGRectMake(27.0f, 250.0f, 714.0f, 55.0f)];
		[rememberMe_lbl setFrame:CGRectMake(37.0f, 267.0f, 120.0f, 21.0f)];
		[rememberSwitch setFrame:CGRectMake(165.0f, 264.0f, 94.0f, 27.0f)];
	}
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	
	[textField resignFirstResponder];
	
	if ([textField isEqual:Username])
	{
		[Password becomeFirstResponder];
	}
	else 
	{
		_blankspaceiPadAppDelegate *appDelegate = (_blankspaceiPadAppDelegate*)[[UIApplication sharedApplication] delegate];
		[appDelegate logOnBtnPressed:nil];
	}
	
	return YES;
} 

-(IBAction) switchValueChanged:(id) sender
{
	
	if (rememberSwitch.on) {
		remember = TRUE;
	}
	else {
		remember = FALSE;
	}
	
}

-(NSDictionary *) loginPressed
{
	[Username resignFirstResponder];
	[Password resignFirstResponder];
	
	NSString *usernameTxt = [Username text];
	NSString *passwordTxt = [Password text];
	
	UIAlertView *alertView;
	
	if ([usernameTxt isEqualToString:@""])
	{
		alertView=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Logon Name cannot be empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView setDelegate:self];
		[alertView show];
		[alertView release];
		
		loginSuccess = FALSE;
		return nil;
	}
	if ([passwordTxt isEqualToString:@""])
	{
		alertView=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Password cannot be empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView setDelegate:self];
		[alertView show];
		[alertView release];
		
		loginSuccess = FALSE;
		return nil;
	}
	
	if (remember)
	{
		NSArray *Username_Password_Details = [NSArray arrayWithObjects:usernameTxt,passwordTxt,nil];
		NSData *data = [NSPropertyListSerialization dataFromPropertyList:Username_Password_Details  format:NSPropertyListXMLFormat_v1_0  errorDescription:nil];
		NSLog(@"%@",DataFilePath);
		[data writeToFile:DataFilePath atomically:YES];
		
	}
	
	return [[NSDictionary alloc] initWithObjectsAndKeys:usernameTxt,@"username",passwordTxt,@"password",nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	
	[self changeToOrientation:interfaceOrientation];
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
