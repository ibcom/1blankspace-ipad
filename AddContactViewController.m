//
//  AddContactViewController.m
//  1blankspaceContactManager
//
//  Created by Vipin Jain on 19/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddContactViewController.h"
#import "sqlite3.h"
#import "Config.h"


@implementation AddContactViewController
@synthesize firstname_txt,surname_txt,streetadd1_txt,streetadd2_txt,streetsuburb_txt,streetstate_txt,streetpostcode_txt,streetcountry_txt,Email_txt,Phone_txt,Mobile_txt,scrollView;
@synthesize contact,cd;
@synthesize firstname_lbl,surname_lbl,streetadd1_lbl,streetadd2_lbl,streetsuburb_lbl,streetstate_lbl,streetpostcode_lbl,streetcountry_lbl,Email_lbl,Phone_lbl,Mobile_lbl;
@synthesize bgImgView;


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
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	doneBtnExist = FALSE;
	
	UIBarButtonItem *leftIconBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnPressed:)];
	self.navigationItem.leftBarButtonItem = leftIconBtn;
	[leftIconBtn release];
	
	cFunc = [[CommonFunctions alloc] init];
	
	if (contactIsBeingEdited) {
		NSString * navigationBarTitle = [contact.firstname stringByAppendingFormat:@" %@",contact.surname];
		[self setTitle:navigationBarTitle];
	}
	else {
		[self setTitle:@"New Contact"];
	}

	
	[firstname_lbl setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
	[surname_lbl setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
	[streetadd1_lbl setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
	[streetadd2_lbl setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
	[streetsuburb_lbl setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
	[streetstate_lbl setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
	[streetpostcode_lbl setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
	[streetcountry_lbl setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
	[Email_lbl setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
	[Phone_lbl setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
	[Mobile_lbl setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
	
	if (contactIsBeingEdited) {
		[firstname_txt setText:contact.firstname];
		[surname_txt setText:contact.surname];
		[streetadd1_txt setText:contact.streetaddress1];
		[streetadd2_txt setText:contact.streetaddress2];
		[streetsuburb_txt setText:contact.streetsuburb];
		[streetstate_txt setText:contact.streetstate];
		[streetpostcode_txt setText:contact.streetpostcode];
		[streetcountry_txt setText:contact.streetcountry];
		[Email_txt setText:contact.email];
		[Phone_txt setText:contact.phone];
		[Mobile_txt setText:contact.mobile];
	}
	
	MobLength = [[Mobile_txt text] length];
	PhoneLength = [[Phone_txt text] length];
}



-(void)orientationChanged:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
		
		[scrollView setContentSize:CGSizeMake(320, 500)];
		[bgImgView setImage:[UIImage imageNamed:@"bg"]];
		
		[firstname_lbl setFrame:CGRectMake(168, 25, 95, 45)];
		[surname_lbl setFrame:CGRectMake(168, 80, 95, 45)];
		[Mobile_lbl setFrame:CGRectMake(168, 156, 95, 45)];
		[Phone_lbl setFrame:CGRectMake(168, 211, 95, 45)];
		[Email_lbl setFrame:CGRectMake(168, 287, 95, 45)];
		[streetadd1_lbl setFrame:CGRectMake(168, 363, 95, 45)];
		[streetsuburb_lbl setFrame:CGRectMake(168, 473, 95, 45)];
		[streetstate_lbl setFrame:CGRectMake(168, 528, 95, 45)];
		[streetpostcode_lbl setFrame:CGRectMake(168, 583, 95, 45)];
		[streetcountry_lbl setFrame:CGRectMake(168, 638, 95, 45)];
		
		[firstname_txt setFrame:CGRectMake(301, 25, 540, 45)];
		[surname_txt setFrame:CGRectMake(301, 80, 540, 45)];
		[Mobile_txt setFrame:CGRectMake(301, 156, 540, 45)];
		[Phone_txt setFrame:CGRectMake(301, 211, 540, 45)];
		[Email_txt setFrame:CGRectMake(301, 287, 540, 45)];
		[streetadd1_txt setFrame:CGRectMake(301, 363, 540, 45)];
		[streetsuburb_txt setFrame:CGRectMake(301, 473, 540, 45)];
		[streetstate_txt setFrame:CGRectMake(301, 528, 540, 45)];
		[streetpostcode_txt setFrame:CGRectMake(301, 583, 540, 45)];
		[streetcountry_txt setFrame:CGRectMake(301, 638, 540, 45)];
		[streetadd2_txt setFrame:CGRectMake(301, 418, 540, 45)];
		
	}
	else {
		[scrollView setContentSize:CGSizeMake(320, 0)];
		[bgImgView setImage:[UIImage imageNamed:@"bg_blue"]];
		
		[firstname_lbl setFrame:CGRectMake(40, 25, 95, 45)];
		[surname_lbl setFrame:CGRectMake(40, 80, 95, 45)];
		[Mobile_lbl setFrame:CGRectMake(40, 156, 95, 45)];
		[Phone_lbl setFrame:CGRectMake(40, 211, 95, 45)];
		[Email_lbl setFrame:CGRectMake(40, 287, 95, 45)];
		[streetadd1_lbl setFrame:CGRectMake(40, 363, 95, 45)];
		[streetsuburb_lbl setFrame:CGRectMake(40, 473, 95, 45)];
		[streetstate_lbl setFrame:CGRectMake(40, 528, 95, 45)];
		[streetpostcode_lbl setFrame:CGRectMake(40, 583, 95, 45)];
		[streetcountry_lbl setFrame:CGRectMake(40, 638, 95, 45)];
		
		[firstname_txt setFrame:CGRectMake(173, 25, 540, 45)];
		[surname_txt setFrame:CGRectMake(173, 80, 540, 45)];
		[Mobile_txt setFrame:CGRectMake(173, 156, 540, 45)];
		[Phone_txt setFrame:CGRectMake(173, 211, 540, 45)];
		[Email_txt setFrame:CGRectMake(173, 287, 540, 45)];
		[streetadd1_txt setFrame:CGRectMake(173, 363, 540, 45)];
		[streetsuburb_txt setFrame:CGRectMake(173, 473, 540, 45)];
		[streetstate_txt setFrame:CGRectMake(173, 528, 540, 45)];
		[streetpostcode_txt setFrame:CGRectMake(173, 583, 540, 45)];
		[streetcountry_txt setFrame:CGRectMake(173, 638, 540, 45)];
		[streetadd2_txt setFrame:CGRectMake(173, 418, 540, 45)];
	}

}


- (void)textFieldDidBeginEditing:(UITextField *)textField {  
	
	[self scrollViewToCenterOfScreen:textField];
	
	if (!doneBtnExist) {
		[self displayDoneBtn];
	}
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{

	if ([textField isEqual:firstname_txt])
	{
		[surname_txt becomeFirstResponder];
	}
	else if ([textField isEqual:surname_txt])
	{
		[Mobile_txt becomeFirstResponder];
	}
	else if ([textField isEqual:Mobile_txt])
	{
		[Phone_txt becomeFirstResponder];
	}
	else if ([textField isEqual:Phone_txt])
	{
		[Email_txt becomeFirstResponder];
	}
	else if ([textField isEqual:Email_txt])
	{
		[streetadd1_txt becomeFirstResponder];
	}
	else if ([textField isEqual:streetadd1_txt])
	{
		[streetadd2_txt becomeFirstResponder];
	}
	else if ([textField isEqual:streetadd2_txt])
	{
		[streetsuburb_txt becomeFirstResponder];
	}
	else if ([textField isEqual:streetsuburb_txt])
	{
		[streetstate_txt becomeFirstResponder];
	}
	else if ([textField isEqual:streetstate_txt])
	{
		[streetpostcode_txt becomeFirstResponder];
	}
	else if ([textField isEqual:streetpostcode_txt])
	{
		[streetcountry_txt becomeFirstResponder];
	}
	else {
		[textField resignFirstResponder];
		[scrollView setContentOffset:CGPointMake(0, 0) animated:YES];  
	}

	
	
	return YES;
} 


- (void)scrollViewToCenterOfScreen:(UIView *)theView {  
	
    CGFloat viewCenterY = theView.center.y;  
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];  
	
    CGFloat availableHeight = applicationFrame.size.height - 250;            // Remove area covered by keyboard  
	
    CGFloat y = viewCenterY - availableHeight / 2.0;  
    if (y < 0) {  
        y = 0;  
    }  
	
}

-(IBAction) testValueChangeMob:(id) sender
{
	NSString *str = [Mobile_txt text];
	NSString * part1;
	NSString * part2;
	NSString * part3;
	
	if ([str length] > MobLength) {
		
		if ([str length] == 5) {
			part1 = [str	substringToIndex:[str length]-1];
			part2 = [str substringFromIndex:[str length]-1];
			
			str = [NSString stringWithFormat:@"%@ %@",part1,part2];
			[Mobile_txt setText:str];
		}
		else if ([str length] == 9) {
			
			part1 = [str	substringToIndex:[str length]-1];
			part2 = [str substringFromIndex:[str length]-1];
			
			str = [NSString stringWithFormat:@"%@ %@",part1,part2];
			[Mobile_txt setText:str];
		}
		else if ([str length] > 12) {
			str = [cFunc removeSpaceInStr:str];
			[Mobile_txt setText:str];
		}
		
	}
	else {
		str = [cFunc removeSpaceInStr:str];
		if ([str length] == 10) {
			part1 = [str substringToIndex:[str	length]-6];
			part2 = [str substringWithRange:NSMakeRange(4, [str	length]-7)];
			part3 = [str substringWithRange:NSMakeRange(7, [str length]-7)];
			str = [NSString stringWithFormat:@"%@ %@ %@",part1,part2,part3];
			[Mobile_txt setText:str];
			NSLog(@"%@ %@ %@",part1,part2,part3);
		}
	}
	
	MobLength = [str length];

}

-(IBAction) testValueChangePhone:(id) sender
{
	NSString *str = [Phone_txt text];
	NSString * part1;
	NSString * part2;
	NSString * part3;
	
	if ([str length] > PhoneLength) {
		
		if ([str length] == 3) {
			part1 = [str	substringToIndex:[str length]-1];
			part2 = [str substringFromIndex:[str length]-1];
			
			str = [NSString stringWithFormat:@"%@ %@",part1,part2];
			[Phone_txt setText:str];
		}
		else if ([str length] == 8) {
			part1 = [str	substringToIndex:[str length]-1];
			part2 = [str substringFromIndex:[str length]-1];
			
			str = [NSString stringWithFormat:@"%@ %@",part1,part2];
			[Phone_txt setText:str];
		}
		else if ([str length] > 12) {
			str = [cFunc removeSpaceInStr:str];
			[Phone_txt setText:str];
		}
	}
	else {
		str = [cFunc removeSpaceInStr:str];
		if ([str length] == 10) {
			part1 = [str substringToIndex:[str	length]-8];
			part2 = [str substringWithRange:NSMakeRange(2, [str	length]-6)];
			part3 = [str substringWithRange:NSMakeRange(6, [str length]-6)];
			str = [NSString stringWithFormat:@"%@ %@ %@",part1,part2,part3];
			[Phone_txt setText:str];
			NSLog(@"%@ %@ %@",part1,part2,part3);
		}
		
	}

	PhoneLength = [str length];
}

-(IBAction) saveAndSendContact:(id) sender
{
	NSString * firstName = [firstname_txt text];
	NSString * surName = [surname_txt text];
	NSString * streetadd1 = [streetadd1_txt text];
	NSString * streetadd2 = [streetadd2_txt text];
	NSString * streetSuburb = [streetsuburb_txt text];
	NSString * streetState = [streetstate_txt text];
	NSString * streetPostcode = [streetpostcode_txt text];
	NSString * streetCountry = [streetcountry_txt text];
	NSString * email = [Email_txt text];
	NSString * phone = [Phone_txt text];
	NSString * mobile = [Mobile_txt text];
	
	
	if (contactIsBeingEdited) {
		NSString *noDataAvailable = @"";
		
		NSString *saveContact =  [SiteURL stringByAppendingFormat:@"object.asp?sid=%@&method=PERSON_UPDATE&select=%@&firstname=%@&surname=%@&streetaddress1=%@&streetaddress2=%@&streetsuburb=%@&streetstate=%@&streetpostcode=%@&streetcountry=%@&email=%@&phone=%@&mobile=%@",
								  Sid,contact.id,[cFunc URLEncodeString:firstName],[cFunc URLEncodeString:surName],[cFunc URLEncodeString:streetadd1],[cFunc URLEncodeString:streetadd2],[cFunc URLEncodeString:streetSuburb],[cFunc URLEncodeString:streetState],[cFunc URLEncodeString:streetPostcode],[cFunc URLEncodeString:streetCountry],[cFunc URLEncodeString:email],[cFunc URLEncodeString:phone],[cFunc URLEncodeString:mobile]];
		
		NSString *URLContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:saveContact] encoding:NSUTF8StringEncoding error:nil];
		
		NSLog(@"%@",URLContent);
		
		NSArray * resultArr = [URLContent componentsSeparatedByString:@"|"];
		
		if ([[resultArr objectAtIndex:1] isEqualToString:@"OK"]) 
		{
			sqlite3 *database;
			
			NSString *sqlStatement = @"";
			if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK) 
			{
				
				sqlStatement = [NSString stringWithFormat:@"delete from fav_contacts where contact_id = '%@' and UserID=%@",contact.id,UserID];
				
				
				NSLog(@"%@",sqlStatement);	
				int execResponse = sqlite3_exec(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL);
				if (execResponse == SQLITE_OK)
				{
					NSLog(@"record deleted successfully!!");
					requestToReloadFav = TRUE;
				}
				else 
				{
					NSLog(@"%i",execResponse);
				}
				
				sqlStatement = [NSString stringWithFormat:@" INSERT INTO fav_contacts ('contact_id','firstname','surname','streetaddress1','streetaddress2','streetsuburb','streetstate','streetpostcode','streetcountry','email','phone','mobile','bestcontactonphone','skype','dateofbirth','gender','UserID') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
								contact.id,[firstname_txt text],[surname_txt text],[streetadd1_txt text],[streetadd2_txt text],[streetsuburb_txt text],[streetstate_txt text],[streetpostcode_txt text],[streetcountry_txt text],[Email_txt text],[Phone_txt text],[Mobile_txt text],noDataAvailable,noDataAvailable,noDataAvailable,noDataAvailable,UserID];
				
				
				NSLog(@"%@",sqlStatement);	
				execResponse = sqlite3_exec(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL);
				if (execResponse == SQLITE_OK)
				{
					NSLog(@"record inserted successfully!!");
					requestToReloadFav = TRUE;
				}
				else 
				{
					NSLog(@"%i",execResponse);
				}
				
				NSLog(@"Error while inserting data. '%s'", sqlite3_errmsg(database));
				
				sqlite3_close(database);
				
			}
			
		}
		
		cd.contact.firstname = firstName;
		cd.contact.surname = surName;
		cd.contact.streetaddress1 = streetadd1;
		cd.contact.streetaddress2 = streetadd2;
		cd.contact.streetsuburb = streetSuburb;
		cd.contact.streetstate = streetState;
		cd.contact.streetpostcode = streetPostcode;
		cd.contact.streetcountry = streetCountry;
		cd.contact.email = email;
		cd.contact.phone = phone;
		cd.contact.mobile = mobile;
	}
	else {
		
		if ([firstName isEqualToString:@""]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"first name cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			[alert release];
			return;
		}
		
		NSString *saveContact =  [SiteURL stringByAppendingFormat:@"object.asp?sid=%@&method=PERSON_ADD&firstname=%@&surname=%@&streetaddress1=%@&streetaddress2=%@&streetsuburb=%@&streetstate=%@&streetpostcode=%@&streetcountry=%@&email=%@&phone=%@&mobile=%@",
								  Sid,[cFunc URLEncodeString:firstName],[cFunc URLEncodeString:surName],[cFunc URLEncodeString:streetadd1],[cFunc URLEncodeString:streetadd2],[cFunc URLEncodeString:streetSuburb],[cFunc URLEncodeString:streetState],[cFunc URLEncodeString:streetPostcode],[cFunc URLEncodeString:streetCountry],[cFunc URLEncodeString:email],[cFunc URLEncodeString:phone],[cFunc URLEncodeString:mobile]];
		
		NSString *URLContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:saveContact] encoding:NSUTF8StringEncoding error:nil];
		
		NSLog(@"%@",URLContent);
		
		NSArray * resultArr = [URLContent componentsSeparatedByString:@"|"];
		NSString *Contactid = [resultArr objectAtIndex:1];
		
		sqlite3 *database;
		
		NSString *noDataAvailable = @"";
		
		NSString *sqlStatement = @"";
		if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK) 
		{
			
			sqlStatement = [NSString stringWithFormat:@" INSERT INTO fav_contacts ('contact_id','firstname','surname','streetaddress1','streetaddress2','streetsuburb','streetstate','streetpostcode','streetcountry','email','phone','mobile','bestcontactonphone','skype','dateofbirth','gender','UserID') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
							Contactid,[firstname_txt text],[surname_txt text],[streetadd1_txt text],[streetadd2_txt text],[streetsuburb_txt text],[streetstate_txt text],[streetpostcode_txt text],[streetcountry_txt text],[Email_txt text],[Phone_txt text],[Mobile_txt text],noDataAvailable,noDataAvailable,noDataAvailable,noDataAvailable,UserID];
			
			
			NSLog(@"%@",sqlStatement);	
			int execResponse = sqlite3_exec(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL);
			if (execResponse == SQLITE_OK)
			{
				NSLog(@"record inserted successfully!!");
				requestToReloadFav = TRUE;
			}
			else 
			{
				NSLog(@"%i",execResponse);
			}
			
			NSLog(@"Error while inserting data. '%s'", sqlite3_errmsg(database));
			
			sqlite3_close(database);
			
		}
		
	}

		
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) cancelBtnPressed:(id) sender
{
	contactIsBeingEdited = FALSE;
	[self.navigationController popViewControllerAnimated:YES];
}

-(void) displayDoneBtn
{
	UIBarButtonItem *rightIconBtn = [[UIBarButtonItem alloc] initWithTitle:@" Done " style:UIBarButtonItemStylePlain target:self action:@selector(saveAndSendContact:)];
	self.navigationItem.rightBarButtonItem = rightIconBtn;
	[rightIconBtn release];
	
	doneBtnExist = TRUE;
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	[self orientationChanged:interfaceOrientation];
	
    return YES;
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
	[bgImgView release];
    [super dealloc];
}


@end
