//
//  EmailViewController.m
//  1blankspaceContactManager
//
//  Created by Vipin Jain on 18/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EmailViewController.h"
#import "Config.h"
#import "CommonFunctions.h"


@implementation EmailViewController
@synthesize subject,message,scrollView,sendBtn,lineImg;
@synthesize contactId;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setTitle:@"Email"];
	
	UIBarButtonItem *rightIconBtn = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendBtnPressed:)];
	self.navigationItem.rightBarButtonItem = rightIconBtn;
	[rightIconBtn release];
	
	cFunc = [[CommonFunctions	alloc] init];
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	
	[textField resignFirstResponder];
	[scrollView setContentOffset:CGPointMake(0, 0) animated:YES];  
	
	if ([textField isEqual:subject])
	{
		[message becomeFirstResponder];
	}
	
	return YES;
}
 


- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[textView setText:@""];
	[textView setTextColor:[UIColor blackColor]];
	[self scrollViewToCenterOfScreen:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	if ([[textView text] isEqualToString:@""]) {
		[textView setText:@"Message"];
		[textView setTextColor:[UIColor colorWithRed:0.7019 green:0.7019 blue:0.7019 alpha:1.0]];
	}
}

- (void)scrollViewToCenterOfScreen:(UIView *)theView {  
	
    CGFloat viewCenterY = theView.center.y;  
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];  
	
    CGFloat availableHeight = applicationFrame.size.height - 20;            // Remove area covered by keyboard  
	
    CGFloat y = viewCenterY - availableHeight / 2.0;  
    if (y < 0) {  
        y = 0;  
    }  
	
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];  
	
}

-(IBAction) sendBtnPressed:(id) sender
{
	[message resignFirstResponder];
	[scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	HUD.graceTime = 0.5;
	
    [self.view addSubview:HUD];
    HUD.delegate = self;
	[HUD showWhileExecuting:@selector(sendEmail) onTarget:self withObject:@"0" animated:YES];

}

-(void) sendEmail
{
	NSString *subj = [subject text];
	NSString *msg = [message text];
	
	UIAlertView *alertView;
	
	if ([subj isEqualToString:@""])
	{
		alertView=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Subject cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView setDelegate:self];
		[alertView show];
		[alertView release];
		return;
	}
	if ([msg isEqualToString:@""])
	{
		alertView=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Message cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView setDelegate:self];
		[alertView show];
		[alertView release];
		return;
	}
	
	NSString *emailURL =  [SiteURL stringByAppendingFormat:@"object.asp?sid=%@&method=MESSENGER_SEND_EMAIL&select=%@&subject=%@&message=%@",Sid,contactId,subj,msg];
	
	NSString *URLContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:[cFunc URLEncodeString:emailURL]] encoding:NSUTF8StringEncoding error:nil];
	
	NSLog(@"%@",URLContent);
	
	if ([URLContent isEqualToString:@"OK|OK"]) {
		
		alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"E-mail sent successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		
	}
	else {
		
		alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"E-mail not sent successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}

}

- (void)hudWasHidden {
	
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	[self orientationChanged:interfaceOrientation];	
    return YES;
}


-(void)orientationChanged:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
		
		[lineImg setFrame:CGRectMake(0, 32, 1024, 1)];
		[lineImg setImage:[UIImage imageNamed:@"gray_line1"]];
		[subject setFrame:CGRectMake(10, 0, 1004, 31)];
		[message setFrame:CGRectMake(3, 33, 1018, 300)];
		
	}
	else {
		
		[lineImg setFrame:CGRectMake(0, 32, 768, 1)];
		[lineImg setImage:[UIImage imageNamed:@"gray_line"]];
		[subject setFrame:CGRectMake(10, 0, 748, 31)];
		[message setFrame:CGRectMake(3, 33, 768, 650)];
	}
	
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[lineImg release];
    [super dealloc];
}


@end
