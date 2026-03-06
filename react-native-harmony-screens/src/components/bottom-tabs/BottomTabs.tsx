'use client';

import React from 'react';
import {
  Platform,
  StyleSheet,
  findNodeHandle,
  type NativeSyntheticEvent,
} from 'react-native';
import BottomTabsNativeComponent, {
  type NativeProps as BottomTabsNativeComponentProps,
} from '../../specs/BottomTabsNativeComponent';
import BottomTabsScreen from './BottomTabsScreen';
import featureFlags from '../../flags';
import type {
  BottomTabsProps,
  NativeFocusChangeEvent,
  RepeatedTabSelectionEvent,
} from './BottomTabs.types';
import { bottomTabsDebugLog } from '../../private/logging';

const CONTENT_SLOT_TAB_KEY = '__content__';
const isHarmony = (Platform as { OS?: string }).OS === 'harmony';

function useContentSlotChildren(
  children: React.ReactNode,
  experimentalControlNavigationStateInJS: boolean,
) {
  const [focusedTabKey, setFocusedTabKey] = React.useState<string | null>(
    null,
  );

  const tabs = React.useMemo(() => {
    const arr = React.Children.toArray(children);
    return arr.filter(
      (child): child is React.ReactElement<{ tabKey?: string }> =>
        React.isValidElement(child) &&
        typeof (child as React.ReactElement<{ tabKey?: string }>).props
          ?.tabKey === 'string' &&
        (child as React.ReactElement<{ tabKey?: string }>).props.tabKey !==
          CONTENT_SLOT_TAB_KEY,
    );
  }, [children]);

  const contentMap = React.useMemo(() => {
    const map: Record<string, React.ReactNode> = {};
    tabs.forEach((tab) => {
      const tabKey = tab.props.tabKey;
      if (tabKey) {
        map[tabKey] = tab.props.children;
      }
    });
    return map;
  }, [tabs]);

  const initialFocusedKey =
    focusedTabKey ?? (tabs[0]?.props?.tabKey as string | undefined) ?? null;

  const derivedFocusedKey = experimentalControlNavigationStateInJS
    ? (tabs.find((t) => t.props.isFocused === true)?.props?.tabKey as
        | string
        | undefined) ?? initialFocusedKey
    : (focusedTabKey ?? initialFocusedKey);

  return {
    tabs,
    contentMap,
    focusedTabKey: derivedFocusedKey,
    setFocusedTabKey,
  };
}

/**
 * EXPERIMENTAL API, MIGHT CHANGE W/O ANY NOTICE
 */
function BottomTabs(props: BottomTabsProps) {
  bottomTabsDebugLog(`BottomTabs render`);

  const {
    children,
    onNativeFocusChange,
    onRepeatedTabSelection,
    experimentalControlNavigationStateInJS = featureFlags.experiment
      .controlledBottomTabs,
    ...filteredProps
  } = props;

  const {
    tabs,
    contentMap,
    focusedTabKey,
    setFocusedTabKey,
  } = useContentSlotChildren(
    children,
    experimentalControlNavigationStateInJS,
  );

  const componentNodeRef =
    React.useRef<React.Component<BottomTabsNativeComponentProps>>(null);
  const componentNodeHandle = React.useRef<number>(-1);

  React.useEffect(() => {
    if (componentNodeRef.current != null) {
      componentNodeHandle.current =
        findNodeHandle(componentNodeRef.current) ?? -1;
    } else {
      componentNodeHandle.current = -1;
    }
  }, []);

  const onNativeFocusChangeCallback = React.useCallback(
    (event: NativeSyntheticEvent<NativeFocusChangeEvent>) => {
      const { tabKey } = event.nativeEvent;
      bottomTabsDebugLog(
        `BottomTabs [${
          componentNodeHandle.current ?? -1
        }] onNativeFocusChange: ${JSON.stringify(event.nativeEvent)}`,
      );
      if (isHarmony) {
        setFocusedTabKey(tabKey);
      }
      onNativeFocusChange?.(event);
    },
    [onNativeFocusChange],
  );

  const onRepeatedTabSelectionCallback = React.useCallback(
    (event: NativeSyntheticEvent<RepeatedTabSelectionEvent>) => {
      bottomTabsDebugLog(
        `BottomTabs [${
          componentNodeHandle.current ?? -1
        }] onRepeatedTabSelection: ${JSON.stringify(event.nativeEvent)}`,
      );
      onRepeatedTabSelection?.(event);
    },
    [onRepeatedTabSelection],
  );

  const renderedChildren = React.useMemo(() => {
    if (!isHarmony || tabs.length === 0) {
      return children;
    }

    const metadataTabs = tabs.map((tab) =>
      React.cloneElement(tab as React.ReactElement<any>, {
        children: null,
      }),
    );

    const contentSlotTab = (
      <BottomTabsScreen
        key={CONTENT_SLOT_TAB_KEY}
        tabKey={CONTENT_SLOT_TAB_KEY}
        isFocused={true}
      >
        {focusedTabKey ? contentMap[focusedTabKey] : null}
      </BottomTabsScreen>
    );

    return [...metadataTabs, contentSlotTab];
  }, [isHarmony, tabs, children, focusedTabKey, contentMap]);

  return (
    <BottomTabsNativeComponent
      style={styles.fillParent}
      onNativeFocusChange={onNativeFocusChangeCallback}
      onRepeatedTabSelection={onRepeatedTabSelectionCallback}
      controlNavigationStateInJS={experimentalControlNavigationStateInJS}
      // @ts-ignore suppress ref - debug only
      ref={componentNodeRef}
      {...filteredProps}>
      {renderedChildren}
    </BottomTabsNativeComponent>
  );
}

export default BottomTabs;

const styles = StyleSheet.create({
  fillParent: {
    flex: 1,
    width: '100%',
    height: '100%',
  },
});
