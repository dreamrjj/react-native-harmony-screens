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
  @State edges: Readonly<EdgesDefaultType> = {
    top: false,
    right: false,
    bottom: false,
    left: false
  };
  @State insetType: string = 'all';
  @State newInsetType: SafeAreaType = SafeAreaType.SYSTEM;
  @State descriptor: RNSSafeAreaViewDescriptor = {} as RNSSafeAreaViewDescriptor;
  private cleanUpCallbacks: (() => void)[] = [];
  @State columnType: string = 'column';

  aboutToAppear() {
    this.descriptor =
      this.ctx.descriptorRegistry.getDescriptor<RNSSafeAreaViewDescriptor>(this.tag);
    this.cleanUpCallbacks.push(
      this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag, (newDescriptor) => {
        this.descriptor = newDescriptor as RNSSafeAreaViewDescriptor;
        this.onDescriptorChange();
      }),
    );
    this.onDescriptorChange();
    this.insetTypeChange()
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
        // this.newInsetType = SafeAreaType.All;//不支持
    }
  }

  onDescriptorChange() {
    const columnTypeValue = this.descriptor.rawProps['columnType'] as string | undefined;
    if (columnTypeValue !== undefined) {
      this.columnType = columnTypeValue;
    }
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      Column() {
        ContentSlot(this.ctx.getContentForTag(this.tag));
      }
      .width('100%')
      .height('100%')
      .expandSafeArea([this.newInsetType], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
  }
}

