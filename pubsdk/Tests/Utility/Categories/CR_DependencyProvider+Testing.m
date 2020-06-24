//
//  CR_DependencyProvider+Testing.m
//  CriteoPublisherSdk
//
//  Copyright © 2018-2020 Criteo. All rights reserved.
//

#import <OCMock/OCMock.h>
#import "CR_DependencyProvider+Testing.h"
#import "CR_InMemoryUserDefaults.h"
#import "CR_NetworkManagerSimulator.h"
#import "CR_NetworkCaptor.h"
#import "Criteo+Testing.h"
#import "CriteoPublisherSdkTests-Swift.h"

@implementation CR_DependencyProvider (Testing)

+ (instancetype)testing_dependencyProvider {
  return CR_DependencyProvider.new.withIsolatedUserDefaults.withIsolatedDeviceInfo
      .withPreprodConfiguration.withListenedNetworkManager.withIsolatedNotificationCenter
      .withIsolatedFeedbackStorage;
}

- (CR_DependencyProvider *)withListenedNetworkManager {
  CR_NetworkManager *networkManager =
      [[CR_NetworkManagerSimulator alloc] initWithConfig:self.config];
  networkManager = OCMPartialMock(networkManager);
  networkManager = [[CR_NetworkCaptor alloc] initWithNetworkManager:networkManager];
  self.networkManager = networkManager;
  return self;
}

- (CR_DependencyProvider *)withPreprodConfiguration {
  CR_Config *config = [CR_Config configForTestWithCriteoPublisherId:CriteoTestingPublisherId
                                                       userDefaults:self.userDefaults];
  self.config = config;
  return self;
}

- (CR_DependencyProvider *)withIsolatedDeviceInfo {
  self.deviceInfo = [[CR_DeviceInfoMock alloc] init];
  return self;
}

- (CR_DependencyProvider *)withIsolatedNotificationCenter {
  self.notificationCenter = [[NSNotificationCenter alloc] init];
  return self;
}

- (CR_DependencyProvider *)withIsolatedFeedbackStorage {
  CR_FeedbackFileManagingMock *feedbackFileManagingMock =
      [[CR_FeedbackFileManagingMock alloc] init];
  feedbackFileManagingMock.useReadWriteDictionary = YES;
  CASInMemoryObjectQueue *feedbackSendingQueue = [[CASInMemoryObjectQueue alloc] init];
  CR_FeedbackStorage *feedbackStorage =
      [[CR_FeedbackStorage alloc] initWithFileManager:feedbackFileManagingMock
                                            withQueue:feedbackSendingQueue];
  self.feedbackStorage = feedbackStorage;
  return self;
}

- (CR_DependencyProvider *)withIsolatedUserDefaults {
  self.userDefaults = [[CR_InMemoryUserDefaults alloc] init];
  return self;
}

@end
