//
//  AppsManager.h
//  Proof
//
//  Created by Ethan Whited on 2/15/23.
//
#import <UIKit/UIKit.h>
#import "grant_full_disk_access.h"

@interface App : NSObject
@property (nonatomic) NSString *appName;
@property (nonatomic) NSString *appIdentifier;
@property (nonatomic) NSString *filePath;
@end

@interface AppsManager : NSObject
@property (nonatomic, retain) NSMutableArray *allApps;
@property (nonatomic) App *app;
@property (nonatomic, retain) AppsManager *sharedManager;
@end
