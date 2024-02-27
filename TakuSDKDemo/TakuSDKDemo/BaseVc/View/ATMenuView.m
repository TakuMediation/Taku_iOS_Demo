//
//  ATMenuView.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/9.
//

#import "ATMenuView.h"
#import "ATSelectViewController.h"

@interface ATMenuView()

@property (nonatomic, strong) UILabel *menuTitleLabel;
@property (nonatomic, strong) UILabel * submenuTitleLabel;
@property (nonatomic, strong) UIView *menuLine;

@property (nonatomic, strong) UIButton *menu;

@property (nonatomic, strong) UIButton *subMenu;

@property (nonatomic, strong) UIImageView *menuImage;

@property (nonatomic, strong) UIImageView *subMenuImage;

@property (nonatomic, strong) NSArray *menuList;

@property (nonatomic, strong) NSArray *subMenuList;

@property(nonatomic,strong) UISwitch * autoSwitch;



@end

@implementation ATMenuView

- (instancetype)initWithMenuList:(NSArray *)menuList subMenuList:(NSArray *)subMenuList
{
    if (self = [super init]) {
        _menuList = menuList;
        _subMenuList = subMenuList;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.menuTitleLabel];
    [self addSubview:self.submenuTitleLabel];
    [self addSubview:self.menuLine];
    [self addSubview:self.menu];
    
    [self addSubview:self.autoSwitch];
    
    [self.menu addSubview:self.menuImage];
    
    [self.menuTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kScaleW(22));
        make.left.equalTo(self.mas_left).offset(kScaleW(22));
    }];
    
    [self.menuLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kScaleW(82));
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(kScaleW(1));
    }];
    
    
    
    [self.autoSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kScaleW(10));
        make.right.equalTo(self.mas_right).offset(kScaleW(-22));
    }];
    
    [self.submenuTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kScaleW(22));
        make.right.equalTo(self.autoSwitch.mas_left).offset(kScaleW(-15));
    }];
    
    if (!self.subMenuList) {
        [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(kScaleW(-56));
            make.left.equalTo(self.mas_left).offset(kScaleW(22));
            make.right.equalTo(self.mas_right).offset(kScaleW(-22));
            make.height.mas_equalTo(kScaleW(64));
        }];
    } else {
        [self addSubview:self.subMenu];
        [self.subMenu addSubview:self.subMenuImage];
        
        [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(kScaleW(-56));
            make.left.equalTo(self.mas_left).offset(kScaleW(22));
            make.right.equalTo(self.mas_right).offset(kScaleW(-300));
            make.height.mas_equalTo(kScaleW(64));
        }];
        
        [self.subMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(kScaleW(-56));
            make.left.equalTo(self.menu.mas_right).offset(kScaleW(22));
            make.right.equalTo(self.mas_right).offset(kScaleW(-22));
            make.height.mas_equalTo(kScaleW(64));
        }];
        
        [self.subMenuImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.subMenu.mas_centerY);
            make.width.height.mas_equalTo(kScaleW(34));
            make.right.equalTo(self.subMenu.mas_right).offset(kScaleW(-24));
        }];
    }
    
    [self.menuImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.menu.mas_centerY);
        make.width.height.mas_equalTo(kScaleW(34));
        make.right.equalTo(self.menu.mas_right).offset(kScaleW(-24));
    }];
    
    [self.autoSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    
}


#pragma mark - public
- (void)resetMenuList:(NSArray *)menuList
{
    _menuList = menuList;
    [_menu setTitle:self.menuList.firstObject forState:UIControlStateNormal];
}

- (void)hiddenSubMenu
{
    self.subMenu.hidden = YES;
    
    [self.menu mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(kScaleW(-22));
    }];
   
    
    
}

- (void)showSubMenu
{
    self.subMenu.hidden = NO;
    
    [self.menu mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(kScaleW(-300));
    }];
   
}

-(void)switchChange:(UISwitch*)sender{
    
    if (self.turnOnAuto) {
        self.turnOnAuto(sender.isOn);
    }
}
#pragma mark - Action
- (void)showMenuList
{
    ATSelectViewController *vc = [[ATSelectViewController alloc] initWithSelectList:self.menuList multipleSelection:self.multiple];
    __weak typeof(self) weakSelf = self;
    [vc setSelectBlock:^(NSArray * _Nonnull select) {
        [weakSelf.menu setTitle:select.firstObject forState:UIControlStateNormal];
        if (weakSelf.multiple && weakSelf.selectMenus) {
            weakSelf.selectMenus(select);
            return;
        }
        if (weakSelf.selectMenu) {
            weakSelf.selectMenu(select.firstObject);
        }
        
        [weakSelf.autoSwitch setOn:false];// = false;
        
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[self superViewController] presentViewController:nav animated:YES completion:nil];
}

- (void)showSubMenuList
{
    ATSelectViewController *vc = [[ATSelectViewController alloc] initWithSelectList:self.subMenuList];
    __weak typeof(self) weakSelf = self;
    [vc setSelectBlock:^(NSArray * _Nonnull select) {
        [weakSelf.subMenu setTitle:select.firstObject forState:UIControlStateNormal];
        if (weakSelf.selectSubMenu) {
            weakSelf.selectSubMenu(select.firstObject);
        }
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[self superViewController] presentViewController:nav animated:YES completion:nil];
}

- (UIViewController *)superViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - lazy
- (UILabel *)menuTitleLabel
{
    if (!_menuTitleLabel) {
        _menuTitleLabel = [[UILabel alloc] init];
        _menuTitleLabel.text = @"Select Network";
        _menuTitleLabel.textColor = [UIColor blackColor];
        _menuTitleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _menuTitleLabel;
}

-(UILabel *)submenuTitleLabel{
    if (!_submenuTitleLabel) {
        _submenuTitleLabel = [[UILabel alloc] init];
        _submenuTitleLabel.text = @"Auto";
        _submenuTitleLabel.textColor = [UIColor blackColor];
        _submenuTitleLabel.font = [UIFont systemFontOfSize:16];
        _submenuTitleLabel.hidden = true;
    }
    
    return _submenuTitleLabel;
}
- (UIView *)menuLine
{
    if (!_menuLine) {
        _menuLine = [[UIView alloc] init];
        _menuLine.backgroundColor = kRGB(200, 200, 200);
    }
    return _menuLine;
}

-(UISwitch *)autoSwitch{
    
    if (!_autoSwitch) {
        _autoSwitch = [[ UISwitch alloc]init];
        _autoSwitch.hidden = true;
        _autoSwitch.onTintColor = kRGB(73, 109, 255);
        
    }
    return _autoSwitch;
}
- (UIButton *)menu
{
    if (!_menu) {
        _menu = [[UIButton alloc] init];
        _menu.backgroundColor = [UIColor whiteColor];
        _menu.layer.masksToBounds = YES;
        _menu.layer.cornerRadius = 5;
        _menu.layer.borderWidth = kScaleW(1);
        _menu.layer.borderColor = kRGB(200, 200, 200).CGColor;
        [_menu setTitle:self.menuList.firstObject forState:UIControlStateNormal];
        [_menu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _menu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _menu.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_menu addTarget:self action:@selector(showMenuList) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menu;
}

- (UIButton *)subMenu
{
    if (!_subMenu) {
        _subMenu = [[UIButton alloc] init];
        _subMenu.backgroundColor = [UIColor whiteColor];
        _subMenu.layer.masksToBounds = YES;
        _subMenu.layer.cornerRadius = 5;
        _subMenu.layer.borderWidth = kScaleW(1);
        _subMenu.layer.borderColor = kRGB(200, 200, 200).CGColor;
        [_subMenu setTitle:self.subMenuList.firstObject forState:UIControlStateNormal];
        [_subMenu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _subMenu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _subMenu.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_subMenu addTarget:self action:@selector(showSubMenuList) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subMenu;
}

-(void)setTurnAuto:(BOOL)turnAuto{
    self.autoSwitch.hidden = !turnAuto;
    self.submenuTitleLabel.hidden = !turnAuto;
}
- (UIImageView *)menuImage
{
    if (!_menuImage) {
        _menuImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_icon"]];
    }
    return _menuImage;
}

- (UIImageView *)subMenuImage
{
    if (!_subMenuImage) {
        _subMenuImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_icon"]];
    }
    return _subMenuImage;
}

@end
