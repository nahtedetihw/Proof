//
//  ViewController.h
//  Proof
//
//  Created by Ethan Whited on 2/12/23.
//

#import "AppsManager.h"

@interface AppViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating> {
    NSArray *searchResultsArray;
    NSMutableArray *userMutableArray;
}
@property (retain, nonatomic) UISearchController *searchController;
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) AppsManager *appsManager;
@end

@interface UIImage (Private)
+ (id)_applicationIconImageForBundleIdentifier:(id)identifier format:(int)format scale:(int)scale;
@end
