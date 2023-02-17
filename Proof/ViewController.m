//
//  ViewController.m
//  Proof
//
//  Created by Ethan Whited on 2/12/23.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "AppViewController.h"
#import "grant_full_disk_access.h"

@interface ViewController : UITabBarController
@end

@interface ViewController()
@end

@implementation ViewController
- (void)viewDidLoad {
    if (![[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:@"/var/mobile"] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil]) {
        grant_full_disk_access(^(NSError* _Nullable error) {
            if (error != nil) {
            }
        });
    }
    
    UIViewController *controller1 = [[AppViewController alloc] init];
    UIViewController *controller2 = [[SettingsViewController alloc] init];
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"Apps" image:[UIImage systemImageNamed:@"app.badge.fill"] tag:0];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage systemImageNamed:@"gear"] tag:1];
    
    controller1.tabBarItem = tabBarItem1;
    controller2.tabBarItem = tabBarItem2;
    
    self.viewControllers = [NSArray arrayWithObjects:
                            controller1,
                            controller2,
                            nil];
    
    [[UIView appearance] setTintColor:[UIColor systemRedColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    if (![[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:@"/var/mobile"] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil])[self exploitAlert];
}

- (void)exploitAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Exploit Failed" message:@"Restart app and try again." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:^ {
        }];
    }];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
