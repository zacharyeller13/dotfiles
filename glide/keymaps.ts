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

glide.keymaps.set("normal", "<C-d>", "scroll_page_down")
glide.keymaps.set("normal", "<C-u>", "scroll_page_up")

glide.keymaps.set("normal", "<leader>s", async () => {
    let current = await glide.tabs.active()
    if (glide.unstable.split_views.has_split_view(current)) {
        glide.unstable.split_views.separate(current)
        return
    }
    glide.commandline.show({
        title: "Select 2nd tab",
        options: (await listAllTabs()).map((tab) => ({ label: tab.title!, execute(_) { glide.unstable.split_views.create([current, tab]) } }))
    })

}, { description: "Split view" })

async function listAllTabs() {
    let tabs = await glide.tabs.query({ active: false })
    return tabs
}


const selectors = "[class*=link], [class*=action], [class*=button], [tabindex], [data-qa*=btn]"
// This kinda works for now as far as adding more clickable hints
glide.keymaps.set("normal", "f", () => { glide.hints.show({ include: selectors, include_click_listeners: true }) })
// Open in new tab instead of directly
glide.keymaps.set("normal", "F", () => { glide.hints.show({ include: selectors, action: "newtab-click", include_click_listeners: true }) })

// Show the built-in hints only incase I've selected too many with selectors
glide.keymaps.set("normal", ";f", "hint")

/** Move a tab forward or backward
  * @param {number} direction - 1 or -1
  */
async function moveActiveTab(direction: 1 | -1) {
    let tab = await glide.tabs.active()

    await browser.tabs.move(tab.id, { index: tab.index + direction })
}
