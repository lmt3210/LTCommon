//
//  AboutWindowController.m
//
//  Created by Nicolás Miari on 2016/02/11.
//  Copyright © 2016 Nicolás Miari. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "AboutWindowController.h"


@implementation AboutWindowController

@synthesize mWebsiteButton1;
@synthesize mWebsiteButton2;
@synthesize mWebsiteButton3;
@synthesize mWebLink1;
@synthesize mWebLink2;
@synthesize mWebLink3;

// Singleton (see header file)
+ (instancetype)defaultController
{
    static id staticInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
    });
 
    return staticInstance;
}

- (instancetype)init
{
    return [super initWithWindowNibName:@"AboutWindow" owner:self];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Window has loaded; all subview outlets are initialized
    
    // 1. Customize the window's overall appearance:
    [self.window setBackgroundColor:[NSColor colorWithSRGBRed:(61.0 / 255.0)
                                     green:(39.0 / 255.0) blue:(93.0 / 255.0)
                                     alpha:1.0]];
    // 2. Read the app's info and reflect that content in the window's
    //    subviews:
    
    // App icon:
    self.appIconImageView.image = [NSApp applicationIconImage];
    
    // The contents of Info.plist:
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];

    // Configure all labels:
    self.appNameLabel.stringValue =
        [infoDictionary objectForKey:@"CFBundleName"];
    NSString *version = [NSString stringWithFormat:@"Version %@",
                         [infoDictionary
                          objectForKey:@"CFBundleShortVersionString"]];
    self.appVersionLabel.stringValue = version;
    self.appCopyrightLabel.stringValue =
        [infoDictionary objectForKey:@"NSHumanReadableCopyright"];
    
    // If you add more custom subviews to display additional information about
    // your app, configure them here

    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *txtPath = [bundle URLForResource:@"Credits"
                      withExtension:@"txt"];
    NSString *text = [NSString stringWithContentsOfURL:txtPath
                      encoding:NSASCIIStringEncoding error:nil];
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSArray *lines = [text componentsSeparatedByCharactersInSet:separator];
    
    NSColor *color = [NSColor whiteColor];
    NSMutableAttributedString *title =
    [[NSMutableAttributedString alloc]
     initWithData:[lines[0] dataUsingEncoding:NSUnicodeStringEncoding]
     options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
     documentAttributes:nil error:nil];
    NSRange titleRange = NSMakeRange(0, [title length]);
    [title addAttribute:NSForegroundColorAttributeName
     value:color range:titleRange];
    [mWebsiteButton1 setAttributedTitle:title];
    mWebLink1 = lines[1];

    if ([lines[2] isEqualToString:@"None"] == YES)
    {
        [mWebsiteButton2 setTitle:@""];
        mWebLink2 = nil;
    }
    else
    {
        title = [[NSMutableAttributedString alloc]
                 initWithData:[lines[2]
                 dataUsingEncoding:NSUnicodeStringEncoding]
                 options:@{NSDocumentTypeDocumentAttribute:
                 NSHTMLTextDocumentType}
                 documentAttributes:nil error:nil];
        titleRange = NSMakeRange(0, [title length]);
        [title addAttribute:NSForegroundColorAttributeName
         value:color range:titleRange];
        [mWebsiteButton2 setAttributedTitle:title];
        mWebLink2 = lines[3];
    }
    
    if ([lines[4] isEqualToString:@"None"] == YES)
    {
        [mWebsiteButton3 setTitle:@""];
        mWebLink3 = nil;
    }
    else
    {
        title = [[NSMutableAttributedString alloc]
                 initWithData:[lines[4]
                 dataUsingEncoding:NSUnicodeStringEncoding]
                 options:@{NSDocumentTypeDocumentAttribute:
                 NSHTMLTextDocumentType}
                 documentAttributes:nil error:nil];
        titleRange = NSMakeRange(0, [title length]);
        [title addAttribute:NSForegroundColorAttributeName
         value:color range:titleRange];
        [mWebsiteButton3 setAttributedTitle:title];
        mWebLink3 = lines[5];
    }
}

- (IBAction)mWebsiteLink3:(id)sender
{
    if (mWebLink3 != nil)
    {
        [[NSWorkspace sharedWorkspace]
         openURL:[NSURL URLWithString:mWebLink3]];
    }
}

- (IBAction)mWebsiteLink2:(id)sender
{
    if (mWebLink2 != nil)
    {
        [[NSWorkspace sharedWorkspace]
         openURL:[NSURL URLWithString:mWebLink2]];
    }
}

- (IBAction)mWebsiteLink1:(id)sender
{
    if (mWebLink1 != nil)
    {
        [[NSWorkspace sharedWorkspace]
         openURL:[NSURL URLWithString:mWebLink1]];
    }
}
@end
