//
//  FilmCell.h
//  Vision
//
//  Created by QianFeng on 16/7/4.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilmCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewL;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *categoryL;
@end
