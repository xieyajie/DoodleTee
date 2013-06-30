//
//  XDEffectViewController.m
//  DoodleTee
//
//  Created by xie yajie on 13-5-28.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDEffectViewController.h"

#import "XDFinishShowViewController.h"

#define kTagTopView 0
#define kTagNormalBottomSegmented 1
#define kTagActionBottomSegmented 2

#define kTagProcessScroll 0
#define kTagDrawScroll 1
#define kTagTextScroll 2

#define kProcessSelected 0
#define kDrawSelected 1
#define kTextSelected 2

@interface XDEffectViewController ()
{
    AKSegmentedControl *_topView; //顶部操作栏
    UIScrollView *_processScroll; //上部选项栏
    UIScrollView *_clothScroll;   //衣服编辑部分
    UIView *_bottomView;          //底部操作栏
    AKSegmentedControl *_normalSegmentedControl;    //默认情况下底部选项卡
    AKSegmentedControl *_actionSegmentedControl;   //选择某种选项后出现的底部选项卡
    UIView *_bgView;              //上部选项栏选中项背景
    
    XDEffectView *_effectView;   //图片编辑区域
    UIImagePickerController *_imagePicker;
    
    NSInteger _processClickIndex;
    NSInteger _drawClickIndex;
    NSInteger _textClickIndex;
    
    NSMutableDictionary *_cacheClothImages;
    NSInteger _prevSegmentedSelectedIndex;
}

@property (nonatomic, retain) UIImagePickerController *imagePicker;

@end

@implementation XDEffectViewController

@synthesize imagePicker = _imagePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self layoutBottomView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _processScroll.frame.size.width / 5, _processScroll.frame.size.height)];
    _bgView.backgroundColor = [UIColor blueColor];
    _bgView.alpha = 0.8;
    
    _processClickIndex = 0;
    _drawClickIndex = -1;
    _textClickIndex = -1;
    
    _clothScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - _bottomView.frame.size.height)];
    _clothScroll.contentSize = CGSizeMake(_clothScroll.frame.size.width * 1.5, _clothScroll.frame.size.height * 1.5);
    _clothScroll.scrollEnabled = NO;
    [self.view addSubview:_clothScroll];
    
    _topView = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 42.5)];
    _topView.tag = kTagTopView;
    [_topView setSelectedIndex:0];
    [_topView setDelegate:self];
    [self initTopSegmentedView];
    [self.view addSubview:_topView];
    
    _processScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height + 5, self.view.frame.size.width, 45)];
    [self.view addSubview:_processScroll];
    //添加单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processScrollTapAction:)];
    [_processScroll addGestureRecognizer:tap];
    [tap release];
    _processScroll.backgroundColor = [UIColor blackColor];
    _processScroll.alpha = 0.7;
    [self processAction];
    
    UIImageView *cloth = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, _clothScroll.frame.size.width * 1.5, _clothScroll.frame.size.height * 1.5)];
    cloth.center = _clothScroll.center;
    cloth.contentMode = UIViewContentModeScaleAspectFill;
    cloth.image = [UIImage imageNamed:@"clothe_default.png"];
    [_clothScroll addSubview:cloth];
    
    _effectView = [[XDEffectView alloc] initWithFrame:CGRectMake((_clothScroll.frame.size.width - 200) / 2, 120, 200, 250)];
    [_clothScroll addSubview:_effectView];
    
    [cloth release];
    
    _cacheClothImages = [[NSMutableDictionary alloc] init];
    _prevSegmentedSelectedIndex = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];//图像选取器
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
        _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;//过渡类型,有四种
    }
    return _imagePicker;
}

#pragma mark - UIIMagePicker delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//获取图片
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//将拍到的图片保存到相册
    }
    
    [self hideNormalBottomSegmentedControl];
    [_effectView layoutEditorAreaWithObject:image];
    
    if (_processScroll.tag == kTagProcessScroll && _processClickIndex != 0) {
        [self processImageAction:_processClickIndex];
    }

    [self dismissViewControllerAnimated:YES completion:nil];//关闭模态视图控制器
}

#pragma mark - AKSegmentedControl Delegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    if (segmentedControl.tag == kTagTopView) {
        if (_prevSegmentedSelectedIndex != index) {
            id cacheObject = [_effectView cacheWithCurrentContext];
            if (_prevSegmentedSelectedIndex == -1) {
                _prevSegmentedSelectedIndex = 0;
            }
            [_cacheClothImages setObject:cacheObject forKey:[NSString stringWithFormat:@"%d", _prevSegmentedSelectedIndex]];
            _prevSegmentedSelectedIndex = index;
        }
        
        switch (index) {
            case 0:
                [self hideActionBottomSegmentedControl];
                [self processAction];
                break;
            case 1:
                [self hideNormalBottomSegmentedControl];
                [self drawAction];
                break;
            case 2:
                [self hideNormalBottomSegmentedControl];
                [self textAction];
                break;
                
            default:
                break;
        }
    }
    else if (segmentedControl.tag == kTagNormalBottomSegmented)
    {
        switch (index) {
            case 0:
                [self backAction];
                break;
            case 1:
                [self imageAction];
                break;
            case 2:
                [self cameraAction];
                break;
                
            default:
                break;
        }
    }
    else if (segmentedControl.tag == kTagActionBottomSegmented)
    {
        switch (index) {
            case 0:
                [self undoAction];
                break;
            case 1:
                [self doneAction];
                break;
                            
            default:
                break;
        }

    }
}

#pragma mark - UIGestureRecognizer action

//tap
- (void)processScrollTapAction: (UITapGestureRecognizer *)sender
{
    NSInteger index = 0;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        //判断点击的是那个选项
        CGPoint location = [sender locationInView:_processScroll];
        index = location.x / (_processScroll.frame.size.width / 5);
        
        //若是未选中状态
        if (_processScroll.tag == kTagProcessScroll && _processClickIndex != index) {
            _processClickIndex = index;
            [self processImageAction:index];
        }
        else if (_processScroll.tag == kTagDrawScroll && _drawClickIndex != index)
        {
            _drawClickIndex = index;
            [self drawImageAction:index];
        }
        else if(_processScroll.tag == kTagTextScroll && _textClickIndex != index)
        {
            _textClickIndex = index;
            [self textImageAction:index];
        }
    }
}

#pragma mark - private

//设置上部选项栏选中选项时的背景frame
- (void)layoutBgView: (NSInteger)aIndex
{
    CGFloat width = _processScroll.frame.size.width / 5;
    CGFloat height = _processScroll.frame.size.height;
    _bgView.frame = CGRectMake(aIndex * width, 0, width, height);
    [_processScroll addSubview:_bgView];
    [_processScroll sendSubviewToBack:_bgView];
}

- (UIColor *)textColorForIndex:(NSInteger)aIndex
{
    _effectView.bgColor = [UIColor clearColor];
    switch (aIndex) {
        case 0:
            return [UIColor blackColor];
            break;
        case 1:
            return [UIColor blueColor];
            break;
        case 2:
            return [UIColor redColor];
            break;
        case 3:
            _effectView.bgColor = [UIColor blackColor];
            return [UIColor whiteColor];
            break;
        case 4:
            _effectView.bgColor = [UIColor blueColor];
            return [UIColor whiteColor];
            break;
            
        default:
            return [UIColor blackColor];
            break;
    }
}

- (void)hideActionBottomSegmentedControl
{
    _actionSegmentedControl.hidden = YES;
    _normalSegmentedControl.hidden = NO;
}

- (void)hideNormalBottomSegmentedControl
{
    _actionSegmentedControl.hidden = NO;
    _normalSegmentedControl.hidden = YES;
}

- (void)layoutBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 62.5, self.view.frame.size.width, 62.5)];
    _bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomView.layer.shadowOpacity = 1.0;
    _bottomView.layer.shadowRadius = 10.0;
    _bottomView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    UIImageView *bottomImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomBarBg.png"]];
    bottomImgView.frame = CGRectMake(0, 0, _bottomView.frame.size.width, _bottomView.frame.size.height);
    [_bottomView addSubview:bottomImgView];
    [bottomImgView release];
    
    [self initBottomSegmentedView];
    [self.view addSubview:_bottomView];
}

#pragma mark - other

- (void)initTopSegmentedView
{
    CGFloat width = _topView.frame.size.width / 3;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"functionBarBg.png"];
    [_topView setBackgroundImage:backgroundImage];
    [_topView setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [_topView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    [_topView setSeparatorImage:[UIImage imageNamed:@"segmented_separator.png"]];
    
    UIImage *buttonBackgroundImagePressedLeft = [UIImage imageNamed:@"effect_segmented_pressed_left.png"];
    UIImage *buttonBackgroundImagePressedCenter = [UIImage imageNamed:@"effect_segmented_pressed_center.png"];
    UIImage *buttonBackgroundImagePressedRight = [UIImage imageNamed:@"effect_segmented_pressed_right.png"];
    
    //图像处理
    UIButton *buttonProcess = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, _topView.frame.size.height)];
    buttonProcess.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonProcess.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonProcess setTitle:@"图像" forState:UIControlStateNormal];
    [buttonProcess setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonProcess.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonProcess setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    [buttonProcess setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    
    UIImage *buttonProcessImageNormal = [UIImage imageNamed:@"effect_photograph_icon.png"];
    [buttonProcess setImage:buttonProcessImageNormal forState:UIControlStateNormal];
    [buttonProcess setImage:buttonProcessImageNormal forState:UIControlStateSelected];
    
    //自定义绘图
    UIButton *buttonDraw = [[UIButton alloc] initWithFrame:CGRectMake(buttonProcess.frame.origin.x + buttonProcess.frame.size.width, 0, width, _topView.frame.size.height)];
    buttonDraw.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonDraw.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonDraw setTitle:@"涂鸦" forState:UIControlStateNormal];
    [buttonDraw setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonDraw.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonDraw setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    [buttonDraw setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
    
    UIImage *buttonDrawImageNormal = [UIImage imageNamed:@"effect_draw_icon.png"];
    [buttonDraw setImage:buttonDrawImageNormal forState:UIControlStateNormal];
    [buttonDraw setImage:buttonDrawImageNormal forState:UIControlStateSelected];
    
    //添加文字
    UIButton *buttonTitle = [[UIButton alloc] initWithFrame:CGRectMake(buttonDraw.frame.origin.x + buttonDraw.frame.size.width, 0, width, _topView.frame.size.height)];
    buttonTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonTitle.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonTitle setTitle:@"文字" forState:UIControlStateNormal];
    [buttonTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonTitle.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonTitle setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    [buttonTitle setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    
    UIImage *buttonTitleImageNormal = [UIImage imageNamed:@"effect_text_icon.png"];
    [buttonTitle setImage:buttonTitleImageNormal forState:UIControlStateNormal];
    [buttonTitle setImage:buttonTitleImageNormal forState:UIControlStateSelected];
    
    [_topView setButtonsArray:@[buttonProcess, buttonDraw, buttonTitle]];
    [buttonProcess release];
    [buttonDraw release];
    [buttonTitle release];
}

- (void)initNormalBottomSegmentedControl
{
    _normalSegmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(14, 12, _bottomView.frame.size.width - 14 * 2, 35)];
    _normalSegmentedControl.tag = kTagNormalBottomSegmented;
    [_normalSegmentedControl setSegmentedControlMode: AKSegmentedControlModeButton];
    [_normalSegmentedControl setDelegate:self];
    _normalSegmentedControl.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:_normalSegmentedControl];
    
    CGFloat width = _normalSegmentedControl.frame.size.width / 3;
    [_normalSegmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented_separator.png"]];
    
    //返回
    UIButton *buttonback = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, _normalSegmentedControl.frame.size.height)];
    buttonback.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonback.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonback setTitle:@"返回" forState:UIControlStateNormal];
    [buttonback setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonback.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonback setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    UIImage *buttonBackNormal = [UIImage imageNamed:@"effect_image_icon.png"];
    [buttonback setImage:buttonBackNormal forState:UIControlStateNormal];
    
    // 相册
    UIButton *buttonImage = [[UIButton alloc] initWithFrame:CGRectMake(buttonback.frame.origin.x + buttonback.frame.size.width, 0, width, _normalSegmentedControl.frame.size.height)];
    buttonImage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonImage.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonImage setTitle:@"相册" forState:UIControlStateNormal];
    [buttonImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonImage.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonImage setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"effect_image_icon.png"];
    [buttonImage setImage:buttonImageNormal forState:UIControlStateNormal];
    
    //相机
    UIButton *buttonCamera = [[UIButton alloc] initWithFrame:CGRectMake(buttonImage.frame.origin.x + buttonImage.frame.size.width, 0, width, _normalSegmentedControl.frame.size.height)];
    buttonCamera.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonCamera.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonCamera setTitle:@"相机" forState:UIControlStateNormal];
    [buttonCamera setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonCamera.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonCamera setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    UIImage *buttonCameraImageNormal = [UIImage imageNamed:@"effect_camera_icon.png"];
    [buttonCamera setImage:buttonCameraImageNormal forState:UIControlStateNormal];
    
    [_normalSegmentedControl setButtonsArray:@[buttonback, buttonImage, buttonCamera]];
    [buttonback release];
    [buttonImage release];
    [buttonCamera release];
}

- (void)initActionBottomSegmentedControl
{
    _actionSegmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(14, 12, _bottomView.frame.size.width - 14 * 2, 35)];
    _actionSegmentedControl.tag = kTagActionBottomSegmented;
    [_actionSegmentedControl setSegmentedControlMode: AKSegmentedControlModeButton];
    [_actionSegmentedControl setDelegate:self];
    _actionSegmentedControl.backgroundColor = [UIColor clearColor];
    _actionSegmentedControl.hidden = YES;
    [_bottomView addSubview:_actionSegmentedControl];
    
    CGFloat width = _actionSegmentedControl.frame.size.width / 2;
    [_actionSegmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented_separator.png"]];
    
    //重来
    UIButton *buttonUndo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, _normalSegmentedControl.frame.size.height)];
    buttonUndo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonUndo.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonUndo setTitle:@"重来" forState:UIControlStateNormal];
    [buttonUndo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonUndo.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonUndo setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    UIImage *buttonUndoNormal = [UIImage imageNamed:@"effect_image_icon.png"];
    [buttonUndo setImage:buttonUndoNormal forState:UIControlStateNormal];
    
    //完成
    UIButton *buttonDone = [[UIButton alloc] initWithFrame:CGRectMake(buttonUndo.frame.origin.x + buttonUndo.frame.size.width, 0, width, _actionSegmentedControl.frame.size.height)];
    buttonDone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonDone.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonDone setTitle:@"完成" forState:UIControlStateNormal];
    [buttonDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonDone.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonDone setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    UIImage *buttonDoneNormal = [UIImage imageNamed:@"effect_image_icon.png"];
    [buttonDone setImage:buttonDoneNormal forState:UIControlStateNormal];
    
    [_actionSegmentedControl setButtonsArray:@[buttonUndo, buttonDone]];
    [buttonUndo release];
    [buttonDone release];
}

- (void)initBottomSegmentedView
{
    [self initNormalBottomSegmentedControl];
    [self initActionBottomSegmentedControl];
}

- (void)processAction
{
    _clothScroll.scrollEnabled = NO;
    _processScroll.tag = kTagProcessScroll;
    [_effectView setEffectType:XDEffectTypeProcess];
    id cacheObject = [_cacheClothImages objectForKey:[NSString stringWithFormat:@"%d", _processScroll.tag]];
    [_effectView layoutEditorAreaWithObject:cacheObject];
    
    for (UIView *view in _processScroll.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = _processScroll.frame.size.width / 5;
    CGFloat height = _processScroll.frame.size.height;
    for(int i = 0; i < 5; i++)
    {
        NSString *imgName = [[NSString alloc] initWithFormat:@"%@_%i.png", @"effect", i];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        imgView.frame = CGRectMake(i * width, 0, width, height);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_processScroll addSubview:imgView];
        
        [imgView release];
        [imgName release];
    }
    
    if (_processClickIndex > -1) {
        [self layoutBgView:_processClickIndex];
    }
}

- (void)drawAction
{
    _clothScroll.scrollEnabled = NO;
    _processScroll.tag = kTagDrawScroll;
    [_effectView setEffectType:XDEffectTypeDraw];
    id cacheObject = [_cacheClothImages objectForKey:[NSString stringWithFormat:@"%d", _processScroll.tag]];
    [_effectView layoutEditorAreaWithObject:cacheObject];
    
    for (UIView *view in _processScroll.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = _processScroll.frame.size.width / 5;
    CGFloat height = _processScroll.frame.size.height;
    for(int i = 0; i < 5; i++)
    {
        NSString *imgName = [[NSString alloc] initWithFormat:@"%@_%i.png", @"stroke", i];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        imgView.frame = CGRectMake(i * width, 0, width, height);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_processScroll addSubview:imgView];
        
        [imgView release];
        [imgName release];
    }
}

- (void)textAction
{
    _clothScroll.scrollEnabled = YES;
    _clothScroll.alwaysBounceHorizontal = YES;
    _clothScroll.alwaysBounceVertical = NO;
    
    _processScroll.tag = kTagTextScroll;
    [_effectView setEffectType:XDEffectTypeText];
    id cacheObject = [_cacheClothImages objectForKey:[NSString stringWithFormat:@"%d", _processScroll.tag]];
    [_effectView layoutEditorAreaWithObject:cacheObject];
    
    for (UIView *view in _processScroll.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = _processScroll.frame.size.width / 5;
    CGFloat height = _processScroll.frame.size.height;
    for(int i = 0; i < 5; i++)
    {
        NSString *imgName = [[NSString alloc] initWithFormat:@"%@_%i.png", @"font", i];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        imgView.frame = CGRectMake(i * width, 0, width, height);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_processScroll addSubview:imgView];
        
        [imgView release];
        [imgName release];
    }
}

- (void)processImageAction: (NSInteger)aIndex
{
    [self layoutBgView:aIndex];
    [_effectView processImageToState:aIndex];
}

- (void)drawImageAction: (NSInteger)aIndex
{
    [self layoutBgView:aIndex];
    
    switch (aIndex) {
        case 3:
            [_effectView drawForType:XDDrawTypePen];
            break;
        case 4:
            [_effectView drawForType:XDDrawTypePen];
            break;
            
        default:
            break;
    }
}

- (void)textImageAction: (NSInteger)aIndex
{
    [self layoutBgView:aIndex];
    _effectView.drawColor = [self textColorForIndex:aIndex];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageAction
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
    self.imagePicker.allowsEditing = NO;//禁止对图片进行编辑
    
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];//打开模态视图控制器选择图像
    
    NSLog(@"image");
}

- (void)cameraAction
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//照片来源为相机
        
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备没有照相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)undoAction
{
    if (_effectView.effectType == XDEffectTypeProcess) {
        [self hideActionBottomSegmentedControl];
    }
    [_effectView undo];
}

- (void)doneAction
{
    XDFinishShowViewController *finishViewCOntroller = [[XDFinishShowViewController alloc] init];
    [self.navigationController pushViewController:finishViewCOntroller animated:YES];
    [finishViewCOntroller release];
}

@end
