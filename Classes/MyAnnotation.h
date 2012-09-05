//
//  MyAnnotation.h
//  1blankspaceContactManager
//
//  Created by Vipin Jain on 18/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation> {

	CLLocationCoordinate2D coordinate;
	NSString *title;
    NSString *subtitle;
	
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


@end
