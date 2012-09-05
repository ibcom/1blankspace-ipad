//
//  MyAnnotation.m
//  1blankspaceContactManager
//
//  Created by Vipin Jain on 18/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyAnnotation.h"


@implementation MyAnnotation
@synthesize coordinate,title,subtitle;

-(void)dealloc
{
    [title release];
    [subtitle release];
    [super dealloc];
}

@end
