
const containercreate = glide.excmds.create({ name: "containercreate", description: "Create a new container" }, createContainer)
const containerdelete = glide.excmds.create({ name: "containerdelete", description: "Delete a container by name" }, deleteContainer)
const containerremove = glide.excmds.create({ name: "containerremove", description: "Alias for `containerdelete`" }, deleteContainer)
const tmpClear = glide.excmds.create({ name: "tmpClear", description: "Delete ALL tmp containers" }, clearTmpContainers)
const tabnew = glide.excmds.create({ name: "tabnew", description: "Open new tab, optionally in a container with '-c'" }, tabNew)

declare global {
    interface ExcmdRegistry {
        containercreate: typeof containercreate
        containerdelete: typeof containerdelete
        containerremove: typeof containerremove
        tmpClear: typeof tmpClear
        tabnew: typeof tabnew
    }
}

async function clearTmpContainers(_: glide.ExcmdCallbackProps) {
    const containers = await browser.contextualIdentities.query({})
    for (const container of containers) {
        if (container.name.startsWith("tmp")) {
            glide.excmds.execute(`containerdelete ${container.name}`)
        }
    }
}

async function createContainer(props: glide.ExcmdCallbackProps) {
    assert(props.args_arr.length >= 1, "Must provide container name with `containercreate {name}`")
    let name = props.args_arr[0]
    assert(name)
    const container = await browser.contextualIdentities.create({ name: name, color: "red", icon: "fingerprint" });
    glide.excmds.execute(`echo ${container.name}`);
    await browser.tabs.create({ cookieStoreId: container.cookieStoreId });
}

async function deleteContainer(props: glide.ExcmdCallbackProps) {
    assert(props.args_arr.length >= 1, "Must provide container name with `containerdelete {name}`")
    let name = props.args_arr[0]
    assert(name)
    const containers = await browser.contextualIdentities.query({ name: name })
    for (const container of containers) {
        await browser.contextualIdentities.remove(container.cookieStoreId)
    }
}

async function tabNew(props: glide.ExcmdCallbackProps) {
    if (props.args_arr.length > 1) {
        assert(props.args_arr[0] === "-c", "Only option '-c' supported");
        assert(props.args_arr.length >= 2, "Must provide container name with `tabnew -c {name}`");

        let containerName = props.args_arr[1];
        let url = props.args_arr[2]
        // url needs to have the scheme
        if (url && !url.startsWith("http")) {
            url = "https://" + url;
        }
        const containers = await browser.contextualIdentities.query({ name: containerName });
        if (containers.length === 1) {
            let container = containers[0];
            await browser.tabs.create({ cookieStoreId: container?.cookieStoreId, url: url });
            return
        }
    }
    await browser.tabs.create({})
}
