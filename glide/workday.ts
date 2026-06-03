declare global {
    interface ExcmdRegistry {
        workday: typeof workday
    }
    interface GlideGlobals {
        workdayUrl: URL;
    }
}

glide.fs.read("./workday.url", "utf8").then((value) => {
    glide.g.workdayUrl = URL.parse(value)!;
})
const workday = glide.excmds.create({ name: "workday", description: "Open workday in Work container and select time submission" }, workDay)

async function workDay(_props: glide.ExcmdCallbackProps) {
    await glide.excmds.execute(`tabnew -c Work ${glide.g.workdayUrl.toString()}`)

    glide.autocmds.create("UrlEnter", { hostname: glide.g.workdayUrl.hostname }, ({ url, tab_id }) => {
        console.log(url, tab_id)
        console.log(glide.g.workdayUrl)
        glide.buf.keymaps.set("normal", "<leader>x", async () => {
            await glide.content.execute(() => {
                let node = document.body.querySelector("[data-uxi-actionbutton-tasktitle='My Time']")
                node?.querySelector("button")?.click()
            }, { tab_id: await glide.tabs.active(), });
        })
    })
}
