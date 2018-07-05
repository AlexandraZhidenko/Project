//
//  TableViewCell.m
//  getxml_2
//
//  Created by Александра Жиденко on 17.05.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDictTableCell:(NSDictionary *)dictTableCell
{
    self.name.text = [[dictTableCell valueForKey:@"title"] valueForKey:@"text"];
    
    if(![[dictTableCell valueForKey:@"bigImg"] valueForKey:@"text"])
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
    else
    {
        self.image.backgroundColor = [UIColor redColor];
        //self.image = [[dictTableCell valueForKey:@"bigImg"] valueForKey:@"text"];
    }
}

-(void)setDict:(NSMutableDictionary *)dict
{
    NSString* newStr = [self.name.text substringWithRange:NSMakeRange(0, 1)];
    self.circle.fillColor = CFBridgingRetain([dict objectForKey:newStr]);
}

@end
