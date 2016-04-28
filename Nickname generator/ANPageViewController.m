//
//  ANPageViewController.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANPageViewController.h"
#import "ANContentPageViewController.h"

@interface ANPageViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) NSArray* pageHeaders;
@property (strong, nonatomic) NSArray* pageSubHeaders;
@property (strong, nonatomic) NSArray* pageImageContents;


@end


@implementation ANPageViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    
    self.pageHeaders = @[@"Nickname Generator",
                         @"Удобный интерфейс",
                         @"Избранное",
                         @"Гибкие настройки",
                         @"Больше информации"];
    
    
    self.pageSubHeaders = @[@"Генерируйте имена, нажимая на кнопку",
                            @"или встряхивая телефон",
                            @"Добавляйте понравившиеся имена в Избранное",
                            @"Сконфигурируйте генератор по своему желанию",
                            @"Узнайте больше об имени в каталоге имен"];
    
    self.pageImageContents = @[@"diceBG03_1920",
                               @"bg12",
                               @"bg13",
                               @"bg14",
                               @"descr"];
    
    
    ANContentPageViewController* firstVC = [self showViewControllerAtIndex:0];
    
    [self setViewControllers:@[firstVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    
}




- (ANContentPageViewController*) showViewControllerAtIndex:(NSInteger) index {
    
    if ((index >= 0) && (index < [self.pageHeaders count])) {
        
        ANContentPageViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ANContentPageViewController"];
        
        vc.imageFile    = [self.pageImageContents objectAtIndex:index];
        vc.header       = [self.pageHeaders objectAtIndex:index];
        vc.subHeader    = [self.pageSubHeaders objectAtIndex:index];
        
        vc.index        = index;
        
        return vc;
    }
    
    return nil;
}

- (void) nextPage:(NSInteger) index {
    
    ANContentPageViewController* nextVC = [self showViewControllerAtIndex:++index];
    
    [self setViewControllers:@[nextVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    
}


#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    ANContentPageViewController* vc = (ANContentPageViewController*) viewController;
    
    NSInteger index = vc.index;
    
    return [self showViewControllerAtIndex:--index];
    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    ANContentPageViewController* vc = (ANContentPageViewController*) viewController;
    
    NSInteger index = vc.index;
    
    return [self showViewControllerAtIndex:++index];
    
    
}


- (BOOL)shouldAutorotate {
    return NO;
}



@end




