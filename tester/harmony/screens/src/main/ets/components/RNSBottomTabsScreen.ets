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
  RNComponentContext,
  RNViewBase,
} from '@rnoh/react-native-openharmony';
import { RNC } from '../generated/ts';
import { window } from '@kit.ArkUI';
import common from '@ohos.app.ability.common';

export type RNSBottomTabsScreenDescriptor = Descriptor<"RNSBottomTabsScreen", RNC.RNSBottomTabsScreen.Props>

interface imageUriInterface {
  uri?: string;
}

@Component
export struct RNSBottomTabsScreen {
  public static readonly NAME = RNC.RNSBottomTabsScreen.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSBottomTabsScreenDescriptor = {} as RNSBottomTabsScreenDescriptor
  private eventEmitter: RNC.RNSBottomTabsScreen.EventEmitter | undefined = undefined
  private cleanUpCallbacks: (() => void)[] = []

  // Screen-specific props
  @State tabKey: string = ""
  @State title: string = ""
  @State badgeValue: string = ""
  private iconResource?: imageUriInterface
  @State iconType: string = "image"
  private iconImageSource?: imageUriInterface
  @State iconSfSymbolName: string = ""
  private selectedIconImageSource?: imageUriInterface
  @State selectedIconSfSymbolName: string = ""
  @State orientation: string = "default"
  @State nativeViewIsVisible: boolean = false
  @State isFocused: boolean = false
  @State lifecycleState: number = 0
  private lastAppliedOrientation: number = -1


  aboutToAppear() {
    this.eventEmitter = new RNC.RNSBottomTabsScreen.EventEmitter(this.ctx.rnInstance, this.tag)
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSBottomTabsScreenDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSBottomTabsScreenDescriptor)
        this.onDescriptorChange()
      }
    ))
    this.onDescriptorChange()
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
    if (this.nativeViewIsVisible) {
      this.emitDidDisappear()
    }

    this.setLifecycleState(0)
  }

  private setLifecycleState(newState: number) {
    const previousState = this.lifecycleState
    if (previousState === newState) {
      return
    }
    this.lifecycleState = newState
    if (this.eventEmitter) {
      this.eventEmitter.emit("lifecycleStateChange", {
        previousState: previousState,
        newState: newState
      })
    }
  }

  onDescriptorChange() {

    const tabKeyValue = this.descriptor.rawProps['tabKey'] as string | undefined
    if (tabKeyValue !== undefined) {
      this.tabKey = tabKeyValue || ""
    }
    const titleValue = this.descriptor.rawProps['title'] as string | undefined
    if (titleValue !== undefined) {
      this.title = titleValue || ""
    }
    const badgeValueValue = this.descriptor.rawProps['badgeValue'] as string | undefined
    if (badgeValueValue !== undefined) {
      this.badgeValue = badgeValueValue || ""
    }
    const iconResourceValue = this.descriptor.rawProps['iconResource'] as imageUriInterface | undefined
    if (iconResourceValue !== undefined) {
      this.iconResource = iconResourceValue
    }
    const iconTypeValue = this.descriptor.rawProps['iconType'] as string | undefined
    if (iconTypeValue !== undefined) {
      this.iconType = iconTypeValue || "image"
    }
    const iconImageSourceValue = this.descriptor.rawProps['iconImageSource'] as imageUriInterface | undefined
    if (iconImageSourceValue !== undefined) {
      this.iconImageSource = iconImageSourceValue
    }
    const iconSfSymbolNameValue = this.descriptor.rawProps['iconSfSymbolName'] as string | undefined
    if (iconSfSymbolNameValue !== undefined) {
      this.iconSfSymbolName = iconSfSymbolNameValue || ""
    }
    const selectedIconImageSourceValue = this.descriptor.rawProps['selectedIconImageSource'] as imageUriInterface | undefined
    if (selectedIconImageSourceValue !== undefined) {
      this.selectedIconImageSource = selectedIconImageSourceValue
    }
    const selectedIconSfSymbolNameValue = this.descriptor.rawProps['selectedIconSfSymbolName'] as string | undefined
    if (selectedIconSfSymbolNameValue !== undefined) {
      this.selectedIconSfSymbolName = selectedIconSfSymbolNameValue || ""
    }

    const orientationValue = this.descriptor.rawProps['orientation'] as string | undefined
    const newOrientation = orientationValue !== undefined ? orientationValue : "default"
    const orientationChanged = this.orientation !== newOrientation
    this.orientation = newOrientation
    if (orientationChanged && this.isFocused) {
      this.setScreenOrientation()
    }

    const isFocusedValue = this.descriptor.rawProps['isFocused'] as boolean | undefined
    if (isFocusedValue !== undefined) {
      const wasFocused = this.isFocused
      const isNowFocused = isFocusedValue === true

      if (!wasFocused && isNowFocused) {
        this.emitWillAppear()
        this.setScreenOrientation()
        if (this.nativeViewIsVisible) {
          this.setLifecycleState(2)
        }
      } else if (wasFocused && !isNowFocused) {
        this.emitWillDisappear()
        this.restoreDefaultOrientation()
        if (this.nativeViewIsVisible) {
          this.setLifecycleState(0)
        }
      }
      this.isFocused = isNowFocused
    }
  }

  onPageShow() {
    if (!this.nativeViewIsVisible) {
      this.nativeViewIsVisible = true
      this.emitDidAppear()
      if (this.isFocused) {
        this.setScreenOrientation()
        this.setLifecycleState(2)
      } else {
        this.setLifecycleState(0)
      }
    }
  }

  onPageHide() {
    if (this.nativeViewIsVisible) {
      this.nativeViewIsVisible = false
      this.emitDidDisappear()
      if (this.isFocused) {
        this.restoreDefaultOrientation()
      }
      this.setLifecycleState(0)
    }
  }

  emitWillAppear() {
    if (this.eventEmitter) {
      this.eventEmitter.emit("willAppear", {})
    }
  }

  emitDidAppear() {
    if (this.eventEmitter) {
      this.eventEmitter.emit("didAppear", {})
    }
  }

  emitWillDisappear() {
    if (this.eventEmitter) {
      this.eventEmitter.emit("willDisappear", {})
    }
  }

  emitDidDisappear() {
    if (this.eventEmitter) {
      this.eventEmitter.emit("didDisappear", {})
    }
  }

  private setScreenOrientation() {
    if (!this.descriptor) {
      console.log('RNSBottomTabsScreen setScreenOrientation: descriptor is null')
      return
    }

    if (!this.orientation || this.orientation === "default") {
      console.log('RNSBottomTabsScreen setScreenOrientation: orientation is inherit/undefined, using default (UNSPECIFIED)')
      this.restoreDefaultOrientation()
      return
    }

    let orientationTmp = -1 // window.Orientation.UNSPECIFIED

    if (this.orientation === "all") {
      orientationTmp = window.Orientation.AUTO_ROTATION
    } else if (this.orientation === "portrait" || this.orientation === "portraitUp"
      || this.orientation === "portrait_up") {
      orientationTmp = window.Orientation.PORTRAIT
    } else if (this.orientation === "portraitDown") {
      orientationTmp = window.Orientation.PORTRAIT_INVERTED
    } else if (this.orientation === "landscape" || this.orientation === "landscapeRight") {
      orientationTmp = window.Orientation.LANDSCAPE
    } else if (this.orientation === "landscapeLeft") {
      orientationTmp = window.Orientation.LANDSCAPE_INVERTED
    } else if (this.orientation === "allButUpsideDown") {
      orientationTmp = window.Orientation.AUTO_ROTATION
    } else {
      orientationTmp = window.Orientation.UNSPECIFIED
    }

    this.applyOrientation(orientationTmp)
  }

  private restoreDefaultOrientation() {
    this.applyOrientation(window.Orientation.UNSPECIFIED)
  }

  private applyOrientation(orientationTmp: number) {
    // 如果方向没有变化，直接返回，避免重复设置
    if (this.lastAppliedOrientation === orientationTmp) {
      console.log('RNSBottomTabsScreen applyOrientation: orientation not changed, skipping. value=' + orientationTmp)
      return
    }

    try {
      let context = this.ctx.uiAbilityContext as common.UIAbilityContext
      if (!context) {
        console.error('RNSBottomTabsScreen applyOrientation: uiAbilityContext is null')
        return
      }

      window.getLastWindow(context).then((lastWindow) => {
        if (!lastWindow) {
          console.error('RNSBottomTabsScreen applyOrientation: getLastWindow returned null')
          return
        }
        lastWindow.setPreferredOrientation(orientationTmp)
        this.lastAppliedOrientation = orientationTmp
      }).catch((error: Error) => {
        console.error('RNSBottomTabsScreen applyOrientation getLastWindow error: ' + error)
      })
    } catch (error) {
      console.error('RNSBottomTabsScreen applyOrientation context error: ' + error)
    }
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      Column() {
        ContentSlot(this.ctx.getContentForTag(this.tag))
      }
      .width('100%')
      .height('100%')
      .onAppear(() => {
        this.onPageShow()
      })
      .onDisAppear(() => {
        this.onPageHide()
      })
    }
  }
}
