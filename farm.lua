-- Konfiguration
local SEED_SLOT = 1          -- Inventar-Slot, in dem die Samen gelagert werden (1 bis 16)
local REFILL_THRESHOLD = 5   -- Anzahl der Samen, ab der nachgefüllt wird
local LENGTH = 50            -- Länge der Reihe (50 Blöcke)
local WIDTH = 50             -- Anzahl der Reihen (50 Reihen)

-- =================================================================
-- FUNKTION: SEEDS NACHFÜLLEN
-- Wird aufgerufen, wenn der Samenstand niedrig ist.
-- =================================================================
function refill_seeds()
    print("Samenstand niedrig. Starte Refill-Routine...")
    
    -- Turtle um 180 Grad drehen, um zur Kiste zu blicken
    turtle.turnLeft()
    turtle.turnLeft()
    
    -- Slot mit den Seeds auswählen
    turtle.select(SEED_SLOT)

    -- Versuche, maximal 64 Seeds (einen Stack) aus dem Inventar HINTER der Turtle zu saugen.
    -- Der Befehl 'suck()' kann hier ebenfalls verwendet werden, da es Item-Inventare sind.
    local sucked = turtle.suck(64) 
    
    print("Refill abgeschlossen. " .. sucked .. " Samen eingesaugt.")
    
    -- Turtle zurückdrehen, um zum Feld zu blicken
    turtle.turnLeft()
    turtle.turnLeft()
    
    -- Den Seed-Slot wieder auswählen
    turtle.select(SEED_SLOT)
end

-- =================================================================
-- HAUPTPROGRAMM: FARMING-SCHLEIFE
-- =================================================================

-- Starte mit dem Seed-Slot ausgewählt
turtle.select(SEED_SLOT)

for row = 1, WIDTH do
    print("Bearbeite Reihe " .. row .. " von " .. WIDTH)
    
    local direction = (row % 2 == 1) and 1 or -1 -- Bewegungsrichtung (1: vorwärts, -1: rückwärts bei der Logik)

    -- Hauptarbeits-Schleife für die Reihe
    for col = 1, LENGTH do
        
        -- A) INVENTORY CHECK: Prüfen, ob Samen nachgefüllt werden müssen
        if turtle.getItemCount(SEED_SLOT) < REFILL_THRESHOLD then
            refill_seeds()
            
            -- Prüfe nach dem Refill, ob Seeds vorhanden sind
            if turtle.getItemCount(SEED_SLOT) == 0 then
                print("FEHLER: Keine Samen mehr in der Kiste. Stoppe Programm.")
                return -- Programm beenden
            end
        end

        -- B) ARBEITSSCHRITT 1: Umgraben (Tillen)
        -- Da die Hacke ein Upgrade ist, kann turtle.use() automatisch die Hoe-Aktion ausführen.
        local tilled, reason_till = turtle.use()
        
        -- C) ARBEITSSCHRITT 2: Pflanzen (Seeds setzen)
        -- Der Seed-Slot ist ausgewählt. turtle.use() pflanzt auf Ackerland.
        local planted, reason_plant = turtle.use()
        
        -- D) BEWEGUNG: Einen Schritt vorwärts (außer beim letzten Block)
        if col < LENGTH then
            local moved, move_reason = turtle.forward()
            if not moved then
                print("FEHLER: Bewegung fehlgeschlagen (Col " .. col .. "). Prüfe Brennstoff/Hindernis!")
                return -- Programmstopp bei Fehler
            end
        end
    end
    
    -- E) REIHENWECHSEL: Am Ende der Reihe
    
    if row < WIDTH then
        -- 1. 90 Grad drehen (Ende der Reihe)
        turtle.turnLeft() 
        
        -- 2. Einen Schritt vorwärts zur nächsten Reihe
        local moved, move_reason = turtle.forward()
        if not moved then
            print("FEHLER: Reihenwechsel fehlgeschlagen. Ende.")
            return
        end
        
        -- 3. 90 Grad drehen, um in die entgegengesetzte Richtung zu blicken (Zick-Zack-Muster)
        turtle.turnLeft()
    end
end

print("50x50 Fläche fertig bepflanzt! Happy Farming!")
