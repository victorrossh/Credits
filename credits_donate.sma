#include <amxmodx>
#include <cstrike>
#include <credits>
#include <cromchat>

native reg_is_user_logged(id);
native reg_is_user_registered(id);

#pragma tabsize 0

#define szPrefixMenu "\r[FWO]"

new players_menu, players[32], num, i;
new accessmenu, iName[64], callback;

public plugin_init()
{
	register_plugin("Donate Credits", "1.0", "ftl~");

	register_clcmd("say /donate", "transfer_credits");
	register_clcmd("say_team /donate", "transfer_credits");
	register_clcmd("say .donate", "transfer_credits");
	register_clcmd("say_team .donate", "transfer_credits");
		
	register_clcmd("say /doar", "transfer_credits");
	register_clcmd("say_team /doar", "transfer_credits");
	register_clcmd("say .doar", "transfer_credits");
	register_clcmd("say_team .doar", "transfer_credits");

	register_clcmd("DONATE_CREDITS", "transfer_credits_msg");

	CC_SetPrefix("&x04[FWO]");
}
public plugin_cfg() {
	register_dictionary("credits.txt");
}

/*public plugin_natives()
{
	register_library("name");
	register_native("showUserDonate", "native_user_donate", 1);
}

public native_user_donate(id)
{
	return Transfer_Credits(id);
}
We may use this native in the future to add it to the main menu. 
I'll think of something. 
I already created it so that in the future we just need to edit the name and not have to type everything again.*/


public transfer_credits(id)
{
	get_players(players, num, "ch");  
	if(num <= 1)
	{		   
		CC_SendMessage(id, "%L", id, "NO PLAYERS_MSG");
		return PLUGIN_HANDLED;
	}
	
	new tempname[32], info[10]; 
	new Temp[101], credits = get_user_credits(id);
	
	formatex(Temp,charsmax(Temp), "%s \d- \wDonate Credits^nCredits: \y%d\d", szPrefixMenu, credits);
	players_menu = menu_create(Temp, "transfer_credits_handler");
 
	for(i = 0; i < num; i++)
	{		   
		if(players[i] == id)		   
			continue;

		get_user_name(players[i], tempname, charsmax(tempname));   
		num_to_str(players[i], info, charsmax(info));
		menu_additem(players_menu, tempname, info, 0);
	}  
		 
	menu_setprop(players_menu, MPROP_EXIT, MEXIT_ALL);
	menu_display(id, players_menu, 0);
	
	return PLUGIN_HANDLED;
}

public transfer_credits_handler(id, players_menu, item)
{ 
	if(!reg_is_user_logged(id) || !reg_is_user_registered(id)){
		CC_SendMessage(id, "%L",id, "NOT_LOGGED_MSG")
		return PLUGIN_CONTINUE;
	}

	if(item == MENU_EXIT)
	{
		menu_destroy(players_menu);
		return PLUGIN_HANDLED;
	}
   
	new data[6];
	menu_item_getinfo(players_menu, item, accessmenu, data, charsmax(data), iName, charsmax(iName), callback);

	new player = str_to_num(data);
	client_cmd(id, "messagemode ^"DONATE_CREDITS %i^"", player);

	menu_destroy(players_menu);
	return PLUGIN_HANDLED;
}

public transfer_credits_msg(id)
{		
	new param[6];
	read_argv(2, param, charsmax(param));

	for (new x; x < strlen(param); x++)
	{		   
		if(!isdigit(param[x]))
		{
			return 0;
		}  
	}	
   
	new amount = str_to_num(param);
	new credits = get_user_credits(id) - str_to_num(param);

	if(amount <= 0)
		return 0;

	if(get_user_credits(id) < amount)
	{				 
		CC_SendMessage(id, "%L", id, "NOT_ENOUGH_MSG");
		return 0;
	}

	read_argv(1, param, charsmax(param));
	new player = str_to_num(param);
	new player_credits = get_user_credits(player) + amount;

	if(player == id)
		return 0;

	set_user_credits(id, credits);
	set_user_credits(player, player_credits);

	new names[2][32];
	get_user_name(id, names[0], 31);
	get_user_name(player, names[1], 31);

	CC_SendMessage(id, "%L",id, "SEND_CREDITS_MSG", amount, names[1]);
	CC_SendMessage(player, "%L",id, "RECEIVE_CREDITS_FROM_MSG", amount, names[0]);

	return 0;
} 
