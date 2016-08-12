//
//  ZJLabel.m
//  ProjectB
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//


#import "ZJLabel.h"

@interface ZJLabel()
@property(nonatomic,strong)NSTimer *myTimer;
@property(nonatomic,assign)CGRect MYframe;
@property(nonatomic,assign)CGFloat fa;
@property(nonatomic,assign)CGFloat bigNumber;

@end


@implementation ZJLabel

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _MYframe = frame;
        self.backgroundColor = [UIColor whiteColor];
        UILabel *presentLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        presentLable.textAlignment = 1;
        [self addSubview:presentLable];
        self.presentlabel = presentLable;
        self.presentlabel.font = [UIFont systemFontOfSize:55];
            self.presentlabel.textColor = [UIColor whiteColor];
        //        self.presentlabel
    }
    return self;
}
-(void)createTimer{
    if(!self.myTimer){
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(action) userInfo:nil repeats:YES];
    }
    [self.myTimer setFireDate:[NSDate distantPast]];
}
-(void)action{
    _fa = _fa +15;
    if (_fa >= _MYframe.size.width *2.0) {
        _fa = 0;
    }
    [self setNeedsDisplay]; //该方法会自动调用drawRect方法
    //    [self setNeedsLayout];会默认调用layoutSubViews，主要用来处理数据
}
//在timer上会每0.04秒调用一次action方法，action方法会调用 setNeedsDisplay方法
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建路径
    CGMutablePathRef path = CGPathCreateMutable();
    //画水
    CGContextSetLineWidth(context, 1);
    UIColor *blue = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.3];
    CGContextSetFillColorWithColor(context, [blue CGColor]);
    
    
    float y = (1 - self.present) * rect.size.height;
    float y1 = (1 - self.present) * rect.size.height;
    
    CGPathMoveToPoint(path, NULL, 0, y);
    //for循环每执行一次，在正弦曲线上绘制一个点，X自增量越小，曲线越平滑
    for(float x = 0; x <= rect.size.width *3.0; x ++){
        //正弦函数
        //sin部分是曲线波动，bigNumber是曲线波动的幅度，加号后面的部分是曲线波动的基准线，随加载进度而提升
        y = sin(x / rect.size.width * M_PI + _fa /rect.size.width *M_PI) * _bigNumber + (1 - self.present) * rect.size.height;
        CGPathAddLineToPoint(path, nil, x, y);
        
    }
    
    CGPathAddLineToPoint(path, nil, rect.size.width, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    //    CGPathAddLineToPoint(path, nil, 0, 200);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGContextSetLineWidth(context, 1);
    UIColor *blue1 = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.6];
    CGContextSetFillColorWithColor(context, [blue1 CGColor]);
    //    float y1 = 200
    CGPathMoveToPoint(path1, NULL, 0, y1);
    for (float x = 0; x <= rect.size.width; x ++) {
        y1 = sin( x/ rect.size.width *M_PI + _fa / rect.size.width *M_PI +M_PI) * _bigNumber +(1 - self.present) *rect.size.width;
        CGPathAddLineToPoint(path1, nil, x, y1);
    }
    CGPathAddLineToPoint(path1, nil, rect.size.height, rect.size.width);
    CGPathAddLineToPoint(path1, nil, 0, rect.size.height);
    
    CGContextAddPath(context, path1);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path1);
    
    // 添加文字
    NSString *str = [NSString stringWithFormat:@"%ld步",self.NowStep];
    self.presentlabel.text = str;
    
}

-(void)setPresent:(CGFloat)present{
    _present = present;
    [self createTimer];
    if (present <= 0.5) {
        _bigNumber = _MYframe.size.height *0.1 *present *1.4;
    }else{
        _bigNumber = _MYframe.size.height * 0.1 * (1 - present) *1.4;
    }
    // _bigNumber = _MYframe.size.height * 0.1 * 1;
}
@end

