//
//  Config.m
//  1blankspaceiPad
//
//  Created by Vipin Jain on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Config.h"


@implementation Config

NSString		*DatabaseName		= @"contacts_db.sqlite";
NSString		*DatabasePath;

NSString		*SiteURL			= @"https://secure.mydigitalspacelive.com/directory/ondemand/";
BOOL			loginSuccess;
BOOL			loginError;
NSString		*Sid				= @"";
NSString		*UserID;
BOOL			requestToReloadFav;

BOOL			contactIsBeingEdited;

int				launchCount = 0;

@end
