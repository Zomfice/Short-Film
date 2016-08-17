//
//  CollectCell.h
//  Vision
//
//  Created by QianFeng on 16/7/2.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewL;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *CategoryL;
@property (weak, nonatomic) IBOutlet UILabel *descripL;

@end
