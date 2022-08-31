// Created 08/22/22
// Updated 08/26/22

int AlphaCutoff = 223; // only apply AA to pixels that are at or above this alpha
int Alpha = 0; // the alpha of the generated AA pixels (it's set to 0 right now since that seems to work the best w/ Mindustry mods)



void setup() {
  
  ArrayList <File> AllFiles = GetAllFilesInFolder (new File (dataPath("")));
  
  int StartMillis = millis();
  println ("Applying Auto AA...");
  for (File CurrentFile : AllFiles) {
    println ("   Processing \"" + CurrentFile.getName() + "\"...");
    PImage CurrentSprite = loadImage (CurrentFile.getAbsolutePath());
    ApplyAA (CurrentSprite);
    CurrentSprite.save(CurrentFile.getAbsolutePath());
    println ("   Done.");
    
  }
  println ("Done.");
  println ("Finished in " + (millis() - StartMillis) + " ms.");
  
  
  exit();
  
}





PImage ApplyAA (PImage CurrentSprite) {
  CurrentSprite.loadPixels();
  int Width = CurrentSprite.width;
  int Height = CurrentSprite.height;
  
  for (int y = 0; y < Height; y ++) {
    for (int x = 0; x < Width; x ++) {
      ApplyAAForPixel (CurrentSprite, x, y, Width, Height);
    }
  }
  
  CurrentSprite.updatePixels();
  return CurrentSprite;
}



void ApplyAAForPixel (PImage CurrentSprite, int x, int y, int Width, int Height) {
  int CurrentPixel = CurrentSprite.pixels[x + y * Width];
  if (alpha (CurrentPixel) > 0) return;
  
  int NumOfFilledNeighbors = 0;
  int TotalNeighborRed     = 0;
  int TotalNeighborGreen   = 0;
  int TotalNeighborBlue    = 0;
  
  if (x > 0) {
    int NeighborPixel = CurrentSprite.pixels[(x - 1) + y * Width];
    if (alpha (NeighborPixel) >= AlphaCutoff) {
      NumOfFilledNeighbors ++;
      TotalNeighborRed   += red (NeighborPixel);
      TotalNeighborGreen += green (NeighborPixel);
      TotalNeighborBlue  += blue (NeighborPixel);
    }
  }
  
  if (x < Width - 1) {
    int NeighborPixel = CurrentSprite.pixels[(x + 1) + y * Width];
    if (alpha (NeighborPixel) >= AlphaCutoff) {
      NumOfFilledNeighbors ++;
      TotalNeighborRed   += red (NeighborPixel);
      TotalNeighborGreen += green (NeighborPixel);
      TotalNeighborBlue  += blue (NeighborPixel);
    }
  }
  
  if (y > 0) {
    int NeighborPixel = CurrentSprite.pixels[x + (y - 1) * Width];
    if (alpha (NeighborPixel) >= AlphaCutoff) {
      NumOfFilledNeighbors ++;
      TotalNeighborRed   += red (NeighborPixel);
      TotalNeighborGreen += green (NeighborPixel);
      TotalNeighborBlue  += blue (NeighborPixel);
    }
  }
  
  if (y < Height - 1) {
    int NeighborPixel = CurrentSprite.pixels[x + (y + 1) * Width];
    if (alpha (NeighborPixel) >= AlphaCutoff) {
      NumOfFilledNeighbors ++;
      TotalNeighborRed   += red (NeighborPixel);
      TotalNeighborGreen += green (NeighborPixel);
      TotalNeighborBlue  += blue (NeighborPixel);
    }
  }
  
  if (NumOfFilledNeighbors == 0) return;
  
  int AverageRed   = TotalNeighborRed   / NumOfFilledNeighbors;
  int AverageGreen = TotalNeighborGreen / NumOfFilledNeighbors;
  int AverageBlue  = TotalNeighborBlue  / NumOfFilledNeighbors;
  CurrentSprite.pixels[x + y * Width] = color (AverageRed, AverageGreen, AverageBlue, Alpha);
  
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
