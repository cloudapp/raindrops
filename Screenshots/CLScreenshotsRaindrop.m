//
//  CLScreenshotsRaindrop.m
//  Screenshots
//
//  Created by Nick Paulson on 1/28/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "CLScreenshotsRaindrop.h"
#import "CLRaindropHelperProtocol.h"

@interface CLScreenshotsRaindrop ()
@property (nonatomic, readwrite, copy) NSMutableSet *currentFileSet;
@end

@implementation CLScreenshotsRaindrop
@synthesize helper = _helper, currentFileSet = _currentFileSet;

- (id)initWithHelper:(id <CLRaindropHelperProtocol>)theHelper {
	if ((self = [super init])) {
		self.helper = theHelper;
		NSString *filePath = [[self class] screenCaptureLocation];
		int fd = open([filePath UTF8String], O_EVTONLY);
		if (fd == -1) {
			[self release];
			return nil;
		}
		// Cleanup block
		void(^cleanup)() = ^{
			close(fd);
		};
		
		// Create source
		_watcherSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
												fd, (DISPATCH_VNODE_WRITE), 
												dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
		if (!_watcherSource) {
			cleanup();
			[self release];
			return nil;
		}
		NSString *regexString = [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:@"CLScreenshotRegex"];
		self.currentFileSet = [NSMutableSet setWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil]];
		
		// Dispatch source handler
		dispatch_source_set_event_handler(_watcherSource, ^{
			NSError *error = nil;
			NSArray *currFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:&error];
			if (currFiles != nil && error == nil) {
				NSMutableSet *newSet = [NSMutableSet setWithArray:currFiles];
				if ([newSet count] >= [self.currentFileSet count]) {
					[newSet minusSet:self.currentFileSet];
					NSMutableArray *pbItems = [NSMutableArray array];
					for (NSString *newFile in newSet) {
						if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString] evaluateWithObject:newFile]) {
							NSPasteboardItem *item = [[NSPasteboardItem alloc] init];
							[item setString:[[NSURL fileURLWithPath:[filePath stringByAppendingPathComponent:newFile]] absoluteString] forType:(NSString *)kUTTypeFileURL];
							[pbItems addObject:item];
							[item release];
						}
					}
					if ([pbItems count] > 0) {
						NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];
						if ([pasteboard writeObjects:pbItems])
							[self.helper handlePasteboardWithName:pasteboard.name];
					}
				}
				self.currentFileSet = [NSMutableSet setWithArray:currFiles];
			}
		});
		
		dispatch_source_set_cancel_handler(_watcherSource, ^{ cleanup(); });
		
		dispatch_resume(_watcherSource);
	}
	return self;
}

- (void)dealloc {
	self.helper = nil;
	self.currentFileSet = nil;
	[super dealloc];
}

+ (NSString *)screenCaptureLocation {
	NSString *location = [[self screenCapturePrefs] objectForKey:@"location"];
	if (location) {
		location = [location stringByExpandingTildeInPath];
		if (![location hasSuffix:@"/"])
			location = [location stringByAppendingString:@"/"];
		return location;
	}
	return [[@"~/Desktop" stringByExpandingTildeInPath] stringByAppendingString:@"/"];
}

+ (NSString *)screenCaptureType {
	NSString *type = [[self screenCapturePrefs] objectForKey:@"type"];
	if (type)
		return type;
	return @"png";
}

+ (NSDictionary *)screenCapturePrefs {
	return [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.screencapture"];
}

@end
