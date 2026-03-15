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
 * Harmony implementation of experimental gamma StackScreen.
 * It mirrors the RNSScreen lifecycle pattern in a simplified way.
 */

import { Descriptor, RNComponentContext, RNViewBase } from '@rnoh/react-native-openharmony';
import { RNC } from '../generated/ts';

export type RNSStackScreenDescriptor = Descriptor<'RNSStackScreen', RNC.RNSStackScreen.Props>;

@Component
export struct RNSStackScreen {
  public static readonly NAME = RNC.RNSStackScreen.NAME;
  public ctx!: RNComponentContext;
  public tag: number = 0;

  @State descriptor: RNSStackScreenDescriptor = {} as RNSStackScreenDescriptor;
  private eventEmitter: RNC.RNSStackScreen.EventEmitter | undefined = undefined;
  private cleanUpCallbacks: (() => void)[] = [];

  @State maxLifecycleState: number = 0;
  @State screenKey: string = '';
  @State private nativeViewIsVisible: boolean = false;

  aboutToAppear() {
    this.eventEmitter = new RNC.RNSStackScreen.EventEmitter(this.ctx.rnInstance, this.tag);
    this.descriptor =
      this.ctx.descriptorRegistry.getDescriptor<RNSStackScreenDescriptor>(this.tag);
    this.cleanUpCallbacks.push(
      this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag, (newDescriptor) => {
        this.descriptor = newDescriptor as RNSStackScreenDescriptor;
        this.onDescriptorChange();
      }),
    );
    this.onDescriptorChange();
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach((cb) => cb());
    if (this.nativeViewIsVisible) {
      this.emitWillDisappear();
      this.emitDidDisappear();
    }
  }

  onDescriptorChange() {
    const maxLifecycleStateValue = this.descriptor.rawProps['maxLifecycleState'] as number | undefined;
    if (maxLifecycleStateValue !== undefined) {
      const oldState = this.maxLifecycleState;
      this.maxLifecycleState = maxLifecycleStateValue;

      if (oldState === 0 && maxLifecycleStateValue === 1) {
        this.nativeViewIsVisible = false;
      }
      else if (oldState === 0 && maxLifecycleStateValue === 2) {
        this.emitWillAppear();
        this.emitDidAppear();
        this.nativeViewIsVisible = true;
      }
      else if (oldState === 1 && maxLifecycleStateValue === 2) {
        this.emitWillAppear();
        this.emitDidAppear();
        this.nativeViewIsVisible = true;
      }
      else if (oldState === 2 && maxLifecycleStateValue === 1) {
        if (this.nativeViewIsVisible) {
          this.emitWillDisappear();
          this.emitDidDisappear();
        }
        this.nativeViewIsVisible = false;
      }
      else if (oldState === 2 && maxLifecycleStateValue === 0) {
        if (this.nativeViewIsVisible) {
          this.emitWillDisappear();
          this.emitDidDisappear();
        }
        this.nativeViewIsVisible = false;
      }
      else if (oldState === 1 && maxLifecycleStateValue === 0) {
        this.nativeViewIsVisible = false;
      }
    }

    const screenKeyValue = this.descriptor.rawProps['screenKey'] as string | undefined;
    if (screenKeyValue !== undefined) {
      this.screenKey = screenKeyValue;
    }
  }

  onPageShow() {
    if (!this.nativeViewIsVisible && this.maxLifecycleState === 2) {
      this.nativeViewIsVisible = true;
      this.emitDidAppear();
    }
  }

  onPageHide() {
    if (this.nativeViewIsVisible && this.maxLifecycleState === 2) {
      this.nativeViewIsVisible = false;
      this.emitWillDisappear();
      this.emitDidDisappear();
    }
  }

  private emitWillAppear() {
    if (this.eventEmitter) {
      this.eventEmitter.emit('onWillAppear', {});
    }
  }

  private emitDidAppear() {
    if (this.eventEmitter) {
      this.eventEmitter.emit('onDidAppear', {});
    }
  }

  private emitWillDisappear() {
    if (this.eventEmitter) {
      this.eventEmitter.emit('onWillDisappear', {});
    }
  }

  private emitDidDisappear() {
    if (this.eventEmitter) {
      this.eventEmitter.emit('onDidDisappear', {});
    }
  }

  shouldRenderChildren(): boolean {
    return this.maxLifecycleState >= 2; // ATTACHED
  }
  shouldBeVisible(): boolean {
    return this.maxLifecycleState >= 2; // ATTACHED
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      Column() {
        if (this.shouldRenderChildren()) {
          ContentSlot(this.ctx.getContentForTag(this.tag));
        }
      }
      .width('100%')
      .height('100%')
      .opacity(this.shouldBeVisible() ? 1 : 0)
      .onAppear(() => {
        this.onPageShow();
      })
      .onDisAppear(() => {
        this.onPageHide();
      });
    }
  }
}

