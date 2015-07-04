//
//  Liveability.h
//  Liveability
//
//  Created by Peter Marks on 4/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Liveability : NSObject

@property (nonatomic) NSString *postcode;
@property (nonatomic) NSInteger percentile;  // out of 100
@property (nonatomic) NSString *measure;    // what is the thing we're measuring
@property (nonatomic) NSInteger measurement;    // the actual value
@property (nonatomic) NSString *source;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *explanation;

@end
