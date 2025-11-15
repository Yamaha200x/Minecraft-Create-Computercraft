-- Konfiguration
local SEED_SLOT = 1          -- Inventar-Slot der Samen
local REFILL_THRESHOLD = 5
local LENGTH = 50
local WIDTH = 50

-- ... [refill_seeds Funktion bleibt gleich] ... 

-- HAUPTPROGRAMM (Nur der Loop-Teil ist relevant)
for row = 1, WIDTH do
    print("Bearbeite Reihe " .. row .. " von " .. WIDTH)
    
    for col = 1, LENGTH do
        
        -- A) INVENTORY CHECK
        -- ... [Refill-Code bleibt gleich] ...

        -- B) SCHRITT 1: UMGRABEN (TILLING) MIT UPGRADE-HACKE
        -- Wir versuchen dig("left"). Manche CC-Versionen behandeln die Hoe-Aktion hier.
        local tilled, reason_till = turtle.dig("left") 
        
        if not tilled then
            -- Wenn das Umgraben fehlschlägt, ist der Block vielleicht schon Ackerland.
            -- Wir ignorieren den Fehler (wollen nicht den Loop stoppen)
        end

        -- C) SCHRITT 2: PFLANZEN (PLACING SEEDS)
        turtle.select(SEED_SLOT)
        local planted, reason_plant = turtle.place() 
        
        if not planted then
            print("Pflanzen fehlgeschlagen an Col " .. col .. ": " .. (reason_plant or "Kein Ackerland oder Samen"))
        end
        
        -- D) BEWEGUNG
        if col < LENGTH then
            local moved, move_reason = turtle.forward()
            if not moved then
                print("FEHLER: Bewegung fehlgeschlagen (Col " .. col .. "). Prüfe Brennstoff/Hindernis!")
                return
            end
        end
    end
    
    -- E) REIHENWECHSEL
    -- ... [Reihenwechsel-Code bleibt gleich] ...
end
