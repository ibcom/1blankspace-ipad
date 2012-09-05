    //
//  SearchContactsViewController.m
//  1blankspaceiPad
//
//  Created by Vipin Jain on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchContactsViewController.h"
#import "Config.h"
#import "CommonFunctions.h"
#import "TBXML.h"
#import "Contact.h"
#import "ContactDetailViewController.h"
#import "NSString+HTML.h"


@implementation SearchContactsViewController
@synthesize searchBar,tblView,arr;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Search";
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar1
{
	
	[searchBar1 setShowsCancelButton:YES animated:YES];
	[[self navigationController ] setNavigationBarHidden:YES animated: YES];
	return YES;
	
}

-(void) searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText
{
	if ([[searchBar1 text] length]==0) 
	{
		[searchBar1 setShowsCancelButton:YES animated:YES];
	}
	/*else if ([[searchBar1 text] length]>=4) 
	 {
	 if (!HUDisActive) {
	 
	 HUDisActive = TRUE;
	 HUD = [[MBProgressHUD alloc] initWithView:self.view];
	 HUD.graceTime = 0.5;
	 HUD.navigationBar = self.navigationController.navigationBar;
	 [self.view addSubview:HUD];
	 HUD.delegate = self;
	 [HUD showWhileExecuting:@selector(search) onTarget:self withObject:@"0" animated:YES];
	 
	 }
	 }*/
	else
	{
		//[searchBar1 setShowsCancelButton:NO animated:YES];
	}
	
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar1
{
	
	[searchBar1 resignFirstResponder];
	[searchBar1 setShowsCancelButton:NO animated:YES];
	[[self navigationController ] setNavigationBarHidden:NO animated: YES];
	
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
	
	[searchBar1 resignFirstResponder];
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	HUD.graceTime = 0.5;
	HUD.navigationBar = self.navigationController.navigationBar;
    [self.view addSubview:HUD];
    HUD.delegate = self;
	[HUD showWhileExecuting:@selector(search) onTarget:self withObject:@"0" animated:YES]; 
	
	
}


-(void) search
{
	
	// https://secure.mydigitalspacelive.com/directory/ondemand/object.asp?sid=143571096-k-1bafab583b05f3c7300ff815f9e84b79&method=PERSON_SEARCH&basic=1&name=int
	NSString *url = [SiteURL stringByAppendingFormat:@"object.asp?sid=%@&method=PERSON_SEARCH&basic=1&name=%@",Sid,searchBar.text];
	
	NSString *response = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
	
	NSArray *responseArr = [response componentsSeparatedByString:@"|"];
	
	arr = [[NSMutableArray alloc] init];
	
	if ([[responseArr objectAtIndex:0] isEqualToString:@"OK"])
	{
		
		TBXML * tbxml = [[TBXML alloc] initWithXMLString:[responseArr objectAtIndex:1]];
		TBXMLElement * root = tbxml.rootXMLElement; 
		
		if (root) 
		{  
			
			TBXMLElement *row	= [tbxml childElementNamed:@"row" parentElement:root];
			
			while (row != nil)
			{ 
				
				//NSString * rownumber			= [tbxml textForElement:[tbxml childElementNamed:@"rownumber" parentElement:row]];
				//NSString * rowcount				= [tbxml textForElement:[tbxml childElementNamed:@"rowcount" parentElement:row]];
				//NSString * reference			= [tbxml textForElement:[tbxml childElementNamed:@"reference" parentElement:row]];
				NSString * id					= [tbxml textForElement:[tbxml childElementNamed:@"id" parentElement:row]];
				//NSString * contbusinessid		= [tbxml textForElement:[tbxml childElementNamed:@"contbusinessid" parentElement:row]];
				NSString * firstname			= [tbxml textForElement:[tbxml childElementNamed:@"firstname" parentElement:row]];
				NSString * surname				= [tbxml textForElement:[tbxml childElementNamed:@"surname" parentElement:row]];
				NSString * streetaddress1		= [tbxml textForElement:[tbxml childElementNamed:@"streetaddress1" parentElement:row]];
				NSString * streetaddress2		= [tbxml textForElement:[tbxml childElementNamed:@"streetaddress2" parentElement:row]];
				NSString * streetsuburb			= [tbxml textForElement:[tbxml childElementNamed:@"streetsuburb" parentElement:row]];
				NSString * streetstate			= [tbxml textForElement:[tbxml childElementNamed:@"streetstate" parentElement:row]];
				NSString * streetpostcode		= [tbxml textForElement:[tbxml childElementNamed:@"streetpostcode" parentElement:row]];
				NSString * streetcountry		= [tbxml textForElement:[tbxml childElementNamed:@"streetcountry" parentElement:row]];
				NSString * temp					= [tbxml textForElement:[tbxml childElementNamed:@"email" parentElement:row]];
				NSString * email				= [temp stringByDecodingHTMLEntities];
				//NSString * homephone			= [tbxml textForElement:[tbxml childElementNamed:@"homephone" parentElement:row]];
				NSString * phone				= [tbxml textForElement:[tbxml childElementNamed:@"phone" parentElement:row]];
				NSString * mobile				= [tbxml textForElement:[tbxml childElementNamed:@"mobile" parentElement:row]];
				NSString * bestcontactonphone	= [tbxml textForElement:[tbxml childElementNamed:@"bestcontactonphone" parentElement:row]];
				NSString * skype				= [tbxml textForElement:[tbxml childElementNamed:@"skype" parentElement:row]];
				NSString * dateofbirth			= [tbxml textForElement:[tbxml childElementNamed:@"dateofbirth" parentElement:row]];
				//NSString * age					= [tbxml textForElement:[tbxml childElementNamed:@"age" parentElement:row]];
				NSString * gender				= [tbxml textForElement:[tbxml childElementNamed:@"gender" parentElement:row]];
				//NSString * genderttext			= [tbxml textForElement:[tbxml childElementNamed:@"genderttext" parentElement:row]];
				//NSString * gendertext			= [tbxml textForElement:[tbxml childElementNamed:@"gendertext" parentElement:row]];
				//NSString * minutesfromutc		= [tbxml textForElement:[tbxml childElementNamed:@"minutesfromutc" parentElement:row]];
				//NSString * localtime			= [tbxml textForElement:[tbxml childElementNamed:@"localtime" parentElement:row]];	
				//NSString * relationshipcount	= [tbxml textForElement:[tbxml childElementNamed:@"relationshipcount" parentElement:row]];
				
				
				Contact *contact = [[Contact alloc] init];
				contact.id						= id;					
				contact.firstname				= firstname;			
				contact.surname					= surname;				
				contact.streetaddress1			= streetaddress1;		
				contact.streetaddress2			= streetaddress2;		
				contact.streetsuburb			= streetsuburb;			
				contact.streetstate				= streetstate;			
				contact.streetpostcode			= streetpostcode;		
				contact.streetcountry			= streetcountry;		
				contact.email					= email;				
				contact.phone					= phone;				
				contact.mobile					= mobile;				
				contact.bestcontactonphone		= bestcontactonphone;	
				contact.skype					= skype;				
				contact.dateofbirth				= dateofbirth;			
				contact.gender					= gender;				
				
				[arr addObject:contact];
				
				row = [tbxml nextSiblingNamed:@"row" searchFromElement:row];
				
			}
			
			
		}
		
		
	}
	
	
	
}



#pragma mark Table view methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [arr count];	 	
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	int rowHeight;
	
	rowHeight = 55;
	
	return rowHeight;
	
}


// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
 	
	
	static NSString *CellIdentifier					= @"SearchContacts";
	
	Contact *contact = [arr objectAtIndex:indexPath.row];
	
	UITableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	CGSize sizeFirstname = [contact.firstname sizeWithFont:[UIFont systemFontOfSize:22.0f] constrainedToSize:CGSizeMake(200, 30) lineBreakMode:UILineBreakModeWordWrap];
	
	CGSize sizeSurname = [contact.surname sizeWithFont:[UIFont systemFontOfSize:22.0f] constrainedToSize:CGSizeMake(200, 30) lineBreakMode:UILineBreakModeWordWrap];
	
    if (cellView == nil)
	{
		cellView = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		
		/*
		 UITextField *title = [[UITextField alloc] initWithFrame:CGRectMake(74, 5, 220,50 )]; 
		 [title setTag:1];
		 [title setTextAlignment:UITextAlignmentLeft];
		 [title setEnabled:FALSE];
		 [title setTextColor:[UIColor colorWithRed:0.1992 green:0.1992 blue:0.1992 alpha:1.0]];
		 [title setFont:[UIFont boldSystemFontOfSize:16.0]];
		 [title setBackgroundColor:[UIColor clearColor]];
		 [cellView.contentView addSubview:title];
		 [title release];	
		 
		 
		 UITextField *djName = [[UITextField alloc] initWithFrame:CGRectMake(74, 27, 240,50 )]; 
		 [djName setTag:TAG_DJ_NAME];
		 [djName setTextAlignment:UITextAlignmentLeft];
		 [djName setEnabled:FALSE];
		 [djName setTextColor:[UIColor colorWithRed:0.3984 green:0.3984 blue:0.3984 alpha:1.0]];
		 [djName setFont:[UIFont systemFontOfSize:12.0]];
		 [djName setBackgroundColor:[UIColor clearColor]];
		 [cellView.contentView addSubview:djName];
		 [djName release];
		 */
		
		UILabel *lbl1 = [[UILabel alloc] init];
		[lbl1 setTag:1];
		[cellView.contentView addSubview:lbl1];
		
		UILabel *lbl2 = [[UILabel alloc] init];
		[lbl2 setTag:2];
		[cellView.contentView addSubview:lbl2];
		
		cellView.selectionStyle = UITableViewCellSelectionStyleBlue;
		cellView.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
		//cellView.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
		
    }
	
 	if (indexPath.row < [arr count])
	{
		
		UILabel *tmplbl1 = (UILabel *)[cellView viewWithTag:1];
		[tmplbl1 setFrame:CGRectMake(10.0f, 12.0f, sizeFirstname.width+2.f, 30.0f)];
		[tmplbl1 setFont:[UIFont boldSystemFontOfSize:20.0f]];
		[tmplbl1 setText:contact.firstname];
		
		
		UILabel *tmplbl2 = (UILabel *)[cellView viewWithTag:2];
		[tmplbl2 setFrame:CGRectMake(sizeFirstname.width+2.0f+10.0f, 12.0f, sizeSurname.width, 30.0f)];
		[tmplbl2 setFont:[UIFont systemFontOfSize:20.0f]];
		[tmplbl2 setText:contact.surname];
		
		/*
		 UITextField *txtField;
		 
		 txtField = (UITextField *) [cellView viewWithTag:1]; 
		 [txtField setText:[NSString stringWithFormat:@"%@ %@",contact.firstname,contact.surname]];
		 */
	}
	
	return cellView;
	
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	ContactDetailViewController *cd	= [[ContactDetailViewController alloc] init];
	cd.contact			= [[arr objectAtIndex:indexPath.row] retain];
	[self.navigationController pushViewController:cd animated:YES];
	[cd release];
	
}


- (void)hudWasHidden 
{
	HUDisActive = FALSE;
	[tblView reloadData];
	
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
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
