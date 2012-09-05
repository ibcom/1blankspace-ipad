//
//  Contact.h
//  1blankspaceContactManager
//
//  Created by Konstant on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Contact : NSObject {
	
	NSString * id;				
	NSString * firstname;
	NSString * surname;			
	NSString * streetaddress1;	
	NSString * streetaddress2;	
	NSString * streetsuburb;		
	NSString * streetstate;		
	NSString * streetpostcode;	
	NSString * streetcountry;	
	NSString * email;			
	NSString * phone;			
	NSString * mobile;
	NSString * bestcontactonphone;
	NSString * skype;			
	NSString * dateofbirth;		
	NSString * gender;			
 	
}

@property(nonatomic,retain) NSString * id;				
@property(nonatomic,retain) NSString * firstname;		
@property(nonatomic,retain) NSString * surname;			
@property(nonatomic,retain) NSString * streetaddress1;	
@property(nonatomic,retain) NSString * streetaddress2;	
@property(nonatomic,retain) NSString * streetsuburb;		
@property(nonatomic,retain) NSString * streetstate;		
@property(nonatomic,retain) NSString * streetpostcode;	
@property(nonatomic,retain) NSString * streetcountry;
@property(nonatomic,retain) NSString * email;			
@property(nonatomic,retain) NSString * phone;			
@property(nonatomic,retain) NSString * mobile;			
@property(nonatomic,retain) NSString * bestcontactonphone;
@property(nonatomic,retain) NSString * skype;			
@property(nonatomic,retain) NSString * dateofbirth;		
@property(nonatomic,retain) NSString * gender;			

 
@end
