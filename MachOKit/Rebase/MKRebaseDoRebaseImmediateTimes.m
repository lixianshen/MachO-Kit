//----------------------------------------------------------------------------//
//|
//|             MachOKit - A Lightweight Mach-O Parsing Library
//|             MKRebaseDoRebaseImmediateTimes.m
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

#import "MKRebaseDoRebaseImmediateTimes.h"
#import "MKInternal.h"
#import "MKDataModel.h"
#import "MKMachO.h"
#import "MKRebaseInfo.h"

//----------------------------------------------------------------------------//
@implementation MKRebaseDoRebaseImmediateTimes

//|++++++++++++++++++++++++++++++++++++|//
+ (uint8_t)opcode
{ return REBASE_OPCODE_DO_REBASE_IMM_TIMES; }

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark - Performing Rebasing
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
- (BOOL)rebase:(void (^)(void))rebase type:(uint8_t*)type segment:(unsigned*)segment offset:(mk_vm_offset_t*)offset error:(NSError**)error
{
#pragma unused(type)
#pragma unused(segment)
    for (uint8_t i = 0; i < self.count; i++) {
        rebase();
        
        mk_error_t err;
        if ((err = mk_vm_offset_add(*offset, self.offset, offset))) {
            MK_ERROR_OUT = MK_MAKE_VM_OFFSET_ADD_ARITHMETIC_ERROR(err, *offset, self.offset);
            return NO;
        }
    }
    
    return YES;
}

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark - Values
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
- (uint8_t)count
{ return _data & REBASE_IMMEDIATE_MASK; }

//|++++++++++++++++++++++++++++++++++++|//
- (uint64_t)offset
{ return self.dataModel.pointerSize; }

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark - MKNode
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
- (mk_vm_size_t)nodeSize
{ return 1; }

//|++++++++++++++++++++++++++++++++++++|//
- (MKNodeDescription*)layout
{
    MKNodeFieldBuilder *count = [MKNodeFieldBuilder
        builderWithProperty:MK_PROPERTY(count)
        type:MKNodeFieldTypeUnsignedByte.sharedInstance
    ];
    count.description = @"Rebase Count";
    count.options = MKNodeFieldOptionDisplayAsDetail;
    
    MKNodeFieldBuilder *offset = [MKNodeFieldBuilder
        builderWithProperty:MK_PROPERTY(offset)
        type:MKNodeFieldTypeUnsignedQuadWord.sharedInstance
    ];
    offset.description = @"Offset";
    offset.options = MKNodeFieldOptionDisplayAsDetail;
    
    return [MKNodeDescription nodeDescriptionWithParentDescription:super.layout fields:@[
        count.build,
        offset.build
    ]];
}

//|++++++++++++++++++++++++++++++++++++|//
- (NSString*)description
{ return [NSString stringWithFormat:@"REBASE_OPCODE_DO_REBASE_IMM_TIMES(%" PRIu8 ")", self.count]; }

@end
