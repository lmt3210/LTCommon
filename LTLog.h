// 
// LTLog.h 
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

#import <os/log.h>
#import <sys/types.h>
#import <pwd.h>
#import <uuid/uuid.h>

#define LTLOG_NO_FILE  @""

// OS_LOG_TYPE_INFO
// OS_LOG_TYPE_DEBUG
// OS_LOG_TYPE_ERROR

static inline void LTLog(os_log_t log, NSString *logFile, 
                         os_log_type_t type, NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *message =
        [[NSString alloc] initWithFormat:format arguments:args];
    os_log_with_type(log, type, "%{public}s", [message UTF8String]);

    if ([logFile isEqualToString:LTLOG_NO_FILE] == NO)
    {
        FILE *outp = fopen([logFile UTF8String], "a");

        if (outp != NULL)
        {
            fprintf(outp, "%s\n", [message UTF8String]);
            fflush(outp);
            fclose(outp);
        }
    }

    va_end(args);
}

struct LTauErrors
{
    NSString *message;
    OSStatus code;
};

static const struct LTauErrors auErrorList[] =
{
    { @"kAudio_ParamError", -50},
    // These are from AUComponent.h - Audio Unit errors enum
    { @"kAudioUnitErr_InvalidProperty", -10879 },
    { @"kAudioUnitErr_InvalidParameter", -10878 },
    { @"kAudioUnitErr_InvalidElement", -10877 },
    { @"kAudioUnitErr_NoConnection", -10876 },
    { @"kAudioUnitErr_FailedInitialization", -10875 },
    { @"kAudioUnitErr_TooManyFramesToProcess", -10874 },
    { @"kAudioUnitErr_InvalidFile", -10871 },
    { @"kAudioUnitErr_UnknownFileType", -10870 },
    { @"kAudioUnitErr_FileNotSpecified", -10869 },
    { @"kAudioUnitErr_FormatNotSupported", -10868 },
    { @"kAudioUnitErr_Uninitialized", -10867 },
    { @"kAudioUnitErr_InvalidScope", -10866 },
    { @"kAudioUnitErr_PropertyNotWritable", -10865 },
    { @"kAudioUnitErr_CannotDoInCurrentContext", -10863 },
    { @"kAudioUnitErr_InvalidPropertyValue", -10851 },
    { @"kAudioUnitErr_PropertyNotInUse", -10850 },
    { @"kAudioUnitErr_Initialized", -10849 },
    { @"kAudioUnitErr_InvalidOfflineRender", -10848 },
    { @"kAudioUnitErr_Unauthorized", -10847 },
    { @"kAudioUnitErr_MIDIOutputBufferFull", -66753 },
    { @"kAudioComponentErr_InstanceTimedOut", -66754 },
    { @"kAudioComponentErr_InstanceInvalidated", -66749 },
    { @"kAudioUnitErr_RenderTimeout", -66745 },
    { @"kAudioUnitErr_ExtensionNotFound", -66744 },
    { @"kAudioUnitErr_InvalidParameterValue", -66743 },
    { @"kAudioUnitErr_InvalidFilePath", -66742 },
    { @"kAudioUnitErr_MissingKey", -66741 },
    { @"kAudioUnitErr_ComponentManagerNotSupported", -66740 },
    { @"kAudioUnitErr_MultipleVoiceProcessors", -66635 }
};

static inline NSString *statusToString(OSStatus code)
{
    for (int i = 0; i < (sizeof(auErrorList) / sizeof(struct LTauErrors)); i++)
    {
        if (auErrorList[i].code == code)
        {
            return auErrorList[i].message;
        }
    }
    
    if (code > 0)
    {
        char s[5] = { (char)((code >> 24) & 0xff), (char)((code >> 16) & 0xff),
            (char)((code >> 8) & 0xff), (char)(code & 0xff), 0 };
        return [NSString stringWithUTF8String:s];
    }
    else
    {
        return @"????";
    }
}

#define LT_STRUCT_MESSAGE_LENGTH  1024

static char structStr[LT_STRUCT_MESSAGE_LENGTH];

static inline void LTGetStructStringHelper(const char *format, ...)
{
    char str[LT_STRUCT_MESSAGE_LENGTH];
    va_list arg;
    va_start(arg, format);
    vsnprintf(str, LT_STRUCT_MESSAGE_LENGTH, format, arg);
    va_end(arg);
    strlcat(structStr, str, LT_STRUCT_MESSAGE_LENGTH);
}

#define LTGetStructString(s, ret) \
    memset(structStr, 0, LT_STRUCT_MESSAGE_LENGTH); \
    __builtin_dump_struct(s, &LTGetStructStringHelper); \
    ret = [NSString stringWithCString:structStr \
            encoding:NSASCIIStringEncoding];

#define LTPrintStruct(s) \
    __builtin_dump_struct(s, &printf);

