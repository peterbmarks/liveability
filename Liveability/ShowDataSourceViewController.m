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

@end

@implementation ShowDataSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.text = [NSString stringWithFormat:@"Data from: %@\nMeasurement: %@ = %ld", self.livability.source, self.livability.measure, (long)self.livability.measureValue];
    self.navigationController.navigationItem.title = self.suburb;
    UIImage *image = [UIImage imageNamed:self.livability.dataSource];
    if(!image) {
        NSLog(@"Error: unabel to load image %@", self.livability.dataSource);
    }
    self.sourceLogoImageView.image = image;
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
