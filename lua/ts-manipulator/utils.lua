local ts_utils = require('nvim-treesitter.ts_utils')

local U = {}

U.get_node = function()
    local node = ts_utils.get_node_at_cursor()
    if node == nil then
        error("No Treesitter parser found.")
    end
    return node
end

return U
