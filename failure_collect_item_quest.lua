quest failure_collect_item_quest begin
    state start begin
        when levelup with level is 69 begin -- change le level
            set_state(inactive)
            pc.setqf("collect_item", 0) -- Initialize quest flag for item collection
            send_letter("Quête de Collecte")
        end
    end

    state inactive begin
    end

    state active begin
        when letter begin
            local monster_id = 12345 -- change le vnum du mob
            local monster_name = "Monstre Effrayant" -- le nom du boss

            local item_vnum = 69 -- le vnum de l'item
            local item_count = 1 -- la quantité de l'item

            if pc.getqf("collect_item") == 0 then
                clear_letter()
                pc.setqf("collect_item", 1)
                set_state(gather_item)
                send_letter("Quête de Collecte - Collecter l'Objet", string.format("Cher joueur,\n\nUne rumeur se répand dans tout le royaume à propos d'un puissant %s qui garde un objet précieux. Je vous prie de récupérer cet objet pour moi. Soyez prudent, car le %s est très dangereux. Bonne chance.\n\nBien à vous,\nQuêteur Mystérieux", monster_name, monster_name))
            else
                say("Vous avez déjà activé cette quête. Récupérez l'objet auprès du monstre avant de revenir ici.")
            end
        end
    end

    state gather_item begin
        when kill with npc.is_pc() begin
            local monster_id = 12345 -- change le vnum du mob
            local item_vnum = 69-- le vnum de l'item
            local item_count = 1 -- la quantité de l'item

            local drop_chance = 50 -- Chance en pourcentage pour que l'objet drop du monstre

            if npc.get_race() == monster_id and pc.getqf("collect_item") == 1 and math.random(1, 100) <= drop_chance then
                pc.give_item2(item_vnum, item_count)
                say("Vous avez récupéré l'objet. Ramenez-le à l'initiateur de la quête pour recevoir votre récompense.")
                set_state(return_item)
            end
        end
    end

    state return_item begin
        when letter begin
            local item_vnum = 69 -- le vnum de l'item
            local item_count = 1 -- le nombre de l'item

            if pc.count_item(item_vnum) >= item_count then
                pc.remove_item(item_vnum, item_count)
                pc.setqf("collect_item", 0)
                say("Vous avez accompli votre mission. Voici votre récompense.")
                local reward_vnum = 999 -- vnum de la récompense
                local reward_count = 1 -- quantité de la récompense
                pc.give_item2(reward_vnum, reward_count)
                clear_letter()
                send_letter("Quête Terminée", "Félicitations ! Vous avez terminé la quête et obtenu une récompense.")
                set_state(done)
            else
                say("Vous devez collecter l'objet avant de revenir ici pour la récompense.")
            end
        end
    end

    state done begin
    end
end
