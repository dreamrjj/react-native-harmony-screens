// Implementation adapted from `react-native-safe-area-context`:
// https://github.com/AppAndFlow/react-native-safe-area-context/blob/v5.6.1/src/SafeAreaView.tsx
'use client';

import React from 'react';
import { SafeAreaViewProps, NativeStatusBarHeightChangeEvent, NativeNavigationBarHeightChangeEvent } from './SafeAreaView.types';
import SafeAreaViewNativeComponent, {
  NativeProps as SafeAreaViewNativeComponentProps,
} from '../../specs/SafeAreaViewNativeComponent';
import { StyleSheet, NativeSyntheticEvent, DeviceEventEmitter } from 'react-native';

function SafeAreaView(props: SafeAreaViewProps) {
  const [statusBarHeight, setStatusBarHeight] = React.useState(0);
  const onStatusBarHeightChangeCallback = (
    event: NativeSyntheticEvent<NativeStatusBarHeightChangeEvent>
  ) => {
    setStatusBarHeight(event.nativeEvent.statusBarHeight);
    if (typeof props.onStatusBarHeightChange === "function") {
      props.onStatusBarHeightChange?.(event);
    }
  };

  const [navigationBarHeight, setNavigationBarHeight] = React.useState(0);
  const onNavigationBarHeightChangeCallback = (
    event: NativeSyntheticEvent<NativeNavigationBarHeightChangeEvent>
  ) => {
    setNavigationBarHeight(event.nativeEvent.navigationBarHeight);
    if (typeof props.onNavigationBarHeightChange === "function") {
      props.onNavigationBarHeightChange?.(event);
    }
  };

  DeviceEventEmitter.emit('EVENT_TOPEDGE', {
    topEdges: props.edges?.top
  });

  const [translucent, setTranslucent] = React.useState(false);
  const [hidden, setHidden] = React.useState(false);

  React.useEffect(() => {
    const unsubscribe = DeviceEventEmitter.addListener('EVENT_HEADERCONFIG', (data) => {
      if (data?.translucent !== undefined) {
        queueMicrotask(() => {
          setTranslucent(data?.translucent);
        });
      }
      if (data?.translucent !== undefined) {
        queueMicrotask(() => {
          setHidden(data?.hidden);
        });
      }
    });
    return () => unsubscribe.remove();
  })

  function getSafeAreaPadding(
    statusBarHeight: number,
    headerConfig?: { translucent: boolean; hidden: boolean }
  ): number {
    if (!headerConfig?.translucent && headerConfig?.hidden) {
      return 0;
    } else {
      return statusBarHeight;
    }
  }

  return (
    <SafeAreaViewNativeComponent
      {...props}
      style={[styles.flex, props.style, { zIndex: undefined, paddingTop: getSafeAreaPadding(statusBarHeight, { translucent, hidden }), paddingBottom: navigationBarHeight }]}
      edges={getNativeEdgesProp(props.edges)}
      onStatusBarHeightChange={onStatusBarHeightChangeCallback}
      onNavigationBarHeightChange={onNavigationBarHeightChangeCallback}
    />
  );
}

export default SafeAreaView;

function getNativeEdgesProp(
  edges: SafeAreaViewProps['edges'],
): SafeAreaViewNativeComponentProps['edges'] {
  return {
    top: false,
    bottom: false,
    left: false,
    right: false,
    ...edges,
  };
}

const styles = StyleSheet.create({
  flex: {
    flex: 1,
  },
});
