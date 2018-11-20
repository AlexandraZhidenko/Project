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
#import "JMMaskTextField.h"
#import "ObjectClass.h"

@interface ViewController : NSViewController <NSWindowDelegate, NSTextViewDelegate, NSTextFieldDelegate, NSURLSessionDelegate, NSURLAuthenticationChallengeSender>

@property (nonatomic) NSDictionary* parsedXml;
@property (nonatomic) NSOpenPanel* openPanel;

@property (nonatomic) NSMutableDictionary* list;
@property (nonatomic) NSArray* arrayTasks;

@property (nonatomic) NSMutableArray* arrayClosedTasks;
@property (nonatomic) NSMutableArray* arrayClosedTasks_Test;
@property (nonatomic) NSMutableArray* arrayClosedTasks_Bank;

@property (nonatomic) NSArray* fileTypes;

@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;
- (IBAction)btnOpenFile:(id)sender;

@property (weak,nonatomic) IBOutlet NSTextField * inputVersionTextField;
//@property (weak) IBOutlet JMMaskTextField *testTextField;
- (IBAction)btnGetXML:(id)sender;


-(void)printfInf:(NSTextView*)textView;
-(void)getInf:(Task*)task;
-(OSStatus*)extractIdentityAndTrust:(CFDataRef)inP12data :(SecIdentityRef*) identity :(SecTrustRef*) trust;
-(NSDictionary*)getXML:(NSString*)urlStr;
@end

