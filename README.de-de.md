# Debloat Windows 10

### Übersetzungen
[🇬🇧 Englische Version (`GB`)](README.md)

<br>

Dieses Projekt sammelt PowerShell Skripte, die helfen um Windows 10 zu *debloaten*,
häufige Einstellungen zu optimieren und wesentliche Software zu installieren.

Ich habe diese Skripte auf einer Windows 10 Professional 64-bit (Englisch) virtuellen
Maschine getestet. Bitte lasst es mich wissen, wenn es bei euch Fehler gibt.
Die Home Edition und andere Sprachen werden nicht unterstützt.
Diese Skripte sind für technisch erfahrene Administratoren vorgesehen, die wissen was
sie tun und diese Phase der Einrichtung automatisieren wollen. Wenn dies nicht auf dich
zutrifft, empfehle ich ein anderes (interaktiveres) Tool zu nutzen -- und es gibt viele davon.

Beachte bitte, dass ebenfalls Gaming Apps und Serviceprogramme entfernt/deaktiviert werden.
Wenn Du dein System für Gaming benutzen möchtest, passe bitte die Skripte an.

**Es gibt kein Zurück**, Ich empfehle, diese Skripte nur auf einer frischen
Windows Installation (mit Updates) zu verwenden. Teste alles nachdem Du sie genutzt hast,
bevor Du etwas anderes tust. Außerdem gibt es keine Garantie das alles funktionieren wird,
nach einem Update, da ich nicht vorhersagen kann was Microsoft als nächstes tun wird.

## Interaktivität

Die Skripte sind dafür gemacht, ohne jegliche Benutzerinteraktion ausgeführt zu werden. Bitte bearbeite sie entsprechend vor der Ausführung. Wenn Du mehr Interaktivität möchtest schau dir lieber
[DisableWinTracking](https://github.com/10se1ucgo/DisableWinTracking) von
[10se1ucgo](https://github.com/10se1ucgo) an.

## Downloade die neueste Version

Der Code in der `master` Branch ist immer in Entwicklung, aber Du möchtest wahrscheinlich sowieso die neueste Version.

- [Download [zip]](https://github.com/W4RH4WK/Debloat-Windows-10/archive/master.zip)

## Ausführen

Aktiviere die Ausführung von PowerShell Skripten:

    PS> Set-ExecutionPolicy Unrestricted -Scope CurrentUser

Entsperre die PowerShell Skripte und Module in dem Verzeichnis:

    PS> ls -Recurse *.ps*1 | Unblock-File

## Verwendung

Die Skripte können individuell ausgeführt werden, wähle aus, was Du brauchst.

1. Installiere alle wichtigen Updates für dein System.
2. Editiere die Skripte, so dass sie auf dich passen.
3. Führe die Skripte, die Du anwenden möchtest mit PowerShell als Administrator aus (Explorer
   `Dateien > Öffne Windows PowerShell > Öffne Windows PowerShell als
   Administrator`).
4. `PS > Restart-Computer`
5. Führe `disable-windows-defender.ps1` ein weiteres Mal aus, wenn Du es in Schritt 3 ausgeführt hast.
6. `PS > Restart-Computer`

## Startmenü

In der Vergangenheit habe Ich kleinere Fixes mit einbezogen, um das Startmenü brauchbarer zu machen,
wie z.B. das Entfernen von Standardkacheln, die Websuche zu deaktivieren und so weiter. Dies ist nicht
mehr der Fall, weil es mir reicht. Das Menü geht ohne Grund kaputt, es ist langsam,
mühsam zu konfigurieren / skripten und zeigt sogar standardmäßig Werbung!

Bitte ersetze es mit etwas Besserem wie [Open Shell] oder [Start
is Back], aber hör auf es zu nutzen!

[Open Shell]: <https://open-shell.github.io/Open-Shell-Menu/>
[Start is Back]: <http://startisback.com/>

## Bekannte Fehler

### Startmenüsuche

Nach dem Ausführen der Skripte, kann es je nach dem sein, dass die Startmenüsuche nicht mehr auf neu erstellten
Konten funktioniert. Es scheint, dass es sich dabei um einen Fehler bei der Accountinitialisierung handelt, der
erzeugt wird, wenn der Ortungsservice (GeoLocation) deaktiviert wird. Der folgende Workaround wurde von BK aus Atlanta erstellt:

1. Lösche den Registryschlüssel `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lfsvc\TriggerInfo\3`
2. Schalte den Ortungsservice wieder ein (setze den Starttyp auf `Automatisch`)
3. Starte deinen Rechner neu
4. Logge dich mit dem Account ein, bei dem der Fehler vorliegt
5. Starte Cortana und passe die Einstellungen an

Du kannst jetzt auch den Ortungsservice wieder deaktivieren, die Startmenüsuche sollte funktionstüchtig bleiben.

### Sysprep wird hängen bleiben

Wenn du Images mit MDT bereitstellst und diese Skripte ausführst, bleibt der sysprep
Schritt hängen, wenn `dmwappushservice` nicht aktiv ist.

### Xbox Wireless Adapter

Anscheinend führt das Ausführen des Skripts "remove-default-apps" dazu, dass Xbox
Wireless-Adapter nicht mehr funktionieren. Ich vermute, dass man nicht die Xbox
App entfernen sollte, wenn man einen verwenden möchte. Ich habe das jedoch noch nicht bestätigt,
aber es gibt einen Workaround, um sie anschließend wieder zu aktivieren. Siehe
[#78](https://github.com/W4RH4WK/Debloat-Windows-10/issues/78).

### Fehler mit Skype

Ein paar der Domains die durch das hinzufügen in die hosts-Datei blockiert werden, werden für Skype gebraucht. Ich rate dringend davon ab, Skype zu verwenden, aber manche Leute haben vielleicht nicht die
die Möglichkeit, zu einer Alternative. Siehe
[#79](https://github.com/W4RH4WK/Debloat-Windows-10/issues/79).

### Fingerabdrucksensor / Gesichtserkennung funktioniert nicht.

Stelle sicher, dass der Biometrie Service (*Windows Biometric Service*) läuft. Siehe
[#189](https://github.com/W4RH4WK/Debloat-Windows-10/issues/189).

## Haftung

**Alle Skripte werden ohne Gewähr bereitgestellt und die Verwendung erfolgt auf eigene Gefahr.**

## Einen Beitrag leisten

Ich würde mich freuen, die Skriptsammlung zu erweitern. Eröffne einfach einen Issue oder
schicke mir eine Pull-Request.

### Danke an

- [10se1ucgo](https://github.com/10se1ucgo)
- [Plumebit](https://github.com/Plumebit)
- [aramboi](https://github.com/aramboi)
- [maci0](https://github.com/maci0)
- [narutards](https://github.com/narutards)
- [tumpio](https://github.com/tumpio)

## Lizenz

    "THE BEER-WARE LICENSE" (Revision 42):

    As long as you retain this notice you can do whatever you want with this
    stuff. If we meet someday, and you think this stuff is worth it, you can
    buy us a beer in return.

    This project is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.

## Übersetzungen

* [Deutsch](README.de-de.md) (`DE`): [MagicLike](https://github.com/MagicLike)
