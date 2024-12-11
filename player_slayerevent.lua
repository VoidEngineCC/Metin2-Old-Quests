quest player_slayerevent begin
    state start begin
        when login with pc.level >= 15 begin
            set_state(player_kill)
        end
    end

    state player_kill begin
        when letter begin
            send_letter("The Valkyrie Slayer")
        end

        when button or info begin
            say("Dear Player")
            say("I have brought you together in this place to...")
            say("fight!!")
            say("Exactly, fighting for the glory of your name!")
            say_reward("Kill 100 players in a duel!")
            say("")
            if pc.getqf("state") == 0 then
                pc.setqf("state", 1)
            end
            q.set_counter("compteur_kill", pc.getqf("state"))
        end

        when kill begin
            if npc.is_pc() then
                local count = pc.getqf("state") - 1
                if count <= 0 then
                    say_title("You did it !! ")
                    say("You Killed 100 Players !")
                    say("You have won the following items:")
                    say_reward("You Received 2.000.000 Yang")
                    say_reward("Your horse got one level up")
                    pc.change_money(2000000)
                    horse.advance()
                    notice_all("".. pc.get_name() .." won the PvP Event!")
                    notice_all(" ... He slayed 100 players!")
                    clear_letter()
                    set_state(__COMPLETE__)
                elseif count <= 1 then
                    pc.setqf("state", count)
                    q.set_counter("compteur_kill", count)
                end
            end
        end
    end

    state __COMPLETE__ begin
    end
end  