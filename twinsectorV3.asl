
state("TwinSector_Steam") // by Seifer and nikvel
{
    int game : "TwinSector_Steam.exe", 0x0FB96DE0, 0x30; // Level loaded
    int menu : "TwinSector_Steam.exe", 0x0C5AA7F8; // Menu opened
    int map : "TwinSector_Steam.exe", 0xC1AA818; // Level id\
    int finish : "TwinSector_Steam.exe", 0x588594; // Last level map
    float xCoord : "TwinSector_Steam.exe", 0x0FB96DE0, 0x48, 0x140;
}    
start
{
	if (current.game == 1 && old.game == 0)
    {
        return true;
    }
}

isLoading
{
    if (current.game == 0 && settings["loadremover"])
    {
        return true;
    }
    if (current.game == 1)
    {
        return false;
    }
}
split
{
    if (current.map == vars.counter && settings["splitLevels"])
    {
        vars.counter++;
        return true;
    }

    if (current.map - old.map == 1 && settings["splitIndividual"])
    {
        return true;
    }
    if (current.finish == -1 && old.finish == 16) // Last level
    {
        return true;
    }
}
reset
{
    if (current.map < old.map)
    {
        vars.counter = 1;
        return true;
    }
}
onStart
{
    vars.counter = 1;
}
startup 
{
    settings.Add("loadremover", true, "Loadremover");
    settings.Add("splitLevels", true, "Split on levels in a natural order");
    settings.Add("splitIndividual", true, "Split on individual levels");
    vars.counter = 1; 
}
