-- Konfiguration
local SEED_SLOT = 1          -- Inventar-Slot der Samen
local HOE_SLOT = 16          -- Inventar-Slot der Hacke (falls nicht als Upgrade)
local REFILL_THRESHOLD = 5
local LENGTH = 50
local WIDTH = 50

-- =================================================================
-- FUNKTION: SEEDS NACHFÜLLEN (unverändert)
-- =================================================================
function refill_seeds()
    print("Samenstand niedrig. Starte Refill-Routine...")
    
    -- Speichere aktuellen Slot (könnte der HOE_SLOT sein)
    local original_slot = turtle.getSelectedSlot()
    
    turtle.turnLeft()
    turtle.turnLeft()
    
    turtle.select(SEED_SLOT)
    local sucked = turtle.suck(64) 
    
    print("Refill abgeschlossen. " .. sucked .. " Samen eingesaugt.")
    
    turtle.turnLeft()
    turtle.turnLeft()
    
    turtle.select(original_slot) -- Zurück zum ursprünglichen Slot
end

-- =================================================================
-- HAUPTPROGRAMM: FARMING-SCHLEIFE
-- =================================================================
for row = 1, WIDTH do
    print("Bearbeite Reihe " .. row .. " von " .. WIDTH)
    
    for col = 1, LENGTH do
        
        -- A) INVENTORY CHECK
        if turtle.getItemCount(SEED_SLOT) < REFILL_THRESHOLD then
            refill_seeds()
            if turtle.getItemCount(SEED_SLOT) == 0 then
                print("FEHLER: Keine Samen mehr in der Kiste. Stoppe Programm.")
                return 
            end
        end

        -- B) SCHRITT 1: UMGRABEN (TILLING)
        -- Wähle die Hacke (Hoe) aus
        turtle.select(HOE_SLOT) 
        local tilled, reason_till = turtle.place() -- <--- place() nutzt das Tool für Tilling
        
        if not tilled then
            -- Wenn das Umgraben fehlschlägt, ist der Block vielleicht schon Ackerland
            -- Wir ignorieren den Fehler und versuchen trotzdem zu pflanzen
        end

        -- C) SCHRITT 2: PFLANZEN (PLACING SEEDS)
        -- Wähle die Samen aus
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

print("50x50 Fläche fertig bepflanzt!")
