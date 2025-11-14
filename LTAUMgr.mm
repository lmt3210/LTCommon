//
// LTAUMgr.mm
//
// Copyright (c) 2020-2025 Larry M. Taylor
//
// This software is provided 'as-is', without any express or implied
// warranty. In no event will the authors be held liable for any damages
// arising from the use of this software. Permission is granted to anyone to
// use this software for any purpose, including commercial applications, and to
// to alter it and redistribute it freely, subject to 
// the following restrictions:
//
// 1. The origin of this software must not be misrepresented; you must not
//    claim that you wrote the original software. If you use this software
//    in a product, an acknowledgment in the product documentation would be
//    appreciated but is not required.
// 2. Altered source versions must be plainly marked as such, and must not be
//    misrepresented as being the original software.
// 3. This notice may not be removed or altered from any source
//    distribution.
//

// Import this first to avoid 'DebugAssert' is deprecated warnings
#import <AssertMacros.h>

#import <CoreAudio/CoreAudio.h>
#import <CoreAudioKit/CoreAudioKit.h>
#import <AudioUnit/AUCocoaUIView.h>

#import <CoreMIDI/CoreMIDI.h>
#import <AudioToolbox/MusicDevice.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "CAComponent.h"
#import "CAComponentDescription.h"
#import "CAStreamBasicDescription.h"

#import "LTAUMgr.h"

@implementation LTAUMgr

- (id)initWithLogHandle:(os_log_t)log withLogFile:(NSString *)logFile
{
    if ((self = [super init]))
    {
        mAU = nil;
        mOutputUnit = nil;
        mLog = log;
        mLogFile = [logFile copy];
    }

    return self;
}

- (AudioUnit)createAU:(AudioComponentDescription)desc
{
    if (mAU == nil)
    {
        AudioComponent auComp = AudioComponentFindNext(NULL, &desc);
        OSStatus err = AudioComponentInstanceNew(auComp, &mAU);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioComponentInstanceNew for AU, error = %i (%@)",
                  err, statusToString(err));
        }
    }
    
    return mAU;
}

- (void)initAU
{
    if (mAU != nil)
    {
        OSStatus err = AudioUnitInitialize(mAU);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioUnitInitialize for AU, error = %i (%@)",
                  err, statusToString(err));
        }
    }
}

- (void)uninitAU
{
    if (mAU != nil)
    {
        OSStatus err = AudioUnitUninitialize(mAU);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioUnitUninitialize for AU, error = %i (%@)",
                  err, statusToString(err));
        }
    }
}

- (void)deleteAU
{
    if (mAU != nil)
    {
        OSStatus err = AudioUnitReset(mAU, kAudioUnitScope_Global, 0);
        
        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioUnitReset for AU, error = %i (%@)",
                  err, statusToString(err));
        }
        
        err = AudioUnitUninitialize(mAU);
        
        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioUnitUninitialize for AU, error = %i (%@)",
                  err, statusToString(err));
        }
        
        err = AudioComponentInstanceDispose(mAU);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioComponentInstanceDispose for "
                   "AU, error = %i (%@)", err, statusToString(err));
        }

        mAU = nil;
    }
}

- (AudioUnit)createOutput
{
    if (mOutputUnit == nil)
    {
        AudioComponentDescription desc =
            CAComponentDescription(kAudioUnitType_Output,
                                   kAudioUnitSubType_DefaultOutput,
                                   kAudioUnitManufacturer_Apple);
        AudioComponent outComp = AudioComponentFindNext(NULL, &desc);
        OSStatus err = AudioComponentInstanceNew(outComp, &mOutputUnit);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioComponentInstanceNew for output, "
                   "error = %i (%@)", err, statusToString(err));
        }
  
    }

    return mOutputUnit;
}

- (void)initOutput
{
    if (mOutputUnit != nil)
    {
        OSStatus err = AudioUnitInitialize(mOutputUnit);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioUnitInitialize for output, error = %i (%@)",
                  err, statusToString(err));
        }
    }
}

- (void)startOutput
{
    if (mOutputUnit != nil)
    {
        OSStatus err = AudioOutputUnitStart(mOutputUnit);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioUnitOutputStart for output, error = %i (%@)",
                  err, statusToString(err));
        }
    }
}

- (void)stopOutput
{
    if (mOutputUnit != nil)
    {
        OSStatus err = AudioOutputUnitStop(mOutputUnit);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioUnitOutputStop for output, error = %i (%@)",
                  err, statusToString(err));
        }
    }
}

- (void)deleteOutput
{
    if (mOutputUnit != nil)
    {
        OSStatus err = AudioUnitUninitialize(mOutputUnit);
        
        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioUnitUninitialize for output, error = %i (%@)",
                  err, statusToString(err));
        }
        
        err = AudioComponentInstanceDispose(mOutputUnit);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioComponentInstanceDispose for output, "
                   "error = %i (%@)", err, statusToString(err));
        }
        
        mOutputUnit = nil;
    }
}

- (void)connectUnits
{
    if ((mAU != nil) && (mOutputUnit != nil))
    {
        AudioUnitConnection connection;
        connection.destInputNumber = 0;
        connection.sourceAudioUnit = mAU;
        connection.sourceOutputNumber = 0;
  
        OSStatus err = AudioUnitSetProperty(mOutputUnit,
                                            kAudioUnitProperty_MakeConnection,
                                            kAudioUnitScope_Input,
                                            0, &connection,
                                            sizeof(AudioUnitConnection));

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed setting connection between AU "
                   "and output, error = %i (%@)", err, statusToString(err));
        }
    }
}

- (void)showAUState:(AudioUnit)au
{
    LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO, @"AU state:");
    
    CFPropertyListRef propertyList;
    UInt32 sz = sizeof(propertyList);
    AudioUnitGetProperty(au, kAudioUnitProperty_ClassInfo,
                         kAudioUnitScope_Global, 0, &propertyList, &sz);

    NSDictionary *auState = CFBridgingRelease(propertyList);
    
    for (NSString *key in auState)
    {
        id value = auState[key];
        
        if ([key isEqualToString:@"type"] ||
            [key isEqualToString:@"subtype"] ||
            [key isEqualToString:@"manufacturer"])
        {
            int tmp = [value intValue];
            LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO, @"    %@ = %@", key,
                  statusToString(tmp));
        }
        else if ([key isEqualToString:@"version"])
        {
            int tmp = [value intValue];
            NSString *version = [NSString stringWithFormat:@"    %i.%i.%i",
                                 ((tmp >> 16) & 0x0000ffff),
                                 ((tmp >> 8) & 0x000000ff),
                                 (tmp & 0x000000ff)];
            LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO, @"    %@ = %@",
                  key, version);
        }
        else
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO, @"    %@ = %@",
                  key, value);
        }
    }
}

- (void)showAUInfo:(AudioUnit)au
{
    AudioStreamBasicDescription format = { 0 };
    UInt32 absdSize = sizeof(format);
    NSString *absdText;
    
    AudioUnitGetProperty(au, kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input, 0, &format, &absdSize);
    LTGetStructString(&format, absdText);
    LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO, @"    AU (input scope) %@",
          absdText);
    
    AudioUnitGetProperty(au, kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Output, 0, &format, &absdSize);
    LTGetStructString(&format, absdText);
    LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO, @"    AU (output scope) %@",
          absdText);
    
    UInt32 auRunning = 0;
    UInt32 runSize = sizeof(auRunning);
    AudioUnitGetProperty(au, kAudioOutputUnitProperty_IsRunning,
                         kAudioUnitScope_Global, 0, &auRunning, &runSize);
    LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO, @"    AU running = %i",
          auRunning);
}

@end
