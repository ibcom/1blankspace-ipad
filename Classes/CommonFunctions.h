 //
//  CommonFunctions.h
//  1blankspaceContactManager
//
//  Created by Konstant on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommonFunctions : NSObject {

}


-(BOOL) isItFirstLoad;
-(void) syncFavContacts;
-(void) checkAndCreateDatabase;
-(NSString *) URLDecodeString:(NSString *) str;
-(NSString *) URLEncodeString:(NSString *) str;
-(NSString *) removeSpaceInStr:(NSString *) str;

- (void) hideTabBar:(UITabBarController *) tabbarcontroller;
- (void) showTabBar:(UITabBarController *) tabbarcontroller;
@end
