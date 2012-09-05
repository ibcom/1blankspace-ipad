//
//  MapViewController.m
//  1blankspaceContactManager
//
//  Created by Vipin Jain on 18/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "Config.h"
#import "MyAnnotation.h"

@implementation MapViewController
@synthesize mapView,address,name,surname;



/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	UIBarButtonItem *rightIconBtn = [[UIBarButtonItem alloc] initWithTitle:@"View In Maps" style:UIBarButtonItemStylePlain target:self action:@selector(viewInMapBtnPressed:)];
	self.navigationItem.rightBarButtonItem = rightIconBtn;
	[rightIconBtn release];
	
	[mapView setMapType:MKMapTypeStandard];
	[mapView setZoomEnabled:YES];
	[mapView setScrollEnabled:YES];
	
	cFunc = [[CommonFunctions	alloc] init];
	
	NSString *googlemap = @"http://maps.google.com/maps/";
	NSString *mapURL =  [googlemap stringByAppendingFormat:@"geo?q=%@&output=csv",[cFunc URLEncodeString:address]];
	NSLog(@"%@",[cFunc URLEncodeString:address]);
	NSString *URLContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:mapURL] encoding:NSUTF8StringEncoding error:nil];
	
	NSLog(@"%@",URLContent);
	
	NSArray * resultArr = [URLContent componentsSeparatedByString:@","];
	
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
	region.center.latitude = [[resultArr objectAtIndex:2] floatValue];
	region.center.longitude = [[resultArr objectAtIndex:3] floatValue];
	if (region.center.latitude == 0.0 && region.center.longitude == 0.0) { 
		[mapView setHidden:TRUE];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"Unable to find location on google map." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		[alert show];
		[alert release];
		return;
	}
	region.span.longitudeDelta = 0.01f;
	region.span.latitudeDelta = 0.01f;
	[mapView setRegion:region animated:YES];
	
	MyAnnotation *ann = [[MyAnnotation alloc] init];
	ann.title = [name stringByAppendingFormat:@" %@",surname];
	ann.coordinate = region.center;
	[mapView addAnnotation:ann];
	
	[mapView setDelegate:self];
	
	
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id )annotation
{
    MKPinAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
		static NSString *defaultPinID = @"com.invasivecode.pin";
		pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
		if ( pinView == nil )
            pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        pinView.pinColor = MKPinAnnotationColorPurple;
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
    }
    else
        [mapView.userLocation setTitle:@"I am here"];
    return pinView;
}

-(IBAction) viewInMapBtnPressed:(id) sender
{
	NSString* addressText = [cFunc URLEncodeString:address];
	
	// URL encode the spaces
	
	//addressText =  [addressText stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
	
	NSString* urlText = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", addressText];
	
	// lets throw this text on the log so we can view the url in the event we have an issue
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
	//UIApplication *app = [UIApplication sharedApplication];  
	//[app openURL:[NSURL URLWithString:urlText]]; 
	
}


#pragma mark -
#pragma mark Alert delegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	[self.navigationController popViewControllerAnimated:YES];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return TRUE;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
