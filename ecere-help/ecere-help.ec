#include <stdio.h>
#include <stdlib.h>
#include <string.h>

import "ecere"

FILE *naji_input;

void najin(char *namein)
{
char error[4096];


    naji_input = fopen(namein, "rb");

    if (naji_input == NULL)
    {
      sprintf(error, "Error, cannot open input file:\n%s\n%s", namein, strerror(errno));
      MessageBox {text = "Error", contents = error}.Modal();
      exit(1);
    }

}

void najinclose(void)
{
fclose(naji_input);
}



class helpform : Window
{
   text = "Help";
   background = activeBorder;
   borderStyle = sizable;
   hasMaximize = true;
   hasMinimize = true;
   hasClose = true;
   size = { 664, 480 };

   DataRow help_row;
   int a;

   EditBox help_edit_box
   {
      this, text = "help_edit_box", size = { 314, 432 }, position = { 336, 8 }, readOnly = true, true
   };
   ListBox help_list_box 
   {      
      this, text = "help_list_box", anchor = { left = 8, top = 8, right = 0.490741, bottom = 12 }, fullRowSelect = false, true, true, true;

      bool NotifySelect(ListBox listBox, DataRow row, Modifiers mods)
      {
      
      
      if (FileExists(row.string).isFile == true)
      {
      najin(row.string);


      help_edit_box.Clear();

      while (1)
      {
      a = fgetc(naji_input);
      if (a == EOF)
      break;

      help_edit_box.AddCh(a);
      Update(null);
      }

      najinclose();
      }
         return true;
      }
   };

   void ListDirectory(DataRow addTo, char *path)
   {
      static int maxDepth = 0;
      FileListing listing { path };
      maxDepth++;
      while (maxDepth < 5 && listing.Find())
      {
         help_row = addTo.AddString(listing.path);
         help_row.collapsed = true;
         
         if(listing.stats.attribs.isDirectory)
         ListDirectory(help_row, listing.path);

         if(listing.stats.attribs.isFile)
         ListDirectory(help_row, listing.path);

      }
      maxDepth--;
   }

   bool OnCreate()
   {
      String rootDir = "ecere";
      DataRow row = help_list_box.AddString(rootDir);
      ListDirectory(row, rootDir);
      return true;
   }
}

helpform help {};
