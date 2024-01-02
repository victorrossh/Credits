
#include <amxmodx>
#include <cstrike>
#include <hamsandwich>
#include <cromchat>
#include <credits>

#pragma reqlib "vip"

native isPlayerVip(id);

#define PLUGIN "Credits Rewards"
#define VERSION "0.1"
#define AUTHOR "MrShark45"



new g_iCTDeaths;

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR);

	RegisterHam(Ham_Killed, "player", "player_killed");

	//Terro WIN
	register_logevent("terrorist_won" , 6, "3=Terrorists_Win", "3=Target_Bombed") 

	CC_SetPrefix("&x04[LLG]") 

}

public terrorist_won(){
	new terrorists[32],iNum, terro;
	get_players(terrorists, iNum, "ae", "TERRORIST");
	terro = terrorists[0];
	new gain = isPlayerVip(terro)? 100 : 50;
	
	set_user_credits(terro,  get_user_credits(terro) + gain);
	CC_SendMessage(terro, "&x01Ai primit &x04%d &x01credite pentru ca ai &x04castigat &x01runda!", gain);
	CC_SendMessage(terro, "&x01Ai primit &x04%d &x01credite pentru ca au murit &x04%d &x06CT!", g_iCTDeaths*2, g_iCTDeaths);
	CC_SendMessage(terro, "&x01Credite curente: &x04%d&x01!", get_user_credits(terro));
}

public player_killed(victim, attacker){
	new terrorists[MAX_PLAYERS], iNum, terro;
	get_players(terrorists, iNum, "ae", "TERRORIST");
	terro = terrorists[0];

	if(attacker != victim && is_user_alive(attacker)){
		if(cs_get_user_team(attacker) == CS_TEAM_T){
			new gain = isPlayerVip(attacker)? 10 : 5;
			new credits = get_user_credits(attacker);
			set_user_credits(attacker, get_user_credits(attacker) + gain);
			CC_SendMessage(attacker, "&x01Ai primit &x04%d &x01credite pentru ca ai &x07ucis &x01un &x06CT&x01!", gain);
			CC_SendMessage(attacker, "&x01Credite curente: &x04%d&x01!", credits+gain);
		}
		else{
			new gain = isPlayerVip(attacker)? 40 : 20;
			new credits = get_user_credits(attacker);
			CC_SendMessage(attacker, "&x01Ai primit &x04%d &x01credite pentru ca ai &x07ucis teroristul&x01!", gain);
			set_user_credits(attacker, credits + gain);
			CC_SendMessage(attacker, "&x01Credite curente: &x04%d&x01!", credits+gain);
		}
	}
	if(is_user_alive(terro) && !is_user_alive(attacker)){
		new gain = isPlayerVip(terro)? 4 : 2;
		new credits = get_user_credits(terro);
		set_user_credits(terro, credits + gain);
		g_iCTDeaths++;
	}
}

