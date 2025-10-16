-- Programm: stellwerk.lua

-- Konfiguration
local MONITOR_SIDE = "right" -- Seite, an der der Monitor angeschlossen ist
local WEICHE_SIDE = "left"   -- Seite, an der die Weiche (Redstone) angeschlossen ist

-- Initialer Zustand der Weiche
local weiche_status = false

-- Monitor-API initialisieren
local monitor = peripheral.wrap(MONITOR_SIDE)
if not monitor then
    error("Fehler: Monitor an Seite '" .. MONITOR_SIDE .. "' nicht gefunden!")
end

-- Farben einstellen
local COLOR_BG = colors.black
local COLOR_FG = colors.white
local COLOR_WEICHE_EIN = colors.green
local COLOR_WEICHE_AUS = colors.red

-- Funktion zum Zeichnen der GUI
local function drawGUI()
    monitor.setBackgroundColor(COLOR_BG)
    monitor.clear()
    
    -- 1. TEXTSKALIERUNG ANPASSEN (WICHTIG!)
    -- Skalierung 0.5 zeigt viermal mehr Text (2x in Breite, 2x in Höhe)
    monitor.setTextScale(0.5) 
    
    local w, h = monitor.getSize()
    -- Bei Skala 0.5 ist w ca. 100, h ca. 6.
    
    -- Status Text (Position links oben)
    monitor.setTextColor(COLOR_FG)
    monitor.setCursorPos(2, 2) -- x=2, y=2 (im oberen Block)
    monitor.write("Weiche 1:")
    
    -- Statusanzeige (Text)
    monitor.setCursorPos(2, 3) 
    local status_text = weiche_status and "GESTELLT (EIN)" or "GRUNDST (AUS)"
    monitor.write(status_text)
    
    -- Statusfarbe (als kleine Leuchte)
    local status_color = weiche_status and COLOR_WEICHE_EIN or COLOR_WEICHE_AUS
    monitor.setBackgroundColor(status_color)
    monitor.setCursorPos(15, 2) 
    monitor.write("  ") -- Zwei Leerzeichen als visuelle Leuchte
    monitor.setBackgroundColor(COLOR_BG) 
    
    -- Interaktiver Button (Position rechts unten)
    local btn_w = 12  -- Breite
    local btn_h = 2   -- Höhe
    local btn_x = w - btn_w - 1 -- Rechtsbündig
    local btn_y = h - btn_h - 1 -- Unten ausgerichtet (ca. Y=3)
    
    local btn_color = weiche_status and COLOR_WEICHE_EIN or COLOR_WEICHE_AUS
    monitor.setBackgroundColor(btn_color)
    
    -- Button-Feld füllen
    for y = 0, btn_h - 1 do
        monitor.setCursorPos(btn_x, btn_y + y)
        monitor.write(string.rep(" ", btn_w)) 
    end
    
    -- Button-Text
    monitor.setTextColor(colors.white) 
    monitor.setCursorPos(btn_x + 3, btn_y + 1)
    monitor.write("SCHALTEN")
    
    -- Skalierung und Farben zurücksetzen (für weitere Ausgaben)
    monitor.setBackgroundColor(COLOR_BG) 
    monitor.setTextColor(COLOR_FG)
end

-- Funktion zum Umschalten der Weiche
local function toggleWeiche()
    weiche_status = not weiche_status
    redstone.setOutput(WEICHE_SIDE, weiche_status) -- Setzt das Redstone-Signal
end

-- Hauptprogrammlogik
drawGUI() -- GUI initial zeichnen

while true do
    -- Das monitor_touch-Event gibt event, side, x, y zurück
    local event, p1, p2, p3 = os.pullEvent() 

    if event == "monitor_touch" then
        
        -- p2 und p3 sind die X/Y Koordinaten, wenn TextScale = 0.5 aktiv ist!
        local click_x = p2     
        local click_y = p3     
        
        -- Button-Koordinaten neu berechnen (muss exakt zur drawGUI passen!)
        local w, h = monitor.getSize()
        local btn_w = 12  
        local btn_h = 2   
        local btn_x = w - btn_w - 1 
        local btn_y = h - btn_h - 1 
        
        if click_x >= btn_x and click_x < btn_x + btn_w and 
           click_y >= btn_y and click_y < btn_y + btn_h then
            
            toggleWeiche()
            drawGUI() -- GUI nach dem Umschalten neu zeichnen
        end
    end
end
