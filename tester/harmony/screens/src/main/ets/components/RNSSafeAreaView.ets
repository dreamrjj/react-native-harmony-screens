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

import { Descriptor, RNComponentContext, RNViewBase } from '@rnoh/react-native-openharmony';
import { RNC } from '../generated/ts';
import { SafeAreaInsets } from '../utils/SafeAreaInsets';

export type RNSSafeAreaViewDescriptor = Descriptor<'RNSSafeAreaView',
RNC.RNSSafeAreaView.Props>;

interface EdgesDefaultType {
  top: boolean;
  right: boolean;
  bottom: boolean;
  left: boolean;
}

@Component
export struct RNSSafeAreaView {
  public static readonly NAME = RNC.RNSSafeAreaView.NAME;
  public ctx!: RNComponentContext;
  public tag: number = 0;
  @State edges: EdgesDefaultType = {
    top: false,
    right: false,
    bottom: false,
    left: false
  };
  @State edgesValue: SafeAreaEdge[] = []
  @State insetType: string = 'system';
  @State newInsetType: SafeAreaType = SafeAreaType.SYSTEM;
  @State descriptor: RNSSafeAreaViewDescriptor = {} as RNSSafeAreaViewDescriptor;
  private cleanUpCallbacks: (() => void)[] = [];
  private eventEmitter: RNC.RNSSafeAreaView.EventEmitter | undefined = undefined
  private safeAreaInsets!: SafeAreaInsets;
  @State statusBarHeight: number = 0;
  @State navigationBarHeight: number = 0;

  aboutToAppear() {
    this.descriptor =
      this.ctx.descriptorRegistry.getDescriptor<RNSSafeAreaViewDescriptor>(this.tag);
    this.eventEmitter = new RNC.RNSSafeAreaView.EventEmitter(this.ctx.rnInstance, this.tag)
    this.cleanUpCallbacks.push(
      this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag, (newDescriptor) => {
        this.descriptor = newDescriptor as RNSSafeAreaViewDescriptor;
        this.onDescriptorChange();
      }),
    );
    this.onDescriptorChange();
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach((cb) => cb());
  }

  insetTypeChange() {
    switch (this.insetType) {
      case 'system':
        this.newInsetType = SafeAreaType.SYSTEM;
        break;
      case 'interface':
        // this.newInsetType = SafeAreaType.INTERFACE; //不支持
        break;
      default:
      // this.newInsetType = SafeAreaType.All;
    }
  }

  async onDescriptorChange() {
    const edgesValue = this.descriptor.rawProps['edges'] as Readonly<EdgesDefaultType> | undefined;
    if (edgesValue !== undefined) {
      this.edges = edgesValue;
      console.info(`RNSSafeAreaView onDescriptorChange edges:${JSON.stringify(this.edges)}`)
    }
    const insetTypeValue = this.descriptor.rawProps['insetType'] as string | '';
    if (insetTypeValue !== undefined) {
      this.insetType = insetTypeValue;
      this.insetTypeChange()
    }
    this.safeAreaInsets = new SafeAreaInsets(this.ctx)
    const insets = await this.safeAreaInsets.getSafeAreaInsets()
    this.statusBarHeight = insets.top
    console.info(`RNSSafeAreaView statusBarHeight:${this.statusBarHeight}`)
    this.navigationBarHeight = insets.bottom
    if (this.edges.top) {
      this.emitStatusBarChangeEvent(this.statusBarHeight)
    } else {
      this.emitStatusBarChangeEvent(0)
    }
    if (this.edges.bottom) {
      this.emitNavigationBarChangeEvent(28)
    } else {
      this.emitNavigationBarChangeEvent(0)
    }
  }

  emitStatusBarChangeEvent(statusBarHeight: number) {
    if (this.eventEmitter) {
      this.eventEmitter.emit("onStatusBarHeightChange", {
        statusBarHeight: statusBarHeight
      })
    }
  }

  emitNavigationBarChangeEvent(navigationBarHeight: number) {
    if (this.eventEmitter) {
      this.eventEmitter.emit("onNavigationBarHeightChange", {
        navigationBarHeight: navigationBarHeight
      })
    }
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      Stack() {
        ContentSlot(this.ctx.getContentForTag(this.tag))
      }
    }
  }
}

