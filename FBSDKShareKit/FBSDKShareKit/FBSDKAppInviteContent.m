/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#if !TARGET_OS_TV

#import "FBSDKAppInviteContent.h"

#import <FBSDKShareKit/_FBSDKShareUtility.h>

#define FBSDK_APP_INVITE_CONTENT_APP_LINK_URL_KEY @"appLinkURL"
#define FBSDK_APP_INVITE_CONTENT_PREVIEW_IMAGE_KEY @"previewImage"
#define FBSDK_APP_INVITE_CONTENT_PROMO_CODE_KEY @"promoCode"
#define FBSDK_APP_INVITE_CONTENT_PROMO_TEXT_KEY @"promoText"
#define FBSDK_APP_INVITE_CONTENT_DESTINATION_KEY @"destination"

@implementation FBSDKAppInviteContent

- (instancetype)initWithAppLinkURL:(nonnull NSURL *)appLinkURL
{
  if ((self = [super init])) {
    _appLinkURL = appLinkURL;
  }
  return self;
}

- (NSURL *)previewImageURL
{
  return self.appInvitePreviewImageURL;
}

- (void)setPreviewImageURL:(NSURL *)previewImageURL
{
  self.appInvitePreviewImageURL = previewImageURL;
}

#pragma mark - FBSDKSharingValidation

- (BOOL)validateWithOptions:(FBSDKShareBridgeOptions)bridgeOptions error:(NSError *__autoreleasing *)errorRef
{
  return ([_FBSDKShareUtility validateNetworkURL:_appLinkURL name:@"appLinkURL" error:errorRef]
    && [_FBSDKShareUtility validateNetworkURL:_appInvitePreviewImageURL name:@"appInvitePreviewImageURL" error:errorRef]
    && [self _validatePromoCodeWithError:errorRef]);
}

- (BOOL)_validatePromoCodeWithError:(NSError *__autoreleasing *)errorRef
{
  if (_promotionText.length > 0 || _promotionCode.length > 0) {
    NSMutableCharacterSet *alphanumericWithSpaces = NSMutableCharacterSet.alphanumericCharacterSet;
    [alphanumericWithSpaces formUnionWithCharacterSet:NSCharacterSet.whitespaceCharacterSet];

    id<FBSDKErrorCreating> errorFactory = [FBSDKErrorFactory new];

    // Check for validity of promo text and promo code.
    if (!(_promotionText.length > 0 && _promotionText.length <= 80)) {
      if (errorRef != NULL) {
        NSString *message = @"Invalid value for promotionText, promotionText has to be between 1 and 80 characters long.";
        *errorRef = [errorFactory invalidArgumentErrorWithName:@"promotionText"
                                                         value:_promotionText
                                                       message:message
                                               underlyingError:nil];
      }
      return NO;
    }

    if (!(_promotionCode.length <= 10)) {
      if (errorRef != NULL) {
        NSString *message = @"Invalid value for promotionCode, promotionCode has to be between 0 and 10 characters long and is required when promoCode is set.";
        *errorRef = [errorFactory invalidArgumentErrorWithName:@"promotionCode"
                                                         value:_promotionCode
                                                       message:message
                                               underlyingError:nil];
      }
      return NO;
    }

    if ([_promotionText rangeOfCharacterFromSet:alphanumericWithSpaces.invertedSet].location != NSNotFound) {
      if (errorRef != NULL) {
        NSString *message = @"Invalid value for promotionText, promotionText can contain only alphanumeric characters and spaces.";
        *errorRef = [errorFactory invalidArgumentErrorWithName:@"promotionText"
                                                         value:_promotionText
                                                       message:message
                                               underlyingError:nil];
      }
      return NO;
    }

    if (_promotionCode.length > 0 && [_promotionCode rangeOfCharacterFromSet:alphanumericWithSpaces.invertedSet].location != NSNotFound) {
      if (errorRef != NULL) {
        NSString *message = @"Invalid value for promotionCode, promotionCode can contain only alphanumeric characters and spaces.";
        *errorRef = [errorFactory invalidArgumentErrorWithName:@"promotionCode"
                                                         value:_promotionCode
                                                       message:message
                                               underlyingError:nil];
      }
      return NO;
    }
  }

  if (errorRef != NULL) {
    *errorRef = nil;
  }

  return YES;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding
{
  return YES;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
  NSURL *appLinkURL = [decoder decodeObjectOfClass:NSURL.class forKey:FBSDK_APP_INVITE_CONTENT_APP_LINK_URL_KEY];
  if (appLinkURL && (self = [self initWithAppLinkURL:appLinkURL])) {
    _appInvitePreviewImageURL = [decoder decodeObjectOfClass:NSURL.class forKey:FBSDK_APP_INVITE_CONTENT_PREVIEW_IMAGE_KEY];
    _promotionCode = [decoder decodeObjectOfClass:NSString.class forKey:
                      FBSDK_APP_INVITE_CONTENT_PROMO_CODE_KEY];
    _promotionText = [decoder decodeObjectOfClass:NSString.class forKey:
                      FBSDK_APP_INVITE_CONTENT_PROMO_TEXT_KEY];
    _destination = [decoder decodeIntegerForKey:
                    FBSDK_APP_INVITE_CONTENT_DESTINATION_KEY];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:_appLinkURL forKey:FBSDK_APP_INVITE_CONTENT_APP_LINK_URL_KEY];
  [encoder encodeObject:_appInvitePreviewImageURL forKey:FBSDK_APP_INVITE_CONTENT_PREVIEW_IMAGE_KEY];
  [encoder encodeObject:_promotionCode forKey:FBSDK_APP_INVITE_CONTENT_PROMO_CODE_KEY];
  [encoder encodeObject:_promotionText forKey:FBSDK_APP_INVITE_CONTENT_PROMO_TEXT_KEY];
  [encoder encodeInt:(int)_destination forKey:FBSDK_APP_INVITE_CONTENT_DESTINATION_KEY];
}

@end

#endif
