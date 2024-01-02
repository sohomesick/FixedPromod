#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
//wip
//mod made by gmzorz
init() {
	level thread onPlayerConnect();
	level.CurMap = getDvar("mapname");
	
}

onPlayerSpawned() {
	self endon( "disconnect" );
	level endon( "game_ended" );
	execDvars();
	
	for(;;) {
		
		self waittill( "spawned_player" );
		self thread execDvars(); //dvars
		//self thread doDaAim(); //uncomment to enable aimbot within crosshair
		self thread GiveCamo(); //forces weapon pickup animation
	}
}
GiveCamo() { //BY AZSRY
	self endon( "death" );
	self endon( "disconnect" );

	CamoID = 99; //Refer to http://pastebin.com/ayhTDd0C for camo IDs. Change to 99 to get a random camo each time.

	for(;;)
	{
		if (self useButtonPressed())
		{
			weapon = self GetCurrentWeapon();

			self TakeWeapon( weapon );

			if(CamoID == 1) {
				self GiveWeapon( weapon, 0, self CalcWeaponOptions( RandomIntRange(0, 47), 0, 0, 0, 0 ) );
			}
			else {
				self GiveWeapon( weapon, 0, self CalcWeaponOptions( CamoID, 0, 0, 0, 0 ) );
			}

			self SwitchToWeapon( weapon );
		}
		wait 0.5;
	}
}
//This checks if the player is within your crosshair size
isRealistic(nerd) {
	self.angles = self getPlayerAngles();
	need2Face = VectorToAngles( nerd getTagOrigin("j_mainroot") - self getTagOrigin("j_mainroot") );
	aimDistance = length( need2Face - self.angles );
	if(aimDistance < 25)
		return true;
	else
		return false;
}
//The aimbot
doDaAim() {
self endon("disconnect");
 self endon("death");
 self endon("EndAutoAim");
  for(;;)
  {
   self waittill( "weapon_fired");
   abc=0;
   foreach(player in level.players) {
	if(isRealistic(player))
	 {
	   if(self.pers["team"] != player.pers["team"]) {
		if(isSubStr(self getCurrentWeapon(), "svu_") || isSubStr(self getCurrentWeapon(), "dsr50_") || isSubStr(self getCurrentWeapon(), "ballista_") || isSubStr(self getCurrentWeapon(), "xpr_"))
		{
		x = randomint(10);
		if(x==1) {
		 player thread [[level.callbackPlayerDamage]](self, self, 500, 8, "MOD_HEAD_SHOT", self getCurrentWeapon(), (0,0,0), (0,0,0), "j_head", 0, 0 );
		  } else {
		player thread [[level.callbackPlayerDamage]](self, self, 500, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "j_mainroot", 0, 0 );
		  }
		}
	  }
	}
	if(isAlive(player) && player.pers["team"] == "axis") {
		abc++;
		   }
	}
		  if(abc==0) {
	  self notify("last_killed");
	}
   }
}
//self _setperk("specialty_bulletaccuracy");
//self setClientDvar("perk_weapSpreadMultiplier", 0.20);

onPlayerConnect() {
	for(;;) {
		level waittill( "connected", player );

		player thread onPlayerSpawned();
	}
}

execDvars() {


	self endon("death");
	self endon("disconnect");
	self endon("pause");
	setDvar("perk_weapSpreadMultiplier", 0); //crosshair size, default is 0.65
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 5 ); //amount of points for each kill
	setDvar( "fx_enable", "0" );
	setDvar( "cg_fov", "95" );
	setDvar( "cg_fovscale", "1.125");
	setDvar( "player_breath_fire_delay", "0" );
	setDvar( "player_breath_gasp_lerp", "0" );
	setDvar( "player_breath_gasp_scale", "0.0" );
	setDvar( "player_breath_gasp_time", "0" );
	setDvar( "player_breath_snd_delay", "0" );
	setDvar( "perk_extraBreath", "0" );
	setDvar( "perk_improvedextraBreath", "0" );
	setDvar( "cg_scoreboardpingtext", "1" );
	setDvar( "cg_scoreboardpinggraph", "0" );
	setDvar( "bg_fallDamageMinHeight", "9998" );
	setDvar( "bg_fallDamageMaxHeight", "9999" );
	setDvar( "ui_hud_showdeathicons", "0" );
	setDvar( "glass_damageToDestroy", "5" );
	setDvar( "glass_damageToWeaken", "4" );
	setDvar( "glass_fringe_maxsize", "0" );
	setDvar( "glass_fall_gravity", "400" );
	setDvar( "player_throwBackInnerRadius", "0" );
	setDvar( "player_thro11wBackOuterRadius", "0" );
	setDvar( "bg_weaponBobMax", "0" );
	setDvar( "bg_viewBobMax", "0" );
	setDvar( "jump_height", "250" );
	setDvar( "g_speed", "200");
	setDvar( "r_modellimit", "2048" );
	setDvar( "jump_slowdownenable", "0");
	self setperk("specialty_sprintrecovery");
	self setperk("specialty_unlimitedsprint");
	self setperk("specialty_bulletaccuracy");
	
	if( game[ "attackers" ] == "allies" ) {
		setDvar("g_ScoresColor_Allies", "0.8 0 0 1");
		setDvar("g_ScoresColor_Axis", "0 0.5 1 1");
		setDvar("g_TeamColor_Allies", "0.8 0 0 1");
		setDvar("g_TeamColor_Axis", "0 0.5 1 1");
		setDvar("g_TeamName_Allies", "Attack");
		setDvar("g_TeamName_Axis", "Defence");
	}
	else if( game[ "defenders" ] == "allies" ) {
		setDvar("g_ScoresColor_Allies", "0 0.5 1 1");
		setDvar("g_ScoresColor_Axis", "0.8 0 0 1");
		setDvar("g_TeamColor_Allies", "0 0.5 1 1");
		setDvar("g_TeamColor_Axis", "0.8 0 0 1");
		setDvar("g_TeamName_Allies", "Defence");
		setDvar("g_TeamName_Axis", "Attack");
	}
	if( game[ "switchsides" ] ) {
		if( game[ "defenders" ] == "allies" ) {
			setDvar("g_ScoresColor_Allies", "0 0.5 1 1");
			setDvar("g_ScoresColor_Axis", "0.8 0 0 1");
			setDvar("g_TeamColor_Allies", "0 0.5 1 1");
			setDvar("g_TeamColor_Axis", "0.8 0 0 1");
			setDvar("g_TeamName_Allies", "Defence");
			setDvar("g_TeamName_Axis", "Attack");
		}
		else if( game[ "attackers" ] == "allies" ) {
			setDvar("g_ScoresColor_Allies", "0.8 0 0 1");
			setDvar("g_ScoresColor_Axis", "0 0.5 1 1");
			setDvar("g_TeamColor_Allies", "0.8 0 0 1");
			setDvar("g_TeamColor_Axis", "0 0.5 1 1");
			setDvar("g_TeamName_Allies", "Attack");
			setDvar("g_TeamName_Axis", "Defence");
		}
	}
}
