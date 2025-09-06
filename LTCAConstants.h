// 
// LTCAConstants.h 
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

#define LT_AU_MESSAGE_LENGTH  75

struct LTauErrors
{
    const char *message;
    OSStatus code;
};

static const struct LTauErrors auErrorList[] =
{
    // This is from MacTypes.h
    { "noErr", 0 },
    { "kAudio_ParamError", -50 },
    // These are from AUComponent.h - Audio Unit errors enum
    { "kAudioUnitErr_InvalidProperty", -10879 },
    { "kAudioUnitErr_InvalidParameter", -10878 },
    { "kAudioUnitErr_InvalidElement", -10877 },
    { "kAudioUnitErr_NoConnection", -10876 },
    { "kAudioUnitErr_FailedInitialization", -10875 },
    { "kAudioUnitErr_TooManyFramesToProcess", -10874 },
    { "kAudioUnitErr_InvalidFile", -10871 },
    { "kAudioUnitErr_UnknownFileType", -10870 },
    { "kAudioUnitErr_FileNotSpecified", -10869 },
    { "kAudioUnitErr_FormatNotSupported", -10868 },
    { "kAudioUnitErr_Uninitialized", -10867 },
    { "kAudioUnitErr_InvalidScope", -10866 },
    { "kAudioUnitErr_PropertyNotWritable", -10865 },
    { "kAudioUnitErr_CannotDoInCurrentContext", -10863 },
    { "kAudioUnitErr_InvalidPropertyValue", -10851 },
    { "kAudioUnitErr_PropertyNotInUse", -10850 },
    { "kAudioUnitErr_Initialized", -10849 },
    { "kAudioUnitErr_InvalidOfflineRender", -10848 },
    { "kAudioUnitErr_Unauthorized", -10847 },
    { "kAudioUnitErr_MIDIOutputBufferFull", -66753 },
    { "kAudioComponentErr_InstanceTimedOut", -66754 },
    { "kAudioComponentErr_InstanceInvalidated", -66749 },
    { "kAudioUnitErr_RenderTimeout", -66745 },
    { "kAudioUnitErr_ExtensionNotFound", -66744 },
    { "kAudioUnitErr_InvalidParameterValue", -66743 },
    { "kAudioUnitErr_InvalidFilePath", -66742 },
    { "kAudioUnitErr_MissingKey", -66741 },
    { "kAudioUnitErr_ComponentManagerNotSupported", -66740 },
    { "kAudioUnitErr_MultipleVoiceProcessors", -66635 }
};

struct LTauParameterIDs
{
    const char *string;
    int id;
};

static const struct LTauParameterIDs auParameterIDs[] =
{
    // These are from AudioUnitProperties.h - AudioUnitPropertyID enum
    { "kAudioUnitProperty_ClassInfo", 0 },
    { "kAudioUnitProperty_MakeConnection", 1 },
    { "kAudioUnitProperty_SampleRate", 2 },
    { "kAudioUnitProperty_ParameterList", 3 },
    { "kAudioUnitProperty_ParameterInfo", 4 },
    { "kAudioUnitProperty_CPULoad", 6 },
    { "kAudioUnitProperty_StreamFormat", 8 },
    { "kAudioUnitProperty_ElementCount", 11 },
    { "kAudioUnitProperty_Latency", 12 },
    { "kAudioUnitProperty_SupportedNumChannels", 13 },
    { "kAudioUnitProperty_MaximumFramesPerSlice", 14 },
    { "kAudioUnitProperty_ParameterValueStrings", 16 },
    { "kAudioUnitProperty_AudioChannelLayout", 19 },
    { "kAudioUnitProperty_TailTime", 20 },
    { "kAudioUnitProperty_BypassEffect", 21 },
    { "kAudioUnitProperty_LastRenderError", 22 },
    { "kAudioUnitProperty_SetRenderCallback", 23 },
    { "kAudioUnitProperty_FactoryPresets", 24 },
    { "kAudioUnitProperty_RenderQuality", 26 },
    { "kAudioUnitProperty_HostCallbacks", 27 },
    { "kAudioUnitProperty_InPlaceProcessing", 29 },
    { "kAudioUnitProperty_ElementName", 30 },
    { "kAudioUnitProperty_SupportedChannelLayoutTags", 32 },
    { "kAudioUnitProperty_PresentPreset", 36 },
    { "kAudioUnitProperty_DependentParameters", 45 },
    { "kAudioUnitProperty_InputSamplesInOutput", 49 },
    { "kAudioUnitProperty_ShouldAllocateBuffer", 51 },
    { "kAudioUnitProperty_FrequencyResponse", 52 },
    { "kAudioUnitProperty_ParameterHistoryInfo", 53 },
    { "kAudioUnitProperty_NickName", 54 },
    { "kAudioUnitProperty_OfflineRender", 37 },
    { "kAudioUnitProperty_ParameterIDName", 34 },
    { "kAudioUnitProperty_ParameterStringFromValue", 33 },
    { "kAudioUnitProperty_ParameterClumpName", 35 },
    { "kAudioUnitProperty_ParameterValueFromString", 38 },
    { "kAudioUnitProperty_ContextName", 25 },
    { "kAudioUnitProperty_PresentationLatency", 40 },
    { "kAudioUnitProperty_ClassInfoFromDocument", 50 },
    { "kAudioUnitProperty_RequestViewController", 56 },
    { "kAudioUnitProperty_ParametersForOverview", 57 },
    { "kAudioUnitProperty_SupportsMPE", 58 },
    { "kAudioUnitProperty_RenderContextObserver", 60 },
    { "kAudioUnitProperty_LastRenderSampleTime", 61 },
    { "kAudioUnitProperty_LoadedOutOfProcess", 62 },
    { "kAudioUnitProperty_FastDispatch", 5 },
    { "kAudioUnitProperty_SetExternalBuffer", 15 },
    { "kAudioUnitProperty_GetUIComponentList", 18 },
    { "kAudioUnitProperty_CocoaUI", 31 },
    { "kAudioUnitProperty_IconLocation", 39 },
    { "kAudioUnitProperty_AUHostIdentifier", 46 },
    { "kAudioUnitProperty_MIDIOutputCallbackInfo", 47 },
    { "kAudioUnitProperty_MIDIOutputCallback", 48 },
    { "kAudioUnitProperty_MIDIOutputEventListCallback", 63 },
    { "kAudioUnitProperty_AudioUnitMIDIProtocol", 64 },
    { "kAudioUnitProperty_HostMIDIProtocol", 65 },
    { "kAudioUnitProperty_MIDIOutputBufferSizeHint", 66 },
    { "kMusicDeviceProperty_MIDIXMLNames", 1006 },
    { "kMusicDeviceProperty_PartGroup", 1010 },
    { "kMusicDeviceProperty_DualSchedulingMode", 1013 },
    { "kMusicDeviceProperty_SupportsStartStopNote", 1014 },
    // This is my custom property ID
    { "kAudioUnitCustomPropertyUICB", 64056 }
};

static inline void parameterIDToString(int id, char *str)
{
    for (int i = 0;
         i < (sizeof(auParameterIDs) / sizeof(struct LTauParameterIDs)); i++)
    {
        if (auParameterIDs[i].id == id)
        {
            strcpy(str, auParameterIDs[i].string);
            return;
        }
    }

    snprintf(str, LT_AU_MESSAGE_LENGTH, "Unknown ID = %i", id);
    
    return;
}

