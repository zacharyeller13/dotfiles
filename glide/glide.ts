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

glide.include("excmds.ts");
glide.include("autocmds.ts");
glide.include("styles.ts");
glide.include("keymaps.ts");
glide.include("containers.ts");
glide.include("listeners.ts");

// Options
glide.o.hint_size = "15px";
glide.prefs.set("toolkit.legacyUserProfileCustomizations.stylesheets", true);
glide.prefs.set("media.videocontrols.picture-in-picture.audio-toggle.enabled", true);

// Visual selection of non-editable elements
// document.getSelection().addRange(range)
// where range is already has a start and end set with setStart and setEnd
// can we grab the elements of the hints?
