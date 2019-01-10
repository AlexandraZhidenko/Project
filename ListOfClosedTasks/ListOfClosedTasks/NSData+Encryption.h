//
//  NSData+Encryption.h
//  TWIB
//
//  Created by Aleksandr Vorozhischev on 18.04.17.
//  Copyright © 2017 Unreal Mojo. All rights reserved.
//
//#import <UIKit/UIKit.h>
#import <Cocoa/Cocoa.h>

@interface NSData (Encryption) <NSURLSessionDelegate>
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
