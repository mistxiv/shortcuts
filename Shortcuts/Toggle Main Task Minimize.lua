local tbl = function()
   ml_global_information.drawMode = (ml_global_information.drawMode + 1) % 2
end

return tbl
