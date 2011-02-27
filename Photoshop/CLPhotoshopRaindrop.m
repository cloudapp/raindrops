//
//  CLPhotoshopRaindrop.m
//  Photoshop
//
//  Created by Nick Paulson on 1/28/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "CLPhotoshopRaindrop.h"
#import "Photoshop.h"

#define kTempFileLocation [NSTemporaryDirectory() stringByAppendingPathComponent:@"CloudPSTemp.png"]

@implementation CLPhotoshopRaindrop

- (NSString *)pasteboardNameForTriggeredRaindrop {
	PhotoshopApplication *adobePhotoshop = [SBApplication applicationWithBundleIdentifier:@"com.adobe.Photoshop"];
	SBElementArray *docs = [adobePhotoshop documents];
    NSLog(@"Docs = %@", docs);
	if (docs == nil || [docs count] == 0)
		return nil;
	
	PhotoshopDocument *currDoc = [adobePhotoshop currentDocument];	
	PhotoshopDocument *temp = [currDoc saveIn:[NSURL URLWithString:kTempFileLocation] as:PhotoshopSvFmPNG copying:YES appending:PhotoshopE300LowercaseExtension withOptions:nil];
    NSLog(@"Temp = %@", temp);
	if (temp == nil)
		return nil;
	
	NSString *name = [currDoc name];
	name = [name stringByDeletingPathExtension];
	if (name == nil || [name length] == 0)
		name = @"Photoshop Document";
	
	name = [name stringByAppendingString:@".png"];
	NSLog(@"name = %@", name);
	NSData *imageData = [NSData dataWithContentsOfFile:kTempFileLocation];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:kTempFileLocation]) //Sanity check
		[[NSFileManager defaultManager] removeItemAtPath:kTempFileLocation error:nil];
	NSLog(@"Image data = %lu", [imageData length]);
	if (imageData == nil)
		return nil;
	
	NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];
	NSPasteboardItem *item = [[[NSPasteboardItem alloc] init] autorelease];
	[item setData:imageData forType:(NSString *)kUTTypePNG];
	[item setString:name forType:@"public.url-name"];
	[pasteboard writeObjects:[NSArray arrayWithObject:item]];
    NSLog(@"Returning %@", [pasteboard name]);
	return [pasteboard name];
}

@end
