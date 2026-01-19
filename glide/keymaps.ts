let tmpId: number = 0;

// Keymaps
glide.keymaps.set("normal", "<leader>t", createTmpContainer, { description: "Open [t]emp container" });
glide.keymaps.set("command", "<C-n>", "commandline_focus_next", { description: "[N]ext result" });
glide.keymaps.set("command", "<C-p>", "commandline_focus_back", { description: "[P]revious result" });
glide.keymaps.set("command", "<C-y>", "commandline_accept", { description: "Accept result/[Y]es" });
glide.keymaps.set("normal", "t", "tab_new", { description: "New [t]ab" });
glide.keymaps.set("normal", "H", "back", { description: "Back (history)" });
glide.keymaps.set("normal", "L", "forward", { description: "Forward (history)" });
glide.keymaps.set("normal", "<leader>u", undoTabClose, { description: "undo close tab (reopen)" });
glide.keymaps.set(["insert", "command"], "jj", "mode_change normal", { description: "Escape mapping" });
glide.keymaps.set("normal", ">>", async () => await moveActiveTab(1), { description: "Move tab forward" })
glide.keymaps.set("normal", "<lt><lt>", async () => await moveActiveTab(-1), { description: "Move tab backward" })


// glide.keymaps.set("normal", "T", "commandline_show tabnew -c", { description: "New [T]ab in container" });
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


const selectors = "[class*=link], [class*=action], [class*=button], [tabindex], [data-qa*=btn]"
// This kinda works for now as far as adding more clickable hints
glide.keymaps.set("normal", "f", () => { glide.hints.show({ include: selectors, include_click_listeners: true }) })
// Open in new tab instead of directly
glide.keymaps.set("normal", "F", () => { glide.hints.show({ include: selectors, action: "newtab-click", include_click_listeners: true }) })

// Show the built-in hints only incase I've selected too many with selectors
glide.keymaps.set("normal", ";f", "hint")

// Close tab and delete container if this is last tab
glide.keymaps.set("normal", "<leader>d", tabClose, { description: "Close tab (checking to close tmp containers" })

// Search history
glide.keymaps.set("normal", "<leader>sh", async () => {
    const history = await browser.history.search({
        text: "",
        maxResults: 10000,
    })
    history.sort((l, r) => { return (l.visitCount ?? 0) - (r.visitCount ?? 0) })
    console.log(`history len: ${history.length}`)

    glide.commandline.show({
        title: "history",
        options: history.map((histItem) => ({
            label: histItem.title!,
            description: histItem.url,
            execute: async () => { console.log(histItem) }
        }))
    })
});


/** Move a tab forward or backward
  * @param {number} direction - 1 or -1
  */
async function moveActiveTab(direction: 1 | -1) {
    let tab = await glide.tabs.active()

    await browser.tabs.move(tab.id, { index: tab.index + direction })
}

// Custom funcs
async function createTmpContainer(): Promise<void> {
    const colors: string[] = ["blue", "red", "green", "orange"];
    let choice = Math.floor(Math.random() * colors.length);
    let color = colors[choice] ?? "white";

    const container = await browser.contextualIdentities.create({ name: `tmp${tmpId++}`, color: color, icon: "fingerprint" });
    await browser.tabs.create({ cookieStoreId: container.cookieStoreId });
}

// Re-open closed tab/window
// borrowed from tridactyl
async function undoTabClose(): Promise<void> {
    const sessions = await browser.sessions.getRecentlyClosed({ maxResults: 1 })
    const session = sessions[0]

    if (session) {
        await browser.sessions.restore((session.tab || session.window)?.sessionId)
    }
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
            console.warn(reason);
        }
    );

    return glide.excmds.execute("tab_close");
}
