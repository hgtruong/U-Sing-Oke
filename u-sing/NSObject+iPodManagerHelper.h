//
//  NSObject+iPodManager.h
//  u-sing
//
//  Created by Huy Truong on 7/29/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MediaPlayer;
@import AVFoundation;
@interface iPodManagerHelper : NSObject 
- (void)exportAssetAsSourceFormat:(MPMediaItem *)item;
-(void)deleteMyFile:(NSString *)path;
@end
