//
//  CLTunesRaindrop.m
//  iTunes
//
//  Created by Matthias Plappert on 20.02.11.
//  Copyright 2011 phaps. All rights reserved.
//

#import "CLTunesRaindrop.h"


@implementation CLTunesRaindrop

- (NSString *)pasteboardNameForTriggeredRaindrop
{
    iTunesApplication *itunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	NSArray *selectedTracks = [[itunes selection] get];
	
	if (selectedTracks == nil || [selectedTracks count] == 0) {
		return nil;
	}
	
	NSMutableArray *items = [NSMutableArray array];
	for (iTunesFileTrack *track in selectedTracks) {
		if ([track respondsToSelector:@selector(location)]) {
			NSPasteboardItem *item = [[NSPasteboardItem alloc] init];
			[item setString:[[track location] absoluteString] forType:(NSString *)kUTTypeFileURL];
			[items addObject:item];
			[item release];
		}
	}
    
    if ([items count] == 0) {
        return nil;
	}
    
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];
	[pasteboard writeObjects:items];
    return pasteboard.name;
}

@end
