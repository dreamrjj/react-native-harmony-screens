/**
 * Harmony implementation of experimental gamma SplitViewScreen.
 * Each instance wraps one column (primary/secondary/inspector).
 */

import { Descriptor, RNComponentContext, RNViewBase } from '@rnoh/react-native-openharmony';
import { RNC } from '../generated/ts';

export type RNSSplitViewScreenDescriptor = Descriptor<
  'RNSSplitViewScreen',
  RNC.RNSSplitViewScreen.Props
>;

@Component
export struct RNSSplitViewScreen {
  public static readonly NAME = RNC.RNSSplitViewScreen.NAME;
  public ctx!: RNComponentContext;
  public tag: number = 0;

  @State descriptor: RNSSplitViewScreenDescriptor = {} as RNSSplitViewScreenDescriptor;
  private eventEmitter: RNC.RNSSplitViewScreen.EventEmitter | undefined = undefined;
  private cleanUpCallbacks: (() => void)[] = [];

  @State columnType: string = 'column';
  @State private nativeViewIsVisible: boolean = false;

  aboutToAppear() {
    this.eventEmitter = new RNC.RNSSplitViewScreen.EventEmitter(this.ctx.rnInstance, this.tag);
    this.descriptor =
      this.ctx.descriptorRegistry.getDescriptor<RNSSplitViewScreenDescriptor>(this.tag);
    this.cleanUpCallbacks.push(
      this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag, (newDescriptor) => {
        this.descriptor = newDescriptor as RNSSplitViewScreenDescriptor;
        this.onDescriptorChange();
      }),
    );
    this.onDescriptorChange();
    this.emitWillAppear();
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach((cb) => cb());
    if (this.nativeViewIsVisible) {
      this.emitWillDisappear();
      this.emitDidDisappear();
    }
  }

  onDescriptorChange() {
    const columnTypeValue = this.descriptor.rawProps['columnType'] as string | undefined;
    if (columnTypeValue !== undefined) {
      this.columnType = columnTypeValue;
    }
  }

  onPageShow() {
    if (!this.nativeViewIsVisible) {
      this.nativeViewIsVisible = true;
      this.emitDidAppear();
    }
  }

  onPageHide() {
    if (this.nativeViewIsVisible) {
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

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      Column() {
        ContentSlot(this.ctx.getContentForTag(this.tag));
      }
      .width('100%')
      .height('100%')
      .onAppear(() => {
        this.onPageShow();
      })
      .onDisAppear(() => {
        this.onPageHide();
      });
    }
  }
}

