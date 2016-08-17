//
//  RGCollectionViewCell.h
//  Vision
//
//  Created by QianFeng on 16/6/29.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionView;

@property (weak, nonatomic) IBOutlet UILabel *categoryView;

@property (weak, nonatomic) IBOutlet UILabel *title;
@end
