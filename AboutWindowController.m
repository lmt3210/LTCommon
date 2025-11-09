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

// Singleton (see header file)
+ (instancetype) defaultController
{
    static id staticInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
    });
 
    return staticInstance;
}

#pragma mark - Initialization

- (instancetype) init
{
    return [super initWithWindowNibName:@"AboutWindow" owner:self];
}

#pragma mark - NSWindowController

- (void) windowDidLoad
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

    NSBundle *bundle =
        [NSBundle mainBundle];
    NSURL *creditsPath = [bundle URLForResource:@"Credits"
                          withExtension:@"html"];
    NSString *text = [NSString stringWithContentsOfURL:creditsPath
                      encoding:NSASCIIStringEncoding error:nil];
    NSAttributedString *aboutText = [[NSAttributedString alloc]
        initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding]
        options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
        documentAttributes:nil error:nil];

    // Both of these are needed, otherwise hyperlinks won't accept mousedown
    [self.appWebsiteLabel setAllowsEditingTextAttributes:YES];
    [self.appWebsiteLabel setSelectable:YES];
    self.appWebsiteLabel.attributedStringValue = aboutText;
}

@end
