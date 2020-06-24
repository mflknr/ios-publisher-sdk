//
//  CRMediaView.m
//  CriteoPublisherSdk
//
//  Copyright © 2018-2020 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRMediaView.h"
#import "CRMediaView+Internal.h"
#import "CRMediaContent.h"
#import "CRMediaContent+Internal.h"
#import "CRMediaDownloader.h"
#import "Logging.h"

@implementation CRMediaView

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    self.userInteractionEnabled = NO;
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.userInteractionEnabled = NO;
  }
  return self;
}

- (void)setMediaContent:(CRMediaContent *)mediaContent {
  NSURL *url = mediaContent.url;

  // Media downloader may spend time to load the image.
  // We only set the placeholder if a new image comes.
  if (url == nil || ![url isEqual:self.imageUrl]) {
    self.imageView.image = self.placeholder;
  }

  if (url == nil) {
    _mediaContent = mediaContent;
    return;
  }

  __weak typeof(self) weakSelf = self;
  [mediaContent.mediaDownloader downloadImage:url
                            completionHandler:^(UIImage *image, NSError *error) {
                              if (image != nil) {
                                weakSelf.imageView.image = image;
                                weakSelf.imageUrl = url;
                              } else if (error != nil) {
                                CLog(@"Error when fetching image %@ for media view", url, error);
                              }
                            }];

  _mediaContent = mediaContent;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.imageView.frame = self.bounds;
}

#pragma mark - Private

- (UIImageView *)imageView {
  if (_imageView == nil) {
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
  }
  return _imageView;
}

@end
