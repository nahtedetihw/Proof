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
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchBar.scopeButtonTitles = [[NSArray alloc]initWithObjects:@"App Name", @"Bundle ID", nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.definesPresentationContext = NO;
    [self.searchController.searchBar sizeToFit];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar.searchTextField setBackgroundColor:[UIColor tableCellGroupedBackgroundColor]];
    self.searchController.searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView setValue:[UIColor groupTableViewBackgroundColor] forKey:@"tableHeaderBackgroundColor"];
    self.searchController.hidesNavigationBarDuringPresentation = false;
    self.searchController.searchBar.showsScopeBar = true;
    if (@available(iOS 16.0, *)) {
        self.searchController.scopeBarActivation = UISearchControllerScopeBarActivationOnSearchActivation;
    } else {
        self.searchController.automaticallyShowsScopeBar = YES;
    }
    searchResultsArray = [[NSArray alloc]init];
    self.appsManager = [AppsManager new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(copyAllBundleIDs) name:@"ProofCopyAllBundleIDs" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(copyAllAppNamesAndBundleIDs) name:@"ProofCopyAllAppNamesAndBundleIDs" object:nil];
}



-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = self.searchController.searchBar.text;
    NSPredicate *resultPredicate;
    NSInteger scope = self.searchController.searchBar.selectedScopeButtonIndex;
        if (scope == 0) {
            resultPredicate = [NSPredicate predicateWithFormat:@"appName contains[c] %@",searchString];
        }else{
            resultPredicate = [NSPredicate predicateWithFormat:@"appIdentifier contains[c] %@",searchString];
        }
    searchResultsArray = [self.appsManager.allApps filteredArrayUsingPredicate:resultPredicate];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) return [searchResultsArray count];
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
                
                if (self.searchController.active) {
                    cell.textLabel.text = ((App *)[searchResultsArray objectAtIndex:indexPath.row]).appName;
                    cell.detailTextLabel.text = ((App *)[searchResultsArray objectAtIndex:indexPath.row]).appIdentifier;
                    cell.imageView.image = [UIImage _applicationIconImageForBundleIdentifier:((App *)[searchResultsArray objectAtIndex:indexPath.row]).appIdentifier format:0 scale:[UIScreen mainScreen].scale];
                } else {
                    cell.textLabel.text = app.appName;
                    cell.detailTextLabel.text = app.appIdentifier;
                    cell.imageView.image = [UIImage _applicationIconImageForBundleIdentifier:app.appIdentifier format:0 scale:[UIScreen mainScreen].scale];
                }
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
    NSMutableArray *tempArray;
    if (self.searchController.active) {
        tempArray = searchResultsArray.mutableCopy;
    } else {
        tempArray = self.appsManager.allApps;
    }
    for (App *app in tempArray) {
        if (app == [tempArray objectAtIndex:indexPath.row]) {
            NSString *appName = app.appName;
            NSString *appIdentifier = app.appIdentifier;
            NSString *bundlePathAndName = [NSString stringWithFormat:@"App Name:\n%@\n\nBundle ID:\n%@", appName, appIdentifier];
            NSString *bundleIDAndName = [NSString stringWithFormat:@"App Name:\n%@\n\nBundle ID:\n%@", appName, appIdentifier];
            UIImage *appImage = [UIImage _applicationIconImageForBundleIdentifier:app.appIdentifier format:2 scale:[UIScreen mainScreen].scale];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:appName message:bundlePathAndName preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *copy = [UIAlertAction actionWithTitle:@"Copy App Name And BundleID" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:bundleIDAndName];
                UIAlertController *copyController = [UIAlertController alertControllerWithTitle:@"Complete" message:@"App Name & BundleID copied!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *copyOk = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [copyController dismissViewControllerAnimated:YES completion:nil];
                }];
                [copyController addAction:copyOk];
                if (!self.searchController.active) {
                    [self presentViewController:copyController animated:YES completion:nil];
                } else {
                    [self.searchController presentViewController:copyController animated:YES completion:nil];
                }
            }];
            UIAlertAction *copyBundleID = [UIAlertAction actionWithTitle:@"Copy BundleID" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:appIdentifier];
                UIAlertController *copyController = [UIAlertController alertControllerWithTitle:@"Complete" message:@"BundleID copied!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *copyOk = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [copyController dismissViewControllerAnimated:YES completion:nil];
                }];
                [copyController addAction:copyOk];
                if (!self.searchController.active) {
                    [self presentViewController:copyController animated:YES completion:nil];
                } else {
                    [self.searchController presentViewController:copyController animated:YES completion:nil];
                }
            }];
            UIAlertAction *copyImage = [UIAlertAction actionWithTitle:@"Save Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIImageWriteToSavedPhotosAlbum(appImage, nil, nil, nil);
                UIAlertController *copyImageController = [UIAlertController alertControllerWithTitle:@"Complete" message:@"App Image saved to Photos!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *copyImageOk = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [copyImageController dismissViewControllerAnimated:YES completion:nil];
                }];
                [copyImageController addAction:copyImageOk];
                if (!self.searchController.active) {
                    [self presentViewController:copyImageController animated:YES completion:nil];
                } else {
                    [self.searchController presentViewController:copyImageController animated:YES completion:nil];
                }
            }];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:copy];
            [alertController addAction:copyBundleID];
            [alertController addAction:copyImage];
            [alertController addAction:ok];
            if (!self.searchController.active) {
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                [self.searchController presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
}

- (NSMutableArray *)allBundleIDs {
    NSMutableArray *allBundleIDs = [NSMutableArray new];
    for (App *app in self.appsManager.allApps) {
        [allBundleIDs addObject:app.appIdentifier];
    }
    return allBundleIDs;
}

- (NSMutableArray *)allAppNamesAndBundleIDs {
    NSMutableArray *allAppNamesAndBundleIDs = [NSMutableArray new];
    for (App *app in self.appsManager.allApps) {
        [allAppNamesAndBundleIDs addObject:[NSString stringWithFormat:@"App Name:\n%@\nBundle ID:\n%@", app.appName, app.appIdentifier]];
    }
    return allAppNamesAndBundleIDs;
}

- (void)copyAllBundleIDs {
    NSString* copiedAllString = @"";
    for (NSString *appIdentifier in [self allBundleIDs]) {
        copiedAllString = [copiedAllString stringByAppendingString:[NSString stringWithFormat:@"%@\n", appIdentifier]];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Copy All" message:@"Copy all Bundle IDs" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *copy = [UIAlertAction actionWithTitle:@"Copy" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIPasteboard generalPasteboard].string = copiedAllString;
        UIAlertController *copyController = [UIAlertController alertControllerWithTitle:@"Complete" message:@"All Bundle IDs copied!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [copyController dismissViewControllerAnimated:YES completion:nil];
        }];
        [copyController addAction:ok];
        [self presentViewController:copyController animated:YES completion:nil];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:copy];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)copyAllAppNamesAndBundleIDs {
    NSString* copiedAllString = @"";
    for (NSString *appIdentifier in [self allAppNamesAndBundleIDs]) {
        copiedAllString = [copiedAllString stringByAppendingString:[NSString stringWithFormat:@"%@\n\n", appIdentifier]];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Copy All" message:@"Copy all App Names And Bundle IDs" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *copy = [UIAlertAction actionWithTitle:@"Copy" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIPasteboard generalPasteboard].string = copiedAllString;
        UIAlertController *copyController = [UIAlertController alertControllerWithTitle:@"Complete" message:@"All App Names And Bundle IDs copied!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [copyController dismissViewControllerAnimated:YES completion:nil];
        }];
        [copyController addAction:ok];
        [self presentViewController:copyController animated:YES completion:nil];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:copy];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
