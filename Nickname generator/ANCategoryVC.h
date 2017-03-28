//
//  ANCategoryVC.h
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ANNameCategory;

@protocol ANCategorySelectionDelegate;

@interface ANCategoryVC : UIViewController

#pragma mark - OUTLETS
@property (strong, nonatomic) IBOutlet UITableView* tableView;

#pragma mark - PUBLIC PROPERTIES
@property (strong, nonatomic) NSArray* categories;
@property (strong, nonatomic) ANNameCategory* selectedCategory;
@property (weak, nonatomic) id <ANCategorySelectionDelegate> delegate;

@end

#pragma mark - DELEGATE PROTOCOL
@protocol ANCategorySelectionDelegate <NSObject>

@required

- (void) categoryDidSelect:(ANNameCategory*) category;

@end
