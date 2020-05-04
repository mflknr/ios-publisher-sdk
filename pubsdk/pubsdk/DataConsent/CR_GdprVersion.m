//
//  CR_Gdpr1_1.m
//  pubsdk
//
//  Copyright © 2018-2020 Criteo. All rights reserved.
//

#import "CR_GdprVersion.h"

NSString * const CR_GdprAppliesForTcf2_0Key = @"IABTCF_gdprApplies";
NSString * const CR_GdprConsentStringForTcf2_0Key = @"IABTCF_TCString";

NSString * const CR_GdprSubjectToGdprForTcf1_1Key = @"IABConsent_SubjectToGDPR";
NSString * const CR_GdprConsentStringForTcf1_1Key = @"IABConsent_ConsentString";

@interface CR_GdprVersionWithKeys ()

@property (copy, nonatomic, readonly) NSString *consentStringKey;
@property (copy, nonatomic, readonly) NSString *appliesKey;
@property (strong, nonatomic, readonly) NSUserDefaults *userDefaults;

@property (copy, nonatomic, readonly) NSNumber *appliesObject;

@end

@implementation CR_GdprVersionWithKeys

@synthesize tcfVersion = _tcfVersion;

+ (instancetype)gdprTcf1_1WithUserDefaults:(NSUserDefaults *)userDefaults {
    return [[self.class alloc] initWithConsentStringKey:CR_GdprConsentStringForTcf1_1Key
                                             appliesKey:CR_GdprSubjectToGdprForTcf1_1Key
                                             tcfVersion:CR_GdprTcfVersion1_1
                                           userDefaults:userDefaults];
}


+ (instancetype)gdprTcf2_0WithUserDefaults:(NSUserDefaults *)userDefaults {
    return [[self.class alloc] initWithConsentStringKey:CR_GdprConsentStringForTcf2_0Key
                                             appliesKey:CR_GdprAppliesForTcf2_0Key
                                             tcfVersion:CR_GdprTcfVersion2_0
                                           userDefaults:userDefaults];
}

#pragma mark - Life cycle

- (instancetype)initWithConsentStringKey:(NSString *)constantStringKey
                              appliesKey:(NSString *)appliesKey
                              tcfVersion:(CR_GdprTcfVersion)tcfVersion
                            userDefaults:(NSUserDefaults *)userDefaults {
    if (self = [super init]) {
        _consentStringKey = [constantStringKey copy];
        _appliesKey = [appliesKey copy];
        _userDefaults = userDefaults;
        _tcfVersion = tcfVersion;
    }
    return self;
}

#pragma mark - Properties

- (BOOL)isValid {
    return  (self.consentString != nil) ||
            (self.applies != nil);
}

- (NSString *)consentString {
    return [self.userDefaults stringForKey:self.consentStringKey];
}

- (NSNumber *)applies {
    id object = [self.userDefaults objectForKey:self.appliesKey];
    if (object == nil) {
        return nil;
    }
    BOOL applies = [self.userDefaults boolForKey:self.appliesKey];
    return @(applies);
}

@end

@implementation CR_NoGdpr

- (BOOL)isValid {
    return YES;
}

- (CR_GdprTcfVersion)tcfVersion {
    return CR_GdprTcfVersionUnknown;
}

- (NSString *)consentString {
    return nil;
}

- (NSNumber *)applies {
    return nil;
}

@end
