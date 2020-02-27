//
//  CR_DataProtectionConsentMock.m
//  pubsdk
//
//  Created by Romain Lofaso on 12/11/19.
//  Copyright © 2019 Criteo. All rights reserved.
//

#import "CR_DataProtectionConsentMock.h"
#import "pubsdkTests-Swift.h"

NSString * const CR_DataProtectionConsentMockDefaultConsentString = @"BOO9ZXlOO9auMAKABBITA1-AAAAZ17_______9______9uz_Gv_r_f__33e8_39v_h_7_u__7m_-zzV4-_lrQV1yPA1OrZArgEA";
NSString * const CR_DataProtectionConsentMockDefaultUsPrivacyIabConsentString = @"1YNN";

@implementation CR_DataProtectionConsentMock

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gdprMock = [[CR_GdprMock alloc] init];
        self.usPrivacyIabConsentString_mock = CR_DataProtectionConsentMockDefaultUsPrivacyIabConsentString;
        self.isAdTrackingEnabled_mock = YES;
    }
    return self;
}

- (CR_Gdpr *)gdpr {
    return self.gdprMock;
}

- (BOOL)isAdTrackingEnabled
{
    return self.isAdTrackingEnabled_mock;
}

- (NSString *)usPrivacyIabConsentString
{
    return self.usPrivacyIabConsentString_mock;
}

@end
