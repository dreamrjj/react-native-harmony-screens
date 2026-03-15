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

/**
 * Harmony implementation of experimental gamma ScreenStackHost.
 * This is a light-weight container that simply renders its children.
 */

import { Descriptor, RNComponentContext, RNViewBase } from '@rnoh/react-native-openharmony';
import { RNC } from '../generated/ts';

export type RNSScreenStackHostDescriptor = Descriptor<
  'RNSScreenStackHost',
  RNC.RNSScreenStackHost.Props
>;

@Component
export struct RNSScreenStackHost {
  public static readonly NAME = RNC.RNSScreenStackHost.NAME;
  public ctx!: RNComponentContext;
  public tag: number = 0;

  @State descriptor: RNSScreenStackHostDescriptor = {} as RNSScreenStackHostDescriptor;
  private cleanUpCallbacks: (() => void)[] = [];

  aboutToAppear() {
    this.descriptor =
      this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHostDescriptor>(this.tag);
    this.cleanUpCallbacks.push(
      this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag, (newDescriptor) => {
        this.descriptor = newDescriptor as RNSScreenStackHostDescriptor;
      }),
    );
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach((cb) => cb());
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      Stack() {
        // Simply render all children; individual StackScreen items will manage their own lifecycles.
        ContentSlot(this.ctx.getContentForTag(this.tag));
      }
      .width('100%')
      .height('100%');
    }
  }
}

