-- Use this to replace [toc] in markdown files with an actual table of contents
return {
    {
        'hedyhli/markdown-toc.nvim',
        ft = 'markdown', -- Lazy load on markdown filetype
        cmd = { 'Mtoc' }, -- Or, lazy load on "Mtoc" command
        opts = {
            auto_update = true,
        },
    },
}
