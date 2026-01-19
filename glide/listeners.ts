async function startWebRequestListener(capturedRequests: Map<string, any>): Promise<(details: Browser.WebRequest.OnSendHeadersDetailsType) => void> {
    console.log("starting listener");
    const requestListener = (details: Browser.WebRequest.OnSendHeadersDetailsType) => {
        capturedRequests.set(details.url, details);
    };
    let currentTab = await glide.tabs.active();
    browser.webRequest.onSendHeaders.addListener(requestListener, { urls: ["<all_urls>"], tabId: currentTab.id }, ["requestHeaders"]);
    return requestListener;
}

async function captureNextDownload(): Promise<void> {
    const capturedRequests: Map<string, Browser.WebRequest.OnSendHeadersDetailsType> = new Map();
    const curlArgs: string[] = ["curl", "-X"];
    const requestListener = await startWebRequestListener(capturedRequests);

    const downloadsListener = async (downloadItem: Browser.Downloads.DownloadItem) => {
        const requestData = capturedRequests.get(downloadItem.url);
        if (requestData) {
            await browser.downloads.cancel(downloadItem.id);
            curlArgs.push(requestData.method)
            curlArgs.push(`"${requestData.url}"`)

            let headers = requestData.requestHeaders ?? []
            for (const header of headers) {
                let headerValue = header.value ?? ""
                curlArgs.push("-H", `'${header.name}: ${headerValue}'`)
            }

            // In case of any redirects
            curlArgs.push("-L")
            let curl = curlArgs.join(" ");
            glide.commandline.show(
                {
                    title: "Curl request (<Enter> to yank)",
                    options: [{
                        label: curl, execute: async () => {
                            await navigator.clipboard.writeText(curl);
                        }
                    }]
                },
            );

        }

        setTimeout(() => {
            console.log("Stopping listener");
            browser.webRequest.onSendHeaders.removeListener(requestListener);
            browser.downloads.onCreated.removeListener(downloadsListener);
        }, 2000);
    }

    browser.downloads.onCreated.addListener(downloadsListener);
}


glide.keymaps.set("normal", "<leader>cd", captureNextDownload);
