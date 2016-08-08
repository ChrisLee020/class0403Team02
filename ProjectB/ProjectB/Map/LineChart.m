//
//  LineChart.m
//  ProjectB
//
//  Created by lanou on 16/8/5.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "LineChart.h"
#import "day-step_Model.h"
@interface LineChart()

@property(nonatomic,strong)CAShapeLayer *lineChartLayer;
@property(nonatomic,strong)UIBezierPath *path1;
@property(nonatomic,strong)UIView *gradientBackgroundView;
@property(nonatomic,strong)CAGradientLayer *gradientLayer;
@property(nonatomic,strong)NSMutableArray *gradientLayerColors;
@property(nonatomic,assign)NSInteger MaxStep;
@property(nonatomic,strong)NSMutableArray *sortedArr;
@property(nonatomic,assign)NSInteger ChartMax;

@end



@implementation LineChart

static CGFloat bounceX = 30;
static CGFloat bounceY = 20;


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
     
        self.backgroundColor = [UIColor whiteColor];

    }
    
    return self;
}
-(void)build{
    [self fixArr];
    [self createlabelX];
    [self createlabelY];
    [self drawgradientBackgroundView];
    [self setLineDash];
    [self.lineChartLayer removeFromSuperlayer];
    for (NSInteger i = 0; i < 12; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:3000 + i];
        [label removeFromSuperview];
    }
    [self buildLine];
}
-(void)drawRect:(CGRect)rect{
    //画坐标轴
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextMoveToPoint(context, bounceX, bounceY);
    CGContextAddLineToPoint(context, bounceX, rect.size.height - bounceY);
    CGContextAddLineToPoint(context, rect.size.width - bounceX, rect.size.height - bounceY);
    CGContextStrokePath(context);
}
#pragma mark 添加虚线
-(void)setLineDash{
    for (NSInteger i = 0; i < 6; i++) {
        CAShapeLayer *dashLayer = [CAShapeLayer layer];
        dashLayer.strokeColor = [UIColor whiteColor].CGColor;
        dashLayer.fillColor = [[UIColor clearColor]CGColor];
        //默认宽度0不显示
        dashLayer.lineWidth = 1.0;
        
        UILabel *label1 = (UILabel *)[self viewWithTag:2000 + i];
        UIBezierPath *path = [[UIBezierPath alloc]init];
        path.lineWidth = 1.0;
        UIColor *color = [UIColor blueColor];
        [color set];
        
        [path moveToPoint:CGPointMake(0, label1.frame.origin.y - bounceY)];
        CGFloat dash[] = {10,10};
        [path setLineDash:dash count:2 phase:10];
        [path stroke];
        dashLayer.path = path.CGPath;
        [self.gradientBackgroundView.layer addSublayer:dashLayer];
    }
}
#pragma mark 画折线图
-(void)drawLine{

    UIBezierPath *path = [[UIBezierPath alloc]init];
    path.lineWidth = 1.0;
    self.path1 = path;
    UIColor *color = [UIColor greenColor];
    [color set];
//    [path moveToPoint:CGPointMake(label.frame.origin.x - bounceX, (600-arc4random()%600) / 600.0 * (self.frame.size.height - bounceY * 2) + bounceY)];
    CGFloat month = 0;
    if (_sortedArr.count >=7) {
        month = 7;
    }else{
        month = _sortedArr.count;
    }
    //创建折线点标记
    for (NSInteger i = 0; i < month; i++) {
        UILabel *label1 = (UILabel *)[self viewWithTag:1000 + i];
        NSInteger t1 = _sortedArr.count - month + i;
        day_step_Model *model = _sortedArr[t1];
        CGFloat arc = [model.number integerValue];
        //折线点的设定
        if (i == 0) {
            [path moveToPoint:CGPointMake(label1.frame.origin.x - bounceX , ((_ChartMax - arc)/ _ChartMax * 1.0 * (self.frame.size.height - 2 * bounceY)) )];
        }else{
        
        [path addLineToPoint:CGPointMake(label1.frame.origin.x - bounceX , ((_ChartMax - arc)/ _ChartMax * 1.0 * (self.frame.size.height - 2 * bounceY)) )];
        }

        UILabel *falglabel = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x, (_ChartMax - arc)/ _ChartMax * 1.0 * (self.frame.size.height - 2 * bounceY) + bounceY, 30, 15)];
//        falglabel.backgroundColor = [UIColor blueColor];
        falglabel.tag = 3000 + i;
        falglabel.text = [NSString stringWithFormat:@"%.0f",arc];
        falglabel.font = [UIFont systemFontOfSize:10.0];
        [self addSubview:falglabel];
    }
//    [path stroke];
    self.lineChartLayer = [CAShapeLayer layer];
    self.lineChartLayer.path = path.CGPath;
    //修改折线颜色
    self.lineChartLayer.strokeColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1].CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor]CGColor];
    //默认宽度设置为0，使其在初始状态不显示
    self.lineChartLayer.lineWidth = 0.0;
    self.lineChartLayer.lineCap = kCALineCapRound;
    self.lineChartLayer.lineJoin = kCALineJoinRound;
    [self.gradientBackgroundView.layer addSublayer:self.lineChartLayer]; //直接添加到视图上
}
#pragma mark 创建X轴数据
-(void)createlabelX{
    CGFloat month = 0;
    if (_sortedArr.count >=7) {
        month = 7;
    }else{
        month = _sortedArr.count;
    }
    for (NSInteger i = 0; i < month ; i++) {
        UILabel *labelmonth = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 2 * bounceX)/ month * i + bounceX, self.frame.size.height -bounceY * 0.7, (self.frame.size.width - 2 * bounceX) / month - 5, bounceY / 2)];

//        labelmonth.backgroundColor = [UIColor greenColor];   count - month + i
        day_step_Model *model = _sortedArr[(int)(_sortedArr.count - month + i)];
        NSString *temp = [model.date substringFromIndex:5];
        NSLog(@"%@",temp);
        labelmonth.tag = 1000 + i;
        labelmonth.text =[NSString stringWithFormat:@"%@",temp];
        labelmonth.font = [UIFont systemFontOfSize:10];
//        labelmonth.transform = CGAffineTransformMakeRotation(M_PI * 0.1);
        [self addSubview: labelmonth];
    }
}
#pragma mark 创建Y轴数据
-(void)createlabelY{
    CGFloat Ydivision = 6;
    for (NSInteger i = 0; i < Ydivision; i++) {
        UILabel *labelYdivision = [[UILabel alloc]initWithFrame:CGRectMake(0,(self.frame.size.height - 2 * bounceY)/ Ydivision * i + bounceX, bounceY * 1.5, bounceY / 2.0)];
//        labelYdivision.backgroundColor = [UIColor greenColor];
        labelYdivision.tag = 2000 + i;
        labelYdivision.text = [NSString stringWithFormat:@"%.0f",(Ydivision - i ) / Ydivision * _ChartMax];
        labelYdivision.font = [UIFont systemFontOfSize:10];
        [self addSubview:labelYdivision];
    }
}
#pragma mark 渐变的颜色
-(void)drawgradientBackgroundView{

    
    
    //渐变平滑视图（不包含背景色）
    self.gradientBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(bounceX, bounceY, self.bounds.size.width - 2 * bounceX, self.bounds.size.height - 2 * bounceY)];
//    NSLog(@"%f  %f  %f  %f",self.gradientBackgroundView.frame.origin.x,self.gradientBackgroundView.frame.origin.y,self.gradientBackgroundView.frame.size.width,self.gradientBackgroundView.frame.size.height);
    [self addSubview:self.gradientBackgroundView];
    //创建并设置渐变背景图层
        //初始化CAGradientLayer对象，使它的大小为渐变背景视图大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.gradientBackgroundView.bounds;
    //设置渐变区域起始和终点位置（范围为0-1）即渐变路径
    self.gradientLayer.startPoint = CGPointMake(0, 0.0);
    self.gradientLayer.endPoint = CGPointMake(1.0, 0.0);
    //设置颜色渐变过程
    self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithRed:253/255.0 green:164/255.0 blue:8/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:251/255.0 green:37/255.0 blue:45/255.0 alpha:1.0].CGColor]];
    self.gradientLayer.colors = self.gradientLayerColors;
//    [self.layer addSublayer:self.gradientLayer];
    [self.gradientBackgroundView.layer addSublayer:self.gradientLayer];
}
#pragma mark 点击重新绘制曲线
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

        [self.lineChartLayer removeFromSuperlayer];
        for (NSInteger i = 0; i < 12; i++) {
            UILabel *label = (UILabel *)[self viewWithTag:3000 + i];
            [label removeFromSuperview];
        }
    [self buildLine];

    
}
-(void)animationDidStart:(CAAnimation *)anim{
    
    NSLog(@"开始");
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"搞定");
}
-(void)buildLine{
    [self drawLine];
    self.lineChartLayer.lineWidth = 2;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0];
    //设置动画代理，动画结束时现实折线终点信息
    pathAnimation.delegate = self;
    [self.lineChartLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

-(void)fixArr{
    _sortedArr = [NSMutableArray array];
    _ChartMax = 0;
    NSArray *keyarr = [_DataDict allKeys];
   keyarr = [keyarr sortedArrayUsingSelector:@selector(compare:)];
    for (int i = 0; i < keyarr.count; i++) {
        day_step_Model *model = [[day_step_Model alloc]init];
        model.date = keyarr[i];
        model.number = [_DataDict valueForKey:keyarr[i]];
        [_sortedArr addObject:model];
    }
    
    CGFloat month = 0;
    if (_sortedArr.count >=7) {
        month = 7;
    }else{
        month = _sortedArr.count;
    }
    
    for (NSInteger i = 0 ; i < month; i++) {
        
        NSInteger t1 = _sortedArr.count - month + i;
        day_step_Model *model = _sortedArr[t1];
        
        if ([model.number integerValue] > _ChartMax) {
            _ChartMax = [model.number integerValue];
        }
    }
}


@end