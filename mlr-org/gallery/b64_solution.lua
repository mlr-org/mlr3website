-- Pure Lua Base64 encoder
local function base64_encode(data)
  local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  return ((data:gsub('.', function(x)
    local r,bits='',x:byte()
    for i=8,1,-1 do r=r..(bits%2^i-bits%2^(i-1)>0 and'1' or'0') end
    return r
  end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
    if #x < 6 then return '' end
    local c=0
    for i=1,6 do
      c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0)
    end
    return b:sub(c+1,c+1)
  end)..({ '', '==', '=' })[#data%3+1])
end

local function stringify_blocks(blocks)
  local doc = pandoc.Pandoc(blocks)
  return pandoc.write(doc, 'html')
end

function Div(div)
  if div.classes:includes("b64-solution") then
    -- html for the solution body
    local encoded = base64_encode(stringify_blocks(div.content))

    -- build the replacement HTML
    div.content = { pandoc.RawBlock('html', table.concat({
      '<div class="b64-wrapper">',
        '<button class="unlock-btn" onclick="unlockOne(this)">Unlock solution</button>',
        '<div class="hidden-solution" style="display:none" data-encoded="', encoded, '"></div>',
      '</div>'
    })) }

    div.classes = {}          -- strip original class so Quarto leaves it alone
    return div
  end
end

