// Keymaps
glide.keymaps.set("command", "<C-n>", "commandline_focus_next", { description: "[N]ext result" });
glide.keymaps.set("command", "<C-p>", "commandline_focus_back", { description: "[P]revious result" });
glide.keymaps.set("command", "<C-y>", "commandline_accept", { description: "Accept result/[Y]es" });
glide.keymaps.set("normal", "t", "tab_new", { description: "New [t]ab" });
glide.keymaps.set("normal", "H", "back", { description: "Back (history)" });
glide.keymaps.set("normal", "L", "forward", { description: "Forward (history)" });
glide.keymaps.set("normal", "<leader>u", "tab_reopen", { description: "undo close tab (reopen)" });
glide.keymaps.set(["insert", "command"], "jj", "mode_change normal", { description: "Escape mapping" });
glide.keymaps.set("normal", ">>", async () => await moveActiveTab(1), { description: "Move tab forward" })
glide.keymaps.set("normal", "<lt><lt>", async () => await moveActiveTab(-1), { description: "Move tab backward" })


const selectors = "[class*=link], [class*=action], [class*=button], [tabindex], [data-qa*=btn]"
// This kinda works for now as far as adding more clickable hints
glide.keymaps.set("normal", "f", () => { glide.hints.show({ include: selectors, include_click_listeners: true }) })
// Open in new tab instead of directly
glide.keymaps.set("normal", "F", () => { glide.hints.show({ include: selectors, action: "newtab-click", include_click_listeners: true }) })

// Show the built-in hints only incase I've selected too many with selectors
glide.keymaps.set("normal", ";f", "hint")

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
