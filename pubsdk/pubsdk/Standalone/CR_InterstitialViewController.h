//
//  CR_InterstitialViewController.h
//  pubsdk
//
//  Created by Julien Stoeffler on 4/24/19.
//  Copyright © 2019 Criteo. All rights reserved.
//

@import UIKit;
@import WebKit;

@class CRInterstitial;

NS_ASSUME_NONNULL_BEGIN

@interface CR_InterstitialViewController : UIViewController

@property (nonatomic, strong, nullable) WKWebView *webView;
@property (nonatomic, strong, nullable) UIButton *closeButton;
@property (nonatomic, weak) CRInterstitial *interstitial;

- (instancetype)initWithWebView:(WKWebView *)webView
                           view:(nullable UIView *)view
                   interstitial:(CRInterstitial *)interstitial;
- (void)dismissViewController;
- (void)initWebViewIfNeeded;

@end

NS_ASSUME_NONNULL_END
