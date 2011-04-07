//
//  CLPhotoRaindrop.m
//  iPhoto
//
//  Created by Matthias Plappert on 20.02.11.
//  Copyright 2011 phaps. All rights reserved.
//

#import "CLPhotoRaindrop.h"


@implementation CLPhotoRaindrop

- (NSString *)pasteboardNameForTriggeredRaindrop
{
    iPhotoApplication *iPhoto = [SBApplication applicationWithBundleIdentifier:@"com.apple.iPhoto"];
	NSArray *selectedPhotos = [iPhoto selection];
    
	if (selectedPhotos == nil || [selectedPhotos count] == 0) {
		return nil;
    }
    
    NSMutableArray *items = [NSMutableArray array];
	for (iPhotoPhoto *photo in selectedPhotos) {
		if ([photo isKindOfClass:NSClassFromString(@"IPhotoPhoto")]) { // Hack to keep compiler happy
			NSPasteboardItem *item = [[NSPasteboardItem alloc] init];
			[item setString:[[NSURL fileURLWithPath:[photo imagePath]] absoluteString] forType:(NSString *)kUTTypeFileURL];
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
