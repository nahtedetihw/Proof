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
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleInsetGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setValue:[UIColor groupTableViewBackgroundColor] forKey:@"tableHeaderBackgroundColor"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
        } else if (indexPath.row == 1) {
            cell = [[UITableViewCell alloc]initWithStyle:
                    UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.textLabel.text = @"Copy All";
            cell.detailTextLabel.text = @"Copy all Bundle IDs.";
            cell.imageView.image = [[UIImage systemImageNamed:@"doc.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else if (indexPath.row == 2) {
            cell = [[UITableViewCell alloc]initWithStyle:
                    UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.textLabel.text = @"Copy All";
            cell.detailTextLabel.text = @"Copy all App Names & Bundle IDs.";
            cell.imageView.image = [[UIImage systemImageNamed:@"doc.on.doc.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
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
    } else if (indexPath.row == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProofCopyAll" object:nil];
    } else if (indexPath.row == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProofCopyAllAppNamesAndBundleIDs" object:nil];
    }
}
@end
