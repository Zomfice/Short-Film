//
//  PhotoCell.h
//  Vision
//
//  Created by QianFeng on 16/6/15.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"
@interface PhotoCell : UICollectionViewCell{
    UIImageView * _imageView;
}
- (void)refreshUI:(PhotoModel *)model;
@end
