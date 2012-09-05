//
//  CommonFunctions.m
//  1blankspaceContactManager
//
//  Created by Konstant on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CommonFunctions.h"
#import "sqlite3.h"
#import "Config.h"
#import "TBXML.h"

@implementation CommonFunctions

 
-(BOOL) isItFirstLoad{
	
	
	BOOL firstLoad = FALSE;
	
	
	sqlite3 *database;
	NSString *sqlStatement = @"";
 				
	if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK) 
	{
		sqlStatement = [NSString stringWithFormat:@"select count(*) as cnt from fav_contacts where UserID=%@ ",UserID];
		NSLog(@"%@",sqlStatement);
		sqlite3_stmt *compiledStatement;
	
		if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK) 
		{

			if(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				int cnt = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] intValue];
				
				if (cnt)
					firstLoad = FALSE;
				else
					firstLoad = TRUE;
			}
			else 
			{
				firstLoad = TRUE;
			}
			
		}
	
		sqlite3_finalize(compiledStatement);
 		sqlite3_close(database);
	}

	return firstLoad;
	
}


-(void) syncFavContacts{
	
	
	
	// https://secure.mydigitalspacelive.com/directory/ondemand/object.asp?sid=143500838-k-38364da989c5d1f1abc578af88945dbc&method=PERSON_SEARCH
	NSString *url = [SiteURL stringByAppendingFormat:@"object.asp?sid=%@&method=PERSON_SEARCH&favourite=1",Sid];
	
	NSString *response = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
	
	NSArray *responseArr = [response componentsSeparatedByString:@"|"];
	
 
	
	if ([[responseArr objectAtIndex:0] isEqualToString:@"OK"])
	{
		
		TBXML * tbxml = [[TBXML alloc] initWithXMLString:[responseArr objectAtIndex:1]];
		TBXMLElement * root = tbxml.rootXMLElement; 
		
		
		
		if (root) 
		{  
				
			TBXMLElement *row	= [tbxml childElementNamed:@"row" parentElement:root];
			
			sqlite3 *database;
			
			NSString *sqlStatement = @"";
			if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK) 
			{
				
			
				sqlStatement = [NSString stringWithFormat:@"delete from fav_contacts where UserID=%@",UserID];
				
				
				NSLog(@"%@",sqlStatement);	
				int execResponse = sqlite3_exec(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL);
				if (execResponse == SQLITE_OK)
				{
					NSLog(@"record deleted successfully!!");
				}
				else 
				{
					NSLog(@"%i",execResponse);
				}

				
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
					NSString * email				= [tbxml textForElement:[tbxml childElementNamed:@"email" parentElement:row]];
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
																									
									
					sqlStatement = [NSString stringWithFormat:@" INSERT INTO fav_contacts ('contact_id','firstname','surname','streetaddress1','streetaddress2','streetsuburb','streetstate','streetpostcode','streetcountry','email','phone','mobile','bestcontactonphone','skype','dateofbirth','gender','UserID') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
										  id,firstname,surname,streetaddress1,streetaddress2,streetsuburb,streetstate,streetpostcode,streetcountry,email,phone,mobile,bestcontactonphone,skype,dateofbirth,gender,UserID];
					
					
					NSLog(@"%@",sqlStatement);	
					int execResponse = sqlite3_exec(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL);
					if (execResponse == SQLITE_OK)
					{
						NSLog(@"record inserted successfully!!");
					}
					else 
					{
						NSLog(@"%i",execResponse);
					}
					
					NSLog(@"Error while inserting data. '%s'", sqlite3_errmsg(database));
					
					
					row = [tbxml nextSiblingNamed:@"row" searchFromElement:row];
					
				}
				
				sqlite3_close(database);
				
			}
		 			
			
		}
		
		
	}
	
	
	
}



-(void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:DatabasePath];
	
	// If the database already exists then return without doing anything
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DatabaseName];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:DatabasePath error:nil];
	
	[fileManager release];
	
}

-(NSString *) URLDecodeString:(NSString *) str
{
	
	NSMutableString *tempStr = [NSMutableString stringWithString:str];
	[tempStr replaceOccurrencesOfString:@"+" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
	return [[NSString stringWithFormat:@"%@",tempStr] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *) URLEncodeString:(NSString *) str
{
	
	NSMutableString *tempStr = [NSMutableString stringWithString:str];
	[tempStr replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
	return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *) removeSpaceInStr:(NSString *) str
{
	NSMutableString *tempStr = [NSMutableString stringWithString:str];
	[tempStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
	return [NSString stringWithFormat:@"%@",tempStr];
}

- (void) hideTabBar:(UITabBarController *) tabbarcontroller {
	
	
	//[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.5];
    //[UIView commitAnimations];
	
	
	if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) 
	{
		for(UIView *view in tabbarcontroller.view.subviews)
		{
			if([view isKindOfClass:[UITabBar class]])
			{
				[view setFrame:CGRectMake(view.frame.origin.x, 768, view.frame.size.width, view.frame.size.height)];
			} 
			else 
			{
				[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 768)];
			}
			
		}
	}
	else 
	{
		for(UIView *view in tabbarcontroller.view.subviews)
		{
			if([view isKindOfClass:[UITabBar class]])
			{
				[view setFrame:CGRectMake(view.frame.origin.x, 1024, view.frame.size.width, view.frame.size.height)];
			} 
			else 
			{
				[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 1024)];
			}
			
		}
	}
}

- (void) showTabBar:(UITabBarController *) tabbarcontroller 
{	
	//[UIView beginAnimations:nil context:NULL];
	//[UIView setAnimationDuration:0.5];
	//[UIView commitAnimations];
	
	if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) 
	{
		for(UIView *view in tabbarcontroller.view.subviews)
		{
			NSLog(@"%@", view);
			
			if([view isKindOfClass:[UITabBar class]])
			{
				[view setFrame:CGRectMake(view.frame.origin.x, 719, view.frame.size.width, view.frame.size.height)];
				
			} 
			else 
			{
				[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 768)];
			}
			
			
		}
	}
	else 
	{
		for(UIView *view in tabbarcontroller.view.subviews)
		{
			NSLog(@"%@", view);
			
			if([view isKindOfClass:[UITabBar class]])
			{
				[view setFrame:CGRectMake(view.frame.origin.x, 975, view.frame.size.width, view.frame.size.height)];
				
			} 
			else 
			{
				[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 1024)];
			}
			
			
		}
	}
}


@end
