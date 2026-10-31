# Foreverfriendshub_addon

Ein WoW Forever Addon für Multiplayer Coop. Es gehört zur Webseite [foreverfriendshub](https://github.com/xelarus/foreverfriendshub).

## Was es kann (Version 0.1)

- Erfasst pro Charakter: Name, Realm, Fraktion, Klasse, Rasse, Level, Gear Level (wenn der Client es liefert) und das aktuelle Gebiet.
- Aktualisiert die Daten beim Einloggen, beim Gebietswechsel, beim Levelaufstieg und beim Ausrüstungswechsel.
- `/ffhub` öffnet ein Fenster mit dem Export-Text aller erfassten Charaktere. Den Text kopierst du mit Strg+A und Strg+C.

Ein Addon kann selbst keine Daten ins Internet senden. Der Text muss deshalb von Hand auf die Webseite übertragen werden. Eine Import-Funktion dort gibt es noch nicht.

## Installation

Den Ordner `FFHub` nach `World of Warcraft/_classic_era_/Interface/AddOns/` kopieren (Pfad je nach Client). Im Spiel einloggen und `/ffhub` eingeben.

## Format des Exports

Eine Zeile pro Charakter, Werte als `schlüssel=wert`, getrennt durch `;`:

```
FFHUB1;name=Brandur;realm=Beispielrealm;fraktion=Allianz;klasse=Krieger;rasse=Zwerg;level=12;gear=;zone=Dun Morogh;subzone=Kharanos;updated=1793470000
```

Klasse, Rasse und Gebiet kommen in der Sprache des Spielclients. Die Webseite nutzt deutsche Namen, ein deutscher Client passt also direkt.

## Offen

- **Interface-Nummer:** In `FFHub/FFHub.toc` steht `11508` (Classic Era 1.15.8) als Annahme. Im Spiel mit `/dump (select(4, GetBuildInfo()))` die echte Nummer prüfen und eintragen. Bei einer falschen Nummer erscheint das Addon als veraltet und muss unter "Addons" mit "Veraltete Addons laden" aktiviert werden.
- **Nicht getestet:** Der Code wurde noch nicht in einem Spielclient ausgeführt.
- Import auf der Webseite, damit Standort und Level automatisch übernommen werden.
