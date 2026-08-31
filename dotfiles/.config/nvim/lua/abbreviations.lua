local M = {}

-- Keep this list curated: every entry is applied automatically, not suggested.
-- Keys are correct spellings and values are their typo variants. Every key uses
-- the same syntax so the declarations can be sorted lexicographically.
-- Brace alternatives are paired by position. An empty pair on the correct side
-- copies the typo suffixes, so ["separate{}"] = "seperate{,ly}" expands to
-- seperate -> separate and seperately -> separately.
-- Multiple pairs form a product, so ["s{ome}{}"] =
-- "{smoe,soem}{,body}" also covers smoe, soem, smoebody, and soembody.
local corrections = {
  ["about"] = "{abotu,baout}",
  ["accommodate"] = "accomodate",
  ["achieve"] = "acheive",
  ["address"] = "adress",
  ["again"] = "agian",
  ["aggressive"] = "agressive",
  ["already"] = "aleady",
  ["also"] = "aslo",
  ["always"] = "alwasy",
  ["another"] = "anohter",
  ["answer"] = "anwser",
  ["anybody"] = "{anybdoy,anybdy}",
  ["anyhow"] = "anyhwo",
  ["anyone"] = "anyoen",
  ["anyplace"] = "anypalce",
  ["anything"] = "{anyhting,anythign,anyting}",
  ["anytime"] = "anytmie",
  ["anyway"] = "anyawy",
  ["anywhere"] = "anyhwere",
  ["apparent"] = "apparant",
  ["argument"] = "arguement",
  ["article"] = "artilce",
  ["available"] = "{avaliable,availble}",
  ["because"] = "becuase",
  ["before"] = "beofre",
  ["beginning"] = "{beggining,begining}",
  ["being"] = "{beign,bieng}",
  ["believe"] = "beleive",
  ["between"] = "betwen",
  ["cemetery"] = "cemetary",
  ["changeable"] = "changable",
  ["coming"] = "comming",
  ["common"] = "comon",
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
  ["each"] = "eahc",
  ["embarrass"] = "embarass",
  ["environment"] = "{enviornment,enviroment}",
  ["enough"] = "enouhg",
  ["e{very}{}"] = "{evey,evrey}{,body,day,one,thing,where}",
  ["everybody"] = "{everybdoy,everybdy}",
  ["everyday"] = "{everday,everydy}",
  ["everyone"] = "everyoen",
  ["everything"] = "{everyhting,everythign,everyting,everthing}",
  ["everywhere"] = "everyhwere",
  ["example"] = "exmaple",
  ["existence"] = "existance",
  ["explicitly"] = "explicitlly",
  ["first"] = "frist",
  ["following"] = "folowing",
  ["foreign"] = "foriegn",
  ["forty"] = "fourty",
  ["friend"] = "freind",
  ["function"] = "funtion",
  ["gauge"] = "guage",
  ["government"] = "goverment",
  ["grammar"] = "grammer",
  ["great"] = "graet",
  ["happened"] = "happend",
  ["have"] = "{ahve,haev,hvae}",
  ["hierarchy"] = "heirarchy",
  ["history"] = "histroy",
  ["immediately"] = "immediatly",
  ["implementation"] = "implimentation",
  ["important"] = "importnat",
  ["independent"] = "independant",
  ["initialize"] = "initialze",
  ["interesting"] = "intresting",
  ["interrupted"] = "interupted",
  ["into"] = "itno",
  ["just"] = "jsut",
  ["knowledge"] = "knowlege",
  ["length"] = "lenght",
  ["liaison"] = "liason",
  ["library"] = "lib{ary,ray}",
  ["little"] = "littel",
  ["logical"] = "logcial",
  ["maintenance"] = "maintainance",
  ["mak{e,es,er,ers,ing}"] = "mka{e,es,er,ers,ing}",
  ["management"] = "managment",
  ["manually"] = "manualy",
  ["many"] = "mnay",
  ["might"] = "migth",
  ["millennium"] = "millenium",
  ["more"] = "moer",
  ["most"] = "msot",
  ["much"] = "mcuh",
  ["necessary"] = "neccessary",
  ["noticeable"] = "noticable",
  ["number"] = "nubmer",
  ["occur{rence,red,rence}"] = "occur{ance,ed,ence}",
  ["official"] = "offical",
  ["often"] = "ofetn",
  ["one{}"] = "oen{,self}",
  ["only"] = "onyl",
  ["other"] = "otehr",
  ["parameter"] = "paramater",
  ["people"] = "peopel",
  ["persistent"] = "persistant",
  ["please"] = "plaese",
  ["possession"] = "posession",
  ["preferred"] = "prefered",
  ["privilege"] = "priviledge",
  ["probably"] = "probaly",
  ["publicly"] = "publically",
  ["receive"] = "recieve",
  ["recommend"] = "recomend",
  ["referred"] = "refered",
  ["relevant"] = "relevent",
  ["really"] = "realy",
  ["remember"] = "remeber",
  ["repository"] = "respository",
  ["retrieve"] = "retreive",
  ["right"] = "rigth",
  ["same"] = "smae",
  ["separate{}"] = "seperate{,ly}",
  ["several"] = "severl",
  ["should"] = "shoudl",
  ["similar"] = "similiar",
  ["s{ome}{}"] = "{smoe,soem}{,body,day,how,one,place,thing,time,what,where}",
  ["somebody"] = "{somebdoy,somebdy,sombody}",
  ["someday"] = "somday",
  ["somehow"] = "{somehwo,somhow}",
  ["someone"] = "{someoen,somone}",
  ["someplace"] = "somepalce",
  ["something"] = "{somehting,somethign,somethng,somthing}",
  ["sometime"] = "sometmie",
  ["somewhat"] = "somewaht",
  ["somewhere"] = "somehwere",
  ["source"] = "souce",
  ["specify"] = "specifiy",
  ["still"] = "sitll",
  ["successful"] = "succesful",
  ["such"] = "suhc",
  ["supersede"] = "supercede",
  ["synchronous"] = "syncronous",
  ["than"] = "thna",
  ["that"] = "taht",
  ["the"] = "{hte,teh}",
  ["their"] = "thier",
  ["then"] = "tehn",
  ["there"] = "tehre",
  ["these"] = "htese",
  ["they"] = "tehy",
  ["t{hing}{}"] = "{hting,thign,thnig,tihng}{,s}",
  ["t{hink}{}"] = "{htink,thikn,thnik,tihnk}{,ing,s}",
  ["through"] = "throuhg",
  ["together"] = "togther",
  ["tomorrow"] = "tommorow",
  ["truly"] = "truely",
  ["unfortunately"] = "unfortunatly",
  ["unknown"] = "{unknwon,unkown}",
  ["unnecessary"] = "unecessary",
  ["until"] = "untill",
  ["useful"] = "usefull",
  ["very"] = "vrey",
  ["want"] = "wnat",
  ["was"] = "wsa",
  ["weird"] = "wierd",
  ["what"] = "{waht,whta}",
  ["when"] = "wehn",
  ["where"] = "wehre",
  ["which"] = "whcih",
  ["with{}"] = "wiht{,in,out}",
  ["work"] = "wrok",
  ["world"] = "wrold",
  ["would"] = "woudl",
  ["you"] = "yuo",
  ["your"] = "yuor",
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
      if enabled then
        install(event.buf)
      else
        uninstall(event.buf)
      end
    end,
  })
end

return M
