local function infer_csharp_namespace(filepath)
    local dir = vim.fn.fnamemodify(filepath, ":h")
    local current = dir

    -- Walk up looking for a .csproj file
    while current ~= "/" do
        local csproj = vim.fn.glob(current .. "/*.csproj")
        if csproj ~= "" then
            local project_name = vim.fn.fnamemodify(csproj, ":t:r")
            local relative = dir:sub(#current + 2) -- strip project root + separator
            if relative == "" then
                return project_name
            end
            -- Convert path separators to dots
            return project_name .. "." .. relative:gsub("/", ".")
        end
        current = vim.fn.fnamemodify(current, ":h")
    end

    -- Fallback: just use the directory name
    return vim.fn.fnamemodify(dir, ":t")
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    pattern = "*.cs",
    callback = function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local is_empty = #lines == 0 or (#lines == 1 and lines[1] == "")
        if not is_empty then
            return
        end

        local filepath = vim.fn.expand("%:p")
        local classname = vim.fn.expand("%:t:r")
        local namespace = infer_csharp_namespace(filepath)

        local template = {
            "namespace " .. namespace .. ";",
            "",
            "public class " .. classname,
            "{",
            "    ",
            "}",
        }

        vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
        vim.api.nvim_win_set_cursor(0, { 5, 4 })
    end,
})
