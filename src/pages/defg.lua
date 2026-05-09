local time = 0
print("⌨️ Spam Tombol '1' Aktif!")

    while time <=200 do
        if keypress and keyrelease then
            -- 0x31 adalah kode Hex untuk tombol angka '1' di keyboard
            keypress(0x31) 
            task.wait(0.02) -- Tahan tombol sebentar
            keyrelease(0x31)
        else
            warn("❌ Eksekutor-mu tidak mendukung keypress API. Gunakan Metode 1.")
            getgenv().SpamKey1 = false
            break
        end
        
        -- Jeda antar tekanan tombol
        time = time +1
        task.wait(0.05) 
    end

-- CARA MEMATIKAN:
-- Jalankan kode ini di executor untuk berhenti:
-- getgenv().SpamKey1 = false
