export const TAB_ITEM_TAG_NAME = "custom-tab-item";
export const TAB_ITEM_KEY = "tab";
export const getTabId = (key: string | number) => `${TAB_ITEM_KEY}-${key}`;
export const getStoreKey = (groupName: string) => `tabs_${groupName}`;
export const getStore = () => ({
  activeTab: null,
});
export const getXData = (groupName?: string) => {
  if (!groupName) return JSON.stringify(getStore());

  const storeKey = getStoreKey(groupName);

  return `{
    get activeTab() {
      return Alpine.store("${storeKey}")?.activeTab ?? '';
    },
    set activeTab(value) {
      if (Alpine.store("${storeKey}")) {
        Alpine.store("${storeKey}").activeTab = value;
      }
    },
  }`;
};
