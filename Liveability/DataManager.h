//
//  DataManager.h
//  Liveability
//
//  Created by Peter Marks on 3/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Liveability;

extern NSString const * kDataLoadedNotification;

@interface DataManager : NSObject

@property (nonatomic) NSMutableArray *postcodes;
@property (nonatomic) NSDictionary *dataSources;

- (Liveability *)loadLiveabilityData:(NSString *)sourceName forPostcode:(NSString *)postcode;
- (NSArray *)lgasForPostcode:(NSString *)postcode;

@end
