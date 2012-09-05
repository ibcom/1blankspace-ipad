//
//  Config.h
//  1blankspaceiPad
//
//  Created by Vipin Jain on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Config : NSObject {

}

extern  NSString		*SiteURL;
extern	BOOL			loginSuccess;
extern	BOOL			loginError;
extern  NSString		*Sid;
extern  NSString		*UserID;
extern	BOOL			requestToReloadFav;

extern  NSString		*DatabaseName;
extern  NSString		*DatabasePath;

extern	BOOL			contactIsBeingEdited;

extern	int				launchCount;

@end
