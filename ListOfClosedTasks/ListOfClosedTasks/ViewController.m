//
//  ViewController.m
//  ListOfClosedTasks
//
//  Created by Александра Жиденко on 20.07.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

NSString* certPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fileTypes = [NSArray arrayWithObjects:@"xml",nil];
    
    self.outputTextView.delegate = self;
    
    NSMenuItem *itemCert = [[NSMenuItem alloc]initWithTitle:@"itemCert" action:nil keyEquivalent:@""];
    NSMenu* cert = [[NSMenu alloc] initWithTitle:@"Cert"];
    
    [[NSApp mainMenu] addItem:itemCert];
    [[NSApp mainMenu] setSubmenu:cert forItem:itemCert];
    
    NSMenuItem* addCert = [[NSMenuItem alloc] initWithTitle:@"Add" action:@selector(addCert) keyEquivalent:@""];
    [cert addItem:addCert];
    NSMenuItem* deleteCert = [[NSMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteCert) keyEquivalent:@""];
    [cert addItem:deleteCert];
    
    self.keychain = [[AHKeychain alloc] init];
    certPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"p12"];
    
    self.arrayWithVersions = [[NSMutableArray alloc] init];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"versions" ofType:@"rtf"];
    self.arrayWithVersions = [[NSArray alloc] initWithContentsOfFile:filePath];
    if(self.arrayWithVersions == NULL)
    {
        NSURL* url = [NSURL URLWithString:@"https://jira.compassplus.ru/rest/projects/1.0/project/TM/release/allversions?_=1548923969475"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          //NSString * text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          //NSLog(@"text - %@", text);
                                          if (data == nil)
                                              NSLog(@"data == nil");
                                          else
                                          {
                                              NSError *error = nil;
                                              id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                              
                                              if(error)
                                                  NSLog(@"error - %@", error);
                                              else
                                              {
                                                  //NSLog(@"object - %@", object);
                                                  NSArray* array = object;
                                                  self.arrayWithVersions = [[NSMutableArray alloc] init];
                                                  
                                                  for(int i = 0; i < array.count; i++)
                                                  {
                                                      NSDictionary* dict = [[NSDictionary alloc] initWithDictionary:[array objectAtIndex:i]];
                                                      //NSLog(@"name - %@", [dict objectForKey:@"name"]);
                                                      
                                                      [self.arrayWithVersions addObject:[dict objectForKey:@"name"]];
                                                  }
                                                  //NSLog(@"arr - %@", self.versions);
                                                  
                                                  self.fileWithVersionsPath = [[NSBundle mainBundle] pathForResource:@"versions" ofType:@"rtf"];
                                                  [[NSFileManager defaultManager] createFileAtPath:self.fileWithVersionsPath contents:nil attributes:nil];
                                                  [self.arrayWithVersions writeToFile:self.fileWithVersionsPath atomically:YES];
                                              }
                                          }
                                      }];
        [task resume];
    }
    
    NSMenu* menu = [[NSMenu alloc] init];
    for(int i=0; i < self.arrayWithVersions.count; i++)
    {
        NSMenuItem* tmp = [[NSMenuItem alloc] initWithTitle:[self.arrayWithVersions objectAtIndex:i] action:@selector(btnGetXML) keyEquivalent:@""];
        [menu addItem:tmp];
    }
    [self.versions setMenu:menu];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

- (IBAction)btnOpenFile:(id)sender
{
    self.openPanel = [NSOpenPanel openPanel];
    self.openPanel.title = @"Choose a .xml file";
    self.openPanel.showsResizeIndicator = YES;
    self.openPanel.canCreateDirectories = YES;
    self.openPanel.allowsMultipleSelection = NO;
    [self.openPanel setAllowedFileTypes:self.fileTypes];
    
    [self.openPanel beginSheetModalForWindow:self.openPanel.parentWindow completionHandler:^(NSInteger result){
        if (result == NSModalResponseOK)
        {
            NSURL *selection = self.openPanel.URLs[0];
            NSString* path = [[selection path] stringByResolvingSymlinksInPath];
            
            NSString* str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSError *error = nil;
            self.parsedXml = [XMLReader dictionaryForXMLString:str error:&error];
            
            self.arrayClosedTasks = [[NSMutableArray alloc] initWithCapacity:0];
            self.arrayClosedTasks_Bank = [NSMutableArray arrayWithCapacity:0];
            self.arrayClosedTasks_Test = [NSMutableArray arrayWithCapacity:0];
            
            self.arrayTasks = [self getArrayDicts:self.parsedXml];
            self.tasks = [NSMutableArray arrayWithCapacity:0];
            for(int i = 0; i < self.arrayTasks.count; i++)
            {
                Task *task = [[Task alloc] initWithDictionary:self.arrayTasks[i]];
                
                task.block = ^{
                    [self reloadView:self.outputTextView];
                    
                };
                [self.tasks addObject:task];
            }
            [self reloadView:self.outputTextView];
        }
    }];
}

- (void)btnGetXML
{
    
    NSMutableString *tmp = [self.versions itemTitleAtIndex:self.versions.indexOfSelectedItem];
    tmp = [tmp stringByReplacingOccurrencesOfString:@"PB " withString:@""];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", @"https://jira.compassplus.ru/sr/jira.issueviews:searchrequest-xml/temp/SearchRequest.xml?jqlQuery=project+%3D+TM+AND+fixVersion+%3D+%22PB+", tmp, @"%22&tempMax=1000"];
    
    self.outputTextView.string = @"";
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                                        if(error == nil)
                                                        {
                                                            NSString * text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                            
                                                            self.parsedXml = [XMLReader dictionaryForXMLString:text error:&error];
                                                            //NSLog(@"parsed - %@", self.parsedXml);
                                                            
                                                            self.arrayClosedTasks = [[NSMutableArray alloc] initWithCapacity:0];
                                                            self.arrayClosedTasks_Bank = [NSMutableArray arrayWithCapacity:0];
                                                            self.arrayClosedTasks_Test = [NSMutableArray arrayWithCapacity:0];
                                                            
                                                            self.arrayTasks = [self getArrayDicts:self.parsedXml];
                                                            self.tasks = [NSMutableArray arrayWithCapacity:0];
                                                            
                                                            for(int i = 0; i < self.arrayTasks.count; i++)
                                                            {
                                                                Task *task = [[Task alloc] initWithDictionary:self.arrayTasks[i]];
                                                                task.password = self.password;
                                                                
                                                                task.block = ^{
                                                                    [self reloadView:self.outputTextView];
                                                                    
                                                                };
                                                                
                                                                [self.tasks addObject:task];
                                                                
                                                            }
                                                            [self reloadView:self.outputTextView];
                                                        }
                                                        
                                                    }];
    [dataTask resume];
}

-(void)reloadView:(NSTextView*)textView
{
    for (Task *task in self.tasks)
        [self getInf:task];
    
    [self printfInf:textView];
}

-(NSArray*)getArrayDicts:(NSDictionary*)dict
{
    NSArray* array = [[NSArray alloc] init];
    array = [[[dict valueForKey:@"rss"] valueForKey:@"channel"] valueForKey:@"item"];
    if([array isKindOfClass:[NSDictionary class]])
    {
        array = [NSArray arrayWithObject:array];
    }
    
    return array;
}

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSError* error = nil;
    AHKeychainItem *item = [[AHKeychainItem alloc] init];
    item.service = @"service";
    item.account = @"myusername";
    [self.keychain getItem:item error:&error];
    //NSLog(@"getItem - %d", [self.keychain getItem:item error:&error]);
    self.password = item.password;
    
    NSString* tmpFilePath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"p12"];
    NSData* cert = [[NSData alloc] initWithContentsOfFile:tmpFilePath];
    CFDataRef inP12data = (__bridge CFDataRef)cert;
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    
    [self extractIdentityAndTrust:inP12data :&myIdentity :&myTrust];
    
    SecCertificateRef myCertificate;
    SecIdentityCopyCertificate(myIdentity, &myCertificate);
    const void *certs[] = { myCertificate };
    CFArrayRef certsArray = CFArrayCreate(NULL, certs, 1, NULL);
    
    NSURLCredential *credential = [NSURLCredential credentialWithIdentity:myIdentity certificates:(__bridge NSArray*)certsArray persistence:NSURLCredentialPersistencePermanent];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

-(OSStatus*)extractIdentityAndTrust:(CFDataRef)inP12data :(SecIdentityRef*)identity :(SecTrustRef*)trust
{
    
    // Import .p12 data
    CFStringRef password = (__bridge CFStringRef)(self.password);
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL); // options = {passphrase = password;}
    
    CFArrayRef keyref = NULL;
    
    OSStatus sanityChesk = SecPKCS12Import(inP12data, options, &keyref);
    
    if(sanityChesk == errSecSuccess)
    {
        //NSLog(@"Success opening p12 certificate.");
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(keyref, 0);
        const void *tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *trust = (SecTrustRef)tempTrust;
    }
    else
        NSLog(@"err %d", sanityChesk);
    
    return sanityChesk;
}

-(void)getInf:(Task*)task
{
    
    if([task.status isEqualToString:@"Closed"] || [task.status isEqualToString:@"Resolved"])//&& [[[self.arrayTasks[index] valueForKey:@"key"] valueForKey:@"text"] isEqualToString:@"TM-1234"]
    {
        NSColor* textColor;
        textColor = [NSColor blackColor];
        self.list = [NSMutableDictionary dictionaryWithCapacity:0];
        
        //set summary
        [self.list setObject:task.summary forKey:@"summary"];
        
        //set number task
        [self.list setObject:[NSNumber numberWithInteger:task.numberTask] forKey:@"numberTask"];
        
        //set type task
        if(![task.type isEqualToString:@"SubTask"])
        {
            [self.list setObject:task.type forKey:@"typeTask"];
            
            // set task color
            [self.list setObject:textColor forKey:@"colorTask"];
        }
        else
        {
            NSInteger parentNumber = task.parentNumber;
            for(int j = 0; j < self.arrayTasks.count; j++)
            {
                NSInteger number = task.numberTask;
                
                if(number == parentNumber)
                {
                    Task* parentTask = [[Task alloc] initWithDictionary:self.arrayTasks[j]];
                    //[self typeTask:parentTask.type];
                    [self.list setObject:parentTask.type forKey:@"typeTask"];
                    break;
                }
            }
            if([self.list objectForKey:@"typeTask"] == NULL)
            {
                NSLog(@"2-TM- %ld", (long)task.numberTask);
                [self.list setObject:task.type forKey:@"typeTask"];
                
                if([self.list objectForKey:@"typeTask"] == NULL)
                {
                    [self.list setObject:@"No type" forKey:@"typeTask"];
                }
                
                // set task color
                [self.list setObject:textColor forKey:@"colorTask"];
            }
            else
            {
                [self.list setObject:@"No type" forKey:@"typeTask"];
                textColor = [NSColor redColor];
            }
            
        }
        
        // sorting by groups
        BOOL add = false;
        if(task.client == true)
        {
            if([task.typeClients isEqualToString:@"TEST"])
            {
                for (int i = 0; i < self.arrayClosedTasks_Test.count; i++)
                {
                    if ([[self.arrayClosedTasks_Test[i] objectForKey:@"numberTask"] integerValue] == task.numberTask)
                    {
                        [self.arrayClosedTasks_Test[i] setObject:task.type forKey:@"typeTask"];
                        add = true;
                        break;
                    }
                }
                if (add == false)
                {
                    [self.arrayClosedTasks_Test addObject:self.list];
                }
            }
            else
            {
                [self.list setObject:task.typeClients forKey:@"bankName"];
                
                for (int i = 0; i < self.arrayClosedTasks_Bank.count; i++)
                {
                    if ([[self.arrayClosedTasks_Bank[i] objectForKey:@"numberTask"] integerValue] == task.numberTask)
                    {
                        [self.arrayClosedTasks_Bank[i] setObject:task.type forKey:@"typeTask"];
                        add = true;
                        break;
                    }
                }
                if (add == false)
                {
                    [self.arrayClosedTasks_Bank addObject:self.list];
                }
            }
        }
        else if(task.client == false)
        {
            for (int i = 0; i < self.arrayClosedTasks.count; i++)
            {
                if ([[self.arrayClosedTasks[i] objectForKey:@"numberTask"] integerValue] == task.numberTask)
                {
                    [self.arrayClosedTasks[i] setObject:task.type forKey:@"typeTask"];
                    add = true;
                    break;
                }
            }
            if (add == false)
            {
                [self.arrayClosedTasks addObject:self.list];
            }
        }
    }
}

-(void)printfInf:(NSTextView*)textView // output information about tasks
{
    textView.string = @"";
    
    // Output inf
    NSDictionary* attributes = [NSDictionary dictionaryWithObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
    NSAttributedString* attr = [[NSAttributedString alloc] initWithString:@"TEST\n" attributes:attributes];
    [[textView textStorage] appendAttributedString:attr];
    for(int i = 0; i < self.arrayClosedTasks_Test.count; i++)
    {
        
        NSString* tmp = [[NSString alloc] initWithFormat:@"[%@](TM-%@) %@\n\n", [self.arrayClosedTasks_Test[i] valueForKey:@"typeTask"], [self.arrayClosedTasks_Test[i] valueForKey:@"numberTask"], [self.arrayClosedTasks_Test[i] valueForKey:@"summary"]];
        NSDictionary* attributes = [NSDictionary dictionaryWithObject:[self.arrayClosedTasks_Test[i] valueForKey:@"colorTask"] forKey:NSForegroundColorAttributeName];
        attr = [[NSAttributedString alloc] initWithString:tmp attributes:attributes];
        
        [[textView textStorage] appendAttributedString:attr];
    }
    
    attr = [[NSAttributedString alloc] initWithString:@"BANKS\n" attributes:attributes];
    [[textView textStorage] appendAttributedString:attr];
    for(int i = 0; i < self.arrayClosedTasks_Bank.count; i++)
    {
        NSString* tmp = [[NSString alloc] initWithFormat:@"[%@](TM-%@) %@. %@\n\n", [self.arrayClosedTasks_Bank[i] valueForKey:@"typeTask"], [self.arrayClosedTasks_Bank[i] valueForKey:@"numberTask"], [self.arrayClosedTasks_Bank[i] valueForKey:@"bankName"], [self.arrayClosedTasks_Bank[i] valueForKey:@"summary"]];
        NSDictionary* attributes = [NSDictionary dictionaryWithObject:[self.arrayClosedTasks_Bank[i] valueForKey:@"colorTask"] forKey:NSForegroundColorAttributeName];
        attr = [[NSAttributedString alloc] initWithString:tmp attributes:attributes];
        
        [[textView textStorage] appendAttributedString:attr];
    }
    
    attr = [[NSAttributedString alloc] initWithString:@"OTHERS\n" attributes:attributes];
    [[textView textStorage] appendAttributedString:attr];
    for(int i = 0; i < self.arrayClosedTasks.count; i++)
    {
        NSString* tmp = [[NSString alloc] initWithFormat:@"[%@](TM-%@) %@\n\n", [self.arrayClosedTasks[i] valueForKey:@"typeTask"], [self.arrayClosedTasks[i] valueForKey:@"numberTask"], [self.arrayClosedTasks[i] valueForKey:@"summary"]];
        NSDictionary* attributes = [NSDictionary dictionaryWithObject:[self.arrayClosedTasks[i] valueForKey:@"colorTask"] forKey:NSForegroundColorAttributeName];
        attr = [[NSAttributedString alloc] initWithString:tmp attributes:attributes];
        
        [[textView textStorage] appendAttributedString:attr];
    }
}

-(void)addCert
{
    [self deleteCert];
    
    self.openPanel = [NSOpenPanel openPanel];
    self.openPanel.title = @"Choose a cert";
    self.openPanel.showsResizeIndicator = YES;
    self.openPanel.canCreateDirectories = YES;
    self.openPanel.allowsMultipleSelection = NO;
    
    NSArray* type = [NSArray arrayWithObjects:@"p12",nil];
    [self.openPanel setAllowedFileTypes:type];
    
    [self.openPanel beginSheetModalForWindow:self.openPanel.parentWindow completionHandler:^(NSInteger result){
        if (result == NSModalResponseOK)
        {
            NSAlert *alert = [NSAlert alertWithMessageText: @"Input password"
                                             defaultButton:@"OK"
                                           alternateButton:@"Cancel"
                                               otherButton:nil
                                 informativeTextWithFormat:@""];
            
            NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
            [alert setAccessoryView:input];
            NSInteger button = [alert runModal];
            if (button == NSAlertDefaultReturn)
            {
                [input validateEditing];
                self.password = input.stringValue;
            }
            else if (button == NSAlertAlternateReturn)
            {
                self.password = @"";
            }

            NSURL *selection = self.openPanel.URLs[0];
            NSString* filePath = [[NSString alloc] initWithString:[[selection path] stringByResolvingSymlinksInPath]];
            NSData *dataP12 = [NSData dataWithContentsOfFile:filePath];
            //NSLog(@"data - %@", dataP12);
            
            //certPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"p12"];
            [[NSFileManager defaultManager] createFileAtPath:certPath contents:nil attributes:nil];
            [dataP12 writeToFile:certPath atomically:YES];
            
            AHKeychainItem *item = [[AHKeychainItem alloc] init];
            item.service = @"service";
            item.account = @"myusername";
            item.label = @"Keychain Item";
            item.password = self.password;
            
            self.keychain = [[AHKeychain alloc] initCreatingNewKeychain:certPath password:@"000"];
            NSLog(@"save item - %d",[self.keychain saveItem:item error:nil]);
            //[self.keychain saveItem:item error:nil];
        }
    }];
}

-(void)deleteCert
{
    AHKeychainItem *item = [[AHKeychainItem alloc] init];
    item.service = @"service";
    item.account = @"myusername";
    item.label = @"Keychain Item";
    item.password = self.password;
    NSLog(@"err = %d", [self.keychain deleteItem:item error:nil]);
    
    self.password = nil;
    NSLog(@"path - %@", certPath);
    [[NSFileManager defaultManager] createFileAtPath:certPath contents:nil attributes:nil];
}
@end

