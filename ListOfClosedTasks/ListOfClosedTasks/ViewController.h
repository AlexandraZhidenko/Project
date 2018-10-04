//
//  ViewController.h
//  ListOfClosedTasks
//
//  Created by Александра Жиденко on 20.07.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSData+Encryption.h"
#import "XMLReader.h"
#import "OutputTextView.h"

@interface ViewController : NSViewController <NSWindowDelegate, NSTextViewDelegate>

@property (nonatomic) NSDictionary* parsedXml;
@property (nonatomic) NSOpenPanel* openPanel;

@property (nonatomic) NSMutableDictionary* list;
@property (nonatomic) NSArray* arrayTasks;

@property (nonatomic) NSMutableArray* arrayClosedTasks;
@property (nonatomic) NSMutableArray* arrayClosedTasks_Test;
@property (nonatomic) NSMutableArray* arrayClosedTasks_Bank;

@property (nonatomic) NSArray* fileTypes;
@property (nonatomic) NSArray* arrWithCustomFields;

@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;
- (IBAction)btnOpenFile:(id)sender;

- (BOOL)typeTask:(NSString*)typeStr;
-(void)printfInf:(NSDictionary*)dict :(NSTextView*)textView;
-(NSString*)modificationSummary:(NSString*)str;
-(NSString*)setSummary:(NSDictionary*)dictionary;

@end

