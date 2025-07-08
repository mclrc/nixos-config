{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    # languagePacks in Home Manager are managed slightly differently
    # if you want to ensure they are installed. Often, Firefox
    # handles these automatically based on system locale or
    # you manage them through policies or directly in the browser.
    # The 'languagePacks' option you provided seems to be a specific
    # NixOS system-level option rather than a direct Home Manager one for Firefox.
    # If you need to ensure language packs are available, you might
    # need to explicitly add them to your `home.packages` or rely on the system setup.
    # For now, I'll omit it as it's not a direct 'programs.firefox' option in HM.
    # If it's crucial, we'd look into a different way to include it.

    # Policies directly map over
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "always"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"

      # Extensions via policies. ExtensionSettings syntax is identical.
      # Note: The Home Manager 'extensions' option (array of URLs) is for *user-installed* extensions,
      # which are installed into the profile directly. Policies are for *managed* installations,
      # which might be locked down by an admin. You've correctly used the policy approach here.
      ExtensionSettings = {
        # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4525374/bitwarden_password_manager-2025.6.1.xpi";
          installation_mode = "force_installed";
        };
        # Uncomment and provide valid URLs/IDs for these if you want them managed via policies:
        # "uBlock0@raymondhill.net" = {
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        #   installation_mode = "force_installed";
        # };
        # "jid1-MnnxcxisBPnSXQ@jetpack" = {
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
        #   installation_mode = "force_installed";
        # };
        # "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
        #   installation_mode = "force_installed";
        # };
      };
    };

    # Preferences go into the 'profiles.<name>.settings' attribute.
    # Assuming 'default' profile here.
    profiles.default = {
      settings = {
        # "browser.contentblocking.category" = "strict"; # No 'Value' or 'Status' here, just the value itself
        "extensions.pocket.enabled" = false;
        "extensions.screenshots.disabled" = true;
        "browser.topsites.contile.enabled" = false;
        "browser.formfill.enable" = false;
        "browser.search.suggest.enabled" = false;
        "browser.search.suggest.enabled.private" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.system.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "ui.systemUsesDarkTheme" = true;
        "browser.in-content.dark-mode" = true;
        "browser.theme.content-theme" = 1;
      };
    };
  };
}
