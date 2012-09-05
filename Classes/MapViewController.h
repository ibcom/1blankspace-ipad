//
//  MapViewController.h
//  1blankspaceContactManager
//
//  Created by Vipin Jain on 18/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CommonFunctions.h"


@interface MapViewController : UIViewController <MKMapViewDelegate>  {
	IBOutlet MKMapView *mapView;
	
	NSString *address;
	NSString *name;
	NSString *surname;
	
	CommonFunctions * cFunc;

}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *surname;

-(IBAction) viewInMapBtnPressed:(id) sender;
@end
