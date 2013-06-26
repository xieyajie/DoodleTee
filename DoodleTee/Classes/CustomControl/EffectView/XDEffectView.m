//
//  XDEffectView.m
//  DoodleTee
//
//  Created by xieyajie on 13-6-26.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDEffectView.h"

#import "XDDrawTools.h"

#import "ColorMatrix.h"

#import "ImageUtil.h"

#define kDefaultDrawColor [UIColor blackColor]
#define kDefaultBgColor [UIColor clearColor]
#define kDefaultFontSize 18
#define kDefaultLineWidth 5

#define kTextViewHeightMin 20
#define kRandomMax 255.0

@interface XDEffectView()
{
    NSMutableArray *_pathArray;
    NSMutableArray *_bufferArray;
}

@property (nonatomic, assign) id<XDDrawTools> drawTool;

@property (nonatomic, strong) NSMutableArray *pathArray;

@property (nonatomic, strong) NSMutableArray *bufferArray;

@end

@implementation XDEffectView

@synthesize drawTool = _drawTool;

@synthesize pathArray = _pathArray;
@synthesize bufferArray = _bufferArray;

@synthesize currentImage = _currentImage;
@synthesize effectType;

@synthesize drawColor;
@synthesize bgColor;
@synthesize fontSize;
@synthesize lineWidth;
@synthesize undoSteps;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

#pragma mark - private

- (void)configure
{
    _pathArray = [[NSMutableArray alloc] init];
    _bufferArray = [[NSMutableArray alloc] init];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_imageView];
    
    self.drawColor = kDefaultDrawColor;
    self.bgColor = kDefaultBgColor;
    self.fontSize = kDefaultFontSize;
    self.lineWidth = kDefaultLineWidth;
    
    self.backgroundColor = [UIColor lightGrayColor];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
#if PARTIAL_REDRAW
    // TODO: draw only the updated part of the image
//    [self drawPath];
#else
//    [self.image drawInRect:self.bounds];
    [self.drawTool draw];
#endif
}

//生成随机颜色
- (UIColor *)randomColor
{
    static BOOL seeded = NO;
    
    if (!seeded) {
        seeded = YES;
        srand(time(NULL));
    }
    
    CGFloat red = (CGFloat)random() / (CGFloat)kRandomMax;
    CGFloat green = (CGFloat)random() / (CGFloat)kRandomMax;
    CGFloat blue = (CGFloat)random() / (CGFloat)kRandomMax;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

//设置图片符合一定大小
-(UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);//根据当前大小创建一个基于位图图形的环境
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];//根据新的尺寸画出传过来的图片
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
    
    UIGraphicsEndImageContext();//关闭当前环境
    
    return newImage;
}

- (id<XDDrawTools>)toolWithCurrentSetting
{
    switch (_drawType) {
        case XDDrawTypePen:
            return [[XDDrawPenTool alloc] init];
            break;
        case XDDrawTypePoint:
            return [[XDDrawPointTool alloc] init];
            break;
            
        default:
            break;
    }
}

- (void)updateCacheImage:(BOOL)redraw
{
    // init a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw) {
        // erase the previous image
        self.image = nil;
        
        // I need to redraw all the lines
        for (id<XDDrawTools> tool in self.pathArray) {
            [tool draw];
        }
        
    } else {
        // set the draw point
//        [self.image drawAtPoint:CGPointZero];
        [self.drawTool draw];
    }
    
    // store the image
    _imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - UITextViewDelegate



#pragma mark - touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint beginPoint = [touch locationInView:self];
    
    if (self.effectType == XDEffectTypeText) {
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(beginPoint.x, beginPoint.y, self.frame.size.width - beginPoint.x, kTextViewHeightMin)];
        textView.delegate = self;
        textView.textColor = self.drawColor;
        textView.font = [UIFont systemFontOfSize:self.fontSize];
        textView.backgroundColor = self.bgColor;
        [self addSubview:textView];
        [textView becomeFirstResponder];
    }
    else if(self.effectType == XDEffectTypeDraw){
        self.drawTool = [self toolWithCurrentSetting];
        [self.drawTool setInitialPoint:beginPoint];
        [self.pathArray addObject:self.drawTool];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // add the current point to the path
    if(self.effectType == XDEffectTypeDraw && _drawType == XDDrawTypePen){
        CGPoint currentLocation = [touch locationInView:self];
        CGPoint previousLocation = [touch previousLocationInView:self];
        [self.drawTool moveFromPoint:previousLocation toPoint:currentLocation];
        
//#if PARTIAL_REDRAW
//        // calculate the dirty rect
//        CGFloat minX = fmin(previousLocation.x, currentLocation.x) - self.lineWidth * 0.5;
//        CGFloat minY = fmin(previousLocation.y, currentLocation.y) - self.lineWidth * 0.5;
//        CGFloat maxX = fmax(previousLocation.x, currentLocation.x) + self.lineWidth * 0.5;
//        CGFloat maxY = fmax(previousLocation.y, currentLocation.y) + self.lineWidth * 0.5;
//        [self setNeedsDisplayInRect:CGRectMake(minX, minY, (maxX - minX), (maxY - minY))];
//#else
        [self setNeedsDisplay];
//#endif

    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesMoved:touches withEvent:event];
    
    // update the image
    [self updateCacheImage:YES];
    
    // clear the current tool
    self.drawTool = nil;
    
    // clear the redo queue
    [self.bufferArray removeAllObjects];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - public

- (void)setImage:(UIImage *)image
{
    UIImage *img = [self imageWithImageSimple:image scaledToSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    img = [UIImage im];
    _originalImage = [img retain];
    _imageView.image = _originalImage;
}

- (void)processImageToState:(XDProcessState)state
{
    switch (state) {
        case XDProcessStateNormal:
        {
            _imageView.image = _originalImage;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
        case XDProcessStateLomo:
        {
            _imageView.image = [ImageUtil imageWithImage:_originalImage withColorMatrix: colormatrix_lomo];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
        case XDProcessStateBlackAndWhite:
        {
            _imageView.image = [ImageUtil imageWithImage:_originalImage withColorMatrix:colormatrix_heibai];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
        case XDProcessStateBlues:
        {
            _imageView.image = [ImageUtil imageWithImage:_originalImage withColorMatrix:colormatrix_landiao];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
        case XDProcessStateGothic:
        {
            _imageView.image = [ImageUtil imageWithImage:_originalImage withColorMatrix:colormatrix_gete];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
            
        default:
            break;
    }
}

- (void)drawForType:(XDDrawType)type
{
    _drawType = type;
}

@end
