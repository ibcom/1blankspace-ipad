    //
//  FavouriteViewController.m
//  1blankspaceiPad
//
//  Created by Vipin Jain on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavouriteViewController.h"
#import "sqlite3.h"
#import "Config.h"
#import "CommonFunctions.h"
#import "Contact.h"
#import "NSString+HTML.h"
#import "ContactDetailViewController.h"
#import "AddContactViewController.h"


@implementation FavouriteViewController
@synthesize tblView;

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
	cFunc = [[CommonFunctions alloc] init];
	if ([cFunc isItFirstLoad])
	{
		NSLog(@"first load");
		[cFunc syncFavContacts];
		
	}
	else 
	{
		NSLog(@"this is not a first load");
	}
	
	if (requestToReloadFav) {
		
		HUD = [[MBProgressHUD alloc] initWithView:self.view];
		HUD.graceTime = 0.5;
		
		[self.view addSubview:HUD];
		HUD.delegate = self;
		[HUD showWhileExecuting:@selector(loadAllFavContacts) onTarget:self withObject:@"0" animated:YES];
		requestToReloadFav = FALSE;
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationItem setTitle:@"Favourites"];
	
	contactArr = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *rightIconBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContactBtnPressed:)];
	self.navigationItem.rightBarButtonItem = rightIconBtn;
	[rightIconBtn release];
	
	UIBarButtonItem *leftIconBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshBtnPressed:)];
	self.navigationItem.leftBarButtonItem = leftIconBtn;
	[leftIconBtn release];
	
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"  Back  " style:UIBarButtonItemStylePlain target:nil action:nil]];	
}

//load all contacts from local database
-(void) loadAllFavContacts
{
	sqlite3 *database;
	
	NSString *sqlStatement = @"";
	
	Indices = [[NSMutableArray alloc] init];
	tmpContactArr = [[NSMutableArray alloc] init];
	
	if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK) 
	{
		char i;
		for (i='A'; i<='Z'; i++) {
			sqlStatement = [NSString stringWithFormat:@"select * from fav_contacts where firstname like '%c%%' and UserID=%@",i,UserID];
			NSString *character = [NSString stringWithFormat:@"%c",i];
			[Indices addObject:character];
			
			NSLog(@"%@",sqlStatement);
			sqlite3_stmt *compiledStatement;
			NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
			
			if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK) 
			{
				
				while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
				{
					NSString * contact_id			= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 1)];
					NSString * firstname			= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 2)];
					NSString * surname				= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 3)];
					NSString * streetaddress1		= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 4)];
					NSString * streetaddress2		= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 5)];
					NSString * streetsuburb			= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 6)];
					NSString * streetstate			= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 7)];
					NSString * streetpostcode		= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 8)];
					NSString * streetcountry		= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 9)];
					NSString * temp					= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 10)];
					NSString * email				= [temp stringByDecodingHTMLEntities];
					NSString * phone				= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 11)];
					NSString * mobile				= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 12)];
					NSString * bestcontactonphone	= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 13)];
					NSString * skype				= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 14)];
					NSString * dateofbirth			= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 15)];
					NSString * gender				= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 16)];
					
					Contact *contact = [[Contact alloc] init];
					
					contact.id						= contact_id;		
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
					
					
					//NSDictionary *nd = [NSDictionary dictionaryWithObjectsAndKeys:contact_id,@"id",firstname,@"firstname",surname,@"surname",streetaddress1,@"streetaddress1",streetaddress2,@"streetaddress2",streetsuburb,@"streetsuburb",streetstate,@"streetstate",streetpostcode,@"streetpostcode",streetcountry,@"streetcountry",email,@"email",phone,@"phone",mobile,@"mobile",bestcontactonphone,@"bestcontactonphone",skype,@"skype",dateofbirth,@"dateofbirth",gender,@"gender",nil];
					[tmpArr addObject:contact];
				}
				if ([tmpArr count] != 0) {
					[tmpContactArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:character,@"headerTitle",tmpArr,@"sectionArr",nil]];
				}
				
			}
			
			sqlite3_finalize(compiledStatement);
			
		}
		
		sqlite3_close(database);
		
		
	}	
	
}

-(IBAction) refreshBtnPressed:(id) sender
{
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	HUD.graceTime = 0.5;
	
	[self.view addSubview:HUD];
	HUD.delegate = self;
	[HUD showWhileExecuting:@selector(syncAndLoadData) onTarget:self withObject:@"0" animated:YES];
	requestToReloadFav = FALSE;
	
}

-(void) syncAndLoadData
{
	[cFunc syncFavContacts];
	[self loadAllFavContacts];
}

-(IBAction) addContactBtnPressed:(id) sender
{
	AddContactViewController *acvc = [[AddContactViewController alloc] init];
	[self.navigationController pushViewController:acvc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	int sectionCount;
	
	if ([contactArr count]) 
	{
		sectionCount = [contactArr count];
	}
	else 
	{
		sectionCount = 0;
	}
	
	
	return sectionCount;
	
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	int rowCount;
	
	if ([contactArr count]) 
	{
		rowCount = [[[contactArr objectAtIndex:section] objectForKey:@"sectionArr"] count];
	}
	else 
	{
		rowCount = 0;
	}
	
	
	return rowCount;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	int rowHeight;
	
	rowHeight = 55;
	
	return rowHeight;
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	static NSString *MyIdentifier = @"ContactManager";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	Contact *contact = [[Contact alloc] init];
	if ([contactArr count] >= indexPath.section) 
	{
		contact	= [[[contactArr objectAtIndex:indexPath.section] objectForKey:@"sectionArr"] objectAtIndex:indexPath.row];
	}
	
	CGSize sizeFirstname = [contact.firstname sizeWithFont:[UIFont systemFontOfSize:22.0f] constrainedToSize:CGSizeMake(200, 30) lineBreakMode:UILineBreakModeCharacterWrap];
	NSLog(@"firstName_width=%f  firstName_height=%f",sizeFirstname.width,sizeFirstname.height);
	
	CGSize sizeSurname = [contact.surname sizeWithFont:[UIFont systemFontOfSize:22.0f] constrainedToSize:CGSizeMake(200, 30) lineBreakMode:UILineBreakModeCharacterWrap];
	NSLog(@"Surname_width=%f  Surname_height=%f",sizeSurname.width,sizeSurname.height);
	// If no cell is available, create a new one using the given identifier.
	if (cell == nil) {
		// Use the default cell style.
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier] autorelease];
		
		UILabel *lbl1 = [[UILabel alloc] init];
		[lbl1 setTag:1];
		[cell.contentView addSubview:lbl1];
		
		UILabel *lbl2 = [[UILabel alloc] init];
		[lbl2 setTag:2];
		[cell.contentView addSubview:lbl2];
	}
	
	if ([contactArr count]) 
	{
		UILabel *tmplbl1 = (UILabel *)[cell viewWithTag:1];
		[tmplbl1 setFrame:CGRectMake(10.0f, 12.0f, sizeFirstname.width+2.0f, 30.0f)];
		[tmplbl1 setFont:[UIFont boldSystemFontOfSize:20.0f]];
		[tmplbl1 setBackgroundColor:[UIColor clearColor]];
		[tmplbl1 setText:contact.firstname];
		
		
		UILabel *tmplbl2 = (UILabel *)[cell viewWithTag:2];
		[tmplbl2 setFrame:CGRectMake(sizeFirstname.width+2.0f+10.0f, 12.0f, sizeSurname.width, 30.0f)];
		[tmplbl2 setFont:[UIFont systemFontOfSize:20.0f]];
		[tmplbl2 setBackgroundColor:[UIColor clearColor]];
		[tmplbl2 setText:contact.surname];
	}
	
	
	return cell;
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle;
	
	if ([contactArr count]) 
	{
		sectionTitle = [[contactArr objectAtIndex:section] objectForKey:@"headerTitle"];
	}
	
	return sectionTitle;
	
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{
    if ([Indices count]) 
	{
		return Indices;
	}
	else 
	{
		return nil;
	}
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	Contact *contact = [[Contact alloc] init];
	contact	= [[[contactArr objectAtIndex:indexPath.section] objectForKey:@"sectionArr"] objectAtIndex:indexPath.row];
	
	ContactDetailViewController *contactDetail = [[ContactDetailViewController alloc] init];
	contactDetail.contact = [contact retain];
	[self.navigationController pushViewController:contactDetail animated:YES];
	
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
	
	if ([contactArr count]) 
	{
		[contactArr removeAllObjects];
		[contactArr addObjectsFromArray:tmpContactArr];
	}
	else 
	{
		[contactArr addObjectsFromArray:tmpContactArr];
	}
	
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
