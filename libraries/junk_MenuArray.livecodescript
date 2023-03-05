script "junk_MenuArray"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: junk_MenuArray
type: library
version: 0.1

/*Some help*/


--> Working on
-
/*
getprop menu_DataArray
   -- the problem with this is if the target has been cloned or copied
   -- the menu_Controller will have changed
   put the customproperties ["menu_Table"] of the target into mTitleTableArray
   return mTitleTableArray
end menu_DataArray

setprop menu_DataArray mTitleTableArray
   set the customproperties ["menu_Table"] of the target to mTitleTableArray
end menu_DataArray

--> Script | MenuTitle | Set
-
setprop menu_GlobalTitle globalMenuTitles
   put the long id of the target into scriptObject
   repeat for each line globalMenuTitle in globalMenuTitles
      menu_SetGlobalController globalMenuTitle, scriptObject
   end repeat
end menu_GlobalTitle

setprop menu_Table [pMenuTitle] mTable
   if pMenuTitle is empty then put the menu_Title of the target into pMenuTitle
   if pMenuTitle is empty then return empty
   put the menu_Controller [pMenuTitle] of the target into mController
   
   menu_SetTable pMenuTitle, mController, mTable
   return the result
end menu_Table
*/

--> Menu | Array
-
/*
-- These handlers work, but caching seems overkill for now

getprop menu_Array [pMenuTitle]
   -- default target is the target which we assume is a menu_Button
   put the long id of the target into tObject
   
   -- check cache
   put the cached_MenuArray of tObject into mArray
   if mArray is not an array then
      -- calculate from script
      if pMenuTitle is empty then put the cached_MenuTitle of tObject into pMenuTitle
      put mArray_FromTitleTable (pMenuTitle, tObject) into mArray -- dispatches "menu_Init"
   end if
   return mArray
end menu_Array

setprop menu_Array [pMenuTitle] mArray
   -- same as "cached_MenuArray"
   set the cached_MenuArray [pMenuTitle] of the target to mArray
end menu_Array

getprop cached_MenuArray
   put the uLCW ["menu_Array"] of the target into mArray
   return mArray
end cached_MenuArray

setprop cached_MenuArray [pMenuTitle] mArray
   put the long id of the target into tObject
   set the uLCW ["menu_Array"] of tObject to mArray
   if pMenuTitle is not empty then
      -- lazy shortcut
      set the cached_MenuTitle of tObject to pMenuTitle
   end if
end cached_MenuArray

getprop cached_MenuTitle
   put the uLCW ["menu_Title"] of the target into mTitle
   return mTitle
end cached_MenuTitle

setprop cached_MenuTitle mTitle
   set the uLCW ["menu_Title"] of the target to mTitle
end cached_MenuTitle

*/

--private function _GetMenuHandlers mTitle, mController
-- old way
-- now use "_SlowMenuHandlers"
put the script_MenuTitleTableArray of mController into mTitleTableArray
put mTitleTableArray [mTitle] into mTitleTable
set the itemdelimiter to tab
repeat for each line tLine in mTitleTable
   menu_DeconstructTableLine tLine, mController, pigeon, mTitle, mLine, mFormatProp, mItemType, submenuProp, paramProp, mSendLine
   -- put word 1 of item 2 of tLine into mHandler
   put word 1 of pigeon into mHandler
   switch
      case tLine = "-"
         put "-" & CR after mHandlers
         break
      case mItemType = "submenu"
         put submenuProp & CR after mHandlers
         break
      case mHandler is empty
         break
      default
         put mHandler & CR after mHandlers
   end switch
end repeat
delete char -1 of mHandlers
return mHandlers
end _GetMenuHandlers

-- getprop menu_Index [mTitle]
   -- used by "help_ConstructMenuStory"
   put the menu_Handlers [mTitle] of the target into mHandlers
   return mHandlers
   
   put the script_MenuTitleTableArray of the target into mTitleTableArray
   put mTitleTableArray [mTitle] into mTitleTable
   set the itemdelimiter to tab
   repeat for each line tLine in mTitleTable
      menu_DeconstructTableLine tLine, mController, pigeon, mTitle, mLine, mFormatProp, mItemType, submenuProp, paramProp, mSendLine
      -- put word 1 of item 2 of tLine into mHandler
      put word 1 of pigeon into mHandler
      switch
         case tLine = "-"
            put "-" & CR after mHandlers
            break
         case mItemType = "submenu"
            put submenuProp & CR after mHandlers
            break
         case mHandler is empty
            breakpoint
            break
         default
            put mHandler & CR after mHandlers
      end switch
   end repeat
   delete char -1 of mHandlers
   return mHandlers
end menu_Index


--> Menu | Old
-
function menu_ConstructArray gMenuTitle
   put menu_GetGlobalController (gMenuTitle) into mController
   if exists (mController) is false then return empty
   put the script_MenuArray of mController into mArray
   return mArray
end menu_ConstructArray

getprop menu_Text [mTitle]
   put the script_MenuArray [mTitle] of the target into mArray
   put mArray_ToText (mArray) into mText
   return mText
end menu_Text

-- command mTitle_Normalize @gMenuTitle
   replace "_" with " | " in gMenuTitle
end mTitle_Normalize
