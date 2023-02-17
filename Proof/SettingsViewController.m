//
//  SettingsViewController.m
//  Proof
//
//  Created by Ethan Whited on 2/12/23.
//

#import "SettingsViewController.h"
#import "respring.h"

@implementation SettingsViewController
- (void)viewDidLoad {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleInsetGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellID";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc]initWithStyle:
                    UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.textLabel.text = @"Respring";
            cell.detailTextLabel.text = @"Tap to respring your device.";
            cell.imageView.image = [[UIImage systemImageNamed:@"rays"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        respringFrontboard();
    }
}
@end
