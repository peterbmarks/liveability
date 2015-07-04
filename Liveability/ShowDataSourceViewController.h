//
//  ShowDataSourceViewController.h
//  Liveability
//
//  Created by Peter Marks on 4/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Liveability;

@interface ShowDataSourceViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) Liveability *livability;
@property (nonatomic) NSString *suburb;

@end
