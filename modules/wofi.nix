{ config, pkgs, ... }:

{
  # Wofi theming for Catppuccin Mocha
  xdg.configFile."wofi/style.css".text = ''
    window {
        margin: 0px;
        border: 0px solid #45475A;
        background-color: #1E1E2E;
    }

    #input {
        margin: 5px;
        border: 0px;
        color: #CDD6F4;
        background-color: #313244;
    }

    #outer-box {
        margin: 5px;
        border: 0px;
        background-color: #1E1E2E;
    }

    #scroll {
        margin: 0px;
        border: 0px;
    }

    #inner-box {
        margin: 5px;
        border: 0px;
        background-color: #1E1E2E;
    }

    #text {
        margin: 0px;
        border: 0px;
        color: #CDD6F4;
    }

    #entry:selected {
        background-color: #45475A;
    }
  '';
}
