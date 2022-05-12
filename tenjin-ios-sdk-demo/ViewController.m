//
//  ViewController.m
//  tenjin-ios-sdk-demo
//
//  Created by Akarsh on 12.05.22.
//

#import "ViewController.h"
#import "TenjinSDK.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import <AppLovinSDK/AppLovinSDK.h>

@interface ViewController ()<MAAdViewAdDelegate>
@property (nonatomic, strong) MAAdView *adView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [TenjinSDK initialize:@"YWZKFWDZEREQCFMF3DST3AYHZPCC9MWV"];
    
    if (@available(iOS 14, *)) {
        // Displaying an ATT permission prompt
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            switch(status) {
                case ATTrackingManagerAuthorizationStatusNotDetermined :
                    NSLog(@"Not Determined");
                    NSLog(@"Unknown consent");
                case ATTrackingManagerAuthorizationStatusRestricted :
                    NSLog(@"Restricted");
                    NSLog(@"Device has an MDM solution applied");
                case ATTrackingManagerAuthorizationStatusDenied :
                    NSLog(@"Denied");
                    NSLog(@"Denied consent");
                case ATTrackingManagerAuthorizationStatusAuthorized :
                    NSLog(@"Authorized");
                    NSLog(@"Granted consent");
                    // Tenjin initialization with ATTrackingManager
                    [TenjinSDK connect];
                    [self appLovinILRDImplement];
                default :
                    NSLog(@"Unknown");
            }
        }];
        
    } else {
        [TenjinSDK connect];
    }
}

- (void)appLovinILRDImplement {
    // AppLovin Impression Level Ad Revenue Integration
    [TenjinSDK subscribeAppLovinImpressions];
    // AppLovin MAX SDK
    [ALSdk shared].mediationProvider = @"max";
    [ALSdk shared].userIdentifier = @"USER_ID";
    [[ALSdk shared] initializeSdkWithCompletionHandler:^(ALSdkConfiguration *configuration) {
        // Start loading ads
        [self createBannerAd];
    }];
}

- (void)createBannerAd
{
    self.adView = [[MAAdView alloc] initWithAdUnitIdentifier: @"817c2bef41d9943a"];
    self.adView.delegate = self;
    // Banner height on iPhone and iPad is 50 and 90, respectively
    CGFloat height = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 90 : 50;
    // Stretch to the width of the screen for banners to be fully functional
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
    self.adView.frame = CGRectMake(0, 50, width, height);
    // Set background or background color for banners to be fully functional
    self.adView.backgroundColor = UIColor.blackColor;

    [self.view addSubview: self.adView];
    // Load the ad
    [self.adView loadAd];
}

#pragma mark - MAAdDelegate Protocol
- (void)didLoadAd:(MAAd *)ad {}
- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {}
- (void)didClickAd:(MAAd *)ad {}
- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {}

#pragma mark - MAAdViewAdDelegate Protocol
- (void)didExpandAd:(MAAd *)ad {}
- (void)didCollapseAd:(MAAd *)ad {}

#pragma mark - Deprecated Callbacks
- (void)didDisplayAd:(MAAd *)ad { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }
- (void)didHideAd:(MAAd *)ad { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }

@end
