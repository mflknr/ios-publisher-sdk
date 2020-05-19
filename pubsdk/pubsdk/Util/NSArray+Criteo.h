//
//  NSArray+Criteo.h
//  CriteoPublisherSdk
//
//  Copyright © 2018-2020 Criteo. All rights reserved.
//

#ifndef NSArray_Criteo_h
#define NSArray_Criteo_h

#import <Foundation/Foundation.h>

typedef NSArray<NSString *> StringArray;
typedef NSMutableArray<NSString *> MutableStringArray;

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Criteo)

- (NSArray *)cr_splitIntoChunks:(NSUInteger)chunkSize;

@end

NS_ASSUME_NONNULL_END

#endif /* NSArray_Criteo_h */
