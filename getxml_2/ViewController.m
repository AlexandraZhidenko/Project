//
//  ViewController.m
//  getxml_2
//
//  Created by Александра Жиденко on 23.04.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSData* decrypt;
    
    /*NSURL *url = [NSURL URLWithString:@"https://blog.tatarinovms.ru/vdr.uu"];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
//    defaultConfigObject.TLSMinimumSupportedProtocol = kSSLProtocol3;
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            
                                                            NSData* decrypt;
                                                            //NSLog(@"data = %@", data);
                                                            
                                                            decrypt = [[NSData alloc] initWithData:[data AES256DecryptWithKey:@"dpq%^12-ppp"]];
                                                            //NSLog(@"data = %@", decrypt);
                                                            
                                                            NSString * text = [[NSString alloc] initWithData:decrypt encoding:NSUTF8StringEncoding];
                                                            NSError *error = nil;
                                                            self.parsedXml = [XMLReader dictionaryForXMLString:text error:&error];
                                                            //NSLog(@"data = %@", self.parsedXml);
                                                            
                                                        }
                                                    }];
    [dataTask resume];*/
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
