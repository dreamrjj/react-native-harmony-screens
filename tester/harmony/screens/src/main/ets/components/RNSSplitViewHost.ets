/**
 * Harmony implementation of experimental gamma SplitViewHost.
 * Lays out its SplitViewScreen children in a simple horizontal Row.
 */

import { Descriptor, RNComponentContext, RNViewBase } from '@rnoh/react-native-openharmony';
import { RNC } from '../generated/ts';
import { RNSSplitViewScreen, RNSSplitViewScreenDescriptor } from './RNSSplitViewScreen';

export type RNSSplitViewHostDescriptor = Descriptor<
  'RNSSplitViewHost',
  RNC.RNSSplitViewHost.Props
>;

interface SplitViewChildInfo {
  tag: number;
  columnType: string;
}

@Component
export struct RNSSplitViewHost {
  public static readonly NAME = RNC.RNSSplitViewHost.NAME;
  public ctx!: RNComponentContext;
  public tag: number = 0;

  @State descriptor: RNSSplitViewHostDescriptor = {} as RNSSplitViewHostDescriptor;
  private eventEmitter: RNC.RNSSplitViewHost.EventEmitter | undefined = undefined;
  private cleanUpCallbacks: (() => void)[] = [];

  @State private children: number[] = [];
  @State private columns: SplitViewChildInfo[] = [];

  aboutToAppear() {
    this.eventEmitter = new RNC.RNSSplitViewHost.EventEmitter(this.ctx.rnInstance, this.tag);
    this.descriptor =
      this.ctx.descriptorRegistry.getDescriptor<RNSSplitViewHostDescriptor>(this.tag);
    this.cleanUpCallbacks.push(
      this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag, (newDescriptor) => {
        this.descriptor = newDescriptor as RNSSplitViewHostDescriptor;
        this.onDescriptorChange();
      }),
    );
    this.onDescriptorChange();
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach((cb) => cb());
  }

  onDescriptorChange() {
    const newChildren = this.descriptor.childrenTags;
    if (!newChildren) {
      this.children = [];
      this.columns = [];
      return;
    }
    if (JSON.stringify(newChildren) !== JSON.stringify(this.children)) {
      this.children = newChildren;
      this.updateColumns();
    }
  }

  private updateColumns() {
    const items: SplitViewChildInfo[] = [];
    this.children.forEach((childTag: number) => {
      const childDescriptor =
        this.ctx.descriptorRegistry.getDescriptor<RNSSplitViewScreenDescriptor>(childTag);
      if (childDescriptor) {
        const columnTypeValue = childDescriptor.rawProps['columnType'] as string | undefined;
        items.push({
          tag: childTag,
          columnType: columnTypeValue ?? 'column',
        });
      }
    });
    this.columns = items;
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      Row() {
        ForEach(this.columns, (item: SplitViewChildInfo) => {
          this.buildColumn(item);
        }, (item: SplitViewChildInfo) => item.tag.toString());
      }
      .width('100%')
      .height('100%');
    }
  }

  @Builder
  private buildColumn(item: SplitViewChildInfo) {
    // Simple proportional layout: inspector columns are narrower.

    Column() {
      RNSSplitViewScreen({
        ctx: this.ctx,
        tag: item.tag,
      });
    }
    .layoutWeight(item.columnType === 'inspector' ? 1 : 2)
    .height('100%');
  }
}

