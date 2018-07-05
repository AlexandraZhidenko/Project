//
//  CollectionViewController.m
//  getxml_2
//
//  Created by Александра Жиденко on 03.05.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    NSURL *url = [NSURL URLWithString:@"https://bb41.ru/pb/vdr.uu"];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    defaultConfigObject.TLSMinimumSupportedProtocol = kSSLProtocol3;
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            
                                                            NSData* decrypt;
                                                            decrypt = [[NSData alloc] initWithData:[data AES256DecryptWithKey:@"dpq%^12-ppp"]];
                                                            
                                                            NSString * text = [[NSString alloc] initWithData:decrypt encoding:NSUTF8StringEncoding];
                                                            NSError *error = nil;
                                                            self.parsedXml = [XMLReader dictionaryForXMLString:text error:&error];
                                                            NSLog(@"data = %@", self.parsedXml);
                                                            
                                                            self.arrItems = [NSMutableArray arrayWithCapacity:0];
                                                            self.arrItemsHasGroup = [NSMutableArray arrayWithCapacity:0];
                                                            self.arrVendors = [NSMutableArray arrayWithCapacity:0];
                                                            self.arrVendorsAfterSearch = [NSMutableArray arrayWithCapacity:0];
                                                            
                                                            self.arrItems = [[[self.parsedXml valueForKey:@"Response"] valueForKey:@"List"] valueForKey:@"Row"];
                                                            
                                                            for(int i = 0; i < self.arrItems.count; i++)
                                                            {
                                                                NSDictionary* tmpDict = [self.arrItems objectAtIndex:i];
                                                                if([[[tmpDict valueForKey:@"hasGroup"] valueForKey:@"text"] isEqualToString:@"1"])
                                                                {
                                                                    [self.arrItemsHasGroup addObject:tmpDict];
                                                                    //NSLog(@"arr = %@", self.arrItemsHasGroup);
                                                                }
                                                                else
                                                                    [self.arrVendors addObject:tmpDict];
                                                            }
                                                            
                                                            [self.collectionView reloadData];
                                                            //NSLog(@"count = %d", self.countGroups);
                                                        }
                                                    }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"item"])
    {
        TableViewController* tableVC = segue.destinationViewController;
        CollectionViewCell* collectionVC = sender;
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:collectionVC];
        NSDictionary* dict = [self.arrItemsHasGroup objectAtIndex:indexPath.row];
        
        NSMutableArray* tmpArr = [NSMutableArray arrayWithCapacity:0];
        for(int i = 0; i < self.arrVendors.count; i++)
        {
            NSDictionary* tmpDict = [self.arrItems objectAtIndex:i];
            if([[[dict valueForKey:@"id"] valueForKey:@"text"] isEqualToString:[[tmpDict valueForKey:@"parent"] valueForKey:@"text"]])
            {
                [tmpArr addObject:tmpDict];
            }
        }
        tableVC.arrTableViewCell = tmpArr;
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.arrVendorsAfterSearch removeAllObjects];
//    [self.view addSubview:self.tableViewWithResults];
     [self.tableViewWithResults removeFromSuperview];
    if(searchText.length)
    {
        //[self.collectionView setHidden:true];
        [self.tableViewWithResults setHidden:false];
        NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",searchText];
        
        NSMutableArray* tmpArr = [NSMutableArray arrayWithCapacity:0];
        for(int i = 0; i < self.arrVendors.count; i++)
        {
            [tmpArr addObject:[[[self.arrVendors objectAtIndex:i] valueForKey:@"title"] valueForKey:@"text"]];
        }
        tmpArr = (NSMutableArray*)[tmpArr filteredArrayUsingPredicate:pred];
        
        for(int i = 0; i < self.arrVendors.count; i++)
        {
            for(int j = 0; j < tmpArr.count; j++)
            {
                if([[[[self.arrVendors objectAtIndex:i] valueForKey:@"title"] valueForKey:@"text"] isEqualToString:[tmpArr objectAtIndex:j]])
                    [self.arrVendorsAfterSearch addObject:[self.arrVendors objectAtIndex:i]];            }
        }
        
        self.tableViewWithResults = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
        self.tableViewWithResults.delegate = self;
        self.tableViewWithResults.dataSource = self;
        [self.tableViewWithResults registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cell"];
       
        [self.view addSubview:self.tableViewWithResults];
        
    }
    else if(searchText.length == 0)
    {
        [self.tableViewWithResults setHidden:true];
        [self.collectionView setHidden:false];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrItemsHasGroup.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.dictCell = [self.arrItemsHasGroup objectAtIndex:indexPath.row];

    return cell;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrVendorsAfterSearch.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary* tmpDict = [self.arrVendorsAfterSearch objectAtIndex:indexPath.row];
    cell.textLabel.text = [[tmpDict valueForKey:@"title"] valueForKey:@"text"];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
