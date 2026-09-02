local M = {}

-- Keep this list curated: every entry is applied automatically, not suggested,
-- so a typo variant must never be a correctly spelled word.
-- Keys are correct spellings and values are their typo variants. Every key uses
-- the same syntax so the declarations can be sorted lexicographically.
-- Brace alternatives are paired by position. An empty pair on the correct side
-- copies the typo suffixes, so ["separate{}"] = "seperate{,ly}" expands to
-- seperate -> separate and seperately -> separately.
-- Multiple pairs form a product, so ["s{ome}{}"] =
-- "{smoe,soem}{,body}" also covers smoe, soem, smoebody, and soembody.
local corrections = {
  ["abbreviation"] = "abreviation",
  ["about"] = "{abotu,baout}",
  ["absence"] = "absense",
  ["acceptable"] = "acceptible",
  ["accessible"] = "acessible",
  ["accidentally"] = "{accidentaly,accidently}",
  ["accommodat{e,es,ed,ing,ion,ions}"] = "accomodat{e,es,ed,ing,ion,ions}",
  ["according"] = "acording",
  ["accuracy"] = "accuracey",
  ["achieve"] = "acheive",
  ["acknowledge"] = "acknowlege",
  ["acquaintance"] = "{acquaintence,aquaintance}",
  ["acquire"] = "aquire",
  ["across"] = "accross",
  ["actual{,ly}"] = "{acutal,actualy}",
  ["activate"] = "activte",
  ["activit{y,ies}"] = "activt{y,ies}",
  ["additional"] = "additonal",
  ["address{}"] = "adress{,es,ed,ing}",
  ["administrator"] = "adminstrator",
  ["advantage"] = "advatnage",
  ["advertisement"] = "advertisment",
  ["advice"] = "adivce",
  ["again"] = "agian",
  ["aggressive"] = "agressive",
  ["algorithm"] = "algorithim",
  ["allegiance"] = "allegience",
  ["allotted"] = "alloted",
  ["already"] = "aleady",
  ["also"] = "aslo",
  ["although"] = "althought",
  ["always"] = "alwasy",
  ["amateur"] = "amature",
  ["among"] = "amoung",
  ["amount"] = "ammount",
  ["analysis"] = "analisis",
  ["anniversary"] = "{aniversay,aniversary}",
  ["anonymous"] = "anonymus",
  ["another"] = "anohter",
  ["anticipate"] = "anticiapte",
  ["answer"] = "anwser",
  ["anybody"] = "{anybdoy,anybdy}",
  ["anyhow"] = "anyhwo",
  ["anyone"] = "anyoen",
  ["anyplace"] = "anypalce",
  ["anything"] = "{anyhting,anythign,anyting}",
  ["anytime"] = "anytmie",
  ["anyway"] = "anyawy",
  ["anywhere"] = "anyhwere",
  ["apolog{y,ies}"] = "appolog{y,ies}",
  ["apparent"] = "apparant",
  ["apparently"] = "{aparently,apparantly}",
  ["appearance"] = "appearence",
  ["application"] = "applicaiton",
  ["appropriate"] = "appropiate",
  ["approximately"] = "aproximatly",
  ["architecture"] = "architechture",
  ["argument{}"] = "arguement{,s}",
  ["arrangement"] = "arrangment",
  ["article"] = "artilce",
  ["assignment"] = "assigment",
  ["assistance"] = "assitance",
  ["assistant"] = "assitant",
  ["association"] = "assocation",
  ["asynchronous"] = "asyncronous",
  ["attention"] = "attension",
  ["audience"] = "audiance",
  ["authorization"] = "authorizaton",
  ["availability"] = "availablity",
  ["available"] = "{avaliable,availble}",
  ["background"] = "backgroud",
  ["basic{,ally}"] = "{basci,basicly}",
  ["because"] = "becuase",
  ["beautiful"] = "{beautifull,beutiful}",
  ["before"] = "beofre",
  ["beginner"] = "beginer",
  ["beginning"] = "{beggining,begining}",
  ["being"] = "{beign,bieng}",
  ["believe"] = "beleive",
  ["benefit{}"] = "benifit{,s,ed,ing}",
  ["between"] = "betwen",
  ["boolean"] = "boolen",
  ["boundary"] = "boundry",
  ["broccoli"] = "brocoli",
  ["bureaucracy"] = "bureacracy",
  ["b{usiness}{}"] = "{buisness,bussiness}{,es}",
  ["callback"] = "calback",
  ["candidate"] = "canidate",
  ["capability"] = "capabilty",
  ["caribbean"] = "carribean",
  ["categor{y,ies}"] = "catagor{y,ies}",
  ["cemetery"] = "cemetary",
  ["certificate"] = "certifcate",
  ["certain"] = "certian",
  ["challenge"] = "chalenge",
  ["chang{e,es,ed,ing}"] = "chnag{e,es,ed,ing}",
  ["changeable"] = "changable",
  ["character"] = "charactor",
  ["characteristic"] = "charateristic",
  ["choose"] = "chosse",
  ["coherent"] = "coherant",
  ["colleague"] = "collegue",
  ["combination"] = "combinaton",
  ["communication"] = "communciation",
  ["coming"] = "comming",
  ["command{}"] = "comand{,s,ed,ing}",
  ["common"] = "comon",
  ["committ{ed,ing}"] = "commit{ed,ing}",
  ["committee"] = "comittee",
  ["community"] = "comunity",
  ["comparison"] = "comparision",
  ["compatibility"] = "compatability",
  ["competition{}"] = "competion{,s}",
  ["completely"] = "completly",
  ["component{}"] = "componet{,s}",
  ["conceivable"] = "concievable",
  ["conclusion{}"] = "conclussion{,s}",
  ["concurrency"] = "concurency",
  ["configuration{}"] = "configuraiton{,s}",
  ["congratulations"] = "congradulations",
  ["connection{}"] = "conection{,s}",
  ["conscious"] = "concious",
  ["consistent"] = "consistant",
  ["consider"] = "consdier",
  ["continued"] = "continuted",
  ["controll{ed,er,ers,ing}"] = "control{ed,er,ers,ing}",
  ["convenience"] = "convience",
  ["convenient"] = "convient",
  ["correspondence"] = "correspondance",
  ["could"] = "coudl",
  ["creat{e,es,ed,ing,or,ors}"] = "craet{e,es,ed,ing,or,ors}",
  ["criticism"] = "critisism",
  ["curious"] = "curius",
  ["database"] = "datbase",
  ["daughter"] = "daugther",
  ["deceive"] = "decieve",
  ["decision"] = "descision",
  ["declaration"] = "decleration",
  ["define"] = "defien",
  ["definite{,ly}"] = "definat{e,ely}",
  ["definitely"] = "definetely",
  ["definition{}"] = "defintion{,s}",
  ["demonstrate"] = "demonstate",
  ["d{escription}{}"] = "{desciption,descripton}{,s}",
  ["designed"] = "desigend",
  ["desperate"] = "desparate",
  ["destination"] = "destinaton",
  ["destruction"] = "destructon",
  ["detail"] = "detial",
  ["development"] = "developement",
  ["device"] = "deivce",
  ["dictionary"] = "dictionairy",
  ["difference"] = "diffrence",
  ["different"] = "{diferent,differant,diffrent}",
  ["difficult"] = "{dificult,difficutl}",
  ["dimension"] = "dimention",
  ["direction{}"] = "directon{,s}",
  ["disappear{}"] = "dissapear{,s,ed,ing,ance}",
  ["disappointed"] = "dissapointed",
  ["disastrous"] = "disasterous",
  ["discipline"] = "disipline",
  ["discussion{}"] = "discusion{,s}",
  ["distribution{}"] = "distrubution{,s}",
  ["documentation"] = "documention",
  ["does"] = "deos",
  ["duplicate"] = "duplciate",
  ["each"] = "eahc",
  ["eighth"] = "eigth",
  ["eligible"] = "eligable",
  ["embarrass{}"] = "embarass{,es,ed,ing,ment}",
  ["emergency"] = "emergancy",
  ["emphasize"] = "empasize",
  ["encoding"] = "enconding",
  ["enough"] = "enouhg",
  ["enthusiasm"] = "enthusiam",
  ["environment"] = "{enviornment,enviroment}",
  ["equivalent"] = "equivilent",
  ["especially"] = "especialy",
  ["essential"] = "essentail",
  ["evaluate"] = "evalute",
  ["e{very}{}"] = "{evey,evrey}{,body,day,one,thing,where}",
  ["everybody"] = "{everybdoy,everybdy}",
  ["everyday"] = "{everday,everydy}",
  ["everyone"] = "everyoen",
  ["everything"] = "{everyhting,everythign,everyting,everthing}",
  ["everywhere"] = "everyhwere",
  ["exaggerate"] = "exagerate",
  ["example"] = "exmaple",
  ["exceed"] = "excede",
  ["excellent"] = "excelent",
  ["exception"] = "exeption",
  ["exceptional"] = "exeptional",
  ["executable"] = "excutable",
  ["exercise"] = "excercise",
  ["existence"] = "existance",
  ["experience"] = "experiance",
  ["explanation"] = "explaination",
  ["explicit{,ly}"] = "{explict,explicitlly}",
  ["extremely"] = "extremly",
  ["familiar"] = "familar",
  ["fascinating"] = "facinating",
  ["february"] = "febuary",
  ["field"] = "feild",
  ["final{,ly}"] = "{fianl,finaly}",
  ["first"] = "frist",
  ["following"] = "folowing",
  ["foreign"] = "foriegn",
  ["forty"] = "fourty",
  ["forward"] = "foward",
  ["frequently"] = "frequenly",
  ["friend"] = "freind",
  ["function"] = "funtion",
  ["functionality"] = "functionallity",
  ["fundamental"] = "fundemental",
  ["gauge"] = "guage",
  ["general{,ly}"] = "{genral,generaly}",
  ["genius"] = "genious",
  ["government"] = "goverment",
  ["grammar"] = "grammer",
  ["great"] = "graet",
  ["group"] = "gruop",
  ["guarantee"] = "{garantee,guarentee}",
  ["guard"] = "gaurd",
  ["guidance"] = "guidence",
  ["happen{}"] = "hapen{,s,ed,ing}",
  ["happened"] = "happend",
  ["have"] = "{ahve,haev,hvae}",
  ["height"] = "heigth",
  ["helpful"] = "helpfull",
  ["hierarchy"] = "heirarchy",
  ["history"] = "histroy",
  ["hygiene"] = "hygeine",
  ["identity"] = "identitiy",
  ["immediate{,ly}"] = "{immediat,immediatly}",
  ["immediately"] = "immediatley",
  ["implementation{}"] = "implimentation{,s}",
  ["important"] = "importnat",
  ["incredible"] = "incrediable",
  ["independent"] = "independant",
  ["indispensable"] = "indispensible",
  ["information"] = "informaiton",
  ["influence"] = "influance",
  ["initialize"] = "initialze",
  ["installation"] = "instalation",
  ["instance"] = "instnace",
  ["instead"] = "instaed",
  ["instruction{}"] = "instrucion{,s}",
  ["integrate"] = "intergrate",
  ["intelligence"] = "inteligence",
  ["interesting"] = "intresting",
  ["interface"] = "interafce",
  ["interrupted"] = "interupted",
  ["into"] = "itno",
  ["issue"] = "isuse",
  ["iteration{}"] = "iteraton{,s}",
  ["just"] = "jsut",
  ["keyboard"] = "keybaord",
  ["knowledge"] = "knowlege",
  ["language"] = "langauge",
  ["leisure"] = "liesure",
  ["length"] = "lenght",
  ["liaison"] = "liason",
  ["library"] = "lib{ary,ray}",
  ["license"] = "lisence",
  ["likely"] = "likley",
  ["little"] = "littel",
  ["logical"] = "logcial",
  ["machine"] = "mahcine",
  ["maintenance"] = "maintainance",
  ["mak{e,es,er,ers,ing}"] = "mka{e,es,er,ers,ing}",
  ["manageable"] = "managable",
  ["management"] = "managment",
  ["manually"] = "manualy",
  ["many"] = "mnay",
  ["maximum"] = "maxium",
  ["memory"] = "memroy",
  ["message{}"] = "mesage{,s}",
  ["method{}"] = "mehtod{,s}",
  ["might"] = "migth",
  ["millennium"] = "millenium",
  ["minimum"] = "minumum",
  ["miscellaneous"] = "{miscelaneous,miscellanous}",
  ["mischievous"] = "mischievious",
  ["module{}"] = "moduel{,s}",
  ["more"] = "moer",
  ["most"] = "msot",
  ["much"] = "mcuh",
  ["multiple"] = "mulitple",
  ["natural"] = "natual",
  ["navigation"] = "navagation",
  ["necessar{y,ily}"] = "neccessar{y,ily}",
  ["necessary"] = "necesary",
  ["neighbor"] = "nieghbor",
  ["neither"] = "niether",
  ["normal{,ly}"] = "{norml,normaly}",
  ["noticeable"] = "noticable",
  ["noticeably"] = "noticably",
  ["notification"] = "notifcation",
  ["number"] = "nubmer",
  ["occasion"] = "occassion",
  ["occasionally"] = "ocassionally",
  ["occur{rence,red,rence}"] = "occur{ance,ed,ence}",
  ["official"] = "offical",
  ["often"] = "ofetn",
  ["omission"] = "ommission",
  ["one{}"] = "oen{,self}",
  ["only"] = "onyl",
  ["operator"] = "operater",
  ["opportunit{y,ies}"] = "oportunit{y,ies}",
  ["optional"] = "optinal",
  ["original{,ly}"] = "{orginal,originaly}",
  ["other"] = "otehr",
  ["package{}"] = "pakcage{,s,d}",
  ["parallel"] = "paralell",
  ["parameter"] = "paramater",
  ["particular"] = "particualr",
  ["pattern{}"] = "patern{,s,ed,ing}",
  ["people"] = "peopel",
  ["performance"] = "perfomance",
  ["perhaps"] = "prehaps",
  ["permanent"] = "permanant",
  ["permission"] = "permision",
  ["persistent"] = "persistant",
  ["plac{e,es,ed,ing}"] = "palc{e,es,ed,ing}",
  ["please"] = "plaese",
  ["position"] = "postion",
  ["possession"] = "posession",
  ["possible"] = "posible",
  ["precede"] = "preceed",
  ["precedence"] = "precendence",
  ["preference"] = "preferance",
  ["preferr{ed,ing}"] = "prefer{ed,ing}",
  ["preparation"] = "preperation",
  ["presence"] = "presense",
  ["privilege"] = "priviledge",
  ["probably"] = "probaly",
  ["process{}"] = "proccess{,es,ed,ing}",
  ["production"] = "prodcution",
  ["professional"] = "profesional",
  ["promise{}"] = "promisse{,s,d}",
  ["promising"] = "promissing",
  ["pronunciation"] = "pronounciation",
  ["propert{y,ies}"] = "propret{y,ies}",
  ["proposal"] = "proposel",
  ["publicly"] = "publically",
  ["purpose"] = "purpsoe",
  ["quantit{y,ies}"] = "quanit{y,ies}",
  ["query"] = "qeury",
  ["question"] = "quesiton",
  ["questionnaire"] = "questionaire",
  ["real{,ly}"] = "{rael,realy}",
  ["receive"] = "recieve",
  ["recognize"] = "reconize",
  ["recommend{}"] = "recomend{,s,ed,ing,ation}",
  ["recursive"] = "recusive",
  ["reference"] = "refrence",
  ["referr{ed,ing,al}"] = "refer{ed,ing,al}",
  ["relevant"] = "relevent",
  ["relationship"] = "relashionship",
  ["remember"] = "remeber",
  ["repetition"] = "repeatition",
  ["repository"] = "respository",
  ["request{}"] = "reqeust{,s,ed,ing}",
  ["require"] = "requrie",
  ["required"] = "requried",
  ["resolution"] = "resoluton",
  ["resource{}"] = "resouce{,s}",
  ["response{}"] = "reponse{,s}",
  ["responsibilit{y,ies}"] = "responsabilit{y,ies}",
  ["restaurant"] = "{restaraunt,resturant}",
  ["retrieve"] = "retreive",
  ["return"] = "reutrn",
  ["rhythm"] = "{rhytm,rythym}",
  ["right"] = "rigth",
  ["safety"] = "saftey",
  ["same"] = "smae",
  ["schedule"] = "shedule",
  ["secretary"] = "secretery",
  ["security"] = "securtiy",
  ["sentence"] = "sentance",
  ["separate{}"] = "seperate{,ly}",
  ["sequence"] = "sequnce",
  ["several"] = "severl",
  ["should"] = "shoudl",
  ["significant"] = "signifcant",
  ["similar{}"] = "similiar{,ity,ly}",
  ["sincerely"] = "sincerly",
  ["software"] = "sofware",
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
  ["specific"] = "specifc",
  ["specify"] = "specifiy",
  ["standard"] = "standad",
  ["statement"] = "statment",
  ["still"] = "sitll",
  ["strategy"] = "{starategy,stratgey}",
  ["strength"] = "strenght",
  ["successful{}"] = "succesful{,ly}",
  ["such"] = "suhc",
  ["summary"] = "sumary",
  ["supersede"] = "supercede",
  ["surprise"] = "suprise",
  ["surveillance"] = "surveilance",
  ["synchronous"] = "syncronous",
  ["syntax"] = "sytnax",
  ["system"] = "sytem",
  ["tak{e,es,en,ing}"] = "tka{e,es,en,ing}",
  ["technical"] = "tecnical",
  ["technology"] = "technolgy",
  ["temperature"] = "{tempature,temperture}",
  ["temporary"] = "temperary",
  ["tendency"] = "tendancy",
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
  ["timeout"] = "timout",
  ["together"] = "{togehter,togther}",
  ["token"] = "toekn",
  ["tomorrow"] = "tommorow",
  ["tragedy"] = "tradgedy",
  ["transfer"] = "tranfer",
  ["transferr{ed,ing}"] = "transfer{ed,ing}",
  ["trigger"] = "triger",
  ["truly"] = "truely",
  ["understand"] = "understnad",
  ["unfortunate{,ly}"] = "{unfortuante,unfortunatly}",
  ["unique"] = "unqiue",
  ["unknown"] = "{unknwon,unkown}",
  ["unnecessar{y,ily}"] = "unecessar{y,ily}",
  ["until"] = "untill",
  ["unusual"] = "unusal",
  ["us{e,es,ed,er,ers,ing}"] = "ues{e,es,ed,er,ers,ing}",
  ["useful"] = "usefull",
  ["usually"] = "usualy",
  ["utility"] = "utilty",
  ["vacuum"] = "{vaccum,vacum}",
  ["validate"] = "validte",
  ["value{}"] = "vlaue{,s}",
  ["variable{}"] = "varible{,s}",
  ["various"] = "varous",
  ["vehicle{}"] = "vehical{,s}",
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
  ["whole"] = "wohle",
  ["window"] = "widnow",
  ["with{}"] = "wiht{,in,out}",
  ["wonderful"] = "wonderfull",
  ["work"] = "wrok",
  ["workflow"] = "worklfow",
  ["working"] = "wokring",
  ["world"] = "wrold",
  ["would"] = "woudl",
  ["writ{e,es,er,ers,ing}"] = "wirt{e,es,er,ers,ing}",
  ["writing"] = "writting",
  ["yield"] = "yeild",
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
      assert(
        typo ~= expanded_correction,
        ("Correction maps %q to itself"):format(typo)
      )
      assert(
        expanded[typo] == nil or expanded[typo] == expanded_correction,
        ("Conflicting corrections for %q"):format(typo)
      )
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
