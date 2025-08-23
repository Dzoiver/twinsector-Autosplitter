
state("TwinSector_Steam") // by Seifer and nikvel
{
    int game : "TwinSector_Steam.exe", 0x0FB96DE0, 0x30; // Level loaded
    int menu : "TwinSector_Steam.exe", 0xC1AA7F8; // Menu opened
    byte loading : "TwinSector_Steam.exe", 0xC1AA892; // loading finished 128 -> 0
    int map : "TwinSector_Steam.exe", 0xC1AA818; // Level id\
    int finish : "TwinSector_Steam.exe", 0x588594; // Last level map
    float xCoord : "TwinSector_Steam.exe", 0x0FB96DE0, 0x48, 0x140;
    float yCoord : "TwinSector_Steam.exe", 0x0FB96DE0, 0x48, 0x144;
    int cutsceneHour1 : "TwinSector_Steam.exe", 0xFB96D0C;
    // float leftHand : "TwinSector_Steam.exe", 0x0FB96DE0, 0x24, 0x134, 0x134;
}    
start
{
    if (current.cutsceneHour1 == 0 && old.cutsceneHour1 == 1 && current.map == 0)
    {
        return true;
    }
}

isLoading
{
    if (current.game == 0 && old.game == 1)
    {
        vars.loading = true;
        return true;
    }

    if (current.loading == 0 && old.loading == 128 && vars.loading)
    {
        vars.loading = false;
        return false;
    }
}

gameTime
{
    if (current.game == 0 && old.game == 1)
    {
        return timer.CurrentTime.GameTime.GetValueOrDefault() + TimeSpan.FromMilliseconds(vars.loadingPenalty);
    }
}

split
{
    if (current.map == vars.counter && settings["splitLevels"] && old.map != vars.counter)
    {
        vars.counter++;
        return true;
    }

    if (current.map - old.map == 1 && settings["splitIndividual"])
    {
        if (current.map == 0 && old.map == 1)
        return false;
        return true;
    }
    if (current.finish == -1 && old.finish == 16) // Last level
    {
        return true;
    }
}
reset
{
    if (current.cutsceneHour1 == 1 && old.cutsceneHour1 == 0 && current.map == 0)
    {
        vars.counter = 1;
        return true;
    }
}
onStart
{
    vars.loading = false;
    vars.counter = 1;
}
startup 
{
    settings.Add("loadremover", true, "Loadremover");
    settings.Add("splitLevels", true, "Split on levels in a natural order");
    settings.Add("splitIndividual", true, "Split on individual levels");
    vars.counter = 1; // Looks for level order
    vars.loadingPenalty = 200; // Penalty that adds to timer on each load to prevent abusing LRT
    vars.loading = false;
}
