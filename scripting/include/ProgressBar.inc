#if defined _ProgressBar_include
	#endinput
#endif
#define _ProgressBar_include

native void ShowProgressBar(int client, float time);
native void ResetProgressBar(int client);

public SharedPlugin __pl_ProgressBar =
{
	name = "ProgressBar",
	file = "ProgressBar.smx",
#if defined REQUIRE_PLUGIN
	required = 1
#else
	required = 0
#endif
}

#if !defined REQUIRE_PLUGIN
public void __pl_ProgressBar_SetNTVOptional()
{
	MarkNativeAsOptional("ShowProgressBar");
	MarkNativeAsOptional("ResetProgressBar");
}
#endif