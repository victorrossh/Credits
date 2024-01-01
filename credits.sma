#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <nvault>
#include <cromchat>

#define PLUGIN "Credits System"
#define VERSION "0.1"
#define AUTHOR "MrShark45"

new g_hVault;

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR);

	register_clcmd("say /credits", "Show_Credits");
	register_clcmd("amx_give", "GiveCredits", ADMIN_IMMUNITY, "amx_give <name> <amount>");

	register_concmd("amx_givecredits", "GiveCreditsName", ADMIN_IMMUNITY);

	CC_SetPrefix("&x04[DR]");
}

public plugin_cfg(){
	g_hVault = nvault_open("credits");

	if(g_hVault == INVALID_HANDLE)
		set_fail_state("Error opening vault!");
}

public plugin_end(){
	nvault_close(g_hVault);
}

public plugin_natives(){
	register_library("credits")

	register_native("get_user_credits", "get_user_credits_native");
	register_native("set_user_credits", "set_user_credits_native");

	register_native("get_user_credits_name", "get_user_credits_name_native");
	register_native("set_user_credits_name", "set_user_credits_name_native");

}

public GiveCredits(id, lvl, cid){
	if(!cmd_access(id, lvl, cid, 0))
		return PLUGIN_HANDLED

	new szName[64];
	new szNum[32];
	new num;
	read_argv(1, szName, 63);
	read_argv(2, szNum, charsmax(szNum));
	num = str_to_num(szNum);
	if(equali(szName, "@all"))
	{
		new players[MAX_PLAYERS], iPlayers;
		get_players(players, iPlayers, "ch");
		for(new i;i<iPlayers;i++)
		{
			CC_SendMessage(players[i], "&x01Ai primit &x04%d &x01credite!", num);
			set_user_credits(players[i], get_user_credits(players[i])+num);
		}

		return PLUGIN_HANDLED;
	}
	
	new target = find_player("bl", szName);
	if(!is_user_connected(target) || is_user_bot(target)) return PLUGIN_HANDLED;
	set_user_credits(target, get_user_credits(target)+num);

	get_user_name(target, szName, charsmax(szName));

	CC_SendMessage(id, "&x01I-ai trimis &x04%d &x01credite lui %s!", num, szName);
	CC_SendMessage(target, "&x01Ai primit &x04%d &x01credite!", num);
	return PLUGIN_HANDLED;
}

public GiveCreditsName(id, lvl, cid){
	if(!cmd_access(id, lvl, cid, 0) && id != 0)
		return PLUGIN_HANDLED

	new szName[64];
	new szNum[32];
	new num;
	read_argv(1, szName, 63);
	read_argv(2, szNum, charsmax(szNum));
	num = str_to_num(szNum);

	set_user_credits_name(szName, num + get_user_credits_name(szName));

	return PLUGIN_HANDLED
}

public get_user_credits_native(numParams){
	new id = get_param(1);

	return get_user_credits(id);
}

public set_user_credits_native(numParams){
	new id = get_param(1);
	new credits = get_param(2);

	set_user_credits(id, credits);
}

public get_user_credits_name_native(numParams){
	new szName[64];
	get_string(1, szName, charsmax(szName));

	return get_user_credits_name(szName);
}

public set_user_credits_name_native(numParams){
	new szName[64];
	get_string(1, szName, charsmax(szName));
	new credits = get_param(2);

	set_user_credits_name(szName, credits);
}

public set_user_credits(id, credits){
	new szName[64], value[32];
	get_user_name(id, szName, 63);
	num_to_str(credits, value, sizeof(value));
	nvault_set(g_hVault, szName, value);
}

public get_user_credits(id){
	new szName[64], value[32];
	get_user_name(id, szName, 63);
	nvault_get(g_hVault, szName, value, sizeof(value));

	return str_to_num(value);
}

public set_user_credits_name(szName[], credits){
	new value[32];
	num_to_str(credits, value, sizeof(value));
	nvault_set(g_hVault, szName, value);
}

public get_user_credits_name(szName[]){
	new value[32];
	nvault_get(g_hVault, szName, value, sizeof(value));

	return str_to_num(value);
}

public Show_Credits(id){
	new szName[64];
	read_argv(2, szName, charsmax(szName));
	if(strlen(szName)){
		new target = find_player("bl", szName);
		CC_SendMessage(id, "&x01%s are &x04%d &x01credite!", get_user_credits(target));
		
		return PLUGIN_HANDLED;
	}
		
	CC_SendMessage(id, "&x01Ai &x04%d &x01credite!", get_user_credits(id));
	return PLUGIN_HANDLED;
}
