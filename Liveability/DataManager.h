//
//  DataManager.h
//  Liveability
//
//  Created by Peter Marks on 3/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString const * kDataLoadedNotification;

@interface DataManager : NSObject

@property (nonatomic) NSMutableArray *postcodes;
@property (nonatomic) NSDictionary *dataSources;

@end
