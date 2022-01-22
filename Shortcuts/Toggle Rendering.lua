local tbl = function()
   gDisableDrawing = not gDisableDrawing
   Settings.FFXIVMINION.gDisableDrawing = gDisableDrawing
   Hacks:Disable3DRendering(gDisableDrawing)
end

return tbl
