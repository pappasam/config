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
  ["absence"] = "absense",
  ["acceptable"] = "acceptible",
  ["accommodate"] = "accomodate",
  ["accidentally"] = "accidentaly",
  ["achieve"] = "acheive",
  ["acquire"] = "aquire",
  ["across"] = "accross",
  ["actually"] = "actualy",
  ["address"] = "adress",
  ["again"] = "agian",
  ["aggressive"] = "agressive",
  ["already"] = "aleady",
  ["also"] = "aslo",
  ["always"] = "alwasy",
  ["amateur"] = "amature",
  ["among"] = "amoung",
  ["amount"] = "ammount",
  ["analysis"] = "analisis",
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
  ["apparently"] = "{aparently,apparantly}",
  ["appearance"] = "appearence",
  ["appropriate"] = "appropiate",
  ["argument"] = "arguement",
  ["arrangement"] = "arrangment",
  ["article"] = "artilce",
  ["assistance"] = "assitance",
  ["assistant"] = "assitant",
  ["available"] = "{avaliable,availble}",
  ["basically"] = "basicly",
  ["because"] = "becuase",
  ["beautiful"] = "{beautifull,beutiful}",
  ["before"] = "beofre",
  ["beginning"] = "{beggining,begining}",
  ["being"] = "{beign,bieng}",
  ["believe"] = "beleive",
  ["between"] = "betwen",
  ["boundary"] = "boundry",
  ["business"] = "{buisness,bussiness}",
  ["category"] = "catagory",
  ["cemetery"] = "cemetary",
  ["certain"] = "certian",
  ["chang{e,es,ed,ing}"] = "chnag{e,es,ed,ing}",
  ["changeable"] = "changable",
  ["colleague"] = "collegue",
  ["combination"] = "combinaton",
  ["coming"] = "comming",
  ["command"] = "comand",
  ["common"] = "comon",
  ["committ{ed,ing}"] = "commit{ed,ing}",
  ["completely"] = "completly",
  ["configuration"] = "configuraiton",
  ["conscious"] = "concious",
  ["consistent"] = "consistant",
  ["controll{ed,er,ers,ing}"] = "control{ed,er,ers,ing}",
  ["convenient"] = "convient",
  ["could"] = "coudl",
  ["creat{e,es,ed,ing,or,ors}"] = "craet{e,es,ed,ing,or,ors}",
  ["curious"] = "curius",
  ["decision"] = "descision",
  ["definitely"] = "definately",
  ["description"] = "{desciption,descripton}",
  ["designed"] = "desigend",
  ["desperate"] = "desparate",
  ["development"] = "developement",
  ["difference"] = "diffrence",
  ["different"] = "{diferent,differant,diffrent}",
  ["difficult"] = "{dificult,difficutl}",
  ["direction"] = "directon",
  ["disappear"] = "dissapear",
  ["documentation"] = "documention",
  ["does"] = "deos",
  ["each"] = "eahc",
  ["eligible"] = "eligable",
  ["embarrass"] = "embarass",
  ["environment"] = "{enviornment,enviroment}",
  ["enough"] = "enouhg",
  ["especially"] = "especialy",
  ["essential"] = "essentail",
  ["e{very}{}"] = "{evey,evrey}{,body,day,one,thing,where}",
  ["everybody"] = "{everybdoy,everybdy}",
  ["everyday"] = "{everday,everydy}",
  ["everyone"] = "everyoen",
  ["everything"] = "{everyhting,everythign,everyting,everthing}",
  ["everywhere"] = "everyhwere",
  ["example"] = "exmaple",
  ["existence"] = "existance",
  ["experience"] = "experiance",
  ["explanation"] = "explaination",
  ["explicitly"] = "explicitlly",
  ["familiar"] = "familar",
  ["finally"] = "finaly",
  ["first"] = "frist",
  ["following"] = "folowing",
  ["foreign"] = "foriegn",
  ["forty"] = "fourty",
  ["friend"] = "freind",
  ["function"] = "funtion",
  ["fundamental"] = "fundemental",
  ["gauge"] = "guage",
  ["government"] = "goverment",
  ["grammar"] = "grammer",
  ["great"] = "graet",
  ["guarantee"] = "{garantee,guarentee}",
  ["guidance"] = "guidence",
  ["happen{}"] = "hapen{,s,ed,ing}",
  ["happened"] = "happend",
  ["have"] = "{ahve,haev,hvae}",
  ["hierarchy"] = "heirarchy",
  ["history"] = "histroy",
  ["immediately"] = "immediatly",
  ["implementation"] = "implimentation",
  ["important"] = "importnat",
  ["independent"] = "independant",
  ["indispensable"] = "indispensible",
  ["information"] = "informaiton",
  ["initialize"] = "initialze",
  ["instead"] = "instaed",
  ["integrate"] = "intergrate",
  ["intelligence"] = "inteligence",
  ["interesting"] = "intresting",
  ["interrupted"] = "interupted",
  ["into"] = "itno",
  ["just"] = "jsut",
  ["knowledge"] = "knowlege",
  ["language"] = "langauge",
  ["length"] = "lenght",
  ["liaison"] = "liason",
  ["library"] = "lib{ary,ray}",
  ["likely"] = "likley",
  ["little"] = "littel",
  ["logical"] = "logcial",
  ["maintenance"] = "maintainance",
  ["mak{e,es,er,ers,ing}"] = "mka{e,es,er,ers,ing}",
  ["management"] = "managment",
  ["manually"] = "manualy",
  ["many"] = "mnay",
  ["maximum"] = "maxium",
  ["might"] = "migth",
  ["millennium"] = "millenium",
  ["minimum"] = "minumum",
  ["miscellaneous"] = "{miscelaneous,miscellanous}",
  ["more"] = "moer",
  ["most"] = "msot",
  ["much"] = "mcuh",
  ["necessary"] = "neccessary",
  ["noticeable"] = "noticable",
  ["number"] = "nubmer",
  ["occasion"] = "occassion",
  ["occur{rence,red,rence}"] = "occur{ance,ed,ence}",
  ["official"] = "offical",
  ["often"] = "ofetn",
  ["one{}"] = "oen{,self}",
  ["only"] = "onyl",
  ["other"] = "otehr",
  ["parallel"] = "paralell",
  ["parameter"] = "paramater",
  ["particular"] = "particualr",
  ["people"] = "peopel",
  ["performance"] = "perfomance",
  ["permanent"] = "permanant",
  ["persistent"] = "persistant",
  ["plac{e,es,ed,ing}"] = "palc{e,es,ed,ing}",
  ["please"] = "plaese",
  ["possession"] = "posession",
  ["possible"] = "posible",
  ["preferr{ed,ing}"] = "prefer{ed,ing}",
  ["presence"] = "presense",
  ["privilege"] = "priviledge",
  ["probably"] = "probaly",
  ["professional"] = "profesional",
  ["publicly"] = "publically",
  ["question"] = "quesiton",
  ["really"] = "realy",
  ["receive"] = "recieve",
  ["recommend{}"] = "recomend{,s,ed,ing,ation}",
  ["referr{ed,ing,al}"] = "refer{ed,ing,al}",
  ["relevant"] = "relevent",
  ["remember"] = "remeber",
  ["repository"] = "respository",
  ["require"] = "requrie",
  ["response"] = "reponse",
  ["restaurant"] = "{restaraunt,resturant}",
  ["retrieve"] = "retreive",
  ["right"] = "rigth",
  ["same"] = "smae",
  ["schedule"] = "shedule",
  ["separate{}"] = "seperate{,ly}",
  ["several"] = "severl",
  ["should"] = "shoudl",
  ["similar{}"] = "similiar{,ity,ly}",
  ["sincerely"] = "sincerly",
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
  ["strategy"] = "{starategy,stratgey}",
  ["strength"] = "strenght",
  ["successful"] = "succesful",
  ["such"] = "suhc",
  ["supersede"] = "supercede",
  ["surprise"] = "suprise",
  ["synchronous"] = "syncronous",
  ["tak{e,es,en,ing}"] = "tka{e,es,en,ing}",
  ["temperature"] = "{tempature,temperture}",
  ["temporary"] = "temperary",
  ["than"] = "thna",
  ["that"] = "taht",
  ["the"] = "{hte,teh}",
  ["their"] = "thier",
  ["themselves"] = "themselfs",
  ["then"] = "tehn",
  ["there"] = "tehre",
  ["these"] = "htese",
  ["they"] = "tehy",
  ["t{hing}{}"] = "{hting,thign,thnig,tihng}{,s}",
  ["t{hink}{}"] = "{htink,thikn,thnik,tihnk}{,ing,s}",
  ["threshold"] = "threshhold",
  ["through"] = "throuhg",
  ["throughout"] = "througout",
  ["together"] = "togther",
  ["tomorrow"] = "tommorow",
  ["transfer"] = "tranfer",
  ["transferr{ed,ing}"] = "transfer{ed,ing}",
  ["truly"] = "truely",
  ["unfortunately"] = "unfortunatly",
  ["unknown"] = "{unknwon,unkown}",
  ["unnecessary"] = "unecessary",
  ["unusual"] = "unusal",
  ["until"] = "untill",
  ["us{e,es,ed,er,ers,ing}"] = "ues{e,es,ed,er,ers,ing}",
  ["useful"] = "usefull",
  ["vacuum"] = "{vaccum,vacum}",
  ["version"] = "verison",
  ["very"] = "vrey",
  ["visible"] = "visable",
  ["want"] = "wnat",
  ["was"] = "wsa",
  ["wednesday"] = "wendesday",
  ["weird"] = "wierd",
  ["what"] = "{waht,whta}",
  ["when"] = "wehn",
  ["where"] = "wehre",
  ["which"] = "whcih",
  ["with{}"] = "wiht{,in,out}",
  ["work"] = "wrok",
  ["world"] = "wrold",
  ["would"] = "woudl",
  ["writ{e,es,er,ers,ing}"] = "wirt{e,es,er,ers,ing}",
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
