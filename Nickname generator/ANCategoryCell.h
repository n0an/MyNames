//
//  ANCategoryCell.h
//  Nickname generator
//
//  Created by Anton Novoselov on 26/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANCategoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel* categoryName;


@end
