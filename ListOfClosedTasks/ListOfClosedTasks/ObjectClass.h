//
//  ObjectClass.h
//  ListOfClosedTasks
//
//  Created by Александра Жиденко on 13.11.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLReader.h"



@interface ObjectClass : NSObject <NSURLSessionDelegate>

-(NSArray*)getArrayDicts:(NSDictionary*)dict;
-(NSString*)setSummary:(NSDictionary*)dictionary;
-(NSString*)modificationSummary:(NSString*)str;

@end

typedef void (^callback)(void);

@interface Task: NSObject

@property (nonatomic) NSString* type;
@property (nonatomic) NSInteger numberTask;
@property (nonatomic) NSString* summary;
@property (nonatomic) NSString* status;

@property (nonatomic) NSInteger parentNumber;
@property (nonatomic) NSString* typeClients;
@property (nonatomic) BOOL client;
@property (nonatomic, strong) callback block;

-(id)initWithDictionary:(NSDictionary*)dictionary;
-(OSStatus*)extractIdentityAndTrust:(CFDataRef)inP12data :(SecIdentityRef*) identity :(SecTrustRef*) trust;
@end
