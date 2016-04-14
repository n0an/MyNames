//
//  ANDescriptioinVC.h
//  Nickname generator
//
//  Created by Anton Novoselov on 26/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ANNameIterationDirectionNext,
    ANNameIterationDirectionPrevious

} ANNameIterationDirection;

@class ANName;

@interface ANDescriptioinVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel* descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView* nameImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* imageHeightConstraint;


@property (weak, nonatomic) IBOutlet UIButton* readMoreButton;

@property (strong, nonatomic) NSArray* namesArray;


@end
