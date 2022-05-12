//
//  ALEventService.h
//  AppLovinSDK
//
//  Created by Thomas So on 2/13/19
//  Copyright © 2020 AppLovin Corporation. All rights reserved.
//

#import "ALEventTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Service that tracks various analytical events.
 */
@interface ALEventService : NSObject

/**
 * Sets a super property that this service will record with all future events.
 *
 * If @c superProperty is @c nil, this method will remove the super property with key @c key from being recorded with all future events.
 *
 * @param superProperty The value to assign to the super property whose key is @c key. Valid types include @c NSString, @c NSNumber, @c NSSDate, @c NSURL,
 *                      @c NSArray, and @c NSDictionary. Set this to @c nil to remove the super property whose key is @c key from being recorded with all future
 *                      events.
 * @param key           The key that identifies the the super property whose value this method sets.
 */
- (void)setSuperProperty:(nullable id)superProperty forKey:(NSString *)key;

/**
 * NSDictionary that represents the currently-set super properties that this services records with events.
 */
@property (nonatomic, copy, readonly) NSDictionary<NSString *, id> *superProperties;

/**
 * Tracks an event without adding supplemental data.
 *
 * AppLovin recommends that you use one of the predefined strings provided in ALEventTypes.h for the event name, when those strings apply to the event.
 *
 * @param eventName A string that represents the event to track.
 */
- (void)trackEvent:(NSString *)eventName;

/**
 * Tracks an event and adds supplemental data.
 *
 * AppLovin recommends that you use one of the predefined strings provided in ALEventTypes.h for the event name and parameter keys, when those strings
 * apply to the event.
 *
 * @param eventName  A string that represents the event to track.
 * @param parameters A dictionary that contains key-value pairs that further describe this event.
 */
- (void)trackEvent:(NSString *)eventName parameters:(nullable NSDictionary<NSString *, id> *)parameters;

/**
 * Tracks an in-app purchase.
 *
 * AppLovin recommends that you use one of the predefined strings provided in ALEventTypes.h for the parameter keys, when one of those strings applies
 * to the event. At a minimum, provide the following parameters: @c kALEventParameterProductIdentifierKey, @c kALEventParameterRevenueAmountKey, and
 * @c kALEventParameterRevenueCurrencyKey. If you pass a value for @c kALEventParameterStoreKitReceiptKey, AppLovin will use that value for validation.
 * Otherwise, AppLovin will collect @code [NSBundle mainBundle] @endcode ⇒ @code [NSBundle appStoreReceiptURL] @endcode and use it for validation.
 *
 * @param transactionIdentifier Value of the @code [SKTransaction transactionIdentifier] @endcode property.
 * @param parameters            A dictionary that contains key-value pairs that further describe this event.
 */
- (void)trackInAppPurchaseWithTransactionIdentifier:(NSString *)transactionIdentifier parameters:(nullable NSDictionary<NSString *, id> *)parameters;

/**
 * Tracks a checkout / standard purchase.
 *
 * AppLovin recommends that you use one of the predefined strings provided in ALEventTypes.h for the parameter keys, when one of those strings applies to the
 * event. At a minimum, provide the following parameters: @c kALEventParameterProductIdentifierKey, @c kALEventParameterRevenueAmountKey, and
 * @c kALEventParameterRevenueCurrencyKey.
 *
 * @param transactionIdentifier An optional unique identifier for this transaction, generated by you. For Apple Pay transactions, AppLovin suggests that you use
 *                              the value of the @code [PKPaymentToken transactionIdentifier] @endcode property.
 * @param parameters            A dictionary that contains key-value pairs that further describe this event.
 */
- (void)trackCheckoutWithTransactionIdentifier:(nullable NSString *)transactionIdentifier parameters:(nullable NSDictionary<NSString *, id> *)parameters;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
