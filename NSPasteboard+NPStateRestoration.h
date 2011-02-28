//
//  NSPasteboard+NPStateRestoration.h
//  Firefox
//
//  Created by Nick Paulson on 2/27/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSPasteboard (NPStateRestoration)

- (void)savePasteboardState;
- (void)restorePasteboardState;

@end
