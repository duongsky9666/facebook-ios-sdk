/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#if !TARGET_OS_TV

#import <Foundation/Foundation.h>

#import <FBSDKShareKit/FBSDKCameraEffectArguments.h>
#import <FBSDKShareKit/FBSDKCameraEffectTextures.h>
#import <FBSDKShareKit/FBSDKSharingContent.h>

NS_ASSUME_NONNULL_BEGIN

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
/**
 A model for content to share with a Facebook camera effect.
 */
NS_SWIFT_NAME(ShareCameraEffectContent)
@interface FBSDKShareCameraEffectContent : NSObject <FBSDKSharingContent>
#pragma clang diagnostic pop

/**
 ID of the camera effect to use.
 */
@property (nonatomic, copy) NSString *effectID;

/**
 Arguments for the effect.
 */
@property (nonatomic) FBSDKCameraEffectArguments *effectArguments;

/**
 Textures for the effect.
 */
@property (nonatomic) FBSDKCameraEffectTextures *effectTextures;

@end

NS_ASSUME_NONNULL_END

#endif
