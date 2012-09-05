    //
//  ContactDetailViewController.m
//  1blankspaceiPad
//
//  Created by Vipin Jain on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "Contact.h"
#import "sqlite3.h"
#import "Config.h"
#import "EmailViewController.h"
#import "MapViewController.h"
#import "AddContactViewController.h"
#import "NSString+HTML.h"


@implementation ContactDetailViewController
@synthesize contact,tblView;
@synthesize imgBgView;

NSString *orientationType;

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
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) 
	{
		orientationType = @"landscape";
		[imgBgView setFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 768.0f)];
		[imgBgView setImage:[UIImage imageNamed:@"bg.png"]];
	}
	else 
	{
		[imgBgView setFrame:CGRectMake(0.0f, 0.0f, 768.0f, 1024.0f)];
		[imgBgView setImage:[UIImage imageNamed:@"bg_blue.png"]];
		orientationType = @"portrait";
	}
	
	[super viewWillAppear:animated];
	[tblView reloadData];
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[self.navigationController setNavigationBarHidden:FALSE animated:TRUE];
	
	[self setTitle:@"Info"];
	
	UIBarButtonItem *rightIconBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editContactBtnPressed:)];
	self.navigationItem.rightBarButtonItem = rightIconBtn;
	[rightIconBtn release];
	
	UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithTitle:[contact.firstname stringByAppendingFormat:@" %@",contact.surname] style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backBarBtn;
	[backBarBtn release];
	
	[self checkForFav];
	
	
	UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
	v.backgroundColor=[UIColor clearColor];
	[tblView setBackgroundView:v];
}

-(void) checkForFav
{
	sqlite3 *database;
	
	NSString *sqlStatement = @"";
	
	if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK) 
	{
		sqlStatement = [NSString stringWithFormat:@"select Count(*) as cnt from fav_contacts where contact_id like '%@' and UserID=%@",contact.id,UserID];
		
		NSLog(@"%@",sqlStatement);
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			
			if (sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				NSString *cnt = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)];
				if ([cnt intValue] > 0) {
					isFav = TRUE;
					//[favStar setHidden:FALSE];
					//[addAsfavBtn setTitle:@"Remove From Favourite" forState:UIControlStateNormal];
					//[addAsfavBtn setTag:1];
				}
				else {
					isFav = FALSE;
					//[favStar setHidden:TRUE];
					//[addAsfavBtn setTitle:@"Set as Favourite" forState:UIControlStateNormal];
					//[addAsfavBtn setTag:0];
				}
				
			}
			else {
				isFav = FALSE;
				//[favStar setHidden:TRUE];
				//[addAsfavBtn setTitle:@"Set as Favourite" forState:UIControlStateNormal];
				//[addAsfavBtn setTag:0];
			}
			
		}
		
		sqlite3_finalize(compiledStatement);
		
		
		sqlite3_close(database);
		
		
	}	
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int noOfSections;
	NSString *address = [NSString stringWithFormat:@"%@%@%@%@%@%@",contact.streetaddress1,contact.streetaddress2,contact.streetsuburb,contact.streetstate,contact.streetpostcode,contact.streetcountry];
	if ([address isEqualToString:@""]) {
		noOfSections = 3;
	}else {
		noOfSections = 4;
	}
	
	return noOfSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int rowheight;
	if (indexPath.section == 2) {
		rowheight = 111.0f;
	}
	else {
		rowheight = 55.0f;
	}
	
	return rowheight;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	int rowcount;
	
	if (section == 0)
		rowcount = 2;
	else 
		rowcount = 1;
	
	return rowcount;
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cellView = [[UITableViewCell alloc] init];
	
	cellView.selectionStyle = UITableViewCellSelectionStyleBlue;
	cellView.accessoryType	= UITableViewCellAccessoryNone;
    
	
  	
	if (indexPath.section == 0)
	{
		if (indexPath.row == 0 )
		{
			UILabel *lblField = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 19.0f, 85.0f, 20.0f)];
			[lblField setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
			[lblField setFont:[UIFont boldSystemFontOfSize:17.0f]];
			[lblField setTextAlignment:UITextAlignmentRight];
			[lblField setBackgroundColor:[UIColor clearColor]];
			[lblField setHighlightedTextColor:[UIColor whiteColor]];
			[lblField setText:@"mobile"];
			[cellView addSubview:lblField];
			
			UILabel *lblFieldVal = [[UILabel alloc] initWithFrame:CGRectMake(175.0f, 19.0f, 540.0f, 20.0f)];
			[lblFieldVal setTextColor:[UIColor blackColor]];
			[lblFieldVal setBackgroundColor:[UIColor clearColor]];
			[lblFieldVal setFont:[UIFont boldSystemFontOfSize:17.0f]];
			[lblFieldVal setHighlightedTextColor:[UIColor whiteColor]];
			[lblFieldVal setText:[NSString stringWithFormat:@"%@",contact.mobile]];
			[cellView addSubview:lblFieldVal];
			
		}
		else 
		{
			
			
			UILabel *lblField = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 19.0f, 85.0f, 20.0f)];
			[lblField setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
			[lblField setFont:[UIFont boldSystemFontOfSize:17.0f]];
			[lblField setTextAlignment:UITextAlignmentRight];
			[lblField setBackgroundColor:[UIColor clearColor]];
			[lblField setHighlightedTextColor:[UIColor whiteColor]];
			[lblField setText:@"phone"];
			[cellView addSubview:lblField];
			
			UILabel *lblFieldVal = [[UILabel alloc] initWithFrame:CGRectMake(175.0f, 19.0f, 540.0f, 20.0f)];
			[lblFieldVal setTextColor:[UIColor blackColor]];
			[lblFieldVal setBackgroundColor:[UIColor clearColor]];
			[lblFieldVal setFont:[UIFont boldSystemFontOfSize:17.0f]];
			[lblFieldVal setHighlightedTextColor:[UIColor whiteColor]];
			[lblFieldVal setText:[NSString stringWithFormat:@"%@",contact.phone]];
			[cellView addSubview:lblFieldVal];
		}
		
		
	}
	else if (indexPath.section == 1)
	{
		UILabel *lblField = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 19.0f, 85.0f, 20.0f)];
		[lblField setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
		[lblField setFont:[UIFont boldSystemFontOfSize:17.0f]];
		[lblField setTextAlignment:UITextAlignmentRight];
		[lblField setBackgroundColor:[UIColor clearColor]];
		[lblField setHighlightedTextColor:[UIColor whiteColor]];
		[lblField setText:@"email"];
		[cellView addSubview:lblField];
		
		UILabel *lblFieldVal = [[UILabel alloc] initWithFrame:CGRectMake(175.0f, 19.0f, 540.0f, 20.0f)];
		[lblFieldVal setTextColor:[UIColor blackColor]];
		[lblFieldVal setBackgroundColor:[UIColor clearColor]];
		[lblFieldVal setFont:[UIFont boldSystemFontOfSize:17.0f]];
		[lblFieldVal setHighlightedTextColor:[UIColor whiteColor]];
		[lblFieldVal setText:[NSString stringWithFormat:@"%@",contact.email]];
		[cellView addSubview:lblFieldVal];
		
	}
	else if (indexPath.section == 2)
	{
		NSString *address = [NSString stringWithFormat:@"%@%@%@%@%@%@",contact.streetaddress1,contact.streetaddress2,contact.streetsuburb,contact.streetstate,contact.streetpostcode,contact.streetcountry];
		if ([address isEqualToString:@""]) 
		{
			UIView *sectionBack = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 768.0f, 50.0f)];
			[sectionBack setBackgroundColor:[UIColor clearColor]];
			
			[cellView setBackgroundView:sectionBack];
			
			addAsfavBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			
			if ([orientationType isEqualToString:@"landscape"]) {
				
				[addAsfavBtn setFrame:CGRectMake(398.0f, 0.0f, 228.0f, 45.0f)];
			}
			else {
				[addAsfavBtn setFrame:CGRectMake(270.0f, 0.0f, 228.0f, 45.0f)];
			}
			
			if (isFav) {
				[addAsfavBtn setTitle:@"Remove From Favourites" forState:UIControlStateNormal];
			}
			else {
				[addAsfavBtn setTitle:@"Set as Favourite" forState:UIControlStateNormal];
			}
			[addAsfavBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
			[addAsfavBtn addTarget:self action:@selector(favBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
			[cellView addSubview:addAsfavBtn];
			[cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		else 
		{
			UILabel *lblField = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 19.0f, 85.0f, 20.0f)];
			[lblField setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
			[lblField setFont:[UIFont boldSystemFontOfSize:17.0f]];
			[lblField setTextAlignment:UITextAlignmentRight];
			[lblField setBackgroundColor:[UIColor clearColor]];
			[lblField setHighlightedTextColor:[UIColor whiteColor]];
			[lblField setText:@"address"];
			[cellView addSubview:lblField];
			
			NSString *address = [contact.streetaddress1 stringByAppendingFormat:@" %@ \n%@ \n%@ %@",contact.streetaddress2,contact.streetsuburb,contact.streetstate,contact.streetpostcode];
			
			NSString *decodedAddress = [address stringByDecodingHTMLEntities];
			
			UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(167.0f, 10.0f, 540.0f, 80.0f)];
			[txtView setFont:[UIFont boldSystemFontOfSize:17.0f]];
			[txtView setBackgroundColor:[UIColor clearColor]];
			[txtView setUserInteractionEnabled:FALSE];
			[txtView setText:decodedAddress];
			[cellView addSubview:txtView];			
		}
		
	}
	else if(indexPath.section == 3) {
		
		[cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		UIView *sectionBack = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
		[sectionBack setBackgroundColor:[UIColor clearColor]];
		
		[cellView setBackgroundView:sectionBack];
		
		addAsfavBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		
		if ([orientationType isEqualToString:@"landscape"]) {
			
			[addAsfavBtn setFrame:CGRectMake(398.0f, 0.0f, 228.0f, 45.0f)];
		}
		else {
			[addAsfavBtn setFrame:CGRectMake(270.0f, 0.0f, 228.0f, 45.0f)];
		}
		
		if (isFav) {
			[addAsfavBtn setTitle:@"Remove From Favourites" forState:UIControlStateNormal];
		}
		else {
			[addAsfavBtn setTitle:@"Set as Favourite" forState:UIControlStateNormal];
		}
		[addAsfavBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
		[addAsfavBtn addTarget:self action:@selector(favBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
		[cellView addSubview:addAsfavBtn];
	}
	
	
	return cellView;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			
			/*	UIActionSheet *actionSheet = [[UIActionSheet alloc]
			 initWithTitle:@"Option"
			 delegate:self
			 cancelButtonTitle:@"Cancel"
			 destructiveButtonTitle:nil
			 otherButtonTitles:@"Call", @"SMS",nil];
			 
			 [actionSheet setTag:1];
			 [actionSheet showInView:self.tabBarController.view];
			 [actionSheet release];*/
		}
		else if (indexPath.row == 1) {
			/*NSString *temp = [NSString stringWithFormat:@"%@",contact.phone];
			 
			 temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
			 temp = [temp stringByReplacingOccurrencesOfString:@")" withString:@""];
			 temp = [temp stringByReplacingOccurrencesOfString:@"(" withString:@""];
			 temp = [temp stringByReplacingOccurrencesOfString:@"-" withString:@""];
			 
			 NSString *phoneNo = [NSString stringWithFormat:@"tel://%@",temp];
			 
			 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNo]];	*/	}
	}
	else if (indexPath.section == 1) {
		[self emailBtnPressed:nil];
	}
	else if (indexPath.section == 2) {
		[self mapBtnPressed:nil];
		
	}
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	CGFloat sectionHeight;
	
	if (section == 0)
	{
		NSString *strName = [NSString stringWithFormat:@"%@ %@",contact.firstname,contact.surname];
		CGSize sizeName = [strName sizeWithFont:[UIFont boldSystemFontOfSize:20] constrainedToSize:CGSizeMake(250, 100) lineBreakMode:UILineBreakModeCharacterWrap];	
		sectionHeight = sizeName.height+25;
	}
	else 
		sectionHeight = 20;
	
	return sectionHeight;
	
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
    // Create header view and add label as a subview
    UIView *view;
	
	if (section == 0)
	{
		
		NSString *strName = [NSString stringWithFormat:@"%@ %@",contact.firstname,contact.surname];
		CGSize sizeName = [strName sizeWithFont:[UIFont boldSystemFontOfSize:20] constrainedToSize:CGSizeMake(250, 100) lineBreakMode:UILineBreakModeCharacterWrap];	
		
		view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, sizeName.height+40)];
		[view setBackgroundColor:[UIColor clearColor]];
		[view autorelease];
		
		UITextView *txtName = [[UITextView alloc] initWithFrame:CGRectMake(50.0f, 10.0f, 600.0f, sizeName.height+10)];
		[txtName setText:strName];
		[txtName setFont:[UIFont boldSystemFontOfSize:18.0f]];	
		[txtName setTextColor:[UIColor blackColor]];
		[txtName setBackgroundColor:[UIColor clearColor]];
		[txtName setUserInteractionEnabled:FALSE];
		
		[view addSubview:txtName];
		
		UIImageView *favStar = [[UIImageView alloc] init];
		
		if ([orientationType isEqualToString:@"landscape"]) {
			[favStar setFrame:CGRectMake(939.0f, 10.0f, 35.0f, 35.0f)];
		}
		else {
			[favStar setFrame:CGRectMake(683.0f, 10.0f, 35.0f, 35.0f)];
		}
		
		[favStar setImage:[UIImage imageNamed:@"star.png"]];
		[view addSubview:favStar];
		
		if (isFav) {
			[favStar setHidden:FALSE];
			[addAsfavBtn setTag:1];
		}
		else {
			[favStar setHidden:TRUE];
			[addAsfavBtn setTag:0];
		}
		
	}
	else 
	{
		view = nil;
	}
	
    return view;
	
}


-(IBAction) emailBtnPressed:(id) sender
{
	NSString *email = [NSString stringWithFormat:@"%@",contact.email];
	if ([email isEqualToString:@""]) {
		return;
	}
	
	EmailViewController *evc = [[EmailViewController alloc] init];
	evc.contactId = contact.id;
	[self.navigationController pushViewController:evc animated:YES];
}

-(IBAction) mapBtnPressed:(id) sender
{
	NSString *add = [[NSString stringWithFormat:@"%@ %@ %@ %@ %@",contact.streetaddress1,contact.streetaddress2,contact.streetsuburb,contact.streetstate,contact.streetcountry] retain];
	//NSString *add = @"Mansarover Jaipur India";
	NSString *trimmedString = [add stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([trimmedString isEqualToString:@""]) {
		return;
	}
	
	MapViewController *mvc = [[MapViewController alloc] init];
	mvc.address = add;
	mvc.name = contact.firstname;
	mvc.surname = contact.surname;
	[self.navigationController pushViewController:mvc animated:YES];
	
}

-(IBAction) favBtnPressed:(id) sender
{
	if ([addAsfavBtn tag] == 0) {
		
		NSString *saveContact =  [SiteURL stringByAppendingFormat:@"object.asp?sid=%@&method=PERSON_SET_AS_FAVOURITE&select=%@",Sid,contact.id];
		
		NSString *URLContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:saveContact] encoding:NSUTF8StringEncoding error:nil];
		
		NSLog(@"%@",URLContent);
		
		NSArray * resultArr = [URLContent componentsSeparatedByString:@"|"];
		
		if ([[resultArr objectAtIndex:1] isEqualToString:@"OK"]) 
		{
			sqlite3 *database;
			
			NSString *sqlStatement = @"";
			if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK) 
			{
				
				sqlStatement = [NSString stringWithFormat:@" INSERT INTO fav_contacts ('contact_id','firstname','surname','streetaddress1','streetaddress2','streetsuburb','streetstate','streetpostcode','streetcountry','email','phone','mobile','bestcontactonphone','skype','dateofbirth','gender','UserID') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
								contact.id,contact.firstname,contact.surname,contact.streetaddress1,contact.streetaddress2,contact.streetsuburb,contact.streetstate,contact.streetpostcode,contact.streetcountry,contact.email,contact.phone,contact.mobile,contact.bestcontactonphone,contact.skype,contact.dateofbirth,contact.gender,UserID];
				
				
				NSLog(@"%@",sqlStatement);	
				int execResponse = sqlite3_exec(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL);
				if (execResponse == SQLITE_OK)
				{
					NSLog(@"record inserted successfully!!");
					[self checkForFav];
					[tblView reloadData];
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
		else {
			UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please try again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alertview show];
			[alertview release];
		}
		
		
		
	}
	else if ([addAsfavBtn tag] == 1) 
	{
		
		NSString *saveContact =  [SiteURL stringByAppendingFormat:@"object.asp?sid=%@&method=PERSON_SET_AS_FAVOURITE&select=%@&remove=1",Sid,contact.id];
		
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
					[self checkForFav];
					[tblView reloadData];
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
		
	}
}

-(IBAction) editContactBtnPressed:(id) sender
{
	contactIsBeingEdited = TRUE;
	AddContactViewController *acvc = [[AddContactViewController alloc] init];
	acvc.contact = [contact retain];
	acvc.cd		= self;
	[self.navigationController pushViewController:acvc animated:YES];
}

#pragma mark -
#pragma mark ActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    
	if ([actionSheet tag] == 1)// Handling ActionSheet for contact..
	{
		if (buttonIndex == 0) // make call to contact  
		{
			NSString *temp = [NSString stringWithFormat:@"%@",contact.mobile];
			
			temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
			temp = [temp stringByReplacingOccurrencesOfString:@")" withString:@""];
			temp = [temp stringByReplacingOccurrencesOfString:@"(" withString:@""];
			temp = [temp stringByReplacingOccurrencesOfString:@"-" withString:@""];
			
			NSString *mobileNo = [NSString stringWithFormat:@"tel://%@",temp];
			
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobileNo]];
			
		}
		else if (buttonIndex == 1) // send sms to contact
		{
			
			NSString *temp = [NSString stringWithFormat:@"%@",contact.mobile];
			
			temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
			temp = [temp stringByReplacingOccurrencesOfString:@")" withString:@""];
			temp = [temp stringByReplacingOccurrencesOfString:@"(" withString:@""];
			temp = [temp stringByReplacingOccurrencesOfString:@"-" withString:@""];
			
			NSString *sms = [NSString stringWithFormat:@"sms://%@",temp];
			
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:sms]];
		}
		
	}
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	
	[tblView reloadData];
	
	if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) 
	{
		orientationType = @"landscape";
		[imgBgView setFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 768.0f)];
		[imgBgView setImage:[UIImage imageNamed:@"bg.png"]];
	}
	else 
	{
		[imgBgView setFrame:CGRectMake(0.0f, 0.0f, 768.0f, 1024.0f)];
		[imgBgView setImage:[UIImage imageNamed:@"bg_blue.png"]];
		orientationType = @"portrait";
	}
	
	[tblView reloadData];
	
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
