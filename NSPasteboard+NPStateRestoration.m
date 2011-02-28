//
//  NSPasteboard+NPStateRestoration.m
//  Firefox
//
//  Created by Nick Paulson on 2/27/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "NSPasteboard+NPStateRestoration.h"

static NSMutableDictionary *restorationArrayByPasteboardValue = nil;

@implementation NSPasteboard (NPStateRestoration)

- (void)savePasteboardState {
    if (restorationArrayByPasteboardValue == nil)
        restorationArrayByPasteboardValue = [[NSMutableDictionary alloc] init];
    
    NSValue *selfValue = [NSValue valueWithNonretainedObject:self];
    NSArray *restoreArray = [restorationArrayByPasteboardValue objectForKey:selfValue];
    if (restoreArray == nil)
        restoreArray = [NSArray array];
    
    NSMutableDictionary *pbDict = [NSMutableDictionary dictionary];

	for (NSString *currType in [self types]) {
		NSData *currData = [self dataForType:currType];
		if (currData != nil)
			[pbDict setObject:currData forKey:currType];
	}
    
    [restorationArrayByPasteboardValue setObject:[restoreArray arrayByAddingObject:pbDict] forKey:selfValue];
}

- (void)restorePasteboardState {
    NSValue *selfValue = [NSValue valueWithNonretainedObject:self];
    NSArray *restoreArray = [restorationArrayByPasteboardValue objectForKey:selfValue];
    if ([restoreArray count] > 0) {
        [self clearContents];
        
        NSDictionary *pbDict = [restoreArray lastObject];
        [self declareTypes:[pbDict allKeys] owner:self];
        for (NSString *currType in [pbDict allKeys]) {
            [self setData:[pbDict objectForKey:currType] forType:currType];
        }
        
        NSMutableArray *newRestoreArray = [restoreArray mutableCopy];
        [newRestoreArray removeObject:pbDict];
        [restorationArrayByPasteboardValue setObject:[NSArray arrayWithArray:newRestoreArray] forKey:selfValue];
        [newRestoreArray release];
    }
}

@end
