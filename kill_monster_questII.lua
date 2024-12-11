quest kill_monster_questII begin
    state start begin
        when levelup with level is 69 begin
            set_state(inactive)
            send_letter("La chase des monstres II")
        end
    end

    state inactive begin
    end

    state active begin
        when letter begin
            local required_kills = 100 -- Remplace le nombre des kills
            local reward_item_vnum = 5678 -- Remplace le vnum de la recompense

            clear_letter()
            say_title("Quest NPC:")
            say("Bonjour, brave aventurier !")
            wait()
            say_title("Quest NPC:")
            say("Nos terres sont infestées de monstres dangereux.")
            wait()
            say_title("Quest NPC:")
            say("J'ai besoin que tu prouves ta bravoure en tuant " .. required_kills .. " de ces monstres.")
            wait()
            say_title("Quest NPC:")
            say("Revenez me voir une fois que vous aurez rempli cette tâche.")
            pc.setqf("monster_hunt_required_kills", required_kills)
            pc.setqf("monster_hunt_count", 0)
            set_state(killing_monsters)
            send_letter("La chase des monstres II - Tuez " .. required_kills .. " Monstres")
        end
    end

    state killing_monsters begin
        when kill with npc.is_pc() and pc.getqf("monster_hunt_count") < pc.getqf("monster_hunt_required_kills") begin
            local required_kills = pc.getqf("monster_hunt_required_kills")
            local current_kills = pc.getqf("monster_hunt_count")

            current_kills = current_kills + 1
            pc.setqf("monster_hunt_count", current_kills)

            if current_kills >= required_kills then
                clear_letter()
                say_title("Quest NPC:")
                say("Toutes nos félicitations! tu as tué " .. required_kills .. " des monstres.")
                wait()
                say_title("Quest NPC:")
                say("Comme promis, voici votre récompense.")
                pc.setqf("monster_hunt_count", 0)
                set_state(reward)
                send_letter("La chase des monstres II - Quête terminée")
            else
                local remaining_kills = required_kills - current_kills
                say("tu as tué " .. current_kills .. " monstres. Tu dois tuer " .. remaining_kills .. " encore.")
            end
        end
    end

    state reward begin
        when letter begin
            local reward_item_count = 1

            clear_letter()
            say_title("Quest NPC:")
            say("Merci pour votre bravoure !")
            wait()
            say_title("Quest NPC:")
            say("En gage de notre gratitude, je vous remets cette récompense.")
            wait()

            pc.give_item2(reward_item_vnum, reward_item_count)
            set_state(done)
        end
    end

    state done begin
    end
end
