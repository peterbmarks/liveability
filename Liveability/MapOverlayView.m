//
//  MapOverlayView.m
//  Liveability
//
//  Created by Peter Marks on 4/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import "MapOverlayView.h"

@implementation MapOverlayView

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)ctx
{
    
    UIImage *image          = [UIImage imageNamed:@"INCOME"];
    
    CGImageRef imageReference = image.CGImage;
    
    MKMapRect theMapRect    = [self.overlay boundingMapRect];
    CGRect theRect           = [self rectForMapRect:theMapRect];
    CGRect clipRect     = [self rectForMapRect:mapRect];
    
    CGContextAddRect(ctx, clipRect);
    CGContextClip(ctx);
    
    CGContextDrawImage(ctx, theRect, imageReference);
}

@end
