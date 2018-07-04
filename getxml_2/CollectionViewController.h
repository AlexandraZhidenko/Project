//
//  CollectionViewController.h
//  getxml_2
//
//  Created by Александра Жиденко on 03.05.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSData+Encryption.h"
#import "XMLReader.h"
#import "CollectionViewCell.h"
#import "TableViewController.h"

@interface CollectionViewController : UICollectionViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSDictionary* parsedXml;

@property (nonatomic) NSMutableArray* arrItems;
@property (nonatomic) NSMutableArray* arrItemsHasGroup;
@property (nonatomic) NSMutableArray* arrVendors;
@property (nonatomic) NSMutableArray* arrVendorsAfterSearch;

@property (nonatomic) UISearchBar* searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic) UITableView* tableViewWithResults;

@property (nonatomic) UICollectionView* myCollectionView;
@end
