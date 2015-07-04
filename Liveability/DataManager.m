//
//  DataManager.m
//  Liveability
//
//  Created by Peter Marks on 3/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import "DataManager.h"
#import "FMDB.h"
#import "Postcode.h"
#import "Liveability.h"

NSString const * kDataLoadedNotification = @"kDataLoadedNotification";

@interface DataManager()
{
    FMDatabase *_postcodesDb;
}
@end

@implementation DataManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.postcodes = [NSMutableArray new];
        [self readPostcodes];
        [self loadDataSources];
    }
    return self;
}

- (void)readPostcodes {
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"postcodes"
                                                         ofType:@"sqlite"];
    _postcodesDb = [FMDatabase databaseWithPath:filePath];
    if(![_postcodesDb open]) {
        NSLog(@"Error opening the database at: %@", filePath);
    }
    NSLog(@"_postcodesDb opened");
    // postcode, suburb, state, latitude, longitude
    FMResultSet *s = [_postcodesDb executeQuery:@"SELECT suburb, state, postcode, latitude, longitude FROM postcodes order by suburb"];
    while ([s next]) {
        //retrieve values for each record
        Postcode * pc = [Postcode new];
        pc.postcode = [s stringForColumn:@"postcode"];
        pc.suburb = [s stringForColumn:@"suburb"];
        pc.state = [s stringForColumn:@"state"];
        pc.latitude = [s doubleForColumn:@"latitude"];
        pc.longitude = [s doubleForColumn:@"longitude"];
        [self.postcodes addObject:pc];
    }
    NSLog(@"data loaded");
}

- (void)loadDataSources {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"dataMetadata" ofType:@"plist"];
    self.dataSources = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    // NSLog(@"loaded: %@", self.dataSources);
}

- (Liveability *)loadLiveabilityData:(NSString *)sourceName forPostcode:(NSString *)postcode {
    Liveability * l = nil;
    NSString* filePath = [[NSBundle mainBundle] pathForResource:sourceName
                                                         ofType:@"sqlite"];
    NSLog(@"Opening: %@, %@", sourceName, postcode);
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if(![db open]) {
        NSLog(@"Error opening the database at: %@", filePath);
    }
    NSLog(@"db opened");
    // postcode, suburb, state, latitude, longitude
    FMResultSet *s = [db executeQuery:@"SELECT Percentile, Measurement FROM liveability WHERE Postcode = ?", postcode];
    if ([s next]) {
        l = [Liveability new];
        l.dataSource = sourceName;
        l.postcode = postcode;
        l.percentile = [s intForColumn:@"Percentile"];
        l.measure = self.dataSources[sourceName][@"measurement"];   // what we are measuring
        l.measureValue = [s intForColumn:@"Measurement"];   // the value
        l.source = self.dataSources[sourceName][@"source"];
        l.url = self.dataSources[sourceName][@"url"];
    } else {
        NSLog(@"No data found for postcode = %@", postcode);
    }
    NSLog(@"data loaded");
    return l;
}

// there may be several lga's for a postcode so get them in an array
- (NSArray *)lgasForPostcode:(NSString *)postcode {
    NSMutableArray *lgas = [NSMutableArray new];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"postcodeToLga"
                                                         ofType:@"sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if(![db open]) {
        NSLog(@"Error opening the database at: %@", filePath);
    }
    NSLog(@"db opened");
    // postcode, suburb, state, latitude, longitude
    FMResultSet *s = [db executeQuery:@"SELECT lga FROM p2l WHERE postcode = ?", postcode];
    while ([s next]) {
        NSString *lga = [s stringForColumn:@"lga"];
        [lgas addObject:lga];
    }
    NSLog(@"found %ld lgas for postcode: %@", lgas.count, postcode);
    return lgas;
}

- (Liveability *)loadLiveabilityData:(NSString *)sourceName forLga:(NSString *)lga {
    Liveability * l = nil;
    NSString* filePath = [[NSBundle mainBundle] pathForResource:sourceName
                                                         ofType:@"sqlite"];
    NSLog(@"Opening: %@, %@", sourceName, lga);
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if(![db open]) {
        NSLog(@"Error opening the database at: %@", filePath);
    }
    NSLog(@"db opened");
    // postcode, suburb, state, latitude, longitude
    FMResultSet *s = [db executeQuery:@"SELECT Percentile, Measurement FROM liveability WHERE LGA = ?", lga];
    if ([s next]) {
        l = [Liveability new];
        l.dataSource = sourceName;
        l.lga = lga;
        l.percentile = [s intForColumn:@"Percentile"];
        l.measure = self.dataSources[sourceName][@"measurement"];   // what we are measuring
        l.measureValue = [s intForColumn:@"Measurement"];   // the value
        l.source = self.dataSources[sourceName][@"source"];
        l.url = self.dataSources[sourceName][@"url"];
    } else {
        NSLog(@"No data found for lga = %@", lga);
    }
    NSLog(@"data loaded");
    return l;
}

@end
