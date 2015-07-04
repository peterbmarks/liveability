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
    
    _livabilityFactorsArray = [NSMutableArray new];
    _dataSources = @[@"SEIFANational"];
    for(NSString *dataSource in _dataSources) {
        Liveability *li = [_dataManager loadLiveabilityData:dataSource forPostcode:self.postcode.postcode];
        if(li) {
            [_livabilityFactorsArray addObject:li];
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
    cell.factorLabel.text = _dataSources[indexPath.row];    // title of the data
    cell.percentileLabel.text = [NSString stringWithFormat:@"%ld%%", (long)li.percentile];
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
