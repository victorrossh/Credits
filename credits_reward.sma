
#include <amxmodx>
#include <cstrike>
#include <hamsandwich>
#include <cromchat>
#include <credits>

#pragma reqlib "vip"
native isPlayerVip(id);

#define PLUGIN "Credits Rewards"
#define VERSION "1.0"
#define AUTHOR "MrShark45"


new g_iCTDeaths;

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR);

	RegisterHam(Ham_Killed, "player", "player_killed");

	//Terro WIN
	register_logevent("terrorist_won" , 6, "3=Terrorists_Win", "3=Target_Bombed") 

	CC_SetPrefix("&x04[Credits]") 
}

public plugin_cfg() {
	register_dictionary("credits_reward.txt");
}

public terrorist_won(){
	new terrorists[32],iNum, terro;
	get_players(terrorists, iNum, "ae", "TERRORIST");
	terro = terrorists[0];
	new gain = isPlayerVip(terro)? 100 : 50;
	
	set_user_credits(terro,  get_user_credits(terro) + gain);
	CC_SendMessage(terro, "%L", terro, "REWARD_ROUND", gain);
	CC_SendMessage(terro, "%L", terro, "REWARD_CT_DEATH",  g_iCTDeaths*2, g_iCTDeaths);

	g_iCTDeaths = 0;
}

public player_killed(victim, attacker){
	new terrorists[MAX_PLAYERS], iNum, terro;
	get_players(terrorists, iNum, "ae", "TERRORIST");
	terro = terrorists[0];

	if(attacker != victim && is_user_alive(attacker)){
		new szName[32];
		get_user_name(victim, szName, charsmax(szName));
		new gain;

		if(cs_get_user_team(attacker) == CS_TEAM_T){
			gain = isPlayerVip(attacker)? 10 : 5;
		}
		else{
			gain = isPlayerVip(attacker)? 40 : 20;
		}

		set_user_credits(attacker, get_user_credits(attacker) + gain);
		CC_SendMessage(attacker, "%L", attacker, "REWARD_KILL", gain, szName);
	}
	if(is_user_alive(terro) && !is_user_alive(attacker)){
		new gain = isPlayerVip(terro)? 4 : 2;
		set_user_credits(terro, get_user_credits(terro) + gain);
		g_iCTDeaths++;
	}
}

