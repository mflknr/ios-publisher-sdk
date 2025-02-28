//
//  CRInterstitial.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <CRBid.h>
#import <CRInterstitialAdUnit.h>
#import <CRInterstitialDelegate.h>
#import <CRContextData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRInterstitial : NSObject

@property(nonatomic, readonly) BOOL isAdLoaded;
@property(nullable, nonatomic, weak) id<CRInterstitialDelegate> delegate;

- (instancetype)initWithAdUnit:(CRInterstitialAdUnit *)adUnit;

- (void)loadAd;
- (void)loadAdWithContext:(CRContextData *)contextData;
- (void)loadAdWithBid:(CRBid *)bid;
- (void)loadAdWithDisplayData:(NSString *)displayData;

- (void)presentFromRootViewController:(UIViewController *)rootViewController;

- (BOOL)shouldAutorotate;
- (UIInterfaceOrientationMask)supportedInterfaceOrientations;

- (void)startSKAdImpression API_AVAILABLE(ios(14.5));
- (void)endSKAdImpression API_AVAILABLE(ios(14.5));

@end

NS_ASSUME_NONNULL_END
