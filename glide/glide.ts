// Config docs:
//
//   https://glide-browser.app/config
//
// API reference:
//
//   https://glide-browser.app/api
//
// Default config files can be found here:
//
//   https://github.com/glide-browser/glide/tree/main/src/glide/browser/base/content/plugins
//
// Most default keymappings are defined here:
//
//   https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts
//
// Try typing `glide.` and see what you can do!

glide.unstable.include("excmds.ts");
glide.unstable.include("autocmds.ts");
glide.unstable.include("styles.ts");

declare global {
    interface GlideGlobals {
        containerIds: string[];
        tabsLoaded: boolean;
    }
}
glide.g.containerIds = [];
let tmpId: number = 0;

// Options
glide.o.hint_size = "15px";
glide.prefs.set("toolkit.legacyUserProfileCustomizations.stylesheets", true);
glide.prefs.set("media.videocontrols.picture-in-picture.audio-toggle.enabled", true);

// Keymaps
glide.keymaps.set("normal", "<leader>t",
    () => {
        createTmpContainer()
            .then(
                () => console.log("Opened container"),
                (reason) => console.error(`Couldn't open new tab, ${reason}`)
            );
        console.log(glide.g.containerIds);
    }
    , { description: "Open [t]emp container" }
);
glide.keymaps.set("command", "<C-n>", "commandline_focus_next", { description: "[N]ext result" });
glide.keymaps.set("command", "<C-p>", "commandline_focus_back", { description: "[P]revious result" });
glide.keymaps.set("command", "<C-y>", "commandline_accept", { description: "Accept result/[Y]es" });
glide.keymaps.set("normal", "t", "tab_new", { description: "New [t]ab" });
glide.keymaps.set("normal", "T", "commandline_show tabnew -c", { description: "New [T]ab in container" });
glide.keymaps.set("normal", "H", "back", { description: "Back (history)" });
glide.keymaps.set("normal", "L", "forward", { description: "Forward (history)" });
glide.keymaps.set("normal", "<leader>u", undoTabClose, { description: "undo close tab (reopen)" });
glide.keymaps.set(["insert", "command"], "jj", "mode_change normal", { description: "Escape mapping" });

const selectors = "[class*=link], [class*=action], [class*=button], [tabindex], [data-qa*=btn]"
// This kinda works for now as far as adding more clickable hints
glide.keymaps.set("normal", "f", () => { glide.hints.show({ include: selectors }) })
// Show the built-in hints only incase I've selected too many with selectors
glide.keymaps.set("normal", ";f", "hint")

// Open in new tab instead of directly
glide.keymaps.set("normal", "F", () => { glide.hints.show({ include: selectors, action: "newtab-click" }) })


// Custom funcs
// TODO: Delete container when last tab is closed
async function createTmpContainer() {
    const colors: string[] = ["blue", "red", "green", "orange"];
    let choice = Math.floor(Math.random() * colors.length);
    let color = colors[choice] ?? "white";

    const container = await browser.contextualIdentities.create({ name: `tmp${tmpId++}`, color: color, icon: "fingerprint" });
    glide.excmds.execute(`echo ${container.name}`);
    await browser.tabs.create({ cookieStoreId: container.cookieStoreId });
    glide.g.containerIds.push(container.cookieStoreId);
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

// Default Hintables from Tridactyl
/*export const HINTTAGS_selectors = `
input:not([type=hidden]):not([disabled]),
a,
area,
button,
details,
iframe,
label,
select,
summary,
textarea,
[onclick],
[onmouseover],
[onmousedown],
[onmouseup],
[oncommand],
[role='link'],
[role='button'],
[role='checkbox'],
[role='combobox'],
[role='listbox'],
[role='listitem'],
[role='menuitem'],
[role='menuitemcheckbox'],
[role='menuitemradio'],
[role='option'],
[role='radio'],
[role='scrollbar'],
[role='slider'],
[role='spinbutton'],
[role='tab'],
[role='textbox'],
[role='treeitem'],
[class*='button'],
[tabindex]`*/
