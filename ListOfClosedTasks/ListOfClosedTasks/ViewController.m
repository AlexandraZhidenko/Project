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
    NSArray * fileTypes = [NSArray arrayWithObjects:@"xml",nil];
    [self.openPanel setAllowedFileTypes:fileTypes];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)btnOpenFile:(id)sender
{
    self.outputTextView.string = @"";
    [self.openPanel beginSheetModalForWindow:self.openPanel.parentWindow completionHandler:^(NSInteger result){
        if (result == NSModalResponseOK)
        {
            NSURL *selection = self.openPanel.URLs[0];
            NSString* path = [[selection path] stringByResolvingSymlinksInPath];
            
            NSString* str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSError *error = nil;
            self.parsedXml = [XMLReader dictionaryForXMLString:str error:&error];
            //NSLog(@"data = %@", self.parsedXml);
            
            [self printfInf];
        }
    }];
}

- (BOOL)typeTask:(NSString*)typeStr
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
        return false;
}

-(void)printfInf
{
    self.arrayTasks = [[[self.parsedXml valueForKey:@"rss"] valueForKey:@"channel"] valueForKey:@"item"];
    for(int i = 0; i < self.arrayTasks.count; i++)
    {
        if([[[self.arrayTasks[i] valueForKey:@"status"] valueForKey:@"text"] isEqualToString:@"Closed"] || [[[self.arrayTasks[i] valueForKey:@"status"] valueForKey:@"text"] isEqualToString:@"Resolved"])
        {
            NSColor* textColor = [NSColor blackColor];
            
            self.list = [NSMutableDictionary dictionaryWithCapacity:0];
            [self.list setObject:[[self.arrayTasks[i] valueForKey:@"key"] valueForKey:@"text"] forKey:@"numberTask"];
            
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
            
            [self.list setObject:[[self.arrayTasks[i] valueForKey:@"summary"] valueForKey:@"text"] forKey:@"summary"];
            
            [self.arrayClosedTasks addObject:self.list];
            NSString* tmp = [[NSString alloc] initWithFormat:@"[%@](%@)%@", [self.list valueForKey:@"typeTask"], [self.list valueForKey:@"numberTask"], [self.list valueForKey:@"summary"]];
            NSDictionary* attributes = [NSDictionary dictionaryWithObject:textColor forKey:NSForegroundColorAttributeName];
            NSAttributedString* attr = [[NSAttributedString alloc] initWithString:tmp attributes:attributes];
            [[self.outputTextView textStorage] appendAttributedString:attr];
            [self.outputTextView insertNewline:nil];
        }
    }
}









@end
