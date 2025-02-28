//
//  Criteo.h
//  CriteoPublisherSdk
//
//  Copyright © 2018-2020 Criteo. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#ifndef Criteo_h
#define Criteo_h

#import <Foundation/Foundation.h>
#import <CRAdUnit.h>
#import <CRBid.h>
#import <CRContextData.h>
#import <CRSKAdNetworkInfo.h>
#import <CRUserData.h>

/** Bid response handler, bid can be nil on purpose */
typedef void (^CRBidResponseHandler)(CRBid *_Nullable bid);

NS_ASSUME_NONNULL_BEGIN

@interface Criteo : NSObject

#pragma mark - Lifecycle

/**
 * Use sharedCriteo singleton accessor, do not init your own instance
 * Note: Initialization is expected through registerCriteoPublisherId:
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Criteo shared instance singleton
 * Note: Initialization is expected through registerCriteoPublisherId:
 * @return The Criteo singleton
 */
+ (nonnull instancetype)sharedCriteo;

/**
 * Initialize Criteo singleton
 * @param criteoPublisherId Publisher Identifier
 * @param inventoryGroupId Inventory group identifier
 * @param storeId Publisher's app store id
 * @param adUnits AdUnits array
 */
- (void)registerCriteoPublisherId:(NSString *)criteoPublisherId
             withInventoryGroupId:(NSString *)inventoryGroupId
                      withStoreId:(NSString *)storeId
                      withAdUnits:(NSArray<CRAdUnit *> *)adUnits;

/**
 * Initialize Criteo singleton
 * @param criteoPublisherId Publisher Identifier
 * @param storeId Publisher's app store id
 * @param adUnits AdUnits array
 */
- (void)registerCriteoPublisherId:(NSString *)criteoPublisherId
                      withStoreId:(NSString *)storeId
                      withAdUnits:(NSArray<CRAdUnit *> *)adUnits;

#pragma mark - Consent management

/** Set a custom opt-out/opt-in with same behaviour as the CCPA (US Privacy). */
- (void)setUsPrivacyOptOut:(BOOL)usPrivacyOptOut;

/** Set the privacy consent string owned by the Mopub SDK.
 @deprecated Mopub SDK is not supported anymore
 */
- (void)setMopubConsent:(NSString *)mopubConsent __deprecated;

#pragma mark - User data

/** Set data on the current user which will be used to bid based on context. */
- (void)setUserData:(CRUserData *)userData;

#pragma mark - Bidding

/// Set to true if you think that your mobile app is intended specifically for children, so we treat
/// bidding as child-directed in whole or in part for the purposes of the Children's Online Privacy
/// Protection Act (COPPA).
@property(nonatomic) NSNumber *_Nullable childDirectedTreatment;

/**
 * Request asynchronously a bid from Criteo
 * @param adUnit The ad unit to request
 * @param responseHandler the handler called on response. Responded bid can be nil.
 * Note: responseHandler is invoked on main queue
 */
- (void)loadBidForAdUnit:(CRAdUnit *)adUnit responseHandler:(CRBidResponseHandler)responseHandler;

/**
 * Request asynchronously a bid from Criteo
 * @param adUnit The ad unit to request
 * @param contextData The context of the request
 * @param responseHandler the handler called on response. Responded bid can be nil.
 * Note: responseHandler is invoked on main queue
 */
- (void)loadBidForAdUnit:(CRAdUnit *)adUnit
             withContext:(CRContextData *)contextData
         responseHandler:(CRBidResponseHandler)responseHandler;

#pragma mark App bidding

/**
 * App bidding API, enrich your ad object with Criteo metadata
 * @param object The object to enrich, supports GAM
 * @param bid The bid obtained from Criteo
 */
- (void)enrichAdObject:(id)object withBid:(CRBid *_Nullable)bid;

#pragma mark - Debug

+ (void)setVerboseLogsEnabled:(BOOL)enabled;

#pragma mark - Testing

+ (void)setSharedInstance:(Criteo *)instance;

@end
NS_ASSUME_NONNULL_END

#endif /* Criteo_h */
