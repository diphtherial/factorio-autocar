-- =============================================================
-- === generic helpers
-- =============================================================

function startswith(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function endswith(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

-- copied from another project for allowing disable-able debug statements
function print(...)
  return game.player.print(...)
end

debug=function() end
if debug_mode then
  debug=print
end

function samePos(a, b)
	if a == nil or b == nil then
		return false
	end
	
	return a[1] == b[1] and a[2] == b[2]
end

-- table-to-string helper

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end