local M = {}

-- Keep this list curated: every entry is applied automatically, not suggested.
-- Keys are correct spellings and values are their typo variants. Every key uses
-- the same syntax so the declarations can be sorted lexicographically.
-- Brace alternatives are paired by position. An empty pair on the correct side
-- copies the typo suffixes, so ["separate{}"] = "seperate{,ly}" expands to
-- seperate -> separate and seperately -> separately.
local corrections = {
  ["about"] = "abotu",
  ["accommodate"] = "accomodate",
  ["achieve"] = "acheive",
  ["address"] = "adress",
  ["again"] = "agian",
  ["aggressive"] = "agressive",
  ["already"] = "aleady",
  ["apparent"] = "apparant",
  ["argument"] = "arguement",
  ["article"] = "artilce",
  ["available"] = "{avaliable,availble}",
  ["because"] = "becuase",
  ["beginning"] = "{beggining,begining}",
  ["cemetery"] = "cemetary",
  ["changeable"] = "changable",
  ["coming"] = "comming",
  ["committed"] = "commited",
  ["configuration"] = "configuraiton",
  ["conscious"] = "concious",
  ["could"] = "coudl",
  ["definitely"] = "definately",
  ["designed"] = "desigend",
  ["desperate"] = "desparate",
  ["disappear"] = "dissapear",
  ["documentation"] = "documention",
  ["does"] = "deos",
  ["embarrass"] = "embarass",
  ["environment"] = "{enviornment,enviroment}",
  ["existence"] = "existance",
  ["explicitly"] = "explicitlly",
  ["following"] = "folowing",
  ["foreign"] = "foriegn",
  ["forty"] = "fourty",
  ["friend"] = "freind",
  ["function"] = "funtion",
  ["gauge"] = "guage",
  ["government"] = "goverment",
  ["grammar"] = "grammer",
  ["happened"] = "happend",
  ["have"] = "{ahve,haev,hvae}",
  ["hierarchy"] = "heirarchy",
  ["history"] = "histroy",
  ["immediately"] = "immediatly",
  ["implementation"] = "implimentation",
  ["independent"] = "independant",
  ["initialize"] = "initialze",
  ["interesting"] = "intresting",
  ["interrupted"] = "interupted",
  ["just"] = "jsut",
  ["knowledge"] = "knowlege",
  ["length"] = "lenght",
  ["liaison"] = "liason",
  ["library"] = "lib{ary,ray}",
  ["logical"] = "logcial",
  ["maintenance"] = "maintainance",
  ["management"] = "managment",
  ["manually"] = "manualy",
  ["might"] = "migth",
  ["millennium"] = "millenium",
  ["necessary"] = "neccessary",
  ["noticeable"] = "noticable",
  ["occur{rence,red,rence}"] = "occur{ance,ed,ence}",
  ["official"] = "offical",
  ["parameter"] = "paramater",
  ["persistent"] = "persistant",
  ["possession"] = "posession",
  ["preferred"] = "prefered",
  ["privilege"] = "priviledge",
  ["publicly"] = "publically",
  ["receive"] = "recieve",
  ["recommend"] = "recomend",
  ["referred"] = "refered",
  ["relevant"] = "relevent",
  ["remember"] = "remeber",
  ["repository"] = "respository",
  ["retrieve"] = "retreive",
  ["separate{}"] = "seperate{,ly}",
  ["should"] = "shoudl",
  ["similar"] = "similiar",
  ["source"] = "souce",
  ["specify"] = "specifiy",
  ["successful"] = "succesful",
  ["supersede"] = "supercede",
  ["synchronous"] = "syncronous",
  ["that"] = "taht",
  ["the"] = "{hte,teh}",
  ["their"] = "thier",
  ["think"] = "{htink,thikn,thnik,tihnk}",
  ["tomorrow"] = "tommorow",
  ["truly"] = "truely",
  ["unfortunately"] = "unfortunatly",
  ["unknown"] = "{unknwon,unkown}",
  ["unnecessary"] = "unecessary",
  ["until"] = "untill",
  ["useful"] = "usefull",
  ["weird"] = "wierd",
  ["with"] = "wiht",
  ["would"] = "woudl",
}

local function split_alternatives(value)
  local alternatives = {}
  local start = 1

  while true do
    local comma = value:find(",", start, true)
    if not comma then
      table.insert(alternatives, value:sub(start))
      return alternatives
    end

    table.insert(alternatives, value:sub(start, comma - 1))
    start = comma + 1
  end
end

local function brace_parts(value)
  local open = value:find("{", 1, true)
  if not open then
    assert(not value:find("}", 1, true), ("Unmatched } in %q"):format(value))
    return nil
  end

  local close = value:find("}", open + 1, true)
  assert(close, ("Unmatched { in %q"):format(value))
  assert(
    not value:sub(open + 1, close - 1):find("{", 1, true),
    ("Nested braces are not supported in %q"):format(value)
  )

  return value:sub(1, open - 1),
    value:sub(open + 1, close - 1),
    value:sub(close + 1)
end

local function expand_braces(lhs, rhs)
  local expanded = {}
  local pending = { { lhs = lhs, rhs = rhs } }

  while #pending > 0 do
    local entry = table.remove(pending)
    local lhs_before, lhs_middle, lhs_after = brace_parts(entry.lhs)

    if not lhs_before then
      assert(
        not brace_parts(entry.rhs),
        ("Replacement has more brace pairs than %q"):format(lhs)
      )
      expanded[entry.lhs] = entry.rhs
    else
      local targets = split_alternatives(lhs_middle)
      local rhs_before, rhs_middle, rhs_after = brace_parts(entry.rhs)
      local replacements = rhs_middle and split_alternatives(rhs_middle) or nil

      -- An empty replacement pair aliases the corresponding alternatives from
      -- the left-hand side, as in: seperate{,ly} -> separate{}.
      if replacements and #replacements == 1 and replacements[1] == "" then
        replacements = targets
      end

      for index, target in ipairs(targets) do
        local replacement = entry.rhs
        if replacements then
          replacement = rhs_before
            .. replacements[((index - 1) % #replacements) + 1]
            .. rhs_after
        end

        table.insert(pending, {
          lhs = lhs_before .. target .. lhs_after,
          rhs = replacement,
        })
      end
    end
  end

  return expanded
end

local function title_case(word)
  return word:sub(1, 1):upper() .. word:sub(2)
end

local function expand_corrections(entries)
  local expanded = {}

  for correction, variants in pairs(entries) do
    for typo, expanded_correction in pairs(expand_braces(variants, correction)) do
      expanded[typo] = expanded_correction
    end
  end

  return expanded
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

local case_aware_corrections =
  with_case_variants(expand_corrections(corrections))

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
