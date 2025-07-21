//
// NSString+Hex.m
// Created by Ben Baron on 10/20/10.
//

#import "NSString+Hex.h"

NSString *const HexDomain = @"HexDomain";

@implementation NSString (Hex)

- (NSString *)stringFromHex:(NSString *)str
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};

    for (int i = 0; i < [str length] / 2; i++)
    {
        byte_chars[0] = [str characterAtIndex:(i * 2)];
        byte_chars[1] = [str characterAtIndex:(i * 2) + 1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }

    return [[NSString alloc] initWithData:stringData
            encoding:NSASCIIStringEncoding];
}

- (NSString *)stringToHex:(NSString *)str
{   
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];

    NSMutableString *hexString = [[NSMutableString alloc] init];

    for (NSUInteger i = 0; i < len; i++)
    {
        [hexString appendString:
         [NSString stringWithFormat:@"0x%02X ", chars[i]]];
    }

    free(chars);

    return hexString;
}

@end
