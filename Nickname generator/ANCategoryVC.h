//
//  ANCategoryVC.h
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ANCategorySelectionDelegate;

@interface ANCategoryVC : UIViewController

@property (strong, nonatomic) IBOutlet UITableView* tableView;

@property (strong, nonatomic) NSArray* categories;
@property (assign, nonatomic) NSInteger selectedCategoryIndex;

@property (weak, nonatomic) id <ANCategorySelectionDelegate> delegate;

@end

@protocol ANCategorySelectionDelegate <NSObject>

@required

- (void) categoryDidSelect:(NSInteger) categoryIndex;

@end