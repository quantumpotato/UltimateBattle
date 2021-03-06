/*
	File:  AVAudioSettings.h
	
	Framework:  AVFoundation
	
	Copyright 2008-2010 Apple Inc. All rights reserved.
*/

#import <AVFoundation/AVBase.h>
#import <Foundation/NSObject.h>
#import <Availability.h>

/* This file's methods are available with iPhone 3.0 or later */

/* property keys - values for all keys defined below are NSNumbers */

/* keys for all formats */
extern NSString *const AVFormatIDKey;								/* value is an integer (format ID) from CoreAudioTypes.h */
extern NSString *const AVSampleRateKey;								/* value is floating point in Hertz */
extern NSString *const AVNumberOfChannelsKey;						/* value is an integer */

/* linear PCM keys */
extern NSString *const AVLinearPCMBitDepthKey;						/* value is an integer, one of: 8, 16, 24, 32 */
extern NSString *const AVLinearPCMIsBigEndianKey;					/* value is a BOOL */
extern NSString *const AVLinearPCMIsFloatKey;						/* value is a BOOL */

extern NSString *const AVLinearPCMIsNonInterleaved NS_AVAILABLE(10_7, 4_0);   /* value is a BOOL */
#define AVLinearPCMIsNonInterleavedKey AVLinearPCMIsNonInterleaved

/* encoder property keys */
extern NSString *const AVEncoderAudioQualityKey;					/* value is an integer from enum AVAudioQuality */
	/* only one of AVEncoderBitRateKey and AVEncoderBitRatePerChannelKey should be provided. */
extern NSString *const AVEncoderBitRateKey;							/* value is an integer */
extern NSString *const AVEncoderBitRatePerChannelKey NS_AVAILABLE(10_7, 4_0); /* value is an integer */
extern NSString *const AVEncoderBitDepthHintKey;					/* value is an integer from 8 to 32 */

/* sample rate converter property keys */
extern NSString *const AVSampleRateConverterAudioQualityKey;		/* value is an integer from enum AVAudioQuality */

/* channel layout */
extern NSString *const AVChannelLayoutKey NS_AVAILABLE(10_7, 4_0);	/* value is an NSData containing an AudioChannelLayout */
	

/* property values */

enum {
	AVAudioQualityMin = 0,
	AVAudioQualityLow = 0x20,
	AVAudioQualityMedium = 0x40,
	AVAudioQualityHigh = 0x60,
	AVAudioQualityMax = 0x7F
};
typedef NSInteger AVAudioQuality;



