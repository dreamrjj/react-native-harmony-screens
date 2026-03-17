/**
 * MIT License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { RNC } from '../generated/ts';
import { RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNSScreenStackHeaderConfigDescriptor } from './RNSScreenStackHeaderConfig';
import { RNSScreenStackHeaderSubview, RNSScreenStackHeaderSubviewDescriptor } from './RNSScreenStackHeaderSubview';
import { RNSSearchBarDescriptor } from './RNSSearchBar';
import { obtainImageInfoFromPath } from '../utils/Utils';
import { image } from '@kit.ImageKit';
import { resourceManager } from '@kit.LocalizationKit';

interface GeneratedTypeLiteralInterface_1 {
  type: string;
  imageSource: number;
}

interface GeneratedTypeLiteralInterface_2 {
  fontFamily?: string;
  fontSize?: number;
  fontWeight?: string;
  color?: string;
}

interface GeneratedTypeLiteralInterface_4 {
  color: string;
  backgroundColor: string;
}

interface GeneratedTypeLiteralInterface_3 {
  value: string;
  style?: GeneratedTypeLiteralInterface_4;
}

interface GeneratedTypeLiteralInterface_8 {
  type: string;
  name: string;
}

interface GeneratedTypeLiteralInterface_6 {
  label: string;
  sfSymbolName?: string;
  icon?: GeneratedTypeLiteralInterface_8;
  items: GeneratedTypeLiteralInterface_9[];
  type: string;
  state?: string;
  attributes?: string;
  discoverabilityLabel?: string;
  onPress?: () => void;
  menuId?: string;
}

interface GeneratedTypeLiteralInterface_9 {
  label: string;
  sfSymbolName?: string;
  icon?: GeneratedTypeLiteralInterface_8;
  state?: string;
  attributes?: string;
  discoverabilityLabel?: string;
  onPress?: () => void;
  menuId?: string;
}

interface GeneratedTypeLiteralInterface_7 {
  width: number;
  uri: string;
  height: number;
  scale: number;
}

interface GeneratedTypeLiteralInterface_5 {
  label: string;
  items: GeneratedTypeLiteralInterface_6[];
}

interface BarButtonItem {
  label?: string;
  icon?: GeneratedTypeLiteralInterface_1;
  imageSource?: GeneratedTypeLiteralInterface_7;
  labelStyle?: GeneratedTypeLiteralInterface_2;
  tintColor?: string;
  badge?: GeneratedTypeLiteralInterface_3;
  disabled?: boolean;
  variant?: string;
  menu?: GeneratedTypeLiteralInterface_5;
  spacing?: number;
  sharesBackground?: boolean;
  selected?: boolean;
  changesSelectionAsPrimaryAction?: boolean;
  hidesSharedBackground?: boolean;
  buttonId?: string;
  iconPixelMap?: image.PixelMap;
  onPress?: () => void;
};

@Component
export struct RNSScreenTitleHeader {
  public static readonly NAME = RNC.RNSScreenStackHeaderConfig.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  private eventEmitter: RNC.RNSScreenStackHeaderConfig.EventEmitter | undefined = undefined
  @State isFirstScreenInStack: boolean = true;
  public screenStackHeaderConfigTag!: number
  @State descriptor: RNSScreenStackHeaderConfigDescriptor | undefined = undefined
  @State nativeTitleText: string = "";
  @State fontFamilyValue: string | undefined = undefined;
  @State titleFontSizeValue: string | undefined = undefined;
  @State titleFontWeightValue: string | undefined = undefined;
  @State titleColorValue: string | undefined = undefined;
  @State backgroundColorValue: string | undefined = undefined;
  @State isTitleBarHidden: boolean = false;
  @State hideShadow: boolean = false;
  @State backTitle: string | undefined = undefined;
  @State backTitleFontFamily: string | undefined = undefined;
  @State backTitleFontSize: number | undefined = undefined;
  @State backTitleVisible: boolean | undefined = undefined;
  @State hideBackButton: boolean | undefined = undefined;
  @State backButtonInCustomView: boolean | undefined = undefined;
  @State titleBarTranslucent: boolean = false;
  @State blurEffect: 'none' | 'extraLight' | 'light' | 'dark' | 'regular' | 'prominent' | 'systemUltraThinMaterial' | 'systemThinMaterial' | 'systemMaterial' | 'systemThickMaterial' | 'systemChromeMaterial' | 'systemUltraThinMaterialLight' | 'systemThinMaterialLight' | 'systemMaterialLight' | 'systemThickMaterialLight' | 'systemChromeMaterialLight' | 'systemUltraThinMaterialDark' | 'systemThinMaterialDark' | 'systemMaterialDark' | 'systemThickMaterialDark' | 'systemChromeMaterialDark' =
    'none';
  @State blueStyle: BlurStyle = BlurStyle.NONE;
  @State hintColor: string | undefined = undefined;
  @State headerLeftBarButtonItemsValue: object[] | undefined = []
  @State headerRightBarButtonItemsValue: object[] | undefined = []
  @State newHeaderRightBarButtonItems: object[] = []
  @State newBarButtonItem: BarButtonItem = {} as BarButtonItem
  @State iconPixelMap: image.PixelMap | undefined = undefined
  @State iconPixelMapArray: Map<string, image.PixelMap> = new Map();
  @State isTranslate: boolean = false; // 背景色是否有alpha透明度
  @State hideNavigationBar: boolean = true;
  @State isSearchActive: boolean = false;
  private cleanUpCallbacks: (() => void)[] = []
  public backBtnPressed: () => void = () => {
  }

  aboutToAppear(): void {
    if (!!!this.screenStackHeaderConfigTag) {
      return;
    }
    this.eventEmitter =
      new RNC.RNSScreenStackHeaderConfig.EventEmitter(this.ctx.rnInstance, this.screenStackHeaderConfigTag)
    this.descriptor =
      this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderConfigDescriptor>(this.screenStackHeaderConfigTag)
    console.info(`RNSScreenTitleHeader descriptor:${JSON.stringify(this.descriptor)}`)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.screenStackHeaderConfigTag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenStackHeaderConfigDescriptor)
        this.updateState()
      }))
    this.updateState()
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  blurEffectConvert() {
    if (this.blurEffect) {
      switch (this.blurEffect) {
        case 'none':
          this.blueStyle = BlurStyle.NONE;
          break;
        case 'extraLight':
          this.blueStyle = BlurStyle.BACKGROUND_THIN;
          break;
        case 'light':
          this.blueStyle = BlurStyle.BACKGROUND_THICK;
          break;
        case 'dark':
          this.blueStyle = BlurStyle.BACKGROUND_ULTRA_THICK;
          break;
        case 'regular':
          this.blueStyle = BlurStyle.BACKGROUND_REGULAR;
          break;
        case 'prominent':
        case 'systemMaterial':
        case 'systemMaterialLight':
        case 'systemMaterialDark':
        case 'systemUltraThinMaterial':
        case 'systemUltraThinMaterialLight':
        case 'systemUltraThinMaterialDark':
        case 'systemThinMaterial':
        case 'systemThinMaterialLight':
        case 'systemThinMaterialDark':
        case 'systemThickMaterial':
        case 'systemThickMaterialLight':
        case 'systemThickMaterialDark':
        case 'systemChromeMaterial':
        case 'systemChromeMaterialLight':
        case 'systemChromeMaterialDark':
          this.ctx.logger.error('RNSScreenStackHeaderConfig', this.blurEffect + " not support")
          break;
      }
    }
  }

  async updateState() {
    const rm = this.ctx.uiAbilityContext.resourceManager
    if (!this.descriptor) {
      return
    }
    this.hideShadow = this.descriptor.rawProps["hideShadow"];
    const shouldDisplayNativeTitle = this.descriptor.childrenTags.length > 0 ?
      this.descriptor.childrenTags.every((e) => {
        const tmpDesc = this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderSubviewDescriptor>(e)
        if (tmpDesc.rawProps["type"] === "title" || tmpDesc.rawProps["type"] === "center" ||
          tmpDesc.rawProps["type"] === "left") {
          return false;
        }
        return true;
      }) : true;

    const newNativeTitleText: string = shouldDisplayNativeTitle ? this.descriptor.rawProps["title"] : " ";
    if (this.nativeTitleText !== newNativeTitleText) {
      this.nativeTitleText = newNativeTitleText;
    }
    if (this.fontFamilyValue !== this.descriptor.rawProps["titleFontFamily"]) {
      this.fontFamilyValue = this.descriptor.rawProps["titleFontFamily"]
    }
    if (this.titleFontSizeValue !== this.descriptor.rawProps["titleFontSize"]) {
      this.titleFontSizeValue = this.descriptor.rawProps["titleFontSize"]
    }
    if (this.titleFontWeightValue !== this.descriptor.rawProps["titleFontWeight"]) {
      this.titleFontWeightValue = this.descriptor.rawProps["titleFontWeight"]
    }
    if (this.backgroundColorValue !== this.descriptor.rawProps["backgroundColor"]) {
      this.backgroundColorValue = this.descriptor.rawProps["backgroundColor"] || "#ffffff"
    }

    if (this.backTitle !== this.descriptor.rawProps["backTitle"]) {
      this.backTitle = this.descriptor.rawProps["backTitle"]
    }
    console.info(`RNSScreenTitleHeader backTitle:${this.backTitle}`)
    if (this.backTitleFontFamily !== this.descriptor.rawProps["backTitleFontFamily"]) {
      this.backTitleFontFamily = this.descriptor.rawProps["backTitleFontFamily"]
    }

    if (this.backTitleFontSize !== this.descriptor.rawProps["backTitleFontSize"]) {
      this.backTitleFontSize = this.descriptor.rawProps["backTitleFontSize"]
    }

    if (this.backTitleVisible !== this.descriptor.rawProps["backTitleVisible"]) {
      this.backTitleVisible = this.descriptor.rawProps["backTitleVisible"]
    }
    console.info(`RNSScreenTitleHeader backTitleVisible:${this.backTitleVisible}`)
    if (this.hideBackButton !== this.descriptor.rawProps["hideBackButton"]) {
      this.hideBackButton = this.descriptor.rawProps["hideBackButton"]
    }

    if (this.backButtonInCustomView !== this.descriptor.rawProps["backButtonInCustomView"]) {
      this.backButtonInCustomView = this.descriptor.rawProps["backButtonInCustomView"]
    }

    if (this.titleBarTranslucent !== this.descriptor.rawProps["translucent"]) {
      this.titleBarTranslucent = this.descriptor.rawProps["translucent"];
    }

    if (this.blurEffect !== this.descriptor.rawProps["blurEffect"]) {
      this.blurEffect = this.descriptor.rawProps["blurEffect"];
    }

    let tmpColor: string | undefined = this.descriptor.rawProps["color"];
    if (this.hintColor !== tmpColor) {
      this.hintColor = tmpColor;
    }

    let tmpTitleColor: string | undefined = this.descriptor.rawProps["titleColor"];
    if (this.titleColorValue !== tmpTitleColor) {
      this.titleColorValue = tmpTitleColor;
    }

    let headerLeftBarButtonItems: object[] | undefined = this.descriptor.rawProps["headerLeftBarButtonItems"];
    if (this.headerLeftBarButtonItemsValue !== headerLeftBarButtonItems) {
      this.headerLeftBarButtonItemsValue = headerLeftBarButtonItems;
    }
    console.info(`RNSScreenTitleHeader headerLeftBarButtonItemsValue:${JSON.stringify(this.headerLeftBarButtonItemsValue)}`)
    let headerRightBarButtonItems: object[] | undefined = this.descriptor.rawProps["headerRightBarButtonItems"];
    if (this.headerRightBarButtonItemsValue !== headerRightBarButtonItems) {
      this.headerRightBarButtonItemsValue = headerRightBarButtonItems;
    }
    if (this.headerRightBarButtonItemsValue && this.headerRightBarButtonItemsValue.length > 0) {
      // 清空数组，确保每次更新时都是从空数组开始
      this.newHeaderRightBarButtonItems = [];
      for (let i = 0; i < this.headerRightBarButtonItemsValue?.length; i++) {
        console.info(`RNSScreenTitleHeader headerLeftBarButtonItemsValue**:${JSON.stringify(this.headerRightBarButtonItemsValue[i])}`)
        await this.getIconPixelMap(rm, this.headerRightBarButtonItemsValue[i])
      }
    }
    this.isTranslate = hasTransparency(this.backgroundColorValue);
    this.blurEffectConvert();

    // Resolve hideNavigationBar from child RNSSearchBar descriptor
    for (let i = 0; i < this.descriptor.childrenTags.length; i++) {
      const subviewTag = this.descriptor.childrenTags[i];
      const subviewDesc = this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderSubviewDescriptor>(subviewTag);
      if (subviewDesc?.rawProps["type"] === "searchBar" && subviewDesc.childrenTags.length > 0) {
        const searchBarTag = subviewDesc.childrenTags[0];
        const searchBarDesc = this.ctx.descriptorRegistry.getDescriptor<RNSSearchBarDescriptor>(searchBarTag);
        const rawHideNav = searchBarDesc?.rawProps?.["hideNavigationBar"] as string | boolean;
        this.hideNavigationBar = (rawHideNav === false || rawHideNav === "false") ? false : true;
        break;
      }
    }
  }

  async getIconPixelMap(rm: resourceManager.ResourceManager, item: BarButtonItem) {
    console.info(`RNSScreenTitleHeader item:${JSON.stringify(item)}`)
    let uri: string | undefined = undefined
    if (item.imageSource && item.imageSource?.uri) {
      uri = typeof item.imageSource.uri === 'string' ? item.imageSource.uri :
        String(item.imageSource.uri)
    }
    console.info(`RNSScreenTitleHeader uri:${uri}`)
    console.info(`RNSScreenTitleHeader uri buttonId:${item?.buttonId}`)
    try {
      if (uri) {
        const info = await obtainImageInfoFromPath(rm, uri);
        console.info(`RNSScreenTitleHeader info:${JSON.stringify(info)}`)
        const iconPixelMap = await info.imageSource.createPixelMap();
        console.info(`RNSScreenTitleHeader iconPixelMap:${iconPixelMap}`)
        // 创建一个新对象，保留原有属性并添加iconPixelMap
        const updatedItem: BarButtonItem = {
          label: item.label,
          icon: item.icon,
          imageSource: item.imageSource,
          labelStyle: item.labelStyle,
          tintColor: item.tintColor,
          badge: item.badge,
          disabled: item.disabled,
          variant: item.variant,
          menu: item.menu,
          spacing: item.spacing,
          sharesBackground: item.sharesBackground,
          selected: item.selected,
          changesSelectionAsPrimaryAction: item.changesSelectionAsPrimaryAction,
          hidesSharedBackground: item.hidesSharedBackground,
          buttonId: item.buttonId,
          iconPixelMap: iconPixelMap,
          onPress: item.onPress
        };
        console.info(`RNSScreenTitleHeader updatedItem iconPixelMap exists:${updatedItem.iconPixelMap !== undefined &&
          updatedItem.iconPixelMap !== null}`)
        console.info(`RNSScreenTitleHeader updatedItem label:${updatedItem.label}`)
        this.newHeaderRightBarButtonItems.push(updatedItem)
      } else {
        // 直接添加原item，不做修改
        this.newHeaderRightBarButtonItems.push(item)
      }
      console.info(`RNSScreenTitleHeader newHeaderRightBarButtonItems length:${this.newHeaderRightBarButtonItems.length}`)
    } catch (e) {
      console.error('RNSBottomTabs icon obtainImageInfoFromPath error: ' + e)
      // 出错时直接添加原item
      this.newHeaderRightBarButtonItems.push(item)
    }
  }

  // 转换字体权重
  getFontWeight(weight?: string): number {
    switch (weight) {
      case 'bold':
        return FontWeight.Bold;
      case 'medium':
        return FontWeight.Medium;
      case 'light':
        return FontWeight.Lighter;
      default:
        return FontWeight.Normal;
    }
  }

  @Builder
  renderButton(item: BarButtonItem) {
    Button({ type: ButtonType.Capsule, stateEffect: true }) {
      Row() {
        if (item.iconPixelMap) {
          Image(item.iconPixelMap)
            .width(24)
        }
        Text(item.label || '')
          .fontSize(item.labelStyle?.fontSize || 16)
          .textAlign(TextAlign.Center)
          .fontWeight(this.getFontWeight(item.labelStyle?.fontWeight))
          .fontColor(item.labelStyle?.color ? item.labelStyle.color : item.tintColor || Color.Black)
          .fontFamily(item.labelStyle?.fontFamily || 'sans-serif')
      }
      .padding(10)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .backgroundColor('#F1EDEE')
    .onClick(() => {
      if (!item.disabled) {
        this.eventEmitter?.emit('onPressHeaderBarButtonItem', {
          buttonId: item.buttonId
        })
      }
    })
    .bindMenu(this.menuBuilder(item))
  }

  @Builder
  menuBuilder(item: BarButtonItem) {
    Menu() {
      ForEach(item?.menu?.items, (menuItem: GeneratedTypeLiteralInterface_6) => {
        if (menuItem.type == 'action') {
          MenuItem({ content: menuItem.label })
            .onClick(() => {
              this.eventEmitter?.emit('onPressHeaderBarButtonMenuItem', {
                menuId: menuItem.menuId
              })
            });
        } else if (menuItem.type === 'submenu' && menuItem.items) {
          MenuItemGroup() {
            MenuItem({
              content: menuItem.label,
              builder: (): void => this.SubMenu(menuItem.items)
            })
          }
        }
      });
    }
  }
@Builder
  SubMenu(items:GeneratedTypeLiteralInterface_9[]){
    Menu() {
      ForEach(items, (menuItem: GeneratedTypeLiteralInterface_9) => {
        MenuItem({ content: menuItem.label })
          .onClick(() => {
            this.eventEmitter?.emit('onPressHeaderBarButtonMenuItem', {
              menuId: menuItem.menuId
            })
          });
      });
    }
  }

  build() {
    RelativeContainer() {
      if (this.screenStackHeaderConfigTag) {
        Stack() {
          if (this.headerLeftBarButtonItemsValue && this.headerLeftBarButtonItemsValue?.length > 0 ||
            this.newHeaderRightBarButtonItems && this.newHeaderRightBarButtonItems?.length > 0) {
            Row() {
              Row() {
                SymbolGlyph($r('sys.symbol.arrow_left')).fontSize(26).fontColor([this.hintColor])
                if (this.backTitleVisible) {
                  Text(this.backTitle ? this.backTitle : '')
                    .fontFamily(this.backTitleFontFamily)
                    .fontSize(this.backTitleFontSize ? this.backTitleFontSize : 18)
                    .fontColor(this.hintColor)
                    .margin({
                      left: this.hideBackButton ? 0 : 5,
                      right: (this.backTitleVisible && this.backTitle) ? 5 : 0
                    })
                }
              }
              .height(56)
              .onClick(() => {
                if (this.backBtnPressed) {
                  this.backBtnPressed();
                }
              })

              if (this.headerLeftBarButtonItemsValue && this.headerLeftBarButtonItemsValue?.length > 0) {
                Row() {
                  ForEach(this.headerLeftBarButtonItemsValue, (item: BarButtonItem, index: number) => {
                    if (item.badge) {
                      // 处理带徽章的按钮
                      Badge({
                        count: parseInt(item.badge.value),
                        style: {
                          color: item.badge.style?.color || Color.White,
                          badgeColor: item.badge.style?.backgroundColor || Color.Red
                        }
                      }) {
                        this.renderButton(item)
                      }
                    } else {
                      // 处理普通按钮
                      this.renderButton(item)
                    }
                  });
                }
                .width('35%')
                .height('100%')
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.Start)
              } else {
                Blank()
              }
              Column() {
                Text(this.nativeTitleText)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                  .fontSize(18)
                  .textAlign(TextAlign.Center)
              }
              .justifyContent(FlexAlign.Center)
              .width(120)
              .height('100%')

              if (this.newHeaderRightBarButtonItems && this.newHeaderRightBarButtonItems?.length > 0) {
                Row({ space: 0 }) {
                  ForEach(this.newHeaderRightBarButtonItems, (item: BarButtonItem, index: number) => {
                    if (item.badge) {
                      // 处理带徽章的按钮
                      Badge({
                        count: parseInt(item.badge.value),
                        style: {
                          color: item.badge.style?.color || Color.White,
                          badgeColor: item.badge.style?.backgroundColor || Color.Red
                        }
                      }) {
                        this.renderButton(item)
                      }
                    } else {
                      // 处理普通按钮
                      this.renderButton(item)
                    }
                  });
                }
                .width('35%')
                .height('100%')
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.End)
              } else {
                Blank()
              }
            }
            .width("100%")
            .height("100%")
            .layoutWeight(1)
            .padding({ top: 25 })
            .hitTestBehavior(HitTestMode.Transparent)
          } else {
            Row() {
              if (!this.isFirstScreenInStack && !this.hideBackButton &&
                (!this.isSearchActive || !this.hideNavigationBar)) {
                Row() {
                  SymbolGlyph($r('sys.symbol.arrow_left')).fontSize(26).fontColor([this.hintColor])

                  if (this.backTitleVisible) {
                    Text(this.backTitle ? this.backTitle : '')
                      .fontFamily(this.backTitleFontFamily)
                      .fontSize(this.backTitleFontSize ? this.backTitleFontSize : 18)
                      .fontColor(this.hintColor)
                      .margin({
                        left: this.hideBackButton ? 0 : 5,
                        right: (this.backTitleVisible && this.backTitle) ? 5 : 0
                      })
                  }
                }.height(56)
                .onClick(() => {
                  if (this.backBtnPressed) {
                    this.backBtnPressed();
                  }
                })
              }
              if (!this.isSearchActive || !this.hideNavigationBar) {
                Text(this.nativeTitleText)
                  .height("100%")
                  .fontFamily(this.fontFamilyValue)
                  .fontSize(this.titleFontSizeValue ? this.titleFontSizeValue : 18)
                  .fontWeight(this.titleFontWeightValue ? this.titleFontWeightValue : FontWeight.Medium)
                  .fontColor(this.titleColorValue ? this.titleColorValue : this.hintColor)
                  .textAlign(TextAlign.Start)
              }
            }
            .width("100%")
            .height("100%")
            .layoutWeight(1)
            .hitTestBehavior(HitTestMode.Transparent)

            Stack() {
              if (this.descriptor) {
                ForEach(this.descriptor.childrenTags, (childTag: number) => {
                  RNSScreenStackHeaderSubview({
                    ctx: this.ctx,
                    tag: childTag,
                    isFirstScreenInStack: this.isFirstScreenInStack,
                    onSearchFocusChange: (focused: boolean) => {
                      this.isSearchActive = focused
                    }
                  })
                })
              }
            }
            .width("100%")
            .height("100%")
            .layoutWeight(1)
            .hitTestBehavior(HitTestMode.Transparent)
          }
        }
        .width("100%")
        .height(56)
        .layoutWeight(1)
        .padding({ left: 10, right: 10 })
        .backgroundColor(this.titleBarTranslucent ? Color.Transparent : this.backgroundColorValue)
        .backgroundBlurStyle(this.isTranslate ? this.blueStyle : BlurStyle.NONE)

        Text('')
          .width("100%")
          .height("1")
          .backgroundColor('#d3d3d3')
          .visibility(this.hideShadow ? Visibility.None : Visibility.Visible)
          .alignRules({
            start: { anchor: "__container__", align: HorizontalAlign.Start },
            top: { anchor: "__container__", align: VerticalAlign.Bottom }
          })
      }
    }
    .onAppear(() => {
      this.onPageShow();
    })
    .width("100%")
    .height(56)
    .layoutWeight(1)
    .hitTestBehavior(HitTestMode.Transparent)
  }

  onPageShow(): void {
    if (!this.descriptor) {
      return;
    }
  }
}

export function hasTransparency(color: string | undefined): boolean {
  if (!!!color) {
    return false;
  }
  // 移除所有空格并转为小写
  const normalizedColor = color.replace(/\s/g, '').toLowerCase();

  // 检查 RGBA
  const rgbaMatch = normalizedColor.match(/rgba\([^)]+,\s*([\d.]+)\)/);
  if (rgbaMatch) {
    return parseFloat(rgbaMatch[1]) < 1;
  }

  // 检查 HSLA
  const hslaMatch = normalizedColor.match(/hsla\([^)]+,\s*([\d.]+)\)/);
  if (hslaMatch) {
    return parseFloat(hslaMatch[1]) < 1;
  }

  // 检查 8 位 HEX
  const hexMatch = normalizedColor.match(/^#([a-f0-9]{8})$/);
  if (hexMatch) {
    const alphaHex = hexMatch[1].substring(6, 8);
    return parseInt(alphaHex, 16) < 255;
  }

  // 检查 4 位 HEX（简写格式）
  const shortHexMatch = normalizedColor.match(/^#([a-f0-9]{4})$/);
  if (shortHexMatch) {
    const alphaHex = shortHexMatch[1].charAt(3) + shortHexMatch[1].charAt(3);
    return parseInt(alphaHex, 16) < 255;
  }

  if (normalizedColor === 'translate') {
    return true;
  }

  // 没有透明度信息或格式不支持
  return false;
}
