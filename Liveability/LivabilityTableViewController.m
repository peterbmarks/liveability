//
//  LivabilityTableViewController.m
//  Liveability
//
//  Created by Peter Marks on 4/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import "LivabilityTableViewController.h"
#import "LivabilityTableViewCell.h"
#import "Liveability.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "Postcode.h"
#import "ShowDataSourceViewController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface LivabilityTableViewController ()
{
    NSArray *_dataSources;  // names of the datasources we will display
    NSMutableArray *_livabilityFactorsArray;
    DataManager *_dataManager;
}
@end

@implementation LivabilityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _dataManager = appDelegate.dataManager;
    NSArray *lgas = [_dataManager lgasForPostcode:self.postcode.postcode];
    NSLog(@"postcode: %@ has lgas: %@", self.postcode.postcode, lgas);
    _livabilityFactorsArray = [NSMutableArray new];
    _dataSources = @[@"SEIFA National", @"INCOME", @"Diversity", @"Age"];
    for(NSString *dataSource in _dataSources) {
        BOOL isLga = [_dataManager.dataSources[dataSource][@"isLga"] boolValue];
        if(isLga) {
            NSLog(@"%@ is an lga source", dataSource);
            for(NSString *lga in lgas) {
                Liveability *li = [_dataManager loadLiveabilityData:dataSource forLga:lga];
                NSLog(@"%@ = %ld", dataSource, li.percentile);
                if(li) {
                    [_livabilityFactorsArray addObject:li];
                }
            }
        } else {
            Liveability *li = [_dataManager loadLiveabilityData:dataSource forPostcode:self.postcode.postcode];
            NSLog(@"%@ = %ld", dataSource, li.percentile);
            if(li) {
                [_livabilityFactorsArray addObject:li];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _livabilityFactorsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LivabilityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"livabilityCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Liveability *li = _livabilityFactorsArray[indexPath.row];
    cell.factorLabel.text = li.dataSource;    // title of the data
    cell.percentileLabel.text = [NSString stringWithFormat:@"%ld%%", (long)li.percentile];
    if(li.lga) {
        cell.factorLabel.text = [cell.factorLabel.text stringByAppendingString:[NSString stringWithFormat:@" (lga: %@)", li.lga]];
    }
    cell.goodnessView.backgroundColor = [self colourForGoodness:li.percentile];
    return cell;
}

- (UIColor *)colourForGoodness:(NSInteger)percentile {
    UIColor *colour = [UIColor blackColor];
    if(percentile < 25) {
        colour = UIColorFromRGB(0xf2385a);
    } else if(percentile < 50) {
        colour = UIColorFromRGB(0xf5a503);
    }
    else if(percentile < 80) {
        colour = UIColorFromRGB(0x4ad9d9);
    }
    else {
        colour = UIColorFromRGB(0x36b1bf);
    }
    return colour;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"%s", __func__);
    if ([[segue identifier] isEqualToString:@"showDataSource"]) {
        NSLog(@"show data source");
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Liveability *li = _livabilityFactorsArray[indexPath.row];
        ShowDataSourceViewController *controller = (ShowDataSourceViewController *)[segue destinationViewController];
        controller.livability = li;
        controller.suburb = self.postcode.suburb;
    }
}


@end
