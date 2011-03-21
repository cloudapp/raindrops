//
//  CLScreenshotsRaindrop.m
//  Screenshots
//
//  Created by Nick Paulson & Matthias Plappert on 1/28/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "CLScreenshotsRaindrop.h"
#import "CLRaindropHelperProtocol.h"


@implementation CLScreenshotsRaindrop

@synthesize helper = _helper;

- (id)initWithHelper:(id <CLRaindropHelperProtocol>)theHelper
{
	if ((self = [super init])) {
		self.helper = theHelper;
		
        // Setup query. Do not use KVO because it (for very odd reasons) retains the observer
		_metadataQuery = [[NSMetadataQuery alloc] init];
		[_metadataQuery setSearchScopes:[NSArray arrayWithObject:[self screenCaptureLocation]]];
		NSString *predicateFormat = @"(kMDItemIsScreenCapture = YES) && (kMDItemContentCreationDate > %@)";
		NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, [NSDate date]];
		[_metadataQuery setPredicate:predicate];
		[_metadataQuery setNotificationBatchingInterval:0.1f];
        [_metadataQuery setDelegate:self];
		[_metadataQuery startQuery]; 
	}
	return self;
}

#pragma mark -
#pragma mark KVO

- (id)metadataQuery:(NSMetadataQuery *)query replacementObjectForResultObject:(NSMetadataItem *)result
{   
    if (!result) {
        return result;
    }
    
    // Check dates (NSPredicate fails to do so)
    NSDate *modificationDate = [result valueForAttribute:@"kMDItemContentModificationDate"];
    NSDate *creationDate     = [result valueForAttribute:@"kMDItemContentCreationDate"];
    NSDate *lastUsedDate     = [result valueForAttribute:@"kMDItemLastUsedDate"];
    if (![creationDate isEqualToDate:modificationDate] || ![creationDate isEqualToDate:lastUsedDate]) {
        return result;
    }
    
    NSString *filename = [result valueForAttribute:@"kMDItemFSName"];
    if (filename != nil) {
        NSString *path = [[self screenCaptureLocation] stringByAppendingPathComponent:filename];
        if (path != nil && [[NSFileManager defaultManager] fileExistsAtPath:path]) {
            // Create pasteboard
            NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];
            
            NSPasteboardItem *item = [[NSPasteboardItem alloc] init];
            [item setString:[[NSURL fileURLWithPath:path] absoluteString] forType:(NSString *)kUTTypeFileURL];
            if ([pasteboard writeObjects:[NSArray arrayWithObject:item]]) {
                [self.helper handlePasteboardWithName:pasteboard.name];
            }
            [item release];
        }
    }
    
    return result;
}

#pragma mark -
#pragma mark Accessors

- (NSString *)screenCaptureLocation
{
	NSString *location = [[self screenCapturePrefs] objectForKey:@"location"];
	if (location) {
		location = [location stringByExpandingTildeInPath];
		if (![location hasSuffix:@"/"]) {
			location = [location stringByAppendingString:@"/"];
		}
		return location;
	}
	
	return [[@"~/Desktop" stringByExpandingTildeInPath] stringByAppendingString:@"/"];
}

- (NSDictionary *)screenCapturePrefs
{
	return [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.screencapture"];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	self.helper = nil;
	
	[_metadataQuery stopQuery];
	[_metadataQuery release];
	
	[super dealloc];
}

@end
