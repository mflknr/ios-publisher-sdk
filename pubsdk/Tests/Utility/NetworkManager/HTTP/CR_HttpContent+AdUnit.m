//
//  CR_HttpContent+AdUnit.m
//  pubsdk
//
//  Created by Romain Lofaso on 1/24/20.
//  Copyright © 2020 Criteo. All rights reserved.
//

#import "CR_HttpContent+AdUnit.h"
#import "CR_ApiHandler.h"

@implementation CR_HttpContent (AdUnit)

- (BOOL)isHTTPRequestForCacheAdUnits:(CR_CacheAdUnitArray *)cacheAdUnits {
    for (CR_CacheAdUnit *adUnit in cacheAdUnits) {
        if (![self isHTTPRequestForCacheAdUnit:adUnit]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isHTTPRequestForCacheAdUnit:(CR_CacheAdUnit *)cacheAdUnit {
    for (NSDictionary *slot in self.requestBody[CR_ApiHandlerBidSlotsKey]) {
        NSString *placementId = slot[CR_ApiHandlerBidSlotsPlacementIdKey];
        NSString *sizes = slot[CR_ApiHandlerBidSlotsSizesKey][0];
        NSNumber *isNative = [slot objectForKey:CR_ApiHandlerBidSlotsIsNativeKey];
        NSNumber *isInterstitial = [slot objectForKey:CR_ApiHandlerBidSlotsIsInterstitialKey];
        const BOOL isExpectedAdUnitId = [cacheAdUnit.adUnitId isEqualToString:placementId];
        const BOOL isExpectedSize = [[cacheAdUnit cdbSize] isEqualToString:sizes];
        const BOOL hasNativeWellSet = (cacheAdUnit.adUnitType != CRAdUnitTypeNative) || isNative;
        const BOOL hasInterstitialWellSet = (cacheAdUnit.adUnitType != CRAdUnitTypeInterstitial) || isInterstitial;
        if (isExpectedAdUnitId && isExpectedSize && hasNativeWellSet && hasInterstitialWellSet) {
            return YES;
        }
    }
    return NO;
}

@end
