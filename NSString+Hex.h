//
// NSString+Hex.h
// Created by Ben Baron on 10/20/10.
//

#import <Cocoa/Cocoa.h>

@interface NSString (Hex) 

- (NSString *)stringFromHex:(NSString *)str;
- (NSString *)stringToHex:(NSString *)str;

@end
