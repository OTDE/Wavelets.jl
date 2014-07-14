module POfilters
export WaveletFilter, WaveletType, POfilter, scale

abstract WaveletType
abstract WaveletFilter <: WaveletType

# Periodic, Orthogonal
immutable POfilter <: WaveletFilter
    qmf::Vector{Float64}    # the quadrature mirror filter
    name::String            # filter short name
    n::Integer              # filter length
    function POfilter(qmf::Vector,name::String)
        new(qmf,name,length(qmf))
    end
    function POfilter(qmf::Vector,name::String,n::Integer)
        length(qmf) != n && error("n does not match filter length")
        new(qmf,name,length(qmf))
    end
end
# e.g. "coif18"
function POfilter(name::String)
    qmf = get(FILTERS, name, nothing)
    qmf == nothing && error("filter not found")
    # make sure it is normalized in l2-norm!!!
    return POfilter(qmf./norm(qmf),name)
end
# e.g. "Coiflet", 18
function POfilter(class::String, n::Integer)
    namebase = get(FILTERC2N, class, nothing)
    namebase == nothing && error("filter not found")
    return POfilter(string(namebase,n))
end
# scale filter by scalar
function scale(f::POfilter, a::Number)
    return POfilter(f.qmf.*a, f.name)
end

# class => namebase
FILTERC2N=(ASCIIString=>ASCIIString)[
"Coiflet" => "coif",
"Daubechies" => "db",
"Symmlet" => "sym",
"Battle" => "batt"
]

# the number at end of a filter name is the 
# number of vanishing moments of the mother wavelet function
# name => qmf
FILTERS=(ASCIIString=>Vector{Float64})[
# Haar filter, same as db1
"haar" =>
[0.7071067811865475,0.7071067811865475]
,
# Daubechies filters
"db1" =>
[0.7071067811865475,0.7071067811865475]
,
"db2" =>
[0.4829629131445341,0.8365163037378077,0.2241438680420134,-0.1294095225512603]
,
"db3" =>
[0.3326705529500827,0.8068915093110928,0.4598775021184915,-0.1350110200102546,-0.0854412738820267,0.0352262918857096]
,
"db4" =>
[0.2303778133074431,0.7148465705484058,0.6308807679358788,-0.0279837694166834,-0.1870348117179132,0.0308413818353661,0.0328830116666778,-0.0105974017850021]
,
"db5" =>
[0.1601023979741930,0.6038292697971898,0.7243085284377729,0.1384281459013204,-0.2422948870663824,-0.0322448695846381,0.0775714938400459,-0.0062414902127983,-0.0125807519990820,0.0033357252854738]
,
"db6" =>
[0.1115407433501094,0.4946238903984530,0.7511339080210954,0.3152503517091980,-0.2262646939654399,-0.1297668675672624,0.0975016055873224,0.0275228655303053,-0.0315820393174862,0.0005538422011614,0.0047772575109455,-0.0010773010853085]
,
"db7" =>
[0.0778520540850081,0.3965393194819136,0.7291320908462368,0.4697822874052154,-0.1439060039285293,-0.2240361849938538,0.0713092192668312,0.0806126091510820,-0.0380299369350125,-0.0165745416306664,0.0125509985560993,0.0004295779729214,-0.0018016407040474,0.0003537137999745]
,
"db8" =>
[0.0544158422431049,0.3128715909143031,0.6756307362972904,0.5853546836541907,-0.0158291052563816,-0.2840155429615702,0.0004724845739124,0.1287474266204837,-0.0173693010018083,-0.0440882539307952,0.0139810279173995,0.0087460940474061,-0.0048703529934518,-0.0003917403733770,0.0006754494064506,-0.0001174767841248]
,
"db9" =>
[0.0380779473638791,0.2438346746125939,0.6048231236901156,0.6572880780512955,0.1331973858249927,-0.2932737832791761,-0.0968407832229524,0.1485407493381306,0.0307256814793395,-0.0676328290613302,0.0002509471148340,0.0223616621236805,-0.0047232047577520,-0.0042815036824636,0.0018476468830564,0.0002303857635232,-0.0002519631889427,0.0000393473203163]
,
"db10" =>
[0.0266700579005546,0.1881768000776863,0.5272011889317202,0.6884590394536250,0.2811723436606485,-0.2498464243272283,-0.1959462743773399,0.1273693403357890,0.0930573646035802,-0.0713941471663697,-0.0294575368218480,0.0332126740593703,0.0036065535669880,-0.0107331754833036,0.0013953517470692,0.0019924052951930,-0.0006858566949566,-0.0001164668551285,0.0000935886703202,-0.0000132642028945]
,
# Coiflet filters
"coif2" =>
[-0.0156557285289848,-0.0727326213410511,0.3848648565381134,0.8525720416423900,0.3378976709511590,-0.0727322757411889]
,
"coif4" =>
[-0.0007205494453679,-0.0018232088707116,0.0056114348194211,0.0236801719464464,-0.0594344186467388,-0.0764885990786692,0.4170051844236707,0.8127236354493977,0.3861100668229939,-0.0673725547222826,-0.0414649367819558,0.0163873364635998]
,
"coif6" =>
[-0.0000345997728362,-0.0000709833031381,0.0004662169601129,0.0011175187708906,-0.0025745176887502,-0.0090079761366615,0.0158805448636158,0.0345550275730615,-0.0823019271068856,-0.0717998216193117,0.4284834763776168,0.7937772226256169,0.4051769024096150,-0.0611233900026726,-0.0657719112818552,0.0234526961418362,0.0077825964273254,-0.0037935128644910]
,
"coif8" =>
[-0.0000017849850031,-0.0000032596802369,0.0000312298758654,0.0000623390344610,-0.0002599745524878,-0.0005890207562444,0.0012665619292991,0.0037514361572790,-0.0056582866866115,-0.0152117315279485,0.0250822618448678,0.0393344271233433,-0.0962204420340021,-0.0666274742634348,0.4343860564915321,0.7822389309206135,0.4153084070304910,-0.0560773133167630,-0.0812666996808907,0.0266823001560570,0.0160689439647787,-0.0073461663276432,-0.0016294920126020,0.0008923136685824]
,
"coif10" =>
[-0.0000000951765727,-0.0000001674428858,0.0000020637618516,0.0000037346551755,-0.0000213150268122,-0.0000413404322768,0.0001405411497166,0.0003022595818445,-0.0006381313431115,-0.0016628637021860,0.0024333732129107,0.0067641854487565,-0.0091642311634348,-0.0197617789446276,0.0326835742705106,0.0412892087544753,-0.1055742087143175,-0.0620359639693546,0.4379916262173834,0.7742896037334738,0.4215662067346898,-0.0520431631816557,-0.0919200105692549,0.0281680289738655,0.0234081567882734,-0.0101311175209033,-0.0041593587818186,0.0021782363583355,0.0003585896879330,-0.0002120808398259]
,
# Symmlet filter
"sym4" =>
[-0.1071489014180000,-0.0419109651250000,0.7037390686560000,1.1366582434079999,0.4212345342040000,-0.1403176241790000,-0.0178247014420000,0.0455703458960000]
,
"sym5" =>
[0.0386547959550000,0.0417468644220000,-0.0553441861170000,0.2819906968540000,1.0230529668940000,0.8965816483800000,0.0234789231360000,-0.2479513626130000,-0.0298424998690000,0.0276321529580000]
,
"sym6" =>
[0.0217847003270000,0.0049366123720000,-0.1668632154120000,-0.0683231215870000,0.6944579729580000,1.1138927839260000,0.4779043713330000,-0.1027249698620000,-0.0297837512990000,0.0632505626600000,0.0024999220930000,-0.0110318675090000]
,
"sym7" =>
[0.0037926585340000,-0.0014812259150000,-0.0178704316510000,0.0431554525820000,0.0960147679360000,-0.0700782912220000,0.0246656594890000,0.7581626019640000,1.0857827098140000,0.4081839397250000,-0.1980567068070000,-0.1524638718960000,0.0056713426860000,0.0145213947620000]
,
"sym8" =>
[0.0026727933930000,-0.0004283943000000,-0.0211456865280000,0.0053863887540000,0.0694904659110000,-0.0384935212630000,-0.0734625087610000,0.5153986703740000,1.0991066305370001,0.6807453471900000,-0.0866536154060000,-0.2026486552860000,0.0107586117510000,0.0448236230420000,-0.0007666908960000,-0.0047834585120000]
,
"sym9" =>
[0.0015124873090000,-0.0006691415090000,-0.0145155785530000,0.0125288962420000,0.0877912515540000,-0.0257864459300000,-0.2708937835030000,0.0498828309590000,0.8730484073490000,1.0152597908320000,0.3376589236020000,-0.0771721610970000,0.0008251409290000,0.0427444336020000,-0.0163033512260000,-0.0187693968360000,0.0008765025390000,0.0019811937360000]
,
"sym10" =>
[0.0010891704470000,0.0001352450200000,-0.0122206426300000,-0.0020723639230000,0.0649509245790000,0.0164188694260000,-0.2255589722340000,-0.1002402150310000,0.6670713381540000,1.0882515305000000,0.5428130112130000,-0.0502565400920000,-0.0452407722180000,0.0707035675500000,0.0081528167990000,-0.0287862319260000,-0.0011375353140000,0.0064957283750000,0.0000806612040000,-0.0006495898960000]
,
# Battle-Lemarie filter
"batt2" =>
[-0.0000867523000000,-0.0001586010000000,0.0003617810000000,0.0006529220000000,-0.0015570100000000,-0.0027458800000000,0.0070644200000000,0.0120030000000000,-0.0367309000000000,-0.0488618000000000,0.2809310000000000,0.5781630000000000,0.2809310000000000,-0.0488618000000000,-0.0367309000000000,0.0120030000000000,0.0070644200000000,-0.0027458800000000,-0.0015570100000000,0.0006529220000000,0.0003617810000000,-0.0001586010000000,-0.0000867523000000]
,
"batt4" =>
[0.0001033070000000,-0.0001642640000000,-0.0002018180000000,0.0003267490000000,0.0003959460000000,-0.0006556200000000,-0.0007804680000000,0.0013308600000000,0.0015462400000000,-0.0027452900000000,-0.0030786300000000,0.0057993200000000,0.0061414300000000,-0.0127154000000000,-0.0121455000000000,0.0297468000000000,0.0226846000000000,-0.0778079000000000,-0.0354980000000000,0.3068300000000000,0.5417360000000000,0.3068300000000000,-0.0354980000000000,-0.0778079000000000,0.0226846000000000,0.0297468000000000,-0.0121455000000000,-0.0127154000000000,0.0061414300000000,0.0057993200000000,-0.0030786300000000,-0.0027452900000000,0.0015462400000000,0.0013308600000000,-0.0007804680000000,-0.0006556200000000,0.0003959460000000,0.0003267490000000,-0.0002018180000000,-0.0001642640000000,0.0001033070000000]
,
"batt6" =>
[0.0001011130000000,0.0001107090000000,-0.0001591680000000,-0.0001726850000000,0.0002514190000000,0.0002698420000000,-0.0003987590000000,-0.0004224850000000,0.0006355630000000,0.0006628360000000,-0.0010191200000000,-0.0010420700000000,0.0016465900000000,0.0016413200000000,-0.0026864600000000,-0.0025881600000000,0.0044400200000000,0.0040788200000000,-0.0074684800000000,-0.0063988600000000,0.0128754000000000,0.0099063500000000,-0.0229951000000000,-0.0148537000000000,0.0433544000000000,0.0208414000000000,-0.0914068000000000,-0.0261771000000000,0.3128690000000000,0.5283740000000000,0.3128690000000000,-0.0261771000000000,-0.0914068000000000,0.0208414000000000,0.0433544000000000,-0.0148537000000000,-0.0229951000000000,0.0099063500000000,0.0128754000000000,-0.0063988600000000,-0.0074684800000000,0.0040788200000000,0.0044400200000000,-0.0025881600000000,-0.0026864600000000,0.0016413200000000,0.0016465900000000,-0.0010420700000000,-0.0010191200000000,0.0006628360000000,0.0006355630000000,-0.0004224850000000,-0.0003987590000000,0.0002698420000000,0.0002514190000000,-0.0001726850000000,-0.0001591680000000,0.0001107090000000,0.0001011130000000]
,
# Beylkin filter
"beyl" =>
[0.0993057653740000,0.4242153608130000,0.6998252140570000,0.4497182511490000,-0.1109275983480000,-0.2644972314460000,0.0269003088040000,0.1555387318770000,-0.0175207462670000,-0.0885436306230000,0.0196798660440000,0.0429163872740000,-0.0174604086960000,-0.0143658079690000,0.0100404118450000,0.0014842347820000,-0.0027360316260000,0.0006404853290000]
,
# Vaidyanathan filter
"vaid" =>
[-0.0000629061180000,0.0003436319050000,-0.0004539566200000,-0.0009448971360000,0.0028438345470000,0.0007081375040000,-0.0088391034090000,0.0031538470560000,0.0196872150100000,-0.0148534480050000,-0.0354703986070000,0.0387426192930000,0.0558925236910000,-0.0777097509020000,-0.0839288843660000,0.1319716614170000,0.1350842271290000,-0.1944504717660000,-0.2634948024880000,0.2016121617750000,0.6356010598720000,0.5727977932110000,0.2501841295050000,0.0457993341110000]


]






end


