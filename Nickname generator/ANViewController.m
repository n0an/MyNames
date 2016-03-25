//
//  ANViewController.m
//  Nickname generator
//
//  Created by Anton Novoselov on 12/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANViewController.h"
#import "ANUtils.h"
#import "ANNickName.h"

typedef enum {
    ANGenderMasculine,
    ANGenderFeminine
} ANGender;


@interface ANViewController ()

@property (assign, nonatomic) NSInteger namesCount;


@end

@implementation ANViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.namesCount = self.nameCountControl.selectedSegmentIndex + 1;
    
    NSString* currentNamesLabel = [self getNamesStringForNamesCount:self.namesCount];
    
    self.nameResultLabel.text = currentNamesLabel;
    
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:ANLogNotification
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification * _Nonnull notif) {
         
         ANLog(@"%@", [notif.userInfo objectForKey:ANLogNotificationTextUserInfoKey]);
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Helper Methods

- (NSString*) getNamesStringForNamesCount:(NSInteger) count {
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i < count; i++) {
        
        ANNickName* generatedName = [ANNickName randomName];
        
        [array addObject:generatedName.firstName];
        
    }
    
    NSString* resultString = [array componentsJoinedByString:@" "];
    
    return resultString;
    
}


#pragma mark - Actions

- (IBAction)actionGenerateButtonPressed:(UIButton*)sender {
    
    NSString* currentNamesLabel = [self getNamesStringForNamesCount:self.namesCount];
    
    self.nameResultLabel.text = currentNamesLabel;
    
}

- (IBAction)actionNameCountControlValueChanged:(UISegmentedControl*)sender {
    
    ANLog(@"actionNameCountControlValueChanged");
    ANLog(@"New value is = %d", sender.selectedSegmentIndex);
    
    self.namesCount = sender.selectedSegmentIndex + 1;
    
    
}



- (IBAction)actionGenderControlValueChanged:(UISegmentedControl*)sender {
    
    ANLog(@"actionGenderControlValueChanged");
    ANLog(@"New value is = %d", sender.selectedSegmentIndex);
    
    

    
    
}





@end
