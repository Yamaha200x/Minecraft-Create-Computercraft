-- Konfiguration
local SEED_SLOT = 1          -- Inventar-Slot, in dem die Samen gelagert werden (1 bis 16)
local REFILL_THRESHOLD = 5   -- Anzahl der Samen, ab der nachgefüllt wird
local LENGTH = 50            -- Länge der Reihe (50 Blöcke)
local WIDTH = 50             -- Anzahl der Reihen (50 Reihen)

-- =================================================================
-- FUNKTION: SEEDS NACHFÜLLEN (bleibt gleich, nutzt turtle.suck)
-- =================================================================
function refill_seeds()
    print("Samenstand niedrig. Starte Refill-Routine...")
    
    turtle.turnLeft()
    turtle.turnLeft()
    
    turtle.select(SEED_SLOT)
    local sucked = turtle.suck(64) 
    
    print("Refill abgeschlossen. " .. sucked .. " Samen eingesaugt.")
    
    turtle.turnLeft()
    turtle.turnLeft()
    
    turtle.select(SEED_SLOT)
end

-- =================================================================
-- HAUPTPROGRAMM: FARMING-SCHLEIFE (Geänderte Zeilen markiert!)
-- =================================================================
turtle.select(SEED_SLOT)

for row = 1, WIDTH do
    print("Bearbeite Reihe " .. row .. " von " .. WIDTH)
    
    for col = 1, LENGTH do
        
        -- A) INVENTORY CHECK: Prüfen, ob Samen nachgefüllt werden müssen
        if turtle.getItemCount(SEED_SLOT) < REFILL_THRESHOLD then
            refill_seeds()
            if turtle.getItemCount(SEED_SLOT) == 0 then
                print("FEHLER: Keine Samen mehr in der Kiste. Stoppe Programm.")
                return 
            end
        end

        -- B) ARBEITSSCHRITT 1 & 2: Umgraben (Tillen) UND Pflanzen (Seeds setzen)
        -- Wir nutzen turtle.place(), da es die Standard-Aktion für das Platzieren von Items ist.
        -- Wenn der Slot mit Seeds ausgewählt ist, sollte die Turtle bei deiner Konfiguration
        -- (Hoe-Upgrade) zuerst umgraben und dann die Samen setzen.
        local planted, reason_plant = turtle.place() -- <--- VERWENDE place() STATT use()
        
        if not planted then
            -- Wenn das Pflanzen fehlschlägt, ist das Feld vielleicht schon bepflanzt oder blockiert
            print("Pflanzen/Umgraben fehlgeschlagen an Col " .. col .. ": " .. (reason_plant or "Blockiert/Unbekannt"))
        end
        
        -- D) BEWEGUNG: Einen Schritt vorwärts (bleibt gleich)
        if col < LENGTH then
            local moved, move_reason = turtle.forward()
            if not moved then
                print("FEHLER: Bewegung fehlgeschlagen (Col " .. col .. "). Prüfe Brennstoff/Hindernis!")
                return
            end
        end
    end
    
    -- E) REIHENWECHSEL (bleibt gleich)
    if row < WIDTH then
        turtle.turnLeft() 
        local moved, move_reason = turtle.forward()
        if not moved then
            print("FEHLER: Reihenwechsel fehlgeschlagen. Ende.")
            return
        end
        turtle.turnLeft()
    end
end

print("50x50 Fläche fertig bepflanzt! Happy Farming!")
