//
//  ViewController.h
//  getxml_2
//
//  Created by Александра Жиденко on 23.04.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSData+Encryption.h"
#import "XMLReader.h"

@interface ViewController : UIViewController <NSURLSessionDelegate>
@property (nonatomic) NSDictionary *parsedXml;

@end

