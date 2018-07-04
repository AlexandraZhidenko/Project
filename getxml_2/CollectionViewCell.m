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
    
    //[[dictCell valueForKey:@"bigImg"] valueForKey:@"text"];
}
@end
