//
//  VideoCell.h
//  TWCChallenge
//
//  Created by Rayen Kamta on 9/2/15.
//  Copyright (c) 2015 Geeksdobyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
