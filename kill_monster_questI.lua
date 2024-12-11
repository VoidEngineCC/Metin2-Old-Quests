quest kill_monster_questI begin
    state start begin
        when levelup with level is 69 begin
            set_state(inactive)
            send_letter("La chase des monstres I")
        end
    end

    state inactive begin
    end

    state active begin
        when letter begin
        local target_monster_name = FAILURE -- Change le nom du monstre a tuer
        local target_monster_vnum = 101 -- Change le vnum du monstre a tuer
        local required_kills = 100 -- change la quantité des kills

            clear_letter()
            say_title("Quest NPC:")
            say("Bonjour, brave aventurier !")
            wait()
            say_title("Quest NPC:")
            say("Nos terres sont tourmentées par le redoutable monstre " .. target_monster_name .. ".")
            wait()
            say_title("Quest NPC:")
            say("J'ai besoin que tu prennes soin d'eux en tuant " .. required_kills .. " de ces bêtes.")
            wait()
            say_title("Quest NPC:")
            say("Revenez me voir une fois que vous aurez rempli cette tâche.")
            pc.setqf("kill_monster_stage", 1)
            pc.setqf("kill_monster_count", 0)
            set_state(killing_monsters)
            send_letter("La chase des monstres I - " .. required_kills .. " Monsters")
        end
    end

    state killing_monsters begin
        when kill with npc.is_pc() and pc.getqf("kill_monster_stage") == 1 begin
            local target_monster_vnum = 101
            local required_kills = 100 -- change la quantité des kills
            local current_kills = pc.getqf("kill_monster_count")

            current_kills = current_kills + 1
            pc.setqf("kill_monster_count", current_kills)

            if current_kills >= required_kills then
                clear_letter()
                say_title("Quest NPC:")
                say("Toutes nos félicitations! tu as tué " .. required_kills .. " des monstres.")
                wait()
                say_title("Quest NPC:")
                say("Comme promis, voici votre récompense.")
                pc.setqf("kill_monster_stage", 2)
                pc.setqf("kill_monster_count", 0)
                set_state(reward)
                send_letter("La chase des monstres I - Quête terminée")
            else
                local remaining_kills = required_kills - current_kills
                say("You have slain " .. current_kills .. " monsters. You need to slay " .. remaining_kills .. " more.")
            end
        end
    end

    state reward begin
        when letter begin
            local reward_item_vnum = 5678 -- change la récompense 
            local reward_item_count = 1

            clear_letter()
            say_title("Quest NPC:")
            say("Merci pour votre bravoure !")
            wait()
            say_title("Quest NPC:")
            say("En gage de notre gratitude, je vous remets cette récompense.")
            wait()

            pc.give_item2(reward_item_vnum, reward_item_count)
            pc.setqf("kill_monster_stage", 0)
            set_state(done)
        end
    end

    state done begin
    end
end