local M = {}

-- Keep this list curated: every entry is applied automatically, not suggested.
local corrections = {
  abotu = "about",
  accomodate = "accommodate",
  acheive = "achieve",
  adress = "address",
  agressive = "aggressive",
  agian = "again",
  ahve = "have",
  aleady = "already",
  apparant = "apparent",
  arguement = "argument",
  artilce = "article",
  avaliable = "available",
  availble = "available",
  becuase = "because",
  beggining = "beginning",
  begining = "beginning",
  cemetary = "cemetery",
  changable = "changeable",
  comming = "coming",
  commited = "committed",
  concious = "conscious",
  configuraiton = "configuration",
  coudl = "could",
  definately = "definitely",
  deos = "does",
  desigend = "designed",
  desparate = "desperate",
  dissapear = "disappear",
  documention = "documentation",
  embarass = "embarrass",
  enviornment = "environment",
  enviroment = "environment",
  existance = "existence",
  explicitlly = "explicitly",
  folowing = "following",
  foriegn = "foreign",
  fourty = "forty",
  freind = "friend",
  funtion = "function",
  goverment = "government",
  grammer = "grammar",
  guage = "gauge",
  haev = "have",
  happend = "happened",
  heirarchy = "hierarchy",
  histroy = "history",
  hte = "the",
  htink = "think",
  hvae = "have",
  immediatly = "immediately",
  implimentation = "implementation",
  independant = "independent",
  initialze = "initialize",
  interupted = "interrupted",
  intresting = "interesting",
  jsut = "just",
  knowlege = "knowledge",
  lenght = "length",
  liason = "liaison",
  libary = "library",
  libray = "library",
  logcial = "logical",
  maintainance = "maintenance",
  managment = "management",
  manualy = "manually",
  migth = "might",
  millenium = "millennium",
  neccessary = "necessary",
  noticable = "noticeable",
  occurance = "occurrence",
  occured = "occurred",
  occurence = "occurrence",
  offical = "official",
  paramater = "parameter",
  persistant = "persistent",
  posession = "possession",
  prefered = "preferred",
  priviledge = "privilege",
  publically = "publicly",
  recieve = "receive",
  recomend = "recommend",
  refered = "referred",
  relevent = "relevant",
  remeber = "remember",
  respository = "repository",
  retreive = "retrieve",
  seperate = "separate",
  seperately = "separately",
  shoudl = "should",
  similiar = "similar",
  souce = "source",
  specifiy = "specify",
  succesful = "successful",
  supercede = "supersede",
  syncronous = "synchronous",
  taht = "that",
  teh = "the",
  thier = "their",
  thikn = "think",
  thnik = "think",
  tihnk = "think",
  tommorow = "tomorrow",
  truely = "truly",
  unecessary = "unnecessary",
  unfortunatly = "unfortunately",
  unknwon = "unknown",
  unkown = "unknown",
  untill = "until",
  usefull = "useful",
  wierd = "weird",
  wiht = "with",
  woudl = "would",
}

local function title_case(word)
  return word:sub(1, 1):upper() .. word:sub(2)
end

local function with_case_variants(entries)
  local variants = {}

  for typo, correction in pairs(entries) do
    variants[typo] = correction
    variants[title_case(typo)] = title_case(correction)
    variants[typo:upper()] = correction:upper()
  end

  return variants
end

local case_aware_corrections = with_case_variants(corrections)

-- Use an allowlist so intentionally unusual identifiers remain untouched in code.
local enabled_filetypes = {
  gitcommit = true,
  markdown = true,
}

local function install(bufnr)
  if vim.b[bufnr].prose_abbreviations_installed then
    return
  end

  for typo, correction in pairs(case_aware_corrections) do
    vim.keymap.set("ia", typo, correction, {
      buffer = bufnr,
      desc = ("Correct %s to %s"):format(typo, correction),
      noremap = true,
    })
  end

  vim.b[bufnr].prose_abbreviations_installed = true
end

local function uninstall(bufnr)
  if not vim.b[bufnr].prose_abbreviations_installed then
    return
  end

  for typo in pairs(case_aware_corrections) do
    vim.keymap.del("ia", typo, { buffer = bufnr })
  end

  vim.b[bufnr].prose_abbreviations_installed = nil
end

function M.setup()
  vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
    group = vim.api.nvim_create_augroup(
      "ProseAbbreviations",
      { clear = true }
    ),
    callback = function(event)
      local enabled = enabled_filetypes[vim.bo[event.buf].filetype] == true
      if event.buf == vim.api.nvim_get_current_buf() then
        vim.wo.spell = enabled
      end

      if enabled then
        install(event.buf)
      else
        uninstall(event.buf)
      end
    end,
  })
end

return M
