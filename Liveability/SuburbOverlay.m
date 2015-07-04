//
//  SuburbOverlay.m
//  Liveability
//
//  Created by Peter Marks on 4/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import "SuburbOverlay.h"

@implementation SuburbOverlay

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self != nil) {
        
        
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return self.myCoordinate;
}

- (MKMapRect)boundingMapRect {
    
    MKMapPoint upperLeft = MKMapPointForCoordinate(self.coordinate);
    
    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, 2000, 2000);
    return bounds;
}

@end
