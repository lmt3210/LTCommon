// 
// LTVersionCheck.m
//
// Copyright (c) 2020-2026 Larry M. Taylor
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

#import "LTVersionCheck.h"


@implementation LTVersionCheck

- (id)init
{
    if ((self = [super init]))
    {
        // Setup popup window
        mPopupWindow = [[LTPopup alloc] initWithWindowNibName:@"LTPopup"];
        mText = [[NSMutableString alloc] init];

        // Init variables
        mAppName = @"";
        mAppVersion = @"";
        mCheckCount = 0;
    }
    
    return self;
}


- (id)initWithAppName:(NSString *)appName
       withAppVersion:(NSString *)appVersion
        withLogHandle:(os_log_t)log
          withLogFile:(NSString *)logFile
{
    if ((self = [super init]))
    {
        // Set up logging
        mLog = log;
        mLogFile = [logFile copy];
        
        // Setup popup window
        mPopupWindow = [[LTPopup alloc] initWithWindowNibName:@"LTPopup"];
        mText = [[NSMutableString alloc] init];

        // Init variables
        mAppName = appName;
        mAppVersion = appVersion;
        mCheckCount = 0;

        // Watch for version notification
        [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(versionReceived:)
            name:@"LTLatestVersionNotification" object:nil];

        // Start version fetch
        [self getLatestVersion];
    }
    
    return self;
}

- (void)checkVersionForAppName:(NSString *)appName
                withAppVersion:(NSString *)appVersion
                 withLogHandle:(os_log_t)log
                   withLogFile:(NSString *)logFile
{
    // Set up logging
    mLog = log;
    mLogFile = [logFile copy];
    
    // Init variables
    mAppName = appName;
    mAppVersion = appVersion;

    // Watch for version notification
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(versionReceived2:)
        name:@"LTLatestVersionNotification" object:nil];

    // Start version fetch
    [self getLatestVersion];
}

- (void)versionReceived:(NSNotification *)notification
{
    if ([[notification name]
         isEqualToString:@"LTLatestVersionNotification"] == YES)
    {
        NSDictionary *versionData = [notification userInfo];
        NSString *latestVersion = [versionData objectForKey:@"Latest Version"];

        LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO, @"Latest version is %@",
              latestVersion);
        
        NSUserDefaults *userDefaults =
        [[NSUserDefaultsController sharedUserDefaultsController] values];
        NSString *settingsKey =
            [NSString stringWithFormat:@"%@ VersionCheckCount", mAppName];
        
        if ([userDefaults valueForKey:settingsKey] != nil)
        {
            NSDictionary *checkDict =
            [userDefaults valueForKey:settingsKey];
            NSNumber *checkCountNum = [checkDict objectForKey:mAppVersion];
            mCheckCount = (checkCountNum == nil) ? 0 :
                          [checkCountNum intValue];
        }
        
        if (([mAppVersion isEqualToString:latestVersion] == NO) &&
            (mCheckCount < 3))
        {
            [mText setString:@""];
            [mText appendFormat:@"This is %@ version ", mAppName];
            [mText appendString:mAppVersion];
            [mText appendString:@". The latest released version is "];
            [mText appendString:latestVersion];
            [mText appendString:@"."];
            [mPopupWindow show];
            [mPopupWindow setText:(NSString *)mText];
            
            NSDictionary *check = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:(mCheckCount + 1)],
                                   mAppVersion, nil];
            [userDefaults setValue:check forKey:settingsKey];
        }
    }
}

- (void)versionReceived2:(NSNotification *)notification
{
    if ([[notification name]
         isEqualToString:@"LTLatestVersionNotification"] == YES)
    {
        NSDictionary *versionData = [notification userInfo];
        NSString *latestVersion = [versionData objectForKey:@"Latest Version"];

        LTLog(mLog, mLogFile, OS_LOG_TYPE_INFO, @"Latest version is %@",
              latestVersion);
        
        if ([mAppVersion isEqualToString:latestVersion] == YES)
        {
            [mText setString:@"\n\n"];
            [mText appendFormat:@"This is the latest version."];
            [mPopupWindow show];
            [mPopupWindow setText:(NSString *)mText];
        }
        else
        {
            [mText setString:@"\n"];
            [mText appendFormat:@"This is %@ version ", mAppName];
            [mText appendString:mAppVersion];
            [mText appendString:@".\n\nThe latest released version is "];
            [mText appendString:latestVersion];
            [mText appendString:@"."];
            [mPopupWindow show];
            [mPopupWindow setText:(NSString *)mText];
        }
    }
}

- (void)getLatestVersion
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = @"https://www.larrymtaylor.com/versions.php";
    mDataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] 
                 completionHandler:^(NSData *data, NSURLResponse *response, 
                                     NSError *error)
    {
        if (error != nil)
        {
            LTLog(self->mLog, self->mLogFile, OS_LOG_TYPE_ERROR,
                  @"Network session error: %@", error);
        }
        else if ((data) && ([data length] > 0))
        {
            NSError *e = nil;
            NSDictionary *jsonDicts =
                [NSJSONSerialization JSONObjectWithData:data
                 options:NSJSONReadingMutableContainers error:&e];
 
            for (NSDictionary *jsonDict in jsonDicts)
            {
                NSString *latestVersion =
                    [jsonDict valueForKey:self->mAppName];
         
                if (latestVersion != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSDictionary *versionData =
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         latestVersion, @"Latest Version", nil];
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"LTLatestVersionNotification"
                         object:nil userInfo:versionData];
                    });

                    break;
                }
            }
        }
    }];
    
    [mDataTask resume];
}

@end
