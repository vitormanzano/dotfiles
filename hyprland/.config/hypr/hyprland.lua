--, user.Password.PasswordValue , user.Password.PasswordValueFix package.path so require() can find files in modules/
package.path = package.path .. ";" .. (os.getenv("HOME") or "") .. "/.config/hypr/?.lua"

-- Programs used across modules
terminal    = "ghostty"
fileManager = "ghostty -e yazi"
menu        = "rofi -show drun"

require("modules.monitors")
require("modules.env")
require("modules.autostart")
require("modules.decorations")
require("modules.binds")
require("modules.layout")
require("modules.misc")
require("modules.input")
require("modules.windowrules")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Permission changes require a Hyprland restart to take effect.
hl.config({
    cursor = {
        no_hardware_cursors = true,
    },
    ecosystem = {
        enforce_permissions = true,
    },
})

hl.env("GTK_IM_MODULE", "simple") -- config for using accents in ghostty

 hl.config({
  ecosystem = {
    enforce_permissions = true,
  },
})

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprlock", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")


-- Variáveis de ambiente (Qt/KDE apps)
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Autostart (equivalente ao antigo exec-once)
hl.on("hyprland.start", function()
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")  -- GTK4/libadwaita
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'")        -- GTK3 (precisa do adw-gtk3)
end)
