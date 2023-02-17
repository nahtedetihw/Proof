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
    [self.searchController.searchBar sizeToFit];
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.definesPresentationContext = NO;
    [self.searchController.searchBar sizeToFit];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.hidesNavigationBarDuringPresentation = false;
    self.searchController.searchBar.showsScopeBar = true;
    
    searchResultsArray = [[NSArray alloc]init];
    self.appsManager = [AppsManager new];
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
