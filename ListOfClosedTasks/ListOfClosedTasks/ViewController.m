//
//  ViewController.m
//  ListOfClosedTasks
//
//  Created by Александра Жиденко on 20.07.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayClosedTasks = [NSMutableArray arrayWithCapacity:0];
    
    self.openPanel = [NSOpenPanel openPanel];
    self.openPanel.title = @"Choose a .xml file";
    self.openPanel.showsResizeIndicator = YES;
    self.openPanel.canCreateDirectories = YES;
    self.openPanel.allowsMultipleSelection = NO;
    
    self.fileTypes = [NSArray arrayWithObjects:@"xml",nil];
    [self.openPanel setAllowedFileTypes:self.fileTypes];
    
    self.outputTextView.delegate = self;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)btnOpenFile:(id)sender
{
    [self.openPanel beginSheetModalForWindow:self.openPanel.parentWindow completionHandler:^(NSInteger result){
        if (result == NSModalResponseOK)
        {
            NSURL *selection = self.openPanel.URLs[0];
            NSString* path = [[selection path] stringByResolvingSymlinksInPath];
            
            NSString* str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSError *error = nil;
            self.parsedXml = [XMLReader dictionaryForXMLString:str error:&error];
            //NSLog(@"parsed xml = %@", self.parsedXml);
            
            [self printfInf:self.parsedXml :self.outputTextView];
        }
    }];
}

- (BOOL)typeTask:(NSString*)typeStr // task type definition
{
    if([typeStr isEqualToString:@"Bug"])
    {
        [self.list setObject:@"#" forKey:@"typeTask"];
        return true;
    }
    else if([typeStr isEqualToString:@"Task"])
    {
        [self.list setObject:@"*" forKey:@"typeTask"];
        return true;
    }
    else if([typeStr isEqualToString:@"New Feature"])
    {
        [self.list setObject:@"+" forKey:@"typeTask"];
        return true;
    }
    else
        return false; // processing in function printfInf:(NSDictionary*)dict :(NSTextView*)textView
}

-(void)printfInf:(NSDictionary*)dict :(NSTextView*)textView // output information about task
{
    textView.string = @"";
    self.arrayTasks = [[[dict valueForKey:@"rss"] valueForKey:@"channel"] valueForKey:@"item"];
    //NSLog(@"%@", self.arrayTasks);
    for(int i = 0; i < self.arrayTasks.count; i++)
    {
        if([[[self.arrayTasks[i] valueForKey:@"status"] valueForKey:@"text"] isEqualToString:@"Closed"] || [[[self.arrayTasks[i] valueForKey:@"status"] valueForKey:@"text"] isEqualToString:@"Resolved"])//&& [[[self.arrayTasks[i] valueForKey:@"key"] valueForKey:@"text"] isEqualToString:@"TM-1234"]
        {
            NSColor* textColor = [NSColor blackColor];
            self.list = [NSMutableDictionary dictionaryWithCapacity:0];
            
            //set summary
            NSString* strSummary = [self setSummary:self.arrayTasks[i]];
            [self.list setObject:strSummary forKey:@"summary"];
            
            //set number task
            [self.list setObject:[[self.arrayTasks[i] valueForKey:@"key"] valueForKey:@"text"] forKey:@"numberTask"];
            
            //set type task
            NSString* typeStr = [[self.arrayTasks[i] valueForKey:@"type"] valueForKey:@"text"];
            BOOL correctType = [self typeTask:typeStr];
            if(correctType == false)
            {
                NSString* parentNumber = [[self.arrayTasks[i] valueForKey:@"parent"] valueForKey:@"text"];
                for(int j = 0; j < self.arrayTasks.count; j++)
                {
                    NSString* number = [[self.arrayTasks[j] valueForKey:@"key"] valueForKey:@"text"];
                    if([number isEqualToString:parentNumber])
                    {
                        NSString* tmp = [[self.arrayTasks[j] valueForKey:@"type"] valueForKey:@"text"];
                        [self typeTask:tmp];
                    }
                    else
                    {
                        [self.list setObject:@"No type" forKey:@"typeTask"];
                        textColor = [NSColor redColor];
                    }
                }
            }
            
            [self.arrayClosedTasks addObject:self.list];
            // output inf
            NSString* tmp = [[NSString alloc] initWithFormat:@"[%@](%@) %@\n\n", [self.list valueForKey:@"typeTask"], [self.list valueForKey:@"numberTask"], [self.list valueForKey:@"summary"]];
            NSDictionary* attributes = [NSDictionary dictionaryWithObject:textColor forKey:NSForegroundColorAttributeName];
            NSAttributedString* attr = [[NSAttributedString alloc] initWithString:tmp attributes:attributes];
            [[textView textStorage] appendAttributedString:attr];
        }
    }
}

-(NSString*)modificationSummary:(NSString*)str // this function return correct summary without <>
{
    // from string to array
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=0; i < str.length; i++)
    {
        NSString *tmpStr = [str substringWithRange:NSMakeRange(i, 1)];
        [arr addObject:[tmpStr stringByRemovingPercentEncoding]];
    }
    
    NSUInteger lenghtDescrpt = str.length;
    NSMutableString* summary = [NSMutableString stringWithCapacity:0];
    
    for(int i = 0; i < lenghtDescrpt; i++)
    {
        if((i >= 3 && [arr[i - 2] isEqualToString:@")"] && [arr[i - 3] isEqualToString:@">"]) || (i >= 2 && [arr[i - 1] isEqualToString:@")"] && [arr[i - 2] isEqualToString:@">"]))
        {
            for(int j = i; j < lenghtDescrpt; j++)
            {
                [summary appendString:arr[j]];
                if([arr[j] isEqualToString:@"\n"] || [arr[j] isEqualToString:@"<"])
                {
                    summary = [summary stringByReplacingOccurrencesOfString:arr[j] withString:@""];
                    str = [str stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
                    str = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
                    return summary;
                }
            }
        }
    }
    
    str = [str stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    return summary;
}

-(NSString*)setSummary:(NSDictionary*)dictionary // this function defining summary task
{
    NSLog(@"dict = %@", dictionary);
    NSString* strSummary;
    // check if there is a comment for technical writer
    NSArray* arrWithCustomFields = [[dictionary valueForKey:@"customfields"] valueForKey:@"customfield"];
    for(int i = 0; i < arrWithCustomFields.count; i++)
    {
        if([[[[arrWithCustomFields[i] valueForKey:@"customfieldvalues"] valueForKey:@"customfieldvalue"] valueForKey:@"text"] containsString:@"href="])
        {
            strSummary = [[[arrWithCustomFields[i] valueForKey:@"customfieldvalues"] valueForKey:@"customfieldvalue"] valueForKey:@"text"];
            strSummary = [self modificationSummary:strSummary];
            return strSummary;
        }
    }
    
    NSArray* arrWithComments = [[dictionary valueForKey:@"comments"] valueForKey:@"comment"];
    // if no comments
    if (arrWithComments.count == 0)
    {
        strSummary = [[dictionary valueForKey:@"summary"] valueForKey:@"text"];
        return strSummary;
    }
    // if a few comments
    else if([arrWithComments isKindOfClass:[NSArray class]])
    {
        for(int i = 0; i < arrWithComments.count; i++)
        {
            NSString* strComment = [arrWithComments[i] valueForKey:@"text"];
            if([strComment containsString:@"</span>(<a href="])
            {
                NSLog(@"str - %@", strComment);
                strSummary = [self modificationSummary:strComment];
                NSLog(@"str - %@", strSummary);
                return strSummary;
            }
        }
    }
    // if one comment
    else if([arrWithComments isKindOfClass:[NSDictionary class]])
    {
        NSString* strComment = [arrWithComments valueForKey:@"text"];
        if([strComment containsString:@"</span>(<a href="])
        {
            NSLog(@"str - %@", strComment);
            strSummary = [self modificationSummary:strComment];
            NSLog(@"str - %@", strSummary);
            return strSummary;
        }
    }
    
    strSummary = [[dictionary valueForKey:@"summary"] valueForKey:@"text"];
    return strSummary;
}

@end
