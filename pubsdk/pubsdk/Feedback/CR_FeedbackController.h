//
// Copyright © 2018-2020 Criteo. All rights reserved.
//

#ifndef CR_FeedbackController_h
#define CR_FeedbackController_h

#import <Foundation/Foundation.h>

@class CR_FeedbackStorage;
@class CR_ApiHandler;
@class CR_Config;
@class CR_CdbRequest;
@class CR_CdbResponse;
@class CR_CdbBid;

/**
 * Update metrics files accordingly to received events.
 *
 * @see Client side metric specification:
 * https://confluence.criteois.com/display/PUBSDK/Publisher+SDK+-+Client+Side+Metrics
 */
@protocol CR_FeedbackDelegate

/**
 * On CDB call start, each requested slot is tracked by a new metric feedback. The metrics marks the
 * timestamp of this event and wait for further updates.
 *
 * @param request Request sent to CDB
 */
- (void)onCdbCallStarted:(CR_CdbRequest *)request;

/**
 * When the CDB call ends successfully, metrics corresponding to requested slots are updated
 * accordingly to the response.
 *
 * If there is no response for a slot, then it is a no bid. The metric marks the timestamp of this
 * event and, as no consumption of this no-bid is expected, the metric is tagged as finished and
 * ready to send.
 *
 * If there is a matching invalid slot, then it is considered as an error. The metric is not
 * longer updated and is flagged as ready to send.
 *
 * If there is a matching valid slot, then it is a consumable bid. The metric marks the timestamp
 * of this event, and waits for further updates (via consumption).
 *
 * @param response Response coming from CDB
 * @param request Request that was sent to CDB
 */
- (void)onCdbCallResponse:(CR_CdbResponse *)response fromRequest:(CR_CdbRequest *)request;

/**
 * On CDB call failed, metrics corresponding to the requested slots are updated.
 *
 * If the failure is a timeout, then all metrics are flagged as having a timeout.
 *
 * Then, since no further updates are expected, all metrics are flagged as ready to send.
 *
 * @param failure Error representing the failure of the call
 * @param request Request that was sent to CDB
 */
- (void)onCdbCallFailure:(NSError *)failure fromRequest:(CR_CdbRequest *)request;

/**
 * On bid consumption, the metric feedback associated to the bid is updated.
 *
 * If the bid has not expired, then the bid managed to go from CDB to the user. The metric marks
 * the timestamp of this event.
 *
 * Since this is the end of the bid lifecycle, the metric does not expect further updates and is
 * flagged as ready to send.
 *
 * @param consumedBid bid that was consumed
 */
- (void)onBidConsumed:(CR_CdbBid *)consumedBid;

/**
 * Send asynchronously a new batch of metrics to the CSM backend.
 *
 * This is a fire and forget operation. No output is expected. Although, if an error occurs while
 * sending the metrics to the backend, they are pushed back in the sending queue.
 *
 * The batch is polled from the queue (instead of peeked). Data loss is tolerated if the process
 * is terminated while the batch is being sent to the CSM backed. This is to ensure that the same
 * metric will never be sent to CSM backend twice.
 */
- (void)sendFeedbackBatch;

@end

@interface CR_FeedbackController : NSObject <CR_FeedbackDelegate>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFeedbackStorage:(CR_FeedbackStorage *)feedbackStorage
                             apiHandler:(CR_ApiHandler *)apiHandler
                                 config:(CR_Config *)config NS_DESIGNATED_INITIALIZER;

/**
 * Helper method to create a feedback delegate based on a feedback controller but guarded by the CSM
 * feature flag.
 *
 * @param feedbackStorage internal storage used to handle living metrics and queued ready-to-send
 * metrics
 * @param apiHandler handler used to send ready-to-send metrics
 * @param config global config to help the API and enabled/disabled this CSM feature
 * @return feedback delegate
 */
+ (id<CR_FeedbackDelegate>)controllerWithFeedbackStorage:(CR_FeedbackStorage *)feedbackStorage
                                              apiHandler:(CR_ApiHandler *)apiHandler
                                                  config:(CR_Config *)config;

@end

#endif /* CR_FeedbackController_h */
