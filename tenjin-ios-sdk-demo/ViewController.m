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

@interface ViewController ()

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
                default :
                    NSLog(@"Unknown");
            }
        }];
        
    } else {
        [TenjinSDK connect];
    }
}


@end
