//
//  OutputTextView.h
//  ListOfClosedTasks
//
//  Created by Александра Жиденко on 28.08.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewController.h"

@interface OutputTextView : NSTextView <NSDraggingSource, NSDraggingDestination>

@property (nonatomic) NSDictionary* xml;
@property (nonatomic) BOOL highlight;
@property (nonatomic) NSArray* fileTypesTextView;

- (id)initWithCoder:(NSCoder *)aDecoder;
@end
