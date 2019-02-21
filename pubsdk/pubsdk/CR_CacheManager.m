//
//  CR_CacheManager.m
//  pubsdk
//
//  Created by Adwait Kulkarni on 12/18/18.
//  Copyright © 2018 Criteo. All rights reserved.
//

#import "CR_CacheManager.h"
#import "Logging.h"

@implementation CR_CacheManager

- (instancetype) init {
    if(self = [super init]) {
        _bidCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) initSlots: (NSArray *) slots {
    for(CRAdUnit *slot in slots) {
        _bidCache[slot] = [CR_CdbBid emptyBid];
    }
}

- (void) setBid: (CR_CdbBid *) bid
      forAdUnit: (CRAdUnit *) adUnit {
    @synchronized (_bidCache) {
        if(adUnit) {
            _bidCache[adUnit] = bid;
        } else {
            CLog(@"Cache update failed because adUnit was nil. bid:  %@", bid);
        }
    }
}

- (CR_CdbBid *) getBid: (CRAdUnit *) slotId {
    CR_CdbBid *bid = [_bidCache objectForKey:slotId];
    if(bid) {
        _bidCache[slotId] = [CR_CdbBid emptyBid];
        // check ttl hasn't elapsed
        if (bid.isExpired) {
            return [CR_CdbBid emptyBid];
        }
    }
    return bid;
}

@end
