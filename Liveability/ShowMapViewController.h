//
//  DetailViewController.h
//  Liveability
//
//  Created by Peter Marks on 3/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@class Postcode;

@interface ShowMapViewController : UIViewController <CLLocationManagerDelegate, MKReverseGeocoderDelegate, MKMapViewDelegate>

@property (strong, nonatomic) Postcode* detailItem;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationManager *myLocationManager;

@end

