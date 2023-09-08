#!/bin/sh


requisites() {
    local base_packages="bspwm sxhkd tmux zsh rofi kitty polybar"
    local aux_packages="bat lsd rbenv grc fzf wmname feh"
    
    echo "Actualizando repositorios..."
    
    sudo apt update

    echo "Instalando paquetes..."

    sudo apt install ${base_packages} ${aux_packages} -y
    sudo apt remove kitty -y
}


kitty() {
    echo "Instalando kitty..."
    
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    
    sudo ln -s ~/.local/kitty.app/bin/kitty /usr/bin/kitty
    sudo ln -s ~/.local/kitty.app/bin/kitten /usr/bin/kitten
}


dotfiles() {
    echo "Instalando fuentes..."

    mkdir -p ~/.fonts & cp -r fonts ~/.fonts
    
    echo "Aplicando configuraciones..."
    
    cp -r .zshrc ~/.zshrc
    cp -r bspwm ~/.config/
    cp -r sxhkd ~/.config/
    cp -r polybar ~/.config/
    cp -r kitty ~/.config/
    
    echo "Aplicando permisos..."
    
    chmod +x ~/.config/bspwm/bspwmrc
    chmod +x ~/.config/bspwm/scripts/bspwm_resize
    chmod +x ~/.config/sxhkd/sxhkdrc
    find ~/.config/polybar -type f -name "*.sh" -exec chmod +x {} \;
}


plugins() {
    local plugin_dir="/usr/share/zsh/plugins/"
        
    # Carpetas necesarias
    sudo mkdir -p $plugin_dir
        
    echo "Instalando plugins para zsh..."
        
    sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting ${plugin_dir}zsh-syntax-highlighting
    sudo git clone https://github.com/zsh-users/zsh-autosuggestions ${plugin_dir}zsh-autosuggestions
    sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -O ${plugin_dir}sudo.plugin.zsh
}


powerlevel10k() {
    echo "Instalando 'powerlevel10k' para zsh..."
    
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
    
    echo "Actualizando configuración de zsh..."
    
    sudo rm -f /root/.zshrc
    sudo ln -s /home/*/.zshrc /root/.zshrc
}


# Ejecucion principal
requisites      ; echo
kitty           ; echo
dotfiles        ; echo
plugins         ; echo
powerlevel10k   ; echo

