let tmpId: number = 0;

glide.keymaps.set("normal", "<leader>t", createTmpContainer, { description: "Open [t]emp container" });

glide.keymaps.set("normal", "T", async () => {
    const containers = await browser.contextualIdentities.query({});

    glide.commandline.show({
        title: "Open container tab",
        // input: "tabnew -c ",
        options: containers.map((container) => ({
            label: container.name,
            // description: container.name,
            execute: () => {
                glide.excmds.execute(`tabnew -c ${container.name}`)
            }
        }))
    })
});

// Close tab and delete container if this is last tab
glide.keymaps.set("normal", "<leader>d", tabClose, { description: "Close tab (checking to close tmp containers" })

/** Create a new container prefixed with "tmp" and the current increment of tmpId
 *  and open a new tab inside that container
 */
async function createTmpContainer(): Promise<void> {
    const colors: string[] = ["blue", "red", "green", "orange"];
    let choice = Math.floor(Math.random() * colors.length);
    let color = colors[choice] ?? "white";

    const container = await browser.contextualIdentities.create({ name: `tmp${tmpId++}`, color: color, icon: "fingerprint" });
    await browser.tabs.create({ cookieStoreId: container.cookieStoreId });
}

/** Close the active tab and remove its container if it is the only
  * tab in the container. This is necessary because we are not longer able to get tabinfo
  * like the cookieStoreId at the 'onRemoved' event
  */
async function tabClose(): Promise<void> {
    const activeTab = await glide.tabs.active();
    let cookieStoreId = activeTab.cookieStoreId;
    if (!cookieStoreId) {
        return glide.excmds.execute("tab_close");
    }

    const containedTabs = await glide.tabs.query({ cookieStoreId: cookieStoreId })
    if (containedTabs.length > 1) {
        return glide.excmds.execute("tab_close");
    }

    assert(containedTabs.length == 1, "Should be only exactly 1 tab in the container at this point")
    browser.contextualIdentities.get(cookieStoreId).then(
        async (container) => {
            if (!container.name.startsWith("tmp")) {
                return
            }
            await browser.contextualIdentities.remove(cookieStoreId);
        }
        , (reason) => {
            console.warn(`Error getting container when closing tab: ${reason}`);
        }
    );

    return glide.excmds.execute("tab_close");
}
