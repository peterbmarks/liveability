//
//  SuburbOverlay.h
//  Liveability
//
//  Created by Peter Marks on 4/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKOverlay.h>

@interface SuburbOverlay : NSObject <MKOverlay>

- (MKMapRect)boundingMapRect;
@property (nonatomic) CLLocationCoordinate2D myCoordinate;

@end
