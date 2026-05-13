//
// LTAUGraph.mm
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

#import "LTAUGraph.h"

@implementation LTAUGraph

- (id)initWithLogHandle:(os_log_t)log withLogFile:(NSString *)logFile
{
    if ((self = [super init]))
    {
        mLog = log;
        mLogFile = [logFile copy];
    }

    return self;
}

- (AudioUnit)createGraph
{
    OSStatus err = NewAUGraph(&mGraph);
    
    if (err != noErr)
    {
        LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
              @"NewAUGraph returned status %i (%@)", err, statusToString(err));
    }
   
    if (mGraph)
    {
        CAComponentDescription desc =
            CAComponentDescription(kAudioUnitType_Output,
                                   kAudioUnitSubType_DefaultOutput,
                                   kAudioUnitManufacturer_Apple);
    
        err = AUGraphAddNode(mGraph, &desc, &mOutputNode);
    
        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"AUGraphAddNode for output returned status %i (%@)",
                  err, statusToString(err));
        }
   
        err = AUGraphOpen(mGraph);
    
        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"AUGraphOpen returned status %i (%@)",
                  err, statusToString(err));
        }
   
        err = AUGraphNodeInfo(mGraph, mOutputNode, NULL, &mOutputUnit);
    
        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"AUGraphNodeInfo for output returned status %i (%@)",
                  err, statusToString(err));
        }
    }

    return mOutputUnit;
}

- (AudioUnit)addSynth:(AudioComponentDescription)desc
{
    OSStatus err = AUGraphAddNode(mGraph, &desc, &mSynthNode);

    if (err != noErr)
    {
        LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
              @"AUGraphAddNode for AU returned status %i (%@)",
              err, statusToString(err));
        return nil;
    }

    err = AUGraphNodeInfo(mGraph, mSynthNode, NULL, &mSynthUnit);

    if (err != noErr)
    {
        LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
              @"AUGraphNodeInfo for AU returned status %i (%@)",
              err, statusToString(err));
    }

    err = AUGraphUpdate(mGraph, NULL);

    if (err != noErr)
    {
        LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
              @"AUGraphUpdate returned status %i (%@)",
              err, statusToString(err));
    }

    return mSynthUnit;
}

- (void)removeSynth
{
    if (mSynthNode)
    {
        OSStatus err = AUGraphRemoveNode(mGraph, mSynthNode);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"AUGraphRemoveNode returned status %i (%@)",
                  err, statusToString(err));
        }

        mSynthNode = NULL;
    }    
}

- (void)startGraph
{
    if (mGraph)
    {
        OSStatus err = AUGraphConnectNodeInput(mGraph, mSynthNode, 0,
                                               mOutputNode, 0);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"AUGraphConnectNodeInput returned status %i (%@)",
                  err, statusToString(err));
        }

        err = AUGraphUpdate(mGraph, NULL);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"AUGraphUpdate returned status %i (%@)",
                  err, statusToString(err));
        }

        err = AUGraphInitialize(mGraph);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"AUGraphInitialize returned status %i (%@)",
                  err, statusToString(err));
        }

        err = AUGraphStart(mGraph);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"AUGraphStart returned status %i (%@)",
                  err, statusToString(err));
        }
    }
}

- (void)stopGraph
{
    if (mGraph)
    {
        Boolean isRunning = FALSE;
        OSStatus err = AUGraphIsRunning(mGraph, &isRunning);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"AUGraphIsRunning returned status %i (%@)",
                  err, statusToString(err));
        }

        if (isRunning)
        {
            err = AUGraphStop(mGraph);

            if (err != noErr)
            {
                LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                      @"AUGraphStop returned status %i (%@)",
                      err, statusToString(err));
            }

            err = AUGraphUninitialize(mGraph);

            if (err != noErr)
            {
                LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                      @"AUGraphUninitialize returned status %i (%@)",
                      err, statusToString(err));
            }

            err = AUGraphClearConnections(mGraph);

            if (err != noErr)
            {
                LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                      @"AUGraphClearConnections returned status %i (%@)",
                      err, statusToString(err));
            }

            err = AUGraphUpdate(mGraph, NULL);

            if (err != noErr)
            {
                LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                      @"AUGraphUpdate returned status %i (%@)",
                      err, statusToString(err));
            }
        }
    }
}

- (void)destroyGraph
{
    if (mGraph)
    {
        // Close and destroy
        OSStatus err = AUGraphClose(mGraph);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"AUGraphClose returned status %i (%@)",
                  err, statusToString(err));
        }

        err = DisposeAUGraph(mGraph);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"DisposeAUGraph returned status %i (%@)",
                  err, statusToString(err));
        }
    }
}

- (void)graphInfo
{
    OSStatus err = statusErr;
    UInt32 numNodes = 0;

    err = AUGraphGetNodeCount(mGraph, &numNodes);

    if (err == noErr)
    {
        LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO,
              @"AUGraph has %i nodes", numNodes);
    }
    else
    {
        LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
              @"AUGraphGetNodeCount returned status %i (%@)",
              err, statusToString(err));
    }

    for (UInt32 i = 0; i < numNodes; i++)
    {
        AUNode node;
        err = AUGraphGetIndNode(mGraph, i, &node);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"AUGraphGetIndNode returned status %i (%@)",
                  err, statusToString(err));
        }

        AudioComponentDescription desc = { 0 };
        AudioUnit au = NULL;

        err = AUGraphNodeInfo(mGraph, node, &desc, &au);

        if (err == noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO,
                  @"AUGraph node %i: type %@, subtype %@, manufacturer %@", i,
                  statusToString(desc.componentType),
                  statusToString(desc.componentSubType),
                  statusToString(desc.componentManufacturer));
        }
        else
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"AUGraphGetNodeInfo for node %i returned status %i (%@)",
                  i, err, statusToString(err));
        }

        UInt32 inputCount = 0;                   
        UInt32 inputCountSize = sizeof(inputCount);
        err = AudioUnitGetProperty(au, kAudioUnitProperty_ElementCount,
                                   kAudioUnitScope_Input, 0, 
                                   &inputCount, &inputCountSize);
  
        if (err == noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO,
                  @"AUGraph node %i: input count = %i", i, inputCount);
        }
        else
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Get element count for node %i input error = %i (%@)",
                  i, err, statusToString(err));
        }

        UInt32 outputCount = 0;                   
        UInt32 outputCountSize = sizeof(outputCount);
        err = AudioUnitGetProperty(au, kAudioUnitProperty_ElementCount,
                                   kAudioUnitScope_Output, 0, 
                                   &outputCount, &outputCountSize);
  
        if (err == noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO,
                  @"AUGraph node %i: output count = %i", i, outputCount);
        }
        else
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Get element count for node %i output error = %i (%@)",
                  i, err, statusToString(err));
        }

        if (inputCount > 0)
        {
            AudioStreamBasicDescription format = { 0 };
            UInt32 absdSize = sizeof(format);
            NSString *absdText;
    
            err = AudioUnitGetProperty(au, kAudioUnitProperty_StreamFormat,
                                       kAudioUnitScope_Input, 0,
                                       &format, &absdSize);
            if (err == noErr)
            {
                LTGetStructString(&format, absdText);
                LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO,
                      @"AUGraph node %i input %@", i, absdText);
            }
            else
            {
                LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                      @"Get stream format for node %i input error = %i (%@)",
                      i, err, statusToString(err));
            }
        }
    
        if (outputCount > 0)
        {
            AudioStreamBasicDescription format = { 0 };
            UInt32 absdSize = sizeof(format);
            NSString *absdText;

            err = AudioUnitGetProperty(au, kAudioUnitProperty_StreamFormat,
                                       kAudioUnitScope_Output, 0,
                                       &format, &absdSize);

            if (err == noErr)
            {
                LTGetStructString(&format, absdText);
                LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO,
                      @"AUGraph node %i output %@", i, absdText);
            }
            else
            {
                LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                      @"Get stream format for node %i output error = %i (%@)",
                      i, err, statusToString(err));
            }
        }
    }
}

- (void)showAUState:(AudioUnit)au forAUName:(NSString *)name
{
    LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO, @"%@ AU state:", name);
    
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

- (void)showAUInfo:(AudioUnit)au forAUName:(NSString *)name
    hasInput:(bool)hasInput hasOutput:(bool)hasOutput
{
    AudioStreamBasicDescription format = { 0 };
    UInt32 absdSize = sizeof(format);
    NSString *absdText;
    OSStatus err = statusErr;
    
    if (hasOutput == true)
    {
        err = AudioUnitGetProperty(au, kAudioUnitProperty_StreamFormat,
                                   kAudioUnitScope_Input, 0,
                                   &format, &absdSize);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioUnitGetProperty for "
                   "kAudioUnitProperty_StreamFormat for input scope, "
                   "error = %i (%@)", err, statusToString(err));
        }
        else
        {
            LTGetStructString(&format, absdText);
            LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO,
                  @"    %@ AU (input scope) %@", name, absdText);
        }
    
        err = AudioUnitGetProperty(au, kAudioUnitProperty_StreamFormat,
                                   kAudioUnitScope_Output, 0,
                                   &format, &absdSize);

        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioUnitGetProperty for "
                   "kAudioUnitProperty_StreamFormat for output scope, "
                   "error = %i (%@)", err, statusToString(err));
        }
        else
        {
            LTGetStructString(&format, absdText);
            LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO,
                  @"    %@ AU (output scope) %@", name, absdText);
        }
    }
    
    if (hasOutput == true)
    {
        UInt32 auRunning = 0;
        UInt32 runSize = sizeof(auRunning);
        err = AudioUnitGetProperty(au, kAudioOutputUnitProperty_IsRunning,
                                   kAudioUnitScope_Global, 0,
                                   &auRunning, &runSize);
        
        if (err != noErr)
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
                  @"Failed AudioUnitGetProperty for "
                  "kAudioOutputUnitProperty_IsRunning, error = %i (%@)",
                  err, statusToString(err));
        }
        else
        {
            LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO, @"    %@ AU running = %i",
                  name, auRunning);
        }
    }
    
    UInt32 framesPerSlice;
    UInt32 dataSize = sizeof(framesPerSlice);
    err = AudioUnitGetProperty(au, kAudioUnitProperty_MaximumFramesPerSlice,
                         kAudioUnitScope_Global, 0,
                         &framesPerSlice, &dataSize);

    if (err != noErr)
    {
        LTLog(mLog, mLogFile, OS_LOG_TYPE_ERROR,
              @"Failed AudioUnitGetProperty for "
               "kAudioUnitProperty_MaximumFramesPerSlice, error = %i (%@)",
              err, statusToString(err));
    }
    else
    {
        LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO, @"    %@ AU buffer size = %i",
              name, framesPerSlice);
    }
}

@end
