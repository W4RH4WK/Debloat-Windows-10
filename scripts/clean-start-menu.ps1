function Pin-App {    param(
        [string]$appname,
        [switch]$unpin
    )
    try{
        if ($unpin.IsPresent){
            ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Von "Start" lösen|Unpin from Start'} | %{$_.DoIt()}
            return "App '$appname' unpinned from Start"
        }else{
            ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'An "Start" anheften|Pin to Start'} | %{$_.DoIt()}
            return "App '$appname' pinned to Start"
        }
    }catch{
        Write-Error "Error Pinning/Unpinning App! (App-Name correct?)"
    }
}

Pin-App "Mail" -unpin
Pin-App "Fotos" -unpin
Pin-App "Store" -unpin
Pin-App "Kalender" -unpin
Pin-App "Microsoft Edge" -unpin
Pin-App "Photos" -unpin
Pin-App "Cortana" -unpin
Pin-App "Wetter" -unpin
Pin-App "Phone Companion" -unpin
Pin-App "Twitter" -unpin
Pin-App "Skype Video" -unpin
Pin-App "Candy Crush Soda Saga" -unpin
Pin-App "Groove-musik" -unpin
Pin-App "filme & tv" -unpin
Pin-App "microsoft solitaire collection" -unpin
Pin-App "money" -unpin
Pin-App "office holen" -unpin
Pin-App "onenote" -unpin
Pin-App "news" -unpin
Pin-App "xbox" -unpin
Pin-App "Disney Magic Kingdoms" -unpin
Pin-App "March of Empires: War of Lords" -unpin
Pin-App "Keeper" -unpin
Pin-App "Bubble Witch 3 Saga" -unpin
Pin-App "XING" -unpin
Pin-App "Paint 3D" -unpin
Pin-App "Skype" -unpin
Pin-App "WinZip Universal" -unpin
Pin-App "Rechner" -unpin
Pin-App "Karten" -unpin
Pin-App "Dolby Access" -unpin
Pin-App "Spotify" -unpin
