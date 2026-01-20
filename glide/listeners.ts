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
    const requestListener = await startWebRequestListener(capturedRequests);

    const downloadsListener = async (downloadItem: Browser.Downloads.DownloadItem) => {
        console.log("download listener fired: ", downloadItem.id);
        browser.webRequest.onSendHeaders.removeListener(requestListener);
        browser.downloads.onCreated.removeListener(downloadsListener);

        const requestData = capturedRequests.get(downloadItem.url);
        if (requestData) {
            const curlArgs: string[] = ["curl", "-X"];
            await browser.downloads.cancel(downloadItem.id);

            curlArgs.push(requestData.method)
            curlArgs.push(`"${requestData.url}"`)
            console.log(requestData)

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
    }

    browser.downloads.onCreated.addListener(downloadsListener);

    // Remove listeners regardless of download or not
    setTimeout(() => {
        console.log("Stopping request listener");
        browser.webRequest.onSendHeaders.removeListener(requestListener);
        console.log("Stopping download listener");
        browser.downloads.onCreated.removeListener(downloadsListener);
    }, 5000);
}


glide.keymaps.set("normal", "<leader>cd", captureNextDownload);
