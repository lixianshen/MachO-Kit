//----------------------------------------------------------------------------//
//|
//|             MachOKit - A Lightweight Mach-O Parsing Library
//|             NSFormatter+MKNodeField.m
//|
//|             D.V.
//|             Copyright (c) 2014-2015 D.V. All rights reserved.
//|
//| Permission is hereby granted, free of charge, to any person obtaining a
//| copy of this software and associated documentation files (the "Software"),
//| to deal in the Software without restriction, including without limitation
//| the rights to use, copy, modify, merge, publish, distribute, sublicense,
//| and/or sell copies of the Software, and to permit persons to whom the
//| Software is furnished to do so, subject to the following conditions:
//|
//| The above copyright notice and this permission notice shall be included
//| in all copies or substantial portions of the Software.
//|
//| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//| OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//| MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//| IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//| CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//| TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//| SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//----------------------------------------------------------------------------//

#import "NSFormatter+MKNodeField.h"

//----------------------------------------------------------------------------//
@implementation NSFormatter (MKNodeField)

//|++++++++++++++++++++++++++++++++++++|//
+ (NSFormatter*)mk_decimalNumberFormatter
{
    static NSNumberFormatter *s_DecimalNumberFormatter= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_DecimalNumberFormatter = [NSNumberFormatter new];
        s_DecimalNumberFormatter.numberStyle = NSNumberFormatterNoStyle;
    });
    
    return s_DecimalNumberFormatter;
}

//|++++++++++++++++++++++++++++++++++++|//
+ (NSFormatter*)mk_hexFormatter
{
    return [MKHexNumberFormatter hexNumberFormatterWithDigits:SIZE_T_MAX];
}

//|++++++++++++++++++++++++++++++++++++|//
+ (NSFormatter*)mk_uppercaseHexFormatter
{
    return [MKHexNumberFormatter hexNumberFormatterWithDigits:SIZE_T_MAX uppercase:YES];
}

//|++++++++++++++++++++++++++++++++++++|//
+ (NSFormatter*)mk_hexCompactFormatter
{
    return [MKHexNumberFormatter hexNumberFormatterWithDigits:0];
}

//|++++++++++++++++++++++++++++++++++++|//
+ (NSFormatter*)mk_AddressFormatter
{
    return [self mk_hexFormatter];
}

//|++++++++++++++++++++++++++++++++++++|//
+ (NSFormatter*)mk_SizeFormatter
{
    return nil;
}

//|++++++++++++++++++++++++++++++++++++|//
+ (NSFormatter*)mk_OffsetFormatter
{
    return [self mk_hexFormatter];
}

@end