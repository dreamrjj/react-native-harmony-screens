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

import {
  ColorValue,
  convertColorValueToHex,
  Descriptor,
  RNComponentContext
} from '@rnoh/react-native-openharmony';
import { RNC } from '../generated/ts';
import { RNSBottomTabsScreen, RNSBottomTabsScreenDescriptor } from './RNSBottomTabsScreen';
import { obtainImageInfoFromPath } from '../utils/Utils';
import { image } from '@kit.ImageKit';

export type RNSBottomTabsDescriptor = Descriptor<"RNSBottomTabs", RNC.RNSBottomTabs.Props>

interface ItemStateAppearance {
  tabBarItemTitleFontFamily?: string
  tabBarItemTitleFontSize?: number
  tabBarItemTitleFontWeight?: string
  tabBarItemTitleFontStyle?: string
  tabBarItemTitleFontColor?: ColorValue
  tabBarItemTitlePositionAdjustment?: GeneratedTypeLiteralInterface_2
  tabBarItemIconColor?: ColorValue
  tabBarItemBadgeBackgroundColor?: ColorValue
}

interface ItemAppearance {
  normal?: ItemStateAppearance
  selected?: ItemStateAppearance
  focused?: ItemStateAppearance
  disabled?: ItemStateAppearance
}

interface Appearance {
  stacked?: ItemAppearance
  inline?: ItemAppearance
  compactInline?: ItemAppearance
  tabBarBackgroundColor?: ColorValue
  tabBarShadowColor?: ColorValue
  tabBarBlurEffect?: string
}

interface SpecialEffects {
  repeatedTabSelection?: repeatedTabSelection
}

interface repeatedTabSelection {
  popToRoot?: boolean
  scrollToTop?: boolean
}

interface TabBarItemInfo {
  tag: number
  tabKey: string
  title: string
  badgeValue: string
  iconUri: string | undefined
  selectedIconUri: string | undefined
  iconType: string
  iconPixelMap?: image.PixelMap
  selectedIconPixelMap?: image.PixelMap
  normalAppearance?: ItemStateAppearance
  selectedAppearance?: ItemStateAppearance
  badgeTextColor?: string | undefined
  tabBarBlurEffect?: string | undefined
  systemItem?: string
  specialEffects?: SpecialEffects
  tabBarBackgroundColor?: string
  tabBarShadowColor?: string
}

interface GeneratedTypeLiteralInterface_1 {
  uri?: string;
}

interface GeneratedTypeLiteralInterface_2 {
  horizontal?: number;
  vertical?: number;
}

@Component
export struct RNSBottomTabs {
  public static readonly NAME = RNC.RNSBottomTabs.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSBottomTabsDescriptor = {} as RNSBottomTabsDescriptor
  private eventEmitter: RNC.RNSBottomTabs.EventEmitter | undefined = undefined
  private cleanUpCallbacks: (() => void)[] = []
  @State private children: number[] = []
  @State private focusedTabKey: string = ""
  @State private selectedIndex: number = 0
  @State private tabBarItems: TabBarItemInfo[] = []
  // Appearance props
  @State tabBarBackgroundColor: string | undefined = undefined;
  @State tabBarItemTitleFontFamily: string = ""
  @State tabBarItemTitleFontSize: number = 14
  @State tabBarItemTitleFontSizeActive: number = 14
  @State tabBarItemTitleFontWeight: string = "normal"
  @State tabBarItemTitleFontStyle: string = "Normal"
  @State tabBarItemTitleFontColor: string | undefined = undefined;
  @State tabBarItemTitleFontColorActive: string | undefined = undefined;
  @State tabBarItemIconColor: string | undefined = undefined;
  @State tabBarItemIconColorActive: string | undefined = undefined;
  @State tabBarItemActiveIndicatorColor: string | undefined = undefined;
  @State tabBarItemActiveIndicatorEnabled: boolean = true
  @State tabBarItemRippleColor: string | undefined = undefined;
  @State tabBarItemLabelVisibilityMode: string = "auto"
  @State tabBarTintColor: string | undefined = undefined;
  @State tabBarMinimizeBehavior: string = "automatic"
  @State tabBarControllerMode: string = "automatic"
  @State controlNavigationStateInJS: boolean = false
  @State tabBarShadowColor: string | undefined = undefined;
  @State rippleOpacity: number = 0
  @State rippleScale: number = 0
  @State currentRippleIndex: number = -1

  aboutToAppear() {
    this.eventEmitter = new RNC.RNSBottomTabs.EventEmitter(this.ctx.rnInstance, this.tag)
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSBottomTabsDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSBottomTabsDescriptor)
        this.onDescriptorChange()
      }
    ))
    this.onDescriptorChange()
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  onDescriptorChange() {
    let barBackgroundColor : string | undefined = this.descriptor.rawProps['tabBarBackgroundColor'];
    if (this.tabBarBackgroundColor !== barBackgroundColor) {
      this.tabBarBackgroundColor = barBackgroundColor;
    }
    const tabBarItemTitleFontFamilyValue = this.descriptor.rawProps['tabBarItemTitleFontFamily'] as string | undefined
    if (tabBarItemTitleFontFamilyValue !== undefined) {
      this.tabBarItemTitleFontFamily = tabBarItemTitleFontFamilyValue || ""
    }
    const tabBarItemTitleFontSizeValue =
      this.descriptor.rawProps['tabBarItemTitleFontSize'] as number | undefined
    if (tabBarItemTitleFontSizeValue !== undefined) {
      this.tabBarItemTitleFontSize = tabBarItemTitleFontSizeValue || 14
    }
    const tabBarItemTitleFontSizeActiveValue =
      this.descriptor.rawProps['tabBarItemTitleFontSizeActive'] as number | undefined
    if (tabBarItemTitleFontSizeActiveValue !== undefined) {
      this.tabBarItemTitleFontSizeActive = tabBarItemTitleFontSizeActiveValue || 14
    }
    const tabBarItemTitleFontWeightValue = this.descriptor.rawProps['tabBarItemTitleFontWeight'] as string | undefined
    if (tabBarItemTitleFontWeightValue !== undefined) {
      this.tabBarItemTitleFontWeight = tabBarItemTitleFontWeightValue || "normal"
    }
    this.tabBarItemTitleFontStyle = this.descriptor.rawProps['tabBarItemTitleFontStyle'] as string

    let tabBarItemTitleFontColorValue : string | undefined = this.descriptor.rawProps['tabBarItemTitleFontColor'];
    if (this.tabBarItemTitleFontColor !== tabBarItemTitleFontColorValue) {
      this.tabBarItemTitleFontColor = tabBarItemTitleFontColorValue
    }
    let tabBarItemTitleFontColorActiveValue : string | undefined
      = this.descriptor.rawProps['tabBarItemTitleFontColorActive'];
    if (this.tabBarItemTitleFontColorActive !== tabBarItemTitleFontColorActiveValue) {
      this.tabBarItemTitleFontColorActive = tabBarItemTitleFontColorActiveValue
    }
    let tabBarItemIconColorValue : string | undefined = this.descriptor.rawProps['tabBarItemIconColor'];
    if (this.tabBarItemIconColor !== tabBarItemIconColorValue) {
      this.tabBarItemIconColor = tabBarItemIconColorValue
    }
    let  tabBarItemIconColorActiveValue : string | undefined =
      this.descriptor.rawProps['tabBarItemIconColorActive'];
    if (this.tabBarItemIconColorActive !== tabBarItemIconColorActiveValue) {
      this.tabBarItemIconColorActive = tabBarItemIconColorActiveValue
    }
    const tabBarItemActiveIndicatorColorValue : string | undefined =
      this.descriptor.rawProps['tabBarItemActiveIndicatorColor'];
    if (this.tabBarItemActiveIndicatorColor !== tabBarItemActiveIndicatorColorValue) {
      this.tabBarItemActiveIndicatorColor = tabBarItemActiveIndicatorColorValue
    }
    const tabBarItemActiveIndicatorEnabledValue =
      this.descriptor.rawProps['tabBarItemActiveIndicatorEnabled'] as boolean | undefined
    if (tabBarItemActiveIndicatorEnabledValue !== undefined) {
      this.tabBarItemActiveIndicatorEnabled = tabBarItemActiveIndicatorEnabledValue !== false
    }
    let tabBarItemRippleColorValue : string | undefined = this.descriptor.rawProps['tabBarItemRippleColor'];
    if (this.tabBarItemRippleColor !== tabBarItemRippleColorValue) {
      this.tabBarItemRippleColor = tabBarItemRippleColorValue
    }
    const tabBarItemLabelVisibilityModeValue =
      this.descriptor.rawProps['tabBarItemLabelVisibilityMode'] as string | undefined
    if (tabBarItemLabelVisibilityModeValue !== undefined) {
      this.tabBarItemLabelVisibilityMode = tabBarItemLabelVisibilityModeValue || "auto"
    }
    let tabBarTintColorValue : string | undefined = this.descriptor.rawProps['tabBarTintColor'];
    if (this.tabBarTintColor !== tabBarTintColorValue) {
      this.tabBarTintColor = tabBarTintColorValue
    }
    const tabBarMinimizeBehaviorValue = this.descriptor.rawProps['tabBarMinimizeBehavior'] as string | undefined
    if (tabBarMinimizeBehaviorValue !== undefined) {
      this.tabBarMinimizeBehavior = tabBarMinimizeBehaviorValue || "automatic"
    }
    const tabBarControllerModeValue = this.descriptor.rawProps['tabBarControllerMode'] as string | undefined
    if (tabBarControllerModeValue !== undefined) {
      this.tabBarControllerMode = tabBarControllerModeValue || "automatic"
    }
    const controlNavigationStateInJSValue =
      this.descriptor.rawProps['controlNavigationStateInJS'] as boolean | undefined
    if (controlNavigationStateInJSValue !== undefined) {
      this.controlNavigationStateInJS = controlNavigationStateInJSValue === true
    }
    let tabBarShadowColorValue : string | undefined = this.descriptor.rawProps['tabBarShadowColor'];
    if (this.tabBarShadowColor !== tabBarShadowColorValue) {
      this.tabBarShadowColor = tabBarShadowColorValue
    }
    // Update children
    const newChildren = this.descriptor.childrenTags
    if (JSON.stringify(newChildren) !== JSON.stringify(this.children)) {
      this.children = newChildren
      this.updateTabBarItems().then(() => {
        this.updateFocusedTab()
      }).catch((e: Error) => {
        console.error('RNSBottomTabs updateTabBarItems error: ' + e)
        this.updateFocusedTab()
      })
    }
  }

  async updateTabBarItems() {
    const items: TabBarItemInfo[] = []
    const rm = this.ctx.uiAbilityContext.resourceManager

    for (let i = 0; i < this.children.length; i++) {
      const childTag = this.children[i]
      const childDescriptor = this.ctx.descriptorRegistry.getDescriptor<RNSBottomTabsScreenDescriptor>(childTag)
      if (childDescriptor) {
        const tabKeyValue = childDescriptor.rawProps['tabKey'] as string | undefined
        const titleValue = childDescriptor.rawProps['title'] as string | undefined
        const badgeValue = childDescriptor.rawProps['badgeValue'] as string | undefined
        const iconTypeValue = childDescriptor.rawProps['iconType'] as string | undefined
        const badgeTextColor = childDescriptor.rawProps['tabBarItemBadgeTextColor'] as string | undefined

        const iconResourceValue =
          childDescriptor.rawProps['iconResource'] as GeneratedTypeLiteralInterface_1 | undefined
        let iconUri: string | undefined = undefined
        if (iconResourceValue?.uri) {
          iconUri = typeof iconResourceValue.uri === 'string' ? iconResourceValue.uri : String(iconResourceValue.uri)
        }
        if (!iconUri) {
          const iconImageSourceValue =
            childDescriptor.rawProps['iconImageSource'] as GeneratedTypeLiteralInterface_1 | undefined
          if (iconImageSourceValue?.uri) {
            iconUri = typeof iconImageSourceValue.uri
              === 'string' ? iconImageSourceValue.uri : String(iconImageSourceValue.uri)
          }
        }
        const selectedIconImageSourceValue =
          childDescriptor.rawProps['selectedIconImageSource'] as GeneratedTypeLiteralInterface_1 | undefined
        let selectedIconUri: string | undefined = undefined
        if (selectedIconImageSourceValue?.uri) {
          selectedIconUri = typeof selectedIconImageSourceValue.uri === 'string'
            ? selectedIconImageSourceValue.uri
            : String(selectedIconImageSourceValue.uri)
        }
        let iconPixelMap: image.PixelMap | undefined = undefined
        let selectedIconPixelMap: image.PixelMap | undefined = undefined

        try {
          if (iconUri) {
            const info = await obtainImageInfoFromPath(rm, iconUri)
            iconUri = info.uri
            iconPixelMap = await info.imageSource.createPixelMap()
          }
        } catch (e) {
          console.error('RNSBottomTabs icon obtainImageInfoFromPath error: ' + e)
        }

        try {
          if (selectedIconUri) {
            const info = await obtainImageInfoFromPath(rm, selectedIconUri)
            selectedIconUri = info.uri
            selectedIconPixelMap = await info.imageSource.createPixelMap()
          }
        } catch (e) {
          console.error('RNSBottomTabs selected icon obtainImageInfoFromPath error: ' + e)
        }

        let normalAppearance: ItemStateAppearance | undefined = undefined
        let selectedAppearance: ItemStateAppearance | undefined = undefined
        let tabBarBlurEffect: string | undefined = undefined

        let tabBarBackgroundColorItem: string | undefined = undefined
        let tabBarShadowColorItem: string | undefined = undefined

        const standardAppearanceRaw = childDescriptor.rawProps['standardAppearance'] as Appearance | undefined
        const scrollEdgeAppearanceRaw = childDescriptor.rawProps['scrollEdgeAppearance'] as Appearance | undefined
        const appearanceToUse = standardAppearanceRaw || scrollEdgeAppearanceRaw

        if (appearanceToUse) {
          const itemAppearance = appearanceToUse.stacked || appearanceToUse.inline || appearanceToUse.compactInline
          if (itemAppearance) {
            normalAppearance = itemAppearance.normal as ItemStateAppearance | undefined
            selectedAppearance =
              (itemAppearance.selected || itemAppearance.focused) as ItemStateAppearance | undefined
          }
          if (appearanceToUse.tabBarBackgroundColor) {
            tabBarBackgroundColorItem = convertColorValueToHex(appearanceToUse.tabBarBackgroundColor) || "#FFFFFF"
          }
          if (appearanceToUse.tabBarShadowColor) {
            tabBarShadowColorItem = convertColorValueToHex(appearanceToUse.tabBarShadowColor) || ""
          }
          if (appearanceToUse.tabBarBlurEffect) {
            tabBarBlurEffect = appearanceToUse.tabBarBlurEffect
          }
        }

        const systemItemValue = childDescriptor.rawProps['systemItem'] as string | undefined
        const specialEffectsRaw = childDescriptor.rawProps['specialEffects'] as SpecialEffects | undefined
        let specialEffects: SpecialEffects | undefined = undefined
        if (specialEffectsRaw) {
          specialEffects = {
            repeatedTabSelection: {
              popToRoot: specialEffectsRaw.repeatedTabSelection?.popToRoot !== false,
              scrollToTop: specialEffectsRaw.repeatedTabSelection?.scrollToTop !== false
            }
          }
        }

        if (tabKeyValue) {
          items.push({
            tag: childTag,
            tabKey: tabKeyValue,
            title: titleValue || "",
            badgeValue: badgeValue || "",
            iconUri: iconUri,
            selectedIconUri: selectedIconUri,
            iconType: iconTypeValue || "image",
            iconPixelMap: iconPixelMap,
            selectedIconPixelMap: selectedIconPixelMap,
            normalAppearance: normalAppearance,
            selectedAppearance: selectedAppearance,
            badgeTextColor: badgeTextColor,
            tabBarBlurEffect: tabBarBlurEffect,
            systemItem: systemItemValue,
            specialEffects: specialEffects,
            tabBarBackgroundColor: tabBarBackgroundColorItem,
            tabBarShadowColor: tabBarShadowColorItem,
          })
        } else {
          console.warn('RNSBottomTabs updateTabBarItems child ' + i + ' has no tabKey, skipping')
        }
      }
    }

    this.tabBarItems = items
  }

  updateFocusedTab() {
    if (this.tabBarItems.length === 0) {
      return
    }
    // 当由 JS 侧控制导航状态时，优先根据子组件的 isFocused 来决定选中项
    if (this.controlNavigationStateInJS) {
      let focusedIndex: number = -1
      for (let i = 0; i < this.tabBarItems.length; i++) {
        const childTag = this.tabBarItems[i].tag
        const childDescriptor = this.ctx.descriptorRegistry.getDescriptor<RNSBottomTabsScreenDescriptor>(childTag)
        if (childDescriptor) {
          const isFocusedValue = childDescriptor.rawProps['isFocused'] as boolean | undefined
          if (isFocusedValue === true) {
            focusedIndex = i
            break
          }
        }
      }

      if (focusedIndex >= 0) {
        const item = this.tabBarItems[focusedIndex]
        this.selectedIndex = focusedIndex
        this.focusedTabKey = item.tabKey
        console.log('RNSBottomTabs updateFocusedTab (JS-controlled), focusedIndex: ' + focusedIndex + ', focusedTabKey: ' + this.focusedTabKey)
        this.emitFocusChangeEvent(this.focusedTabKey)
        return
      }
    }

    // 默认行为：如果还没有设置 focusedTabKey，则使用第一个 tab
    if (!this.focusedTabKey) {
      const firstItem = this.tabBarItems[0]
      this.focusedTabKey = firstItem.tabKey
      this.selectedIndex = 0
      this.emitFocusChangeEvent(this.focusedTabKey)
    }
  }

  onTabChange(index: number) {
    if (index >= 0 && index < this.tabBarItems.length) {
      const item = this.tabBarItems[index]
      const isRepeatedSelection = index === this.selectedIndex

      if (isRepeatedSelection) {
        // 重复点击已选中的 tab，处理 specialEffects
        this.handleRepeatedTabSelection(item)
      } else {
        // 切换到新的 tab
        if (this.controlNavigationStateInJS) {
          // JS 控制模式下：仅通过事件通知 JS，native 不直接修改 selectedIndex，
          // 由 JS 侧通过更新 BottomTabsScreen 的 isFocused 来驱动选中态变化。
          if (item.tabKey !== this.focusedTabKey) {
            this.focusedTabKey = item.tabKey
          }
          this.emitFocusChangeEvent(item.tabKey)
        } else {
          // 默认模式：在 native 侧直接更新 selectedIndex 和 focusedTabKey
          this.selectedIndex = index
          if (item.tabKey !== this.focusedTabKey) {
            this.focusedTabKey = item.tabKey
            this.emitFocusChangeEvent(this.focusedTabKey)
          }
        }
      }
    }
  }

  // 处理重复点击 tab 的特殊效果
  handleRepeatedTabSelection(item: TabBarItemInfo) {
    const specialEffects = item.specialEffects
    if (!specialEffects || !specialEffects.repeatedTabSelection) {
      return
    }
    // 先将事件透传给 JS 侧，由 JS 决定具体行为（popToRoot / scrollToTop）
    // if (this.eventEmitter) {
    //   this.eventEmitter.emit("repeatedTabSelection", {
    //     tabKey: item.tabKey,
    //     specialEffects: specialEffects
    //   })
    // }
    // 为了兼容性，仍然保留日志，提示需要在 JS 层实现具体行为
    if (specialEffects?.repeatedTabSelection?.popToRoot !== false) {
      this.handlePopToRoot(item.tag)
    } else if (specialEffects?.repeatedTabSelection?.scrollToTop !== false) {
      this.handleScrollToTop(item.tag)
    }
  }

  // 处理 popToRoot：尝试找到内部的 Stack 并 pop 到根
  handlePopToRoot(screenTag: number) {
    // 注意：Harmony 平台目前无法直接访问 React Navigation 的 Stack 状态
    // 这个功能需要通过 JS 层的 React Navigation API 来实现
    // 这里我们只能记录日志，实际功能需要在 JS 层通过事件回调实现
    console.log('RNSBottomTabs handlePopToRoot called for screen tag: ' + screenTag)
    this.ctx?.logger?.warn?.('RNSBottomTabs', 'popToRoot is not fully supported on Harmony platform. Please implement via JS layer React Navigation API.')
  }

  // 处理 scrollToTop：尝试找到第一个 ScrollView 并滚动到顶部
  handleScrollToTop(screenTag: number) {
    // 注意：Harmony 平台目前无法直接访问 JS 层的 ScrollView 组件
    // 这个功能需要通过在 JS 层监听事件并调用 ScrollView 的 scrollTo 方法来实现
    // 这里我们只能记录日志，实际功能需要在 JS 层通过事件回调实现
    console.log('RNSBottomTabs handleScrollToTop called for screen tag: ' + screenTag)
    this.ctx?.logger?.warn?.('RNSBottomTabs', 'scrollToTop is not fully supported on Harmony platform. Please implement via JS layer ScrollView.scrollTo API.')
  }

  emitFocusChangeEvent(tabKey: string) {
    if (this.eventEmitter) {
      this.eventEmitter.emit("onNativeFocusChange", {
        tabKey: tabKey
      })
    }
  }

  build() {
    Column() {
      // Content area
      Stack() {
        ForEach(this.tabBarItems, (item: TabBarItemInfo, index: number) => {
          if (index === this.selectedIndex) {
            RNSBottomTabsScreen({
              ctx: this.ctx,
              tag: item.tag,
            })
          }
        }, (item: TabBarItemInfo) => item.tabKey)
      }
      .layoutWeight(1)
      .width('100%')

      Row() {
        if (this.tabBarItems.length > 0) {
          ForEach(this.tabBarItems, (item: TabBarItemInfo, index: number) => {
            this.buildTabBarItem(item, index)
          }, (item: TabBarItemInfo) => item.tabKey)
        } else {
          Blank()
            .width('100%')
            .height(56)
        }
      }
      .width('100%')
      .height(56)
      .backgroundColor(this.getCurrentTabBarBackgroundColor())
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)
      .shadow({
        radius: this.getCurrentTabBarShadowColor() !== "" ? 4 : 0,
        color: this.getCurrentTabBarShadowColor() !== "" ? this.getCurrentTabBarShadowColor() : Color.Transparent,
        offsetX: 0,
        offsetY: -2
      })
    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP])
  }

  getCurrentAppearance(item: TabBarItemInfo, index: number): ItemStateAppearance | undefined {
    const isSelected = this.isSelected(index)
    return isSelected ? item.selectedAppearance : item.normalAppearance
  }

  getTitleFontSize(item: TabBarItemInfo, index: number): number {
    const appearance = this.getCurrentAppearance(item, index)
    if (appearance?.tabBarItemTitleFontSize !== undefined) {
      return appearance.tabBarItemTitleFontSize
    }
    return this.isSelected(index) ? this.tabBarItemTitleFontSizeActive : this.tabBarItemTitleFontSize
  }

  getTitleFontFamily(item: TabBarItemInfo, index: number): string {
    const appearance = this.getCurrentAppearance(item, index)
    if (appearance?.tabBarItemTitleFontFamily) {
      return appearance.tabBarItemTitleFontFamily
    }
    return this.tabBarItemTitleFontFamily
  }

  getTitleFontWeight(item: TabBarItemInfo, index: number): string {
    const appearance = this.getCurrentAppearance(item, index)
    if (appearance?.tabBarItemTitleFontWeight) {
      return appearance.tabBarItemTitleFontWeight
    }
    return this.tabBarItemTitleFontWeight
  }

  getTitleFontStyle(item: TabBarItemInfo, index: number): string {
    const appearance = this.getCurrentAppearance(item, index)
    if (appearance?.tabBarItemTitleFontStyle) {
      if (appearance.tabBarItemTitleFontStyle === "Italic") {
        return 'Italic'
      }
      return 'Normal'
    }
    if (this.tabBarItemTitleFontStyle !== null) {
      if (this.tabBarItemTitleFontStyle  === "Italic") {
        return 'Italic'
      } else {
        return 'Normal'
      }
    }

    return 'Normal'
  }

  getTitleFontColor(item: TabBarItemInfo, index: number): string | undefined {
    const appearance = this.getCurrentAppearance(item, index)
    if (appearance?.tabBarItemTitleFontColor) {
      return convertColorValueToHex(appearance.tabBarItemTitleFontColor) || "#000000"
    }
    return this.isSelected(index) ? this.tabBarItemTitleFontColorActive : this.tabBarItemTitleFontColor
  }

  getIconColor(item: TabBarItemInfo, index: number): string | undefined {
    const appearance = this.getCurrentAppearance(item, index)
    if (appearance?.tabBarItemIconColor) {
      return convertColorValueToHex(appearance.tabBarItemIconColor) || "#000000"
    }
    return this.isSelected(index) ? this.tabBarItemIconColorActive : this.tabBarItemIconColor
  }

  getTitlePositionAdjustment(item: TabBarItemInfo, index: number): GeneratedTypeLiteralInterface_2 {
    const appearance = this.getCurrentAppearance(item, index)
    if (appearance?.tabBarItemTitlePositionAdjustment) {
      const adjustment = appearance.tabBarItemTitlePositionAdjustment
      return {
        horizontal: (adjustment.horizontal !== undefined && adjustment.horizontal !== null) ? adjustment.horizontal : 0,
        vertical: (adjustment.vertical !== undefined && adjustment.vertical !== null) ? adjustment.vertical : 0
      }
    }
    return { horizontal: 0, vertical: 0 }
  }

  getBlurRadius(tabBarBlurEffect: string): number {
    if (tabBarBlurEffect === "none"
      || tabBarBlurEffect === ""
      || tabBarBlurEffect === undefined) {
      return BlurStyle.NONE
    }

    switch (tabBarBlurEffect) {
      case "extraLight":
      case "systemUltraThinMaterial":
      case "systemUltraThinMaterialLight":
        return BlurStyle.BACKGROUND_THIN
      case "light":
      case "systemThinMaterial":
      case "systemThinMaterialLight":
        return BlurStyle.BACKGROUND_THIN
      case "regular":
      case "systemMaterial":
      case "systemMaterialLight":
        return BlurStyle.BACKGROUND_REGULAR
      case "dark":
      case "systemThickMaterial":
      case "systemThickMaterialLight":
      case "systemThickMaterialDark":
        return BlurStyle.BACKGROUND_ULTRA_THICK
      case "prominent":
      case "systemChromeMaterial":
      case "systemChromeMaterialLight":
      case "systemChromeMaterialDark":
      case "systemDefault":
      case "systemUltraThinMaterialDark":
      case "systemThinMaterialDark":
      case "systemMaterialDark":
        this.ctx.logger.error('RNSBottomTabs', tabBarBlurEffect +" not support")
        return BlurStyle.NONE
      default:
        return BlurStyle.NONE
    }
  }

  getSystemIcon(systemItem: string): string {
    switch (systemItem) {
      case 'more':
        return 'sys.symbol.more'
      case 'bookmarks':
        return 'sys.symbol.bookmark'
      default:
        return '';
    }

  }

  isSelected(index: number): boolean{
    return index === this.selectedIndex;
  }

  currentIconUri(item: TabBarItemInfo, index: number): string | undefined {
    const isSelected = this.isSelected(index)
    return (isSelected && item.selectedIconUri) ? item.selectedIconUri : item.iconUri
  }

  tabBarItemLabelVisibility(tabBarItemLabelVisibilityMode: string, index: number) : boolean {
    if (tabBarItemLabelVisibilityMode === "unlabeled") {
      return false;
    } else if (tabBarItemLabelVisibilityMode === "labeled") {
      return true;
    } else {
      return tabBarItemLabelVisibilityMode === "auto" && this.tabBarItems.length <= 3
        || tabBarItemLabelVisibilityMode === "selected" && this.isSelected(index);
    }
  }

  getRippleColor(): string {
    if (this.tabBarItemRippleColor && this.tabBarItemRippleColor !== "") {
      return this.tabBarItemRippleColor
    }
    return ""
  }

  triggerRippleAnimation(index: number) {
    if (!this.getRippleColor()) {
      return
    }

    this.currentRippleIndex = index

    this.rippleOpacity = 0
    this.rippleScale = 0.8
    animateTo({
      duration: 150
    }, () => {
      this.rippleOpacity = 0.3
      this.rippleScale = 1.0
    })

    setTimeout(() => {
      animateTo({
        duration: 200
      }, () => {
        this.rippleOpacity = 0
        this.rippleScale = 0
        this.currentRippleIndex = -1
      })
    }, 150)
  }

  getTabItemBackgroundColor(index: number): string | undefined {
    if (this.currentRippleIndex === index && this.rippleOpacity > 0 && this.getRippleColor()) {
      const rippleColor = this.getRippleColor()
      if (rippleColor.startsWith('#')) {
        const rgb = rippleColor.length === 7 ? rippleColor.substring(1) : rippleColor.substring(1, 7)
        const alpha = Math.floor(this.rippleOpacity * 255).toString(16).padStart(2, '0')
        return `#${alpha}${rgb}`
      }
      return rippleColor
    }
    if (this.isSelected(index) && this.tabBarItemActiveIndicatorEnabled) {
      return this.tabBarItemActiveIndicatorColor
    }
    return "#00000000"
  }

  getCurrentBadgeBackgroundColor(item: TabBarItemInfo, index: number): string {
    const appearance = this.getCurrentAppearance(item, index)
    if (appearance?.tabBarItemBadgeBackgroundColor) {
      return convertColorValueToHex(appearance?.tabBarItemBadgeBackgroundColor) || "#000000"
    }
    return "#FF3B30"
  }

  getCurrentBadgeTextColor(badgeTextColor: string | undefined): string {
    if (badgeTextColor === undefined) {
      return "#FFFFFF"
    }
    return badgeTextColor === null ? "#FFFFFF" : badgeTextColor
  }

  getCurrentTabBarBackgroundColor(): string {
    if (this.tabBarItems.length > 0 && this.selectedIndex >= 0 && this.selectedIndex < this.tabBarItems.length) {
      const item = this.tabBarItems[this.selectedIndex]
      if (item.tabBarBackgroundColor) {
        return item.tabBarBackgroundColor
      }
    }
    return this.tabBarBackgroundColor ?? "#FFFFFF"
  }

  getCurrentTabBarShadowColor(): string {
    if (this.tabBarItems.length > 0 && this.selectedIndex >= 0 && this.selectedIndex < this.tabBarItems.length) {
      const item = this.tabBarItems[this.selectedIndex]
      if (item.tabBarShadowColor !== undefined && item.tabBarShadowColor !== "") {
        return item.tabBarShadowColor
      }
    }
    return this.tabBarShadowColor ?? ""
  }

  @Builder
  buildTabBarItem(item: TabBarItemInfo, index: number) {
    Column() {
      if (this.isSelected(index) && item.selectedIconPixelMap) {
        Image(item.selectedIconPixelMap)
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .fillColor(this.getIconColor(item, index))
      } else if (item.iconPixelMap) {
        Image(item.iconPixelMap)
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .fillColor(this.getIconColor(item, index))
      } else {
        if (item.systemItem !== undefined && item.systemItem !== 'none') {
          SymbolGlyph($r(this.getSystemIcon(item.systemItem)))
            .fontSize(24)
            .fontColor([this.getIconColor(item, index)])
        } else {
          Image($r('app.media.settings'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
            .fillColor(this.getIconColor(item, index))
        }
      }

      if (this.tabBarItemLabelVisibility(this.tabBarItemLabelVisibilityMode, index)) {
        Text(item.title)
          .fontSize(this.getTitleFontSize(item, index))
          .fontWeight(this.getTitleFontWeight(item, index))
          .fontStyle(this.getTitleFontStyle(item, index) === 'Italic'
            ? FontStyle.Italic : FontStyle.Normal)
          .fontFamily(this.getTitleFontFamily(item, index))
          .fontColor(this.getTitleFontColor(item, index))
          .margin({
            top: this.getTitlePositionAdjustment(item, index).vertical,
            left: this.getTitlePositionAdjustment(item, index).horizontal,
            right: this.getTitlePositionAdjustment(item, index).horizontal
          })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }

      if (item.badgeValue && item.badgeValue !== "") {
        Text(item.badgeValue)
          .fontSize(10)
          .fontColor(this.getCurrentBadgeTextColor(item.badgeTextColor))
          .backgroundColor(this.getCurrentBadgeBackgroundColor(item, index) || "#FF3B30")
          .padding({ left: 4, right: 4, top: 2, bottom: 2 })
          .borderRadius(10)
          .position({ x: 55, y: -5 })
      }
    }
    .blur(
      this.getBlurRadius(item.tabBarBlurEffect === undefined
        ? 'node' : item.tabBarBlurEffect))
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .height('100%')
    .width('100%')
    .backgroundColor(this.getTabItemBackgroundColor(index))
    .opacity(this.currentRippleIndex === index && this.rippleOpacity > 0 ? 1 : 1)
    .scale({
      x: this.currentRippleIndex === index ? this.rippleScale : 1,
      y: this.currentRippleIndex === index ? this.rippleScale : 1
    })
    .onClick(() => {
      this.triggerRippleAnimation(index)
      this.onTabChange(index)
    })
  }
}
