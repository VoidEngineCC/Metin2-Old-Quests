quest failurelevelreward_quest begin
    state start begin
        when levelup with level is 69 begin -- change le niveau j'ai mis 69 par defaut
            send_letter("Tâche Spéciale")
        end
    end

    state special_task begin
        when letter begin
            local monster_id = 12345 -- Change le vnum du mob
            local monster_name = "Un Monstre" -- Change le nom du mob

            clear_letter()
            local story_text = string.format("Cher joueur,\n\nJ'espère que cette lettre vous trouve en bonne santé. Hélas, j'ai une affaire urgente qui requiert votre attention immédiate. Une créature redoutable connue sous le nom de '%s' terrorise notre contrée, semant chaos et désespoir. Les légendes racontent que cette vile bête garde une arme sacrée capable de vaincre les ténèbres.\n\nJe vous implore de vous engager dans ce voyage périlleux pour vaincre le '%s' et réclamer l'arme pour le plus grand bien de notre royaume. Que les dieux veillent sur vous, brave guerrier !\n\nAvec le plus grand respect,\nConseiller du Roi", monster_name, monster_name)
            send_letter("Tâche Spéciale - Vaincre le monstre", story_text)
            set_state(kill_monster)
        end
    end

    state kill_monster begin
        when kill with npc.is_pc() and npc.get_race() == monster_id begin
            local random_item_vnum = 6789 -- Change le vnum de l'item
            local reward_count = 1 -- change la quantité de l'item

            pc.give_item2(random_item_vnum, reward_count)
            say("Félicitations! Vous avez vaincu le monstre maléfique et gagné une récompense !")
            set_state(reward_given)
        end
    end

    state reward_given begin
        when letter begin
            send_letter("Quête terminée")
            say("Vous avez terminé la quête avec succès! Voici votre récompense.")
        end
    end
end
