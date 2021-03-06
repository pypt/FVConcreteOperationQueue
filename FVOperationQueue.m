//
//  FVOperationQueue.m
//  FileViewTest
//
//  Created by Adam Maxwell on 09/21/07.
/*
 This software is Copyright (c) 2007-2010
 Adam Maxwell. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 - Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in
 the documentation and/or other materials provided with the
 distribution.
 
 - Neither the name of Adam Maxwell nor the names of any
 contributors may be used to endorse or promote products derived
 from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

// Uses private APIs
#ifndef MAC_APP_STORE_BUILD

#import "FVOperationQueue.h"
#import "FVConcreteOperationQueue.h"
#import "FVMainThreadOperationQueue.h"
#import "FVMainThreadOperationDispatchQueue.h"

// C99 math; handles types transparently
#import <tgmath.h>

@implementation FVOperationQueue

static id _mainThreadQueue = nil;
static FVOperationQueue *defaultPlaceholderQueue = nil;
static Class FVOperationQueueClass = Nil;

+ (FVOperationQueue *)mainQueue
{
    return _mainThreadQueue;
}

+ (void)initialize
{
    FVINITIALIZE(FVOperationQueue);  
    FVOperationQueueClass = self;
    defaultPlaceholderQueue = (FVOperationQueue *)NSAllocateObject(FVOperationQueueClass, 0, [self zone]);
#if USE_DISPATCH_QUEUE
    _mainThreadQueue = [FVMainThreadOperationDispatchQueue new];
#else
    _mainThreadQueue = [FVMainThreadOperationQueue new];
#endif
}

+ (id)allocWithZone:(NSZone *)aZone
{
    return FVOperationQueueClass == self ? defaultPlaceholderQueue : NSAllocateObject(self, 0, aZone);
}

// ensure that alloc always calls through to allocWithZone:
+ (id)alloc
{
    return [self allocWithZone:NULL];
}

- (id)init
{
    return ([self class] == FVOperationQueueClass) ? [[FVConcreteOperationQueue allocWithZone:[self zone]] init] : [super init];
}

- (void)dealloc
{
    if ([self class] != FVOperationQueueClass)
        [super dealloc];
}

- (void)subclassResponsibility:(SEL)selector
{
    [NSException raise:@"FVAbstractClassException" format:@"Abstract class %@ does not implement %@", [self class], NSStringFromSelector(selector)];
}

- (void)cancel;
{
    [self subclassResponsibility:_cmd];
}

- (void)setThreadPriority:(double)p;
{
    [self subclassResponsibility:_cmd];
}

- (void)addOperation:(FVOperation *)operation;
{
    [self subclassResponsibility:_cmd];
}
    
- (void)addOperations:(NSArray *)operations;
{
    [self subclassResponsibility:_cmd];
}

- (void)finishedOperation:(FVOperation *)anOperation;
{
    [self subclassResponsibility:_cmd];
}

- (void)terminate
{
    [self subclassResponsibility:_cmd];
}

// Compatibility method, does nothing
- (void)setMaxConcurrentOperationCount:(uint)count {
	// noop
}

@end

#endif	// 'MAC_APP_STORE_BUILD'
