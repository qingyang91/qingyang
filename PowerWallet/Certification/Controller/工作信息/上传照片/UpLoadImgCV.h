//
//  UpLoadImgCV.h
//  Krisc.Zampono
//
//  Created by Krisc.Zampono on 16/5/11.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AscendingUpLoadEntity.h"

@interface UpLoadImgCV : UICollectionView

@property (nonatomic, retain) NSArray<KDAscendingUpLoadImgEntity *> *dataArray;
@property (assign, nonatomic) NSInteger maxNum;

//待上传的图片
@property (nonatomic, retain) NSMutableArray *uploadArray;

@property (assign, nonatomic) NSInteger type;

+ (id)getcollection;
@property (nonatomic, copy) void (^uploadImgSuccss)(void);
@property (nonatomic, copy) void (^showAlertView)(void);
-(void)toCamer;
-(void)toPhoto;
@end
