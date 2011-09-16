#include <stdio.h>
#include <stdlib.h>
#include <string.h>

import "ecere"

File help_file;

void helpin(char *filename)
{
char error[4096];


   
   help_file = FileOpen(filename, readWrite); 
   
    
    if (!help_file)
    {
      sprintf(error, "Error, cannot open file:\n%s\n%s", filename, strerror(errno));
      MessageBox {text = "Error", contents = error}.Modal();
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
      this, anchor = { left = 400, top = 8, right = 0, bottom = 36 }, hasVertScroll = true, multiLine = true, wrap = true
   }
   Button help_button
   {
      this, text = "Save", anchor = { horz = 22, vert = 260 };

      bool NotifyClicked(Button button, int x, int y, Modifiers mods)
      {
                
         if (help_row != null)
         {
         
            if (FileExists(help_row.string).isFile == true)
            {
            helpin(help_row.string);
            help_edit_box.Save(help_file, false);
            delete(help_file);
           }
         
         }
                                               
         return true;
      }
   };
   ListBox help_list_box 
   {
      this, anchor = { left = 8, top = 0, right = 0.5, bottom = 36 }, fullRowSelect = false, true, true, true;

      bool NotifySelect(ListBox listBox, DataRow row, Modifiers mods)
      {
      
         if (row != null)
         {
         
            help_row = row;

            if (FileExists(row.string).isFile == true)
            {
            help_edit_box.Clear();
            helpin(row.string);
            help_edit_box.Load(help_file);
            delete(help_file);
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
