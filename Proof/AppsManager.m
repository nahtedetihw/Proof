//
//  AppsManager.m
//  Proof
//
//  Created by Ethan Whited on 2/15/23.
//
#import "AppsManager.h"

static NSArray *blacklistedApps() {
    return @[@"com.apple.AAUIViewService", @"com.apple.DemoApp"];
}

@implementation App
- (instancetype)init {
    if (self) {
        // initialize
    }
    return self;
}
@end

@implementation AppsManager
- (AppsManager *) init {
    if (self) {
        self.sharedManager = self;
        self.allApps = [NSMutableArray new];
        [self getUserApps];
        [self getSystemApps];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"appName" ascending:YES];
        [self.allApps sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    return self;
}

- (void)getSystemApps {
    NSArray *systemAppsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:@"/Applications"] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    for (NSURL *urls in systemAppsArray) {
        if ([urls.absoluteString hasSuffix:@".app/"]) {
            NSURL *infoPlistURL = [urls URLByAppendingPathComponent:@"Info.plist"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:infoPlistURL.path]) continue;
            NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfURL:infoPlistURL error:nil];
            NSString *appName = [infoPlist objectForKey:@"CFBundleDisplayName"];
            NSString *appIdentifier = [infoPlist objectForKey:@"CFBundleIdentifier"];
            App *app = [App new];
            app.appName = appName;
            app.appIdentifier = appIdentifier;
            app.filePath = urls.path;
            if (![app.appIdentifier isEqualToString:@"com.apple.AAUIViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.AMSEngagementViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.DemoApp"] && ![app.appIdentifier isEqualToString:@"com.apple.BacklinkIndicator"] && ![app.appIdentifier isEqualToString:@"com.apple.ctkui"] && ![app.appIdentifier isEqualToString:@"com.apple.CBRemoteSetup"] && ![app.appIdentifier isEqualToString:@"com.apple.musicrecognition"] && ![app.appIdentifier isEqualToString:@"com.apple.FontInstallViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.CMViewSrvc"] && ![app.appIdentifier isEqualToString:@"com.apple.TVSetupUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.HearingApp"] && ![app.appIdentifier isEqualToString:@"com.apple.Diagnostics"] && ![app.appIdentifier isEqualToString:@"com.apple.FMDMagSafeSetupRemoteUI"] && ![app.appIdentifier isEqualToString:@"com.apple.Photos.PhotosUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.CTNotifyUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.Spotlight"] && ![app.appIdentifier isEqualToString:@"com.apple.dt.XcodePreviews"] && ![app.appIdentifier isEqualToString:@"com.apple.siri.parsec.HashtagImagesApp"] && ![app.appIdentifier isEqualToString:@"com.apple.FunCamera.ShapesPicker"] && ![app.appIdentifier isEqualToString:@"com.apple.Batteries"] && ![app.appIdentifier isEqualToString:@"com.apple.CloudKit.ShareBear"] && ![app.appIdentifier isEqualToString:@"com.apple.SystemPaperViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.sidecar"] && ![app.appIdentifier isEqualToString:@"com.apple.PosterBoard"] && ![app.appIdentifier isEqualToString:@"com.apple.fieldtest"] && ![app.appIdentifier isEqualToString:@"com.apple.family"] && ![app.appIdentifier isEqualToString:@"com.apple.iMessageAppsViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.icloud.apps.messages.business"] && ![app.appIdentifier isEqualToString:@"com.apple.TVRemoteUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.HomeCaptiveViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.DiagnosticsService"] && ![app.appIdentifier isEqualToString:@"com.apple.CompanionAuthViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.Greenfield-iPad"] && ![app.appIdentifier isEqualToString:@"com.apple.CheckerBoard"] && ![app.appIdentifier isEqualToString:@"com.apple.FCAuthenticationUI"] && ![app.appIdentifier isEqualToString:@"com.apple.icloud.FindMyDevice.FindMyExtensionContainer"] && ![app.appIdentifier isEqualToString:@"com.apple.MediaRemoteUI"] && ![app.appIdentifier isEqualToString:@"com.apple.FunCamera.EmojiStickers"] && ![app.appIdentifier isEqualToString:@"com.apple.siri"] && ![app.appIdentifier isEqualToString:@"com.apple.FTMInternal"] && ![app.appIdentifier isEqualToString:@"com.apple.DiagnosticsReporter"] && ![app.appIdentifier isEqualToString:@"com.apple.Sharing.AirDropUI"] && ![app.appIdentifier isEqualToString:@"com.apple.PaperBoard"] &&  ![app.appIdentifier isEqualToString:@"com.apple.PassbookUISceneService"] && ![app.appIdentifier isEqualToString:@"com.apple.replaykitangel"] && ![app.appIdentifier isEqualToString:@"com.apple.social.SLYahooAuth"] && ![app.appIdentifier isEqualToString:@"com.apple.FunCamera.TextPicker"] && ![app.appIdentifier isEqualToString:@"com.apple.ScreenTimeUnlock"] && ![app.appIdentifier isEqualToString:@"com.apple.susuiservice"] && ![app.appIdentifier isEqualToString:@"com.apple.TVAccessViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.SOSBuddy"] && ![app.appIdentifier isEqualToString:@"com.apple.MTLReplayer"] && ![app.appIdentifier isEqualToString:@"com.apple.GameCenterRemoteAlert"] && ![app.appIdentifier isEqualToString:@"com.apple.airplayreceiver"] && ![app.appIdentifier isEqualToString:@"com.apple.LoginUI"] && ![app.appIdentifier isEqualToString:@"com.apple.icq"] && ![app.appIdentifier isEqualToString:@"com.apple.AXUIViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.RemoteiCloudQuotaUI"] && ![app.appIdentifier isEqualToString:@"com.apple.ShazamViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.AuthKitUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.StoreDemoViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.smsFilter"] && ![app.appIdentifier isEqualToString:@"com.apple.CTCarrierSpaceAuth"] && ![app.appIdentifier isEqualToString:@"com.apple.SIMSetupUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.ProximityReaderUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.SpringBoardEducation"] && ![app.appIdentifier isEqualToString:@"com.apple.ClockAngel"] && ![app.appIdentifier isEqualToString:@"com.apple.AskPermissionUI"] && ![app.appIdentifier isEqualToString:@"com.apple.ScreenSharingViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.ClipViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.HealthENBuddy"] && ![app.appIdentifier isEqualToString:@"com.apple.HealthENLauncher"] && ![app.appIdentifier isEqualToString:@"com.apple.BusinessChatViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.findmy.remoteuiservice"] && ![app.appIdentifier isEqualToString:@"com.apple.AuthenticationServicesUI"] && ![app.appIdentifier isEqualToString:@"com.apple.AccountAuthenticationDialog"] && ![app.appIdentifier isEqualToString:@"com.apple.AppSSOUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.BarcodeScanner"] && ![app.appIdentifier isEqualToString:@"com.apple.CompassCalibrationViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.AXRemoteViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.CredentialSharingService"] && ![app.appIdentifier isEqualToString:@"com.apple.datadetectors.DDActionsService"] && ![app.appIdentifier isEqualToString:@"com.apple.DataActivation"] && ![app.appIdentifier isEqualToString:@"com.apple.PublicHealthRemoteUI"] && ![app.appIdentifier isEqualToString:@"com.apple.FaceTimeLinkTrampoline"] && ![app.appIdentifier isEqualToString:@"com.apple.PeopleMessageService"] && ![app.appIdentifier isEqualToString:@"com.apple.gamecenter.GameCenterUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.gamecenter.widgets"] && ![app.appIdentifier isEqualToString:@"com.apple.Home.HomeUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.Home.HomeControlService"] && ![app.appIdentifier isEqualToString:@"com.apple.HDSViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.InCallService"] && ![app.appIdentifier isEqualToString:@"com.apple.InputUI"] && ![app.appIdentifier isEqualToString:@"com.apple.CoreAuthUI"] && ![app.appIdentifier isEqualToString:@"com.apple.MailCompositionService"] && ![app.appIdentifier isEqualToString:@"com.apple.Animoji.StickersApp"] && ![app.appIdentifier isEqualToString:@"com.apple.mobilesms.compose"] && ![app.appIdentifier isEqualToString:@"com.apple.MusicUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.PassbookSecureUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.PassbookStub"] && ![app.appIdentifier isEqualToString:@"com.apple.PassbookUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.PeopleViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.PreBoard"] && ![app.appIdentifier isEqualToString:@"com.apple.PrintKit.Print-Center"] && ![app.appIdentifier isEqualToString:@"com.apple.PCViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.RecoverDeviceUI"] && ![app.appIdentifier isEqualToString:@"com.apple.SafariViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.ScreenshotServicesService"] && ![app.appIdentifier isEqualToString:@"com.apple.MBHelperApp"] && ![app.appIdentifier isEqualToString:@"com.apple.purplebuddy"] && ![app.appIdentifier isEqualToString:@"com.apple.SharingViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.SharedWebCredentialViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.ShortcutsUI"] && ![app.appIdentifier isEqualToString:@"com.apple.shortcuts.runtime"] && ![app.appIdentifier isEqualToString:@"com.apple.ios.StoreKitUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.SubcredentialUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.VSViewService"] && ![app.appIdentifier isEqualToString:@"com.apple.ContactlessUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.TrustMe"] && ![app.appIdentifier isEqualToString:@"com.apple.webapp"] && ![app.appIdentifier isEqualToString:@"com.apple.WebContentFilter.remoteUI.WebContentAnalysisUI"] && ![app.appIdentifier isEqualToString:@"com.apple.WebSheet"] && ![app.appIdentifier isEqualToString:@"com.apple.CarPlayWallpaper"] && ![app.appIdentifier isEqualToString:@"com.apple.AppSettings"] && ![app.appIdentifier isEqualToString:@"com.apple.CarPlaySettings"] && ![app.appIdentifier isEqualToString:@"com.apple.SleepLockScreen"] && ![app.appIdentifier isEqualToString:@"com.apple.CarPlaySplashScreen"] && ![app.appIdentifier isEqualToString:@"com.apple.Health.Sleep"] && ![app.appIdentifier isEqualToString:@"com.apple.ActivityMessagesApp"] && ![app.appIdentifier isEqualToString:@"com.apple.RemotePassUIService"] && ![app.appIdentifier isEqualToString:@"com.apple.HealthPrivacyService"] && ![app.appIdentifier isEqualToString:@"com.apple.PassbookBanner"] && ![app.appIdentifier isEqualToString:@"com.apple.WebSheet"]) [self.allApps addObject:app];
        }
    }
}

- (void)getUserApps {
    NSURL *userAppsDir = [NSURL fileURLWithPath:@"/var/containers/Bundle/Application" isDirectory:true];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:userAppsDir.path] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
    for (NSURL *urls in array) {
        NSArray *finalArray = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:urls.path] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
        for (NSURL *url in finalArray) {
            if (![url.absoluteString hasSuffix:@".app/"]) continue;
            NSURL *infoPlistURL = [url URLByAppendingPathComponent:@"Info.plist"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:infoPlistURL.path]) continue;
            NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfURL:infoPlistURL error:nil];
            NSString *appName = [infoPlist objectForKey:@"CFBundleDisplayName"];
            if (appName == nil) {
                NSString *path = urls.path;
                appName = [[[url.absoluteString stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:path withString:@""] stringByReplacingOccurrencesOfString:@"file:/" withString:@""];
            }
            NSString *appIdentifier = [infoPlist objectForKey:@"CFBundleIdentifier"];
            App *app = [App new];
            app.appName = appName;
            app.appIdentifier = appIdentifier;
            app.filePath = url.path;
            [self.allApps addObject:app];
        }
    }
}
@end
