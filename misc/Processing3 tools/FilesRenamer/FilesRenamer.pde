// Forked from AutoSpriteAA 08/31/22



String OldExtentionName = ".json";
String NewExtentionName = ".hjson";



import java.nio.file.*;



void setup() {
  
  ArrayList <File> AllFiles = GetAllFilesInFolder (new File (dataPath("")));
  
  int StartMillis = millis();
  for (File CurrentFile : AllFiles) {
    String CurrentFileName = CurrentFile.getName();
    if (!CurrentFileName.endsWith(OldExtentionName)) continue;
    String NewFileName = CurrentFileName.substring(0, CurrentFileName.length() - OldExtentionName.length()) + NewExtentionName;
    Path CurrentFilePath = CurrentFile.toPath();
    try {
      Files.move(CurrentFilePath, CurrentFilePath.resolveSibling(NewFileName)); // from stackoverflow: https://stackoverflow.com/a/13826095/13325385
    } catch (IOException e) {}
    CurrentFile.delete();
  }
  println ("Finished in " + (millis() - StartMillis) + " ms.");
  
  
  exit();
  
}





ArrayList <File> GetAllFilesInFolder (File FolderIn) {
  ArrayList <File> FoldersToSearch = new ArrayList <File> ();
  ArrayList <File> Output = new ArrayList <File> ();
  FoldersToSearch.add(FolderIn);
  
  while (FoldersToSearch.size() > 0) {
    File CurrentFolder = FoldersToSearch.remove(FoldersToSearch.size()-1);
    File[] CurrentFolderChildren = CurrentFolder.listFiles();
    for (File CurrentChild : CurrentFolderChildren) {
      ArrayList <File> ListToAddTo = (CurrentChild.isFile()) ? Output : FoldersToSearch;
      ListToAddTo.add(CurrentChild);
    }
  }
  
  return Output;
}
