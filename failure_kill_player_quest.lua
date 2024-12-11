quest failure_kill_player_quest begin
    state start begin
        when levelup with level is 69 begin
            set_state(inactive)
            send_letter("Quête de Chasse aux Joueurs")
        end
    end

    state inactive begin
    end

    state active begin
        when letter begin
            local required_kills = 69 -- Remplace par le nombre de joueurs que le joueur doit tuer pour terminer la quête
            local reward_item_vnum = 5678 -- Remplace 5678 par le VNUM de l'objet de récompense

            clear_letter()
            say_title("PNJ Quêteur:")
            say("Bonjour, brave aventurier !")
            wait()
            say_title("PNJ Quêteur:")
            say("Des joueurs malveillants errent dans notre royaume.")
            wait()
            say_title("PNJ Quêteur:")
            say("Je vous charge de montrer votre bravoure en éliminant " .. required_kills .. " de ces joueurs.")
            wait()
            say_title("PNJ Quêteur:")
            say("Revenez me voir une fois que vous aurez accompli cette tâche.")
            pc.setqf("kill_player_required_kills", required_kills)
            pc.setqf("kill_player_count", 0)
            set_state(killing_players)
            send_letter("Quête de Chasse aux Joueurs - Tuez " .. required_kills .. " Joueurs")
        end
    end

    state killing_players begin
        when kill with pc.is_gm() and pc.getqf("kill_player_count") < pc.getqf("kill_player_required_kills") begin
            local required_kills = pc.getqf("kill_player_required_kills")
            local current_kills = pc.getqf("kill_player_count")

            current_kills = current_kills + 1
            pc.setqf("kill_player_count", current_kills)

            if current_kills >= required_kills then
                clear_letter()
                say_title("PNJ Quêteur:")
                say("Félicitations ! Vous avez éliminé " .. required_kills .. " joueurs.")
                wait()
                say_title("PNJ Quêteur:")
                say("Comme promis, voici votre récompense.")
                pc.setqf("kill_player_count", 0)
                set_state(reward)
                send_letter("Quête de Chasse aux Joueurs - Quête Terminée")
            else
                local remaining_kills = required_kills - current_kills
                say("Vous avez éliminé " .. current_kills .. " joueurs. Il vous en reste " .. remaining_kills .. ".")
            end
        end
    end

    state reward begin
        when letter begin
            local reward_item_count = 1

            clear_letter()
            say_title("PNJ Récompenseur:")
            say("Merci pour votre bravoure !")
            wait()
            say_title("PNJ Récompenseur:")
            say("En signe de gratitude, je vous offre cette récompense.")
            wait()

            pc.give_item2(reward_item_vnum, reward_item_count)
            set_state(done)
        end
    end

    state done begin
    end
end
