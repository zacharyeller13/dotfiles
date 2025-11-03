browser.contextualIdentities.query({ name: "Work" })

async function getContainerByName(containerName?: string): Promise<string> {
    const containers = await browser.contextualIdentities.query({ name: containerName })
    let id = containers[0]?.cookieStoreId
    assert(id)
    return id
}

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
    // Clear tmpContainers on startup
    const containers = await browser.contextualIdentities.query({})
    for (const container of containers) {
        if (container.name.startsWith("tmp")) {
            glide.excmds.execute(`containerdelete ${container.name}`)
        }
    }
});
