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

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Postcode* detailItem;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

