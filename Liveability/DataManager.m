//
//  DataManager.m
//  Liveability
//
//  Created by Peter Marks on 3/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import "DataManager.h"
#import "FMDB.h"

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
        [self openDatabases];
    }
    return self;
}

- (void)openDatabases {
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"postcodes"
                                                         ofType:@"sqlite"];
    _postcodesDb = [FMDatabase databaseWithPath:filePath];
    if(![_postcodesDb open]) {
        NSLog(@"Error opening the database at: %@", filePath);
    }
    NSLog(@"_postcodesDb opened");
    // postcode, suburb, state, latitude, longitude
    FMResultSet *s = [_postcodesDb executeQuery:@"SELECT suburb, state, postcode FROM postcodes"];
    while ([s next]) {
        //retrieve values for each record
        NSString *postcode = [s stringForColumn:@"postcode"];
        NSString *suburb = [s stringForColumn:@"suburb"];
        NSString *state = [s stringForColumn:@"state"];
        NSLog(@"postcode = %@, suburb: %@, state: %@", postcode, suburb, state);
        [self.postcodes addObject:@{@"postcode": postcode, @"suburb": suburb, @"state": state}];
    }
}

@end
