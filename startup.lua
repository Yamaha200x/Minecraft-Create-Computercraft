-- Programm: stellwerk.lua

-- Konfiguration
local MONITOR_SIDE = "right" -- Seite, an der der Monitor angeschlossen ist
local WEICHE_SIDE = "left"   -- Seite, an der die Weiche (Redstone) angeschlossen ist

-- Initialer Zustand der Weiche (true=EIN/gestellt, false=AUS/Grundstellung)
local weiche_status = false

-- Monitor-API initialisieren
local monitor = peripheral.wrap(MONITOR_SIDE)
if not monitor then
    error("Fehler: Monitor an Seite '" .. MONITOR_SIDE .. "' nicht gefunden!")
end

-- Monitor-Größe und Farben einstellen
local w, h = monitor.getSize()
monitor.setTextScale(1)
local COLOR_BG = colors.black
local COLOR_FG = colors.white
local COLOR_WEICHE_EIN = colors.green
local COLOR_WEICHE_AUS = colors.red

-- Funktion zum Zeichnen der GUI
local function drawGUI()
    monitor.setBackgroundColor(COLOR_BG)
    monitor.clear()
    monitor.setTextColor(COLOR_FG)
    
    -- Titel
    monitor.setCursorPos(2, 1)
    monitor.write("ComputerCraft Stellwerk")

    -- Weichen-Status Text
    monitor.setCursorPos(2, 3)
    monitor.write("Weiche 1 Status:")
    
    -- Statusanzeige (Text)
    monitor.setCursorPos(2, 4)
    local status_text = weiche_status and "GESTELLT (Grün)" or "GRUNDSTELLUNG (Rot)"
    monitor.write(status_text)
    
    -- Interaktiver Button
    monitor.setCursorPos(2, 6)
    monitor.write("KLICKEN zum Umschalten:")
    
    -- Button-Feld (Größe: 10x2)
    local btn_x = 2
    local btn_y = 8
    local btn_w = 10
    local btn_h = 2
    
    local btn_color = weiche_status and COLOR_WEICHE_EIN or COLOR_WEICHE_AUS
    monitor.setBackgroundColor(btn_color)
    for y = 0, btn_h - 1 do
        monitor.setCursorPos(btn_x, btn_y + y)
        monitor.write(string.rep(" ", btn_w)) -- Leerräume füllen das Feld
    end
    
    -- Button-Text
    monitor.setTextColor(colors.white) -- Sicherstellen, dass Text sichtbar ist
    monitor.setCursorPos(btn_x + 1, btn_y + 1)
    monitor.write("SCHALTEN")
    
    monitor.setBackgroundColor(COLOR_BG) -- Hintergrundfarbe zurücksetzen
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
    local event, p1, p2 = os.pullEvent()

    if event == "monitor_touch" then
        -- p1 und p2 sind die x/y Koordinaten des Klicks auf dem Monitor
        local click_x = p1
        local click_y = p2
        
        -- Prüfen, ob der Klick innerhalb der Button-Koordinaten liegt
        local btn_x = 2
        local btn_y = 8
        local btn_w = 10
        local btn_h = 2
        
        if click_x >= btn_x and click_x < btn_x + btn_w and
           click_y >= btn_y and click_y < btn_y + btn_h then
            
            toggleWeiche()
            drawGUI() -- GUI nach dem Umschalten neu zeichnen
        end
    end
end
