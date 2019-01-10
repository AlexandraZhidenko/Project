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
#import "ObjectClass.h"
#import "FDKeychain.h"

@interface ViewController : NSViewController <NSWindowDelegate, NSTextViewDelegate, NSTextFieldDelegate, NSURLSessionDelegate, NSURLAuthenticationChallengeSender>

@property (nonatomic) NSDictionary* parsedXml;
@property (nonatomic) NSOpenPanel* openPanel;

@property (nonatomic) NSMutableDictionary* list;
@property (nonatomic) NSArray* arrayTasks;
@property (nonatomic) NSMutableArray <Task*> *tasks;

@property (nonatomic) NSMutableArray* arrayClosedTasks;
@property (nonatomic) NSMutableArray* arrayClosedTasks_Test;
@property (nonatomic) NSMutableArray* arrayClosedTasks_Bank;

@property (nonatomic) NSArray* fileTypes;

@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;
- (IBAction)btnOpenFile:(id)sender;

@property (weak,nonatomic) IBOutlet NSTextField * inputVersionTextField;
- (IBAction)btnGetXML:(id)sender;
-(NSArray*)getArrayDicts:(NSDictionary*)dict;
-(void)reloadView:(NSTextView*)textView;

-(void)printfInf:(NSTextView*)textView;
-(void)getInf:(Task*)task;

-(OSStatus*)extractIdentityAndTrust:(CFDataRef)inP12data :(SecIdentityRef*) identity :(SecTrustRef*) trust;
//@property (nonatomic) NSData *dataP12;
@property (nonatomic, retain) NSString* password;
//@property (nonatomic) NSDictionary *dict;

-(void)addCert;
-(void)deleteCert;
@end

