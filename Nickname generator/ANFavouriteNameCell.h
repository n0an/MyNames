//
//  ANFavouriteNameCell.h
//  Nickname generator
//
//  Created by Anton Novoselov on 15/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANFavouriteNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameCategoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nameImageView;

@end
