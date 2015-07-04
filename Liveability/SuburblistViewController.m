//
//  MasterViewController.m
//  Liveability
//
//  Created by Peter Marks on 3/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import "SuburblistViewController.h"
#import "ShowMapViewController.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "Postcode.h"

@interface SuburblistViewController ()
{
    DataManager *_dataManager;
    NSArray *_filteredPostcodes;
    BOOL _pushedHere;
}
@end

@implementation SuburblistViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _dataManager = appDelegate.dataManager;
    _pushedHere = NO;
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *hereButton = [[UIBarButtonItem alloc] initWithTitle:@"Here" style:UIBarButtonItemStylePlain target:self action:@selector(here:)];
//    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch:)];
    self.navigationItem.rightBarButtonItem = hereButton;
    self.detailViewController = (ShowMapViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)here:(id)sender {
    NSLog(@"here");
    _pushedHere = YES;
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    _pushedHere = NO;
}

- (void)showSearch:(id)sender {
    NSLog(@"%s", __func__);
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        Postcode *pc = nil;
        if(!_pushedHere) {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            pc = _dataManager.postcodes[indexPath.row];
            if(_filteredPostcodes.count) {
                pc = _filteredPostcodes[indexPath.row];
            }
        }
        ShowMapViewController *controller = (ShowMapViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:pc];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows;
    if(_filteredPostcodes.count) {
        rows = _filteredPostcodes.count;
    } else {
        rows = _dataManager.postcodes.count;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Postcode *pc = _dataManager.postcodes[indexPath.row];
    if(_filteredPostcodes.count) {
        pc = _filteredPostcodes[indexPath.row];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@ : %@", pc.suburb, pc.state, pc.postcode];
    return cell;
}

#pragma mark - UISearchBar Delegate Methods
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    if(searchText.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.suburb contains[c] %@",searchText];
        _filteredPostcodes = [NSMutableArray arrayWithArray:[_dataManager.postcodes filteredArrayUsingPredicate:predicate]];
    } else {
        _filteredPostcodes = nil;
        [searchBar resignFirstResponder];
    }
    [self.tableView reloadData];
}

// None of these are working
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"%s", __func__);
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s", __func__);
    [self.searchBar resignFirstResponder];
}


@end
