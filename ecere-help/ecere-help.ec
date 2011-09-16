#include <stdio.h>
#include <stdlib.h>
#include <string.h>

import "ecere"

File help_input_file;

void helpin(char *namein)
{
char error[4096];


   
   help_input_file = FileOpen(namein, read); 
   
    
    if (!help_input_file)
    {
      sprintf(error, "Error, cannot open input file:\n%s\n%s", namein, strerror(errno));
      MessageBox {text = "Error", contents = error}.Modal();
      exit(1);
    }

}




class helpform : Window
{
   text = "Help";
   background = activeBorder;
   borderStyle = sizable;
   hasMaximize = true;
   hasMinimize = true;
   hasClose = true;
   size = { 800, 600 };

   DataRow help_row;
   int a;

   EditBox help_edit_box
   {
      this, anchor = { left = 400, top = 8, right = 0, bottom = 12 }, hasVertScroll = true, multiLine = true, wrap = true
   }
   ListBox help_list_box 
   {      
      this, anchor = { left = 8, top = 8, right = 0.50, bottom = 12 }, fullRowSelect = false, true, true, true;

      bool NotifySelect(ListBox listBox, DataRow row, Modifiers mods)
      {
      
         if (row != null)
         {
         
            if (FileExists(row.string).isFile == true)
            {
            help_edit_box.Clear();
            helpin(row.string);
            help_edit_box.Load(help_input_file);
            delete(help_input_file);
            }
         
         }
         return true;
      }
   };

   void ListDirectory(DataRow addTo, char *path)
   {
      FileListing listing { path };

      while (listing.Find())
      {
         help_row = addTo.AddString(listing.path);
         help_row.collapsed = true;
         
         if(listing.stats.attribs.isDirectory)
         ListDirectory(help_row, listing.path);

         if(listing.stats.attribs.isFile)
         ListDirectory(help_row, listing.path);

      }

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
