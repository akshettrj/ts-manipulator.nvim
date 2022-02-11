local ts_utils = require('nvim-treesitter.ts_utils')
local tsm_utils = require('ts-manipulator.utils')

local A = {}

A.get_current = function()
    local node = tsm_utils.get_node()
    local start_row, start_col = node:start()
    while (true) do
        local parent = node:parent()
        local p_row, p_col = parent:start()
        if (p_row == start_row and p_col == start_col) then
            node = parent
        else
            break
        end
    end
    return node
end

A.select_current = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local argument_node = A.get_current()
    ts_utils.update_selection(bufnr, argument_node)
end

A.swap_forward = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local curr_node = A.get_current()
    local next_node = ts_utils.get_next_node(curr_node)
    if next_node == nil then
        -- error("This is the last argument")
        return
    end
    ts_utils.swap_nodes(curr_node, next_node, bufnr, true)
end

A.swap_backward = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local curr_node = A.get_current()
    local prev_node = ts_utils.get_previous_node(curr_node)
    if prev_node == nil then
        -- error("This is the first argument")
        return
    end
    ts_utils.swap_nodes(curr_node, prev_node, bufnr, true)
end

A.move_forward = function()
    local curr_node = A.get_current()
    local next_node = ts_utils.get_next_node(curr_node)
    if next_node == nil then
        -- error("This is the last argument")
        return
    end
    ts_utils.goto_node(next_node, false, true)
end

A.move_backward = function()
    local curr_node = A.get_current()
    local prev_node = ts_utils.get_previous_node(curr_node)
    if prev_node == nil then
        -- error("This is the first argument")
        return
    end
    ts_utils.goto_node(prev_node, false, true)
end

return A
