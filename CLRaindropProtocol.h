//
//  CLRaindropProtocol.h
//  CloudRaindropHelper
//
//  Created by Nick Paulson on 1/28/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLRaindropHelperProtocol;
@protocol CLRaindropProtocol <NSObject>
@optional
- (id)initWithHelper:(id <CLRaindropHelperProtocol>)helper;
- (NSString *)pasteboardNameForTriggeredRaindrop;
@end
