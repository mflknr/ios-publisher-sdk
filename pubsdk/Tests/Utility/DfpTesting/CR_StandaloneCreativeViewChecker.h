//
// Created by Aleksandr Pakhmutov on 24/12/2019.
// Copyright (c) 2019 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRBannerView.h"
#import "Criteo.h"
#import <XCTest/XCTest.h>


@interface CR_StandaloneCreativeViewChecker : NSObject <CRBannerViewDelegate>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAdUnit:(CRBannerAdUnit *)adUnit criteo:(Criteo *)criteo;

@property(nonatomic, readonly) UIWindow *uiWindow;
@property(nonatomic, readonly) XCTestExpectation *bannerViewFailToReceiveAdExpectation;
@property(nonatomic, readonly) XCTestExpectation *bannerViewDidReceiveAdExpectation;
@property(nonatomic, readonly) XCTestExpectation *adCreativeRenderedExpectation;
@property(nonatomic, readonly) CRBannerView *bannerView;

@end