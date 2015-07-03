//
//  DetailViewController.m
//  Liveability
//
//  Created by Peter Marks on 3/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import "DetailViewController.h"
#import "Postcode.h"
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.navigationController.navigationItem.title = self.detailItem.suburb;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.detailItem.latitude longitude:self.detailItem.longitude];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
    } else {
        self.navigationController.navigationItem.title = @"Locating...";
        self.myLocationManager = [[CLLocationManager alloc] init];
        self.myLocationManager.delegate = self;
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        if(authStatus == kCLAuthorizationStatusNotDetermined) {
            NSLog(@"requesting location in use authorization");
            [self.myLocationManager requestWhenInUseAuthorization];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self startLocation];
    }
}

- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]){
        NSLog(@"requesting location...");
        [self.myLocationManager startUpdatingLocation];
    } else {
        /* Location services are not enabled.
         Take appropriate action: for instance, prompt the
         user to enable the location services */
        NSLog(@"Location services are not enabled");
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    /* We received the new location */
    
    NSLog(@"Latitude = %f", newLocation.coordinate.latitude);
    NSLog(@"Longitude = %f", newLocation.coordinate.longitude);
    [self.myLocationManager stopUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    [self reverseGeocodeLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    /* Failed to receive user's location */
    NSLog(@"location manager error: %@", error);
}

- (void)reverseGeocodeLocation:(CLLocation *)location
{
    CLGeocoder* reverseGeocoder = [[CLGeocoder alloc] init];
    if (reverseGeocoder) {
        [reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark* placemark = [placemarks firstObject];
            if (placemark) {
                self.detailItem = [Postcode new];
                self.detailItem.postcode = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressZIPKey];
                self.detailItem.suburb = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressCityKey];
                self.detailItem.latitude = placemark.location.coordinate.latitude;
                self.detailItem.longitude = placemark.location.coordinate.longitude;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // back on the main thread
                    self.navigationController.navigationItem.title = self.detailItem.suburb;
                    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 500, 500);
                    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
                    [self.mapView setRegion:adjustedRegion animated:YES];
                });
            }
        }];
    }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    NSLog(@"reverse geocoder didfindplacemark");
}
@end
