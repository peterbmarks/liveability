//
//  ShowDataSourceViewController.m
//  Liveability
//
//  Created by Peter Marks on 4/07/2015.
//  Copyright (c) 2015 Peter Marks. All rights reserved.
//

#import "ShowDataSourceViewController.h"
#import "Liveability.h"

@interface ShowDataSourceViewController ()
{
    UIActivityViewController *_activityViewController;
}
@end

@implementation ShowDataSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.text = [NSString stringWithFormat:@"Data from: %@\nMeasurement: %@ = %ld", self.livability.source, self.livability.measure, (long)self.livability.measureValue];
    self.title = self.suburb;
    UIImage *image = [UIImage imageNamed:self.livability.dataSource];
    if(!image) {
        NSLog(@"Error: unabel to load image %@", self.livability.dataSource);
    }
    self.sourceLogoImageView.image = image;
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;

}

- (void)share:(id)sender {
    NSLog(@"%s", __func__);
    NSArray *excludedActivityArray = excludedActivityArray = @[
                                  UIActivityTypePrint,
                                  UIActivityTypeAddToReadingList,
                                  UIActivityTypeAirDrop,
                                  UIActivityTypeAssignToContact
                                  ];
    UIImage *image = [UIImage imageNamed:self.livability.dataSource];
    _activityViewController = [[UIActivityViewController alloc]
                               initWithActivityItems:@[ @"#govhack sharing data", image, [NSURL URLWithString:self.livability.url]] applicationActivities:nil];
                               
    _activityViewController.excludedActivityTypes = excludedActivityArray;
    [self presentViewController:_activityViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onDataSourceButton:(id)sender {
    NSString *urlString = self.livability.url;
    NSLog(@"opening source: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    if(url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
