#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

int m_iSimulationTime;
int m_iProgressBarStartTime;
int m_iProgressBarDuration;
int m_iBlockingUseActionInProgress;

public Plugin myinfo =
{
	name = "Progress Bar",
	author = "",
	description = "Natives for displaying CS:GO's progress bar to clients",
	version = "",
	url = ""
};

public void OnPluginStart()
{
	m_iSimulationTime = FindSendPropInfo("CBaseEntity", "m_flSimulationTime");
	m_iProgressBarStartTime = FindSendPropInfo("CCSPlayer", "m_flProgressBarStartTime");
	m_iProgressBarDuration = FindSendPropInfo("CCSPlayer", "m_iProgressBarDuration");
	m_iBlockingUseActionInProgress = FindSendPropInfo("CCSPlayer", "m_iBlockingUseActionInProgress");
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("ProgressBar");
	CreateNative("ShowProgressBar", Native_ShowProgressBar);
	CreateNative("ResetProgressBar", Native_ResetProgressBar);
	return APLRes_Success;
}

public any Native_ShowProgressBar(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	float duration = GetNativeCell(2);
	SetProgressBarFloat(client, duration);
	return 0;
}

public any Native_ResetProgressBar(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	ResetProgressBar(client);
	return 0;
}

void SetProgressBarFloat(int client, float fProgressTime)
{
	if (!IsValidClient(client))
		return;

	int iProgressTime = RoundToCeil(fProgressTime);
	float flGameTime = GetGameTime();

	SetEntDataFloat(client, m_iSimulationTime, flGameTime + fProgressTime, true);
	SetEntData(client, m_iProgressBarDuration, iProgressTime, 4, true);
	SetEntDataFloat(client, m_iProgressBarStartTime, flGameTime - (iProgressTime - fProgressTime), true);
	SetEntData(client, m_iBlockingUseActionInProgress, 0, 4, true);
}

void ResetProgressBar(int client)
{
	if (!IsValidClient(client))
		return;

	SetEntDataFloat(client, m_iProgressBarStartTime, 0.0, true);
	SetEntData(client, m_iProgressBarDuration, 0, 1, true);
}

stock bool IsValidClient(int client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client))
		return false;
	return true;
}