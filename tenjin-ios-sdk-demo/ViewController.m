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
    // AppLovin ATT wrapper
    [self appLovinILRDImplement];

//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (@available(iOS 14, *)) {
//            // Displaying an ATT permission prompt
//            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
//                switch(status) {
//                    case ATTrackingManagerAuthorizationStatusNotDetermined :
//                        NSLog(@"Not Determined");
//                        NSLog(@"Unknown consent");
//                    case ATTrackingManagerAuthorizationStatusRestricted :
//                        NSLog(@"Restricted");
//                        NSLog(@"Device has an MDM solution applied");
//                    case ATTrackingManagerAuthorizationStatusDenied :
//                        NSLog(@"Denied");
//                        NSLog(@"Denied consent");
//                    case ATTrackingManagerAuthorizationStatusAuthorized :
//                        NSLog(@"Authorized");
//                        NSLog(@"Granted consent");
//                        // Tenjin initialization with ATTrackingManager
//                        [TenjinSDK initialize:@"YWZKFWDZEREQCFMF3DST3AYHZPCC9MWV"];
//                        [TenjinSDK connect];
//                        NSLog(@"Tenjin SDK connect");
////                        [self appLovinILRDImplement];
//                }
//            }];
//
//        } else {
//            [TenjinSDK initialize:@"YWZKFWDZEREQCFMF3DST3AYHZPCC9MWV"];
//            [TenjinSDK connect];
//            NSLog(@"Tenjin SDK connect");
//        }
//    });
    
    //send a particular event for when someone swipes on a part of your app
//    [TenjinSDK sendEventWithName:@"swipe_right"];
    
}

- (void)appLovinILRDImplement {

    // AppLovin MAX SDK
    ALSdkSettings *settings = [[ALSdkSettings alloc] init];
    // Enable consent flow
    settings.consentFlowSettings.enabled = YES;
    // Privacy policy
    settings.consentFlowSettings.privacyPolicyURL = [NSURL URLWithString: @"https://your_company_name.com/privacy_policy"];
    // Terms of Service URL is optional
    settings.consentFlowSettings.termsOfServiceURL = [NSURL URLWithString: @"https://your_company_name.com/terms_of_service"];
    // Getting AppLovin SDK Key from info.plist file
    NSString *sdkKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppLovinSdkKey"];
    ALSdk *sdk = [ALSdk sharedWithKey: sdkKey settings: settings];
    sdk.mediationProvider = @"max";
    sdk.userIdentifier = @"USER_ID";
    [sdk initializeSdkWithCompletionHandler:^(ALSdkConfiguration *configuration) {
        // Tenjin SDK
        [TenjinSDK debugLogs];
        [TenjinSDK initialize:@"YWZKFWDZEREQCFMF3DST3AYHZPCC9MWV"];
        [TenjinSDK connect];
        NSLog(@"Tenjin SDK connect");
        // AppLovin Impression Level Ad Revenue Integration
        [TenjinSDK subscribeAppLovinImpressions];
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

//
//- (void)didPayRevenueForAd:(MAAd *)ad
//{
//    double revenue = ad.revenue; // In USD
//
//    // Miscellaneous data
//    NSString *countryCode = [ALSdk shared].configuration.countryCode; // "US" for the United States, etc - Note: Do not confuse this with currency code which is "USD" in most cases!
//    NSString *networkName = ad.networkName; // Display name of the network that showed the ad (e.g. "AdColony")
//    NSString *adUnitId = ad.adUnitIdentifier; // The MAX Ad Unit ID
//    MAAdFormat *adFormat = ad.format; // The ad format of the ad (e.g. BANNER, MREC, INTERSTITIAL, REWARDED)
//    NSString *placement = ad.placement; // The placement this ad's postbacks are tied to
//    NSString *networkPlacement = ad.networkPlacement; // The placement ID from the network that showed the ad
//
//    NSString *creativeIdentifier = ad.creativeIdentifier;
//    NSString *revenuePrecision = ad.revenuePrecision;
//
////    NSLog(@"ILRD Data: country code %@, networkname %@, adunit id %@, placement %@, network placement %@, revenue %f", countryCode, networkName, adUnitId, placement, networkPlacement, revenue);
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//
//    NSNumber *myDoubleNumber = [NSNumber numberWithDouble:revenue];
//    NSString *revenueString = [myDoubleNumber stringValue];
//    [dict setValue:revenueString forKey:@"revenue"];
//
//    [dict setValue:@"USD" forKey:@"ad_revenue_currency"];
//    [dict setValue:countryCode forKey:@"country"];
//    [dict setValue:networkName forKey:@"network_name"];
//    [dict setValue:adUnitId forKey:@"ad_unit_id"];
//
////        NSString *format = [baseAdNetworkHelper getStringFromObject:adImpression forSelector:@selector(format)];
////    NSString *displayName = [baseAdNetworkHelper getStringFromObject:format forSelector:@selector(displayName)];
////    [appLovinData setObject:displayName forKey:@"format"];
//
//    NSString *label = ad.format.label;
//    [dict setValue:label forKey:@"format"];
//
//    [dict setValue:placement forKey:@"placement"];
//    [dict setValue:networkPlacement forKey:@"network_placement"];
//    [dict setValue:creativeIdentifier forKey:@"creative_id"];
//    [dict setValue:revenuePrecision forKey:@"revenue_precision"];
//
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", jsonString);
////    [TenjinSDK appLovinImpressionFromJSON:jsonString];
//}

@end
