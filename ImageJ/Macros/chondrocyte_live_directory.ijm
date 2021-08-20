// "BatchProcessFolders"
//
// This macro batch processes all the files in a folder and any
// subfolders in that folder. In this example, it runs the Subtract 
// Background command of TIFF files. For other kinds of processing,
// edit the processFile() function at the end of this macro.

   requires("1.33s"); 
   dir = getDirectory("Choose a Directory ");
   setBatchMode(true);
   count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);
   //print(count+" files processed");
   
   function countFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }

   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processFile(path);
          }
      }
  }

  function processFile(path) {
       if (endsWith(path, ".tif")) {

            run("Duplicate...", " ");
            run("8-bit");
            run("Grays");
            run("Subtract Background...", "rolling=50");
            wait(1000)
            //run("Threshold...");
            //setThreshold(0, 41);
            setOption("BlackBackground", false);
            run("Convert to Mask");
            wait(1000)
            run("Watershed");
            wait(1000)
            run("Analyze Particles...", "size=20-800 circularity=.2-1.00 show=Overlay exclude summarize");
            wait(250)


      }
  }