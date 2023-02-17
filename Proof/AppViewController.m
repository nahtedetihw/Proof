//
//  ViewController.m
//  Proof
//
//  Created by Ethan Whited on 2/12/23.
//

#import "AppViewController.h"

NSString *folderPath;

@implementation AppViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleInsetGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;
    [self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:0].active = YES;
    [self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:0].active = YES;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.appsManager = [AppsManager new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appsManager.allApps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellID";
    UITableViewCell *cell;
    if (cell == nil) {
        for (App *app in self.appsManager.allApps) {
            if (app == [self.appsManager.allApps objectAtIndex:indexPath.row]) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                cell = [[UITableViewCell alloc]initWithStyle:
                        UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
                cell.textLabel.text = app.appName;
                cell.detailTextLabel.text = app.appIdentifier;
                cell.imageView.image = [UIImage _applicationIconImageForBundleIdentifier:cell.detailTextLabel.text format:0 scale:[UIScreen mainScreen].scale];
            }
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (App *app in self.appsManager.allApps) {
        if (app == [self.appsManager.allApps objectAtIndex:indexPath.row]) {
            NSString *appName = app.appName;
            NSString *appIdentifier = app.appIdentifier;
            NSString *bundlePathAndName = [NSString stringWithFormat:@"App Name:\n%@\n\nBundle ID:\n%@", appName, appIdentifier];
            NSString *bundleIDAndName = [NSString stringWithFormat:@"App Name:\n%@\n\nBundle ID:\n%@", appName, appIdentifier];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:appName message:bundlePathAndName preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *copy = [UIAlertAction actionWithTitle:@"Copy" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:bundleIDAndName];
            }];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:copy];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}
@end
