//
//  JMMaskTextField.h
//  JMMaskTextField
//
//  Created by Jota Melo on 02/01/17.
//  Copyright © 2017 Jota. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JMStringMask.h"

IB_DESIGNABLE
@interface JMMaskTextField : NSTextField

@property (strong, nonatomic) IBInspectable NSString *maskString;
@property (strong, nonatomic, readonly) JMStringMask *mask;
@property (readonly, nonatomic) NSString *unmaskedText;

@end
