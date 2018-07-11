//
//  CollectionViewCell.m
//  getxml_2
//
//  Created by Александра Жиденко on 07.05.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
-(void)setDictCell:(NSDictionary *)dictCell
{
    _dictCell = dictCell;
    self.name.text = [[dictCell valueForKey:@"title"] valueForKey:@"text"];
    
    if([[dictCell valueForKey:@"bigImg"] valueForKey:@"text"])
    {
        NSString* str = @"https://inetbank.zapsibkombank.ru:9443/style/img/vendors/mobile/";
        NSString* endStr = [[dictCell valueForKey:@"bigImg"] valueForKey:@"text"];
        NSString* resultStr = [str stringByAppendingString:endStr];
        
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:resultStr]];
        self.image.image = [UIImage imageWithData:imageData];
    }
    else
    {
        self.image.backgroundColor = [UIColor whiteColor];
        NSString* newStr = [self.name.text substringWithRange:NSMakeRange(0, 1)];
        
        int radius = (self.image.frame.size.height - 5)/2;
        self.circle = [CAShapeLayer layer];
        self.circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)cornerRadius:radius].CGPath;
        self.circle.position = CGPointMake(CGRectGetMidX(self.image.frame)-radius,
                                           CGRectGetMidY(self.image.frame)-radius);
        self.circle.strokeColor = [UIColor blackColor].CGColor;
        self.circle.lineWidth = 0;
        [self.layer addSublayer:self.circle];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.image.frame.size.height + 5)/2, 0, self.image.frame.size.height, self.image.frame.size.height)];
        label.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
        label.text = newStr;
        [self addSubview:label];
    }
}
@end
