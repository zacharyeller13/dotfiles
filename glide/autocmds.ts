const pinnedTabs: { pinned: boolean, url: string, urlPattern: string, container?: string }[] = [
    {
        pinned: true,
        url: "https://vault.netvoyage.com/neWeb2/home/",
        urlPattern: "https://vault.netvoyage.com/*",
        container: "Work"
    },
    {
        pinned: true,
        url: "https://dev.azure.com/haynesbooneLLP",
        urlPattern: "https://dev.azure.com/haynesbooneLLP*",
        container: "Work"
    },
    {
        pinned: true,
        url: "https://2-app.donedone.com/",
        urlPattern: "https://*.donedone.com/*",
        container: "Work"
    },
    {
        pinned: true,
        url: "https://haynesboone.my.intapp.com/IIS",
        urlPattern: "https://platform.boomi.com/*",
        container: "Work"
    },
]

async function getContainerByName(containerName?: string): Promise<string> {
    const containers = await browser.contextualIdentities.query({ name: containerName })
    let id = containers[0]?.cookieStoreId
    assert(id)
    return id
}

// This is fired on every window open
glide.autocmds.create("ConfigLoaded", async () => {
    glide.process.execute("uname").then(async (val: glide.CompletedProcess) => {
        for await (const line of val.stdout.values()) {
            if (!line.startsWith("Darwin")) {
                return;
            }
        }
        // Pinned tabs
        for (const tab of pinnedTabs) {
            let newTab: Browser.Tabs.CreateCreatePropertiesType = { pinned: tab.pinned, url: tab.url };
            if (tab.container) {
                newTab.cookieStoreId = await getContainerByName(tab.container);
            }

            let existingTab = await glide.tabs.get_first({ pinned: tab.pinned, url: tab.urlPattern, cookieStoreId: newTab.cookieStoreId })
            if (!existingTab) {
                await browser.tabs.create(newTab);
            }
        }

    });
});


//Thanks 45Hnri!
glide.autocmds.create("ModeChanged", "*", (_) => {
    glide.styles.add(`
      #browser {
        border-bottom: 5px solid var(--glide-current-mode-color)
      }
    `,
        { id: "glide-custom-mode-indicator", overwrite: true },
    );
});

// Enter insert on url bar on new tab
glide.autocmds.create("UrlEnter", RegExp("about:newtab"), async (_: { url: string, tab_id: number }) => {
    await glide.excmds.execute("mode_change insert")
})
