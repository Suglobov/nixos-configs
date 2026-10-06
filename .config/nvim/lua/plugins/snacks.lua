return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            -- Включаем скрытые файлы (.env, .gitignore и т.д.) по умолчанию
            hidden = true,
            -- Включаем файлы, которые игнорируются гитом (БЕЗ этого .env не появится, если он в .gitignore)
            ignored = true,
          },
        },
      },
    },
  },
}
