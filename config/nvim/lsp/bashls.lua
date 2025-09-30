return {
  cmd = { "bash-language-server", "start" },
  filetypes = { "bash", "sh" },
  root_markers = { ".git" },
  settings = {
    bashIde = {
      --prevent recursive scanning when opening file in home directory
      globPattern = "*@(.sh|.inc|.bash|.command)" ,
    }
  }
}
