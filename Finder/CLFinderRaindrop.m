//
//  CLFinderRaindrop.m
//  Finder
//
//  Created by Nick Paulson on 2/10/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "CLFinderRaindrop.h"
#import "Finder.h"

@implementation CLFinderRaindrop

- (NSString *)pasteboardNameForTriggeredRaindrop {
    FinderApplication *finder = [SBApplication applicationWithBundleIdentifier:@"com.apple.finder"];
	NSArray *selectedItems = [[finder selection] get];
	
	if (selectedItems == nil || [selectedItems count] == 0)
		return nil;
	
	NSMutableArray *pbItems = [NSMutableArray array];
	for (FinderItem *curr in selectedItems) {
		if (![curr respondsToSelector:@selector(URL)])
			return nil;
		NSURL *theURL = [NSURL URLWithString:[curr URL]];
        NSPasteboardItem *item = [[[NSPasteboardItem alloc] init] autorelease];
        [item setString:[theURL absoluteString] forType:(NSString *)kUTTypeFileURL];
		[pbItems addObject:item];
	}
    
    if ([pbItems count] == 0)
        return nil;
    
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];
	[pasteboard writeObjects:pbItems];
    return pasteboard.name;
}

@end
