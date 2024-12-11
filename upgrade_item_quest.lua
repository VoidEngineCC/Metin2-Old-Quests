quest upgrade_item_quest begin
    state start begin
        when levelup with level is 69 begin
            set_state(inactive)
            send_letter("Quête d'Amélioration d'Objet")
        end
    end

    state inactive begin
    end

    state active begin
        when letter begin
            local item_vnum = 1234 -- NVUM A AMELIORER
            local required_levels = 3 -- Nombre d'améliorations

            if pc.count_item(item_vnum) >= 1 then
                clear_letter()
                say_title("PNJ Quêteur :")
                say("Bonjour, aventurier ! J'ai une tâche spéciale pour vous.")
                wait()
                say_title("PNJ Quêteur :")
                say("Je peux améliorer votre objet si vous ajoutez " .. required_levels .. " niveaux à cet objet.")
                wait()
                say_title("PNJ Quêteur :")
                say("Apportez-moi l'objet et les pierres de renforcement nécessaires, et nous commencerons le processus d'amélioration.")
                pc.setqf("upgrade_item_stage", 1) 
                set_state(waiting_for_upgrade)
                send_letter("Quête d'Amélioration d'Objet - Améliorez l'Objet")
            else
                say("Vous n'avez pas l'objet requis. Revenez quand vous l'aurez.")
            end
        end
    end

    state waiting_for_upgrade begin
        when info or button begin
            say_title("PNJ Quêteur :")
            say("Vous devez apporter l'objet et les pierres de renforcement nécessaires pour commencer le processus d'amélioration.")
            wait()
            say_title("PNJ Quêteur :")
            say("N'oubliez pas que vous devez ajouter " .. required_levels .. " niveaux à l'objet.")
            wait()
            say_title("PNJ Quêteur :")
            say("Revenez me voir lorsque vous serez prêt.")
        end

        when letter begin
            local item_vnum = 1234 -- NVUM A AMELIORER
            local required_levels = 3 -- Nombre d'améliorations

            if pc.count_item(item_vnum) >= 1 then
                clear_letter()
                say_title("PNJ Quêteur :")
                say("Très bien, vous avez l'objet requis.")
                wait()
                say_title("PNJ Quêteur :")
                say("Combien de niveaux voulez-vous ajouter à l'objet ? (Veuillez écrire un nombre entre 1 et " .. required_levels .. ".)")
                pc.setqf("upgrade_item_stage", 2) -- Passez à l'étape suivante de la quête
                set_state(waiting_for_levels)
            else
                say("Vous avez perdu l'objet requis. Revenez quand vous l'aurez.")
                set_state(active)
            end
        end
    end

    state waiting_for_levels begin
        when info or button begin
            say_title("PNJ Quêteur :")
            say("Combien de niveaux voulez-vous ajouter à l'objet ? (Veuillez écrire un nombre entre 1 et " .. required_levels .. ".)")
        end

        when 20300.chat."1" begin
            local required_levels = 3 -- Nombre d'améliorations

            local added_levels = tonumber(20300.get(1))
            if added_levels < 1 or added_levels > required_levels then
                say("Nombre de niveaux invalide. Veuillez écrire un nombre entre 1 et " .. required_levels .. ".")
                set_state(waiting_for_levels)
            else
                pc.remove_item(item_vnum, 1) -- Supprimer l'objet de quête de l'inventaire du joueur
                pc.upgrade_item(item_vnum, added_levels) -- Améliorer l'objet en ajoutant les niveaux
                say("Félicitations ! Vous avez amélioré l'objet avec succès de " .. added_levels .. " niveaux.")
                pc.setqf("upgrade_item_stage", 3) -- Passez à l'étape suivante de la quête
                set_state(return_reward)
            end
        end
    end

    state return_reward begin
        when letter begin
            local reward_item_vnum = 5678 -- récompense

            say_title("PNJ Récompenseur :")
            say("Félicitations pour avoir réussi à améliorer l'objet !")
            wait()
            say_title("PNJ Récompenseur :")
            say("En guise de récompense, je vous offre ceci.")
            wait()

            pc.give_item2(reward_item_vnum, 1) -- Donner la récompense au joueur
            pc.setqf("upgrade_item_stage", 0) -- Réinitialiser l'étape de la quête
            clear_letter()
            send_letter("Quête d'Amélioration d'Objet - Quête Terminée", "Félicitations ! Vous avez terminé la quête et obtenu une récompense.")
            set_state(done)
        end
    end

    state done begin
    end
end
