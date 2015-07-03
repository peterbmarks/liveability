//
//  Postcode.h
//  Liveability
//
//  Created by Peter Marks on 4/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Postcode : NSObject

@property (nonatomic) NSString *postcode;
@property (nonatomic) NSString *suburb;
@property (nonatomic) NSString *state;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
