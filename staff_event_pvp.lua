quest staff_event_pvp begin
    state start begin
        when 7726.click with isAdmin() begin -- Replace 9002 with the NPC's vnum
            local flag = get_global_reg("staff_event_enabled")
            local menu = {
                "Enable Heroes' battle",
                "Disable Heroes' battle",
                "Announcement",
                "Reset Kills",
                "Reset Total Kills",
            }
            local choice = select_table(menu)
            if choice == 1 then
                if flag == 1 then
                    syschat("ERROR CODE = 1")
                else
                    notice_all("Le combat des heros est sur le point de commencer!")
                    notice_all("Vous allez etre teleporter dans le ring!")
                    notice_all("Heroes' battle event is about to start !")
                    notice_all("You will be teleported inside the ring!")
                    set_global_reg("staff_event_enabled", 1)
                end
            elseif choice == 2 then
                if flag == 0 then
                    syschat("ERROR CODE = 0")
                else
                    local max_kills = mysql_query("SELECT name, kills FROM player.player ORDER BY kills DESC LIMIT 1")
                    local max_kills_player = max_kills.name[1]
                    local max_kills_count = max_kills.kills[1]
                    notice_all(string.format("Merci d'avoir participer a la bataille des heros!"))
                    notice_all(string.format("Le gagnant est : %s avec une score de : %d Kills.", max_kills_player, max_kills_count))
                    notice_all(string.format("Thanks for participating in the Heroes' battle!"))
                    notice_all(string.format("The winner is : %s with a score of: %d Kills.", max_kills_player, max_kills_count))
                    set_global_reg("staff_event_enabled", 0)
                end
            elseif choice == 3 then
                notice_all("L'Arene PvP ouvre ses portes pour un nouveau tournoi soyez prets!")
                notice_all("Dirigez-vous vers l'arene PvP en utilisant votre fenetre de teleportation.")
                notice_all("The PvP Arena is opening its gates for a new tournament be ready!")
                notice_all("Head to the PvP Arena using your teleport window.")
            elseif choice == 4 then
                local reset_kills = mysql_query("UPDATE player.player SET kills = 0")
                syschat("All player kills have been reset!")
            elseif choice == 5 then
                local reset_totalkills = mysql_query("UPDATE player.player SET totalkills = 0")
                syschat("All player totalkills have been reset!")
                notice_all("[SYSTEM]: All PvP points have been cleared by the system!")
        end
end
        when kill with npc.is_pc() and pc.get_map_index() == 263 begin
                local kill_now = mysql_query("SELECT kills from player.player WHERE name='"..pc.get_name().."' LIMIT 1")
                local kill_up = mysql_query("UPDATE player.player SET kills ='"..(kill_now.kills[1]+1).."' WHERE name ='"..pc.get_name().."' LIMIT 1")
                local kills_now = mysql_query("SELECT totalkills from player.player WHERE name='"..pc.get_name().."' LIMIT 1")
                local kills_up = mysql_query("UPDATE player.player SET totalkills ='"..(kills_now.totalkills[1]+10).."' WHERE name ='"..pc.get_name().."' LIMIT 1")
        end
    end
end