local ts_utils = require('nvim-treesitter.ts_utils')
local tsm_utils = require('ts-manipulator.utils')

local A = {}

local argument_node_types = {
    python = {"argument_list"},
    lua = {"arguments"},
    cpp = {"parameter_list"},
    c = {"parameter_list"}
}

local function table_has_val(tab, val)
    for _, tabval in ipairs(tab) do
        if tabval == val then
            return true
        end
    end
    return false
end

-- To get the current argument's node table
A.get_current = function()

    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local buf_arg_nodetypes = argument_node_types[buf_ft]
    if buf_arg_nodetypes == nil then
        error("Filetype '" .. buf_ft .. "' not currently supported")
    end

    local node = tsm_utils.get_node()
    local root_node = ts_utils.get_root_for_node(node)
    while (true) do
        local parent = node:parent()
        if (parent:id() == root_node:id()) then
            error("The cursor is not above on any argument")
        elseif table_has_val(buf_arg_nodetypes, parent:type()) then
            break
        else
            node = parent
        end
    end
    return node
end

-- Visually select the current argument
A.select_current = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local argument_node = A.get_current()
    ts_utils.update_selection(bufnr, argument_node)
end

-- Swap the current argument with the next one (if any)
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

-- Swap the current argument with the previous one (if any)
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

-- Move to the next argument (if any)
A.move_forward = function()
    local curr_node = A.get_current()
    local next_node = ts_utils.get_next_node(curr_node)
    if next_node == nil then
        -- error("This is the last argument")
        return
    end
    ts_utils.goto_node(next_node, false, true)
end

-- Move to the previous argument (if any)
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
