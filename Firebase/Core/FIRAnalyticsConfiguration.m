// Copyright 2017 Google
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "FIRAnalyticsConfiguration.h"

#import "Private/FIRAnalyticsConfiguration+Internal.h"

@implementation FIRAnalyticsConfiguration

+ (FIRAnalyticsConfiguration *)sharedInstance {
  static FIRAnalyticsConfiguration *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[FIRAnalyticsConfiguration alloc] init];
  });
  return sharedInstance;
}

- (void)postNotificationName:(NSString *)name value:(id)value {
  if (!name.length || !value) {
    return;
  }
  [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                      object:self
                                                    userInfo:@{ name : value }];
}

- (void)setMinimumSessionInterval:(NSTimeInterval)minimumSessionInterval {
  [self postNotificationName:kFIRAnalyticsConfigurationSetMinimumSessionIntervalNotification
                       value:@(minimumSessionInterval)];
}

- (void)setSessionTimeoutInterval:(NSTimeInterval)sessionTimeoutInterval {
  [self postNotificationName:kFIRAnalyticsConfigurationSetSessionTimeoutIntervalNotification
                       value:@(sessionTimeoutInterval)];
}

- (void)setAnalyticsCollectionEnabled:(BOOL)analyticsCollectionEnabled {
  // Persist the measurementEnabledState. Use FIRAnalyticsEnabledState values instead of YES/NO.
  FIRAnalyticsEnabledState analyticsEnabledState =
      analyticsCollectionEnabled ? kFIRAnalyticsEnabledStateSetYes : kFIRAnalyticsEnabledStateSetNo;
  [[NSUserDefaults standardUserDefaults] setObject:@(analyticsEnabledState)
                                            forKey:kFIRAPersistedConfigMeasurementEnabledStateKey];
  [[NSUserDefaults standardUserDefaults] synchronize];

  [self postNotificationName:kFIRAnalyticsConfigurationSetEnabledNotification
                       value:@(analyticsCollectionEnabled)];
}

@end