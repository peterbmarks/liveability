//
//  LivabilityTableViewCell.h
//  Liveability
//
//  Created by Peter Marks on 4/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivabilityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *factorLabel;
@property (weak, nonatomic) IBOutlet UIView *goodnessView;
@property (weak, nonatomic) IBOutlet UILabel *percentileLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *lgaLabel;

@end
