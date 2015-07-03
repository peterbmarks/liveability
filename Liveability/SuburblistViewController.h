//
//  MasterViewController.h
//  Liveability
//
//  Created by Peter Marks on 3/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowMapViewController;

@interface SuburblistViewController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) ShowMapViewController *detailViewController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

