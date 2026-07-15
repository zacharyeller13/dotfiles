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
