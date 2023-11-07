%% CBOE_sample: from VIX white paper
%% Checked my result == CBOE VIX white paper's result (at least with the sample data)

clear;clc;
addpath('E:\Dropbox\GitHub\ambiguity_premium\main_functions');
% '20171012' 2nd Tue in Oct. : 736980
% TTM: 25D, 32D
date = 736980;
exdate1 = daysadd(date, 25);
exdate2 = daysadd(date, 32);
DTM_BUS1 = daysdif(date, exdate1, 13);
DTM_BUS2 = daysdif(date, exdate2, 13);
CT = '09:46:00';
TTM1 = 0.0683486;
TTM2 = 0.0882686;
r1 = 0.0305 * 1e-2;
r2 = 0.0286 * 1e-2;
isSTD1 = 1;
isSTD2 = 0;

%% T_1st

T_1st = [800	1160.9	1164.4	0	0.1
900	1060.9	1064.5	0	0.1
1000	961	964.5	0	0.1
1050	911	914.5	0	0.1
1100	861	864.6	0	0.05
1125	836	839.6	0	0.05
1150	811	814.6	0	0.05
1175	786.1	789.6	0	0.05
1200	761.1	764.6	0	0.05
1220	741.1	744.6	0	0.1
1225	736.1	739.6	0	0.05
1240	721.1	724.6	0	0.1
1250	711.1	714.6	0	0.05
1260	701.1	704.6	0	0.1
1270	691.1	694.6	0	0.1
1275	686.1	689.6	0	0.1
1280	681.1	684.6	0	0.1
1290	671.1	674.7	0	0.1
1300	661.1	664.7	0.05	0.1
1305	656.1	659.7	0	0.1
1310	651.1	654.7	0	0.1
1315	646.1	649.7	0	0.1
1320	641.2	644.7	0	0.1
1325	636.2	639.7	0.05	0.1
1330	631.2	634.7	0	0.1
1335	626.2	629.7	0	0.15
1340	621.2	624.7	0	0.15
1345	616.2	619.7	0	0.15
1350	611.2	614.7	0.05	0.15
1355	606.2	609.7	0.05	0.35
1360	601.2	604.7	0	0.35
1365	596.2	599.7	0	0.35
1370	591.2	594.7	0.05	0.35
1375	586.2	589.7	0.1	0.15
1380	581.2	584.7	0.1	0.2
1385	576.2	579.7	0.1	0.35
1390	571.2	574.7	0.1	0.35
1395	566.2	569.7	0.1	0.15
1400	561.2	564.8	0.1	0.15
1405	556.2	559.8	0	0.35
1410	551.2	554.8	0.05	0.4
1415	546.2	549.8	0	0.4
1420	541.2	544.8	0.05	0.4
1425	536.3	539.8	0.15	0.2
1430	531.3	534.8	0.05	0.4
1435	526.3	529.8	0.15	0.4
1440	521.3	524.8	0.05	0.3
1445	516.3	519.8	0.05	0.4
1450	511.3	514.8	0.15	0.25
1455	506.3	509.8	0.05	0.45
1460	501.3	504.8	0.05	0.45
1465	496.3	499.8	0.05	0.45
1470	491.3	494.8	0.05	0.45
1475	486.3	489.9	0.15	0.25
1480	481.3	484.9	0.05	0.45
1485	476.3	479.9	0.2	0.5
1490	471.3	474.9	0.05	0.3
1495	466.4	469.9	0.05	0.5
1500	461.4	464.9	0.25	0.4
1505	456.4	459.9	0.3	0.35
1510	451.4	454.9	0.05	0.55
1515	446.4	449.9	0.05	0.55
1520	441.4	445	0.1	0.6
1525	436.4	440	0.3	0.4
1530	431.4	435	0.05	0.6
1535	426.4	430	0.1	0.65
1540	421.4	425	0.1	0.65
1545	416.5	420	0.1	0.65
1550	411.5	415	0.3	0.7
1555	406.5	410.1	0.15	0.7
1560	401.5	405.1	0.15	0.7
1565	396.5	400.1	0.15	0.7
1570	391.5	395.1	0.2	0.75
1575	386.5	390.1	0.35	0.75
1580	381.5	385.1	0.25	0.8
1585	376.6	380.2	0.25	0.8
1590	371.6	375.2	0.25	0.8
1595	366.6	370.2	0.25	0.8
1600	361.6	365.2	0.5	0.85
1605	356.6	360.3	0.3	0.85
1610	351.6	355.3	0.35	0.9
1615	346.7	350.3	0.35	0.9
1620	341.7	345.3	0.35	0.9
1625	336.7	340.4	0.4	0.95
1630	331.7	335.4	0.4	0.95
1635	326.7	330.4	0.45	1
1640	321.8	325.4	0.45	1
1645	316.8	320.5	0.5	1.05
1650	311.8	315.5	0.5	0.85
1655	306.8	310.5	0.55	1.1
1660	301.9	305.6	0.55	1.1
1665	296.9	300.6	0.6	1.15
1670	291.9	295.7	0.6	1.15
1675	287	290.7	0.65	1.2
1680	282	285.7	0.7	1.25
1685	277	280.8	0.75	1.3
1690	272.1	275.8	0.75	1.3
1695	267.1	270.9	0.8	1.35
1700	262.1	265.9	0.85	1.4
1705	257.2	261	0.85	1.4
1710	252.2	256	0.9	1.45
1715	247.3	251.1	0.95	1.5
1720	242.3	246.1	1	1.55
1725	237.4	241.2	1.05	1.6
1730	232.4	236.3	1.1	1.65
1735	227.5	231.3	1.15	1.7
1740	222.5	226.4	1.2	1.75
1745	217.6	221.5	1.25	1.85
1750	212.6	216.6	1.3	1.9
1755	207.7	211.6	1.4	1.95
1760	202.8	206.7	1.45	2.05
1765	197.8	201.8	1.5	2.15
1770	192.9	196.9	1.6	2.2
1775	188	192	1.65	2.35
1780	183.1	187.1	1.75	2.4
1785	178.2	182.2	1.85	2.5
1790	173.3	177.3	1.9	2.6
1795	168.4	172.4	2	2.75
1800	163.5	167.5	2.15	2.9
1805	158.6	162.6	2.25	3
1810	153.8	157.8	2.35	3.2
1815	148.9	152.9	2.5	3.4
1820	144.1	148.1	2.65	3.5
1825	139.2	143.3	3	3.6
1830	134.4	138.4	3	3.9
1835	129.6	133.6	3.2	4.1
1840	124.8	128.8	3.4	4.4
1845	120.1	124.1	3.6	4.6
1850	115.4	119.3	3.8	4.9
1855	110.6	114.6	4.1	5.2
1860	105.9	109.9	4.4	5.5
1865	101.3	105.2	4.7	5.8
1870	96.6	100.5	5	6.2
1875	92	95.9	5.4	6.6
1880	87.4	91.3	5.8	7
1885	82.9	86.7	6.2	7.5
1890	78.4	82.2	6.7	8
1895	74	77.7	7.2	8.6
1900	69.6	73.2	7.8	8.8
1905	66	68.5	8.5	9.5
1910	61.6	64.1	9.1	10.2
1915	57.4	59.8	9.9	11.3
1920	53.3	55.6	10.7	12.1
1925	49.1	51.2	11.6	12.6
1930	45.2	47.3	12.5	14
1935	41.2	43.4	13.6	14.7
1940	37.4	39.5	14.7	15.8
1945	33.7	35.7	15.9	17.2
1950	30.1	32.1	17.7	18.8
1955	26.7	28.5	19	20.5
1960	23.4	25.1	20.6	22
1965	20.3	21.8	22.3	24
1970	17.4	18.8	24.3	25.8
1975 14.60 15.90 26.50 28.10
1980 12.20 13.30 28.90 30.60
1985 9.90 11.00 31.40 33.20
1990 7.90 9.00 34.30 36.50
1995 6.20 7.10 37.40 39.70
2000 4.70 5.20 40.70 43.20
2005 3.40 4.20 44.00 47.70
2010 2.65 3.10 48.00 51.40
2015 1.75 2.30 52.20 56.00
2020 1.20 1.70 56.60 60.40
2025 1.00 1.25 61.20 65.00
2030 0.45 1.00 65.90 69.70
2035 0.25 0.80 70.70 74.40
2040 0.35 0.65 75.60 79.30
2045 0.20 0.60 80.50 84.10
2050 0.20 0.30 85.40 89.00
2055 0.15 0.50 90.40 94.00
2060 0.15 0.30 95.30 98.90
2065 0.15 0.20 100.30 103.90
2070 0.10 0.20 105.30 108.90
2075 0.10 0.20 110.30 113.80
2080 0.05 0.45 115.30 118.80
2085 0.05 0.40 120.30 123.80
2090 0.05 0.15 125.30 128.80
2095 0.05 0.35 130.30 133.80
2100 0.05 0.15 135.30 138.80
2120 0.00 0.15 155.30 158.80
2125 0.05 0.15 160.30 163.80
2150 0.00 0.10 185.20 188.80
2175 0.00 0.05 210.20 213.70
2200 0.00 0.05 235.20 238.70
2225 0.05 0.10 260.20 263.70
2250 0.00 0.05 285.20 288.70
];

n1 = size(T_1st, 1);
CallData_1st = array2table([repmat([date, exdate1, r1, TTM1, DTM_BUS1, isSTD1], n1, 1), T_1st(:, 1:3)]);
PutData_1st = array2table([repmat([date, exdate1, r1, TTM1, DTM_BUS1, isSTD1], n1, 1), T_1st(:, [1,4,5])]);
CallData_1st.Properties.VariableNames = {'date', 'exdate', 'r', 'TTM', 'DTM_BUS', 'isSTD', 'Kc', 'C_bid', 'C_ask'};
PutData_1st.Properties.VariableNames = {'date', 'exdate', 'r', 'TTM', 'DTM_BUS', 'isSTD', 'Kp', 'P_bid', 'P_ask'};
clear T_1st;

%% T_2nd
T_2nd = [1225	735.9	738.8	0	0.1
1250	710.8	713.8	0	0.1
1275	686	688.7	0.05	0.1
1300	660.9	663.8	0	0.1
1325	635.9	638.6	0.1	0.2
1350	610.9	613.6	0.1	0.2
1375	585.9	588.7	0.1	0.25
1400	561	563.7	0.15	0.25
1425	536	538.8	0.2	0.3
1450	511.1	513.8	0.25	0.35
1475	486.1	488.9	0.3	0.4
1500	461.2	464	0.35	0.45
1510	451.3	454	0.35	0.5
1520	441.3	444	0.4	0.5
1525	436.3	439.1	0.4	0.55
1530	431.3	434.1	0.45	0.55
1540	421.4	424.1	0.45	0.6
1550	411.4	414.2	0.5	0.6
1555	406.4	409.2	0.5	0.65
1560	401.4	404.2	0.55	0.65
1565	396.5	399.2	0.55	0.7
1570	391.2	394	0.6	0.7
1575	386.5	389.3	0.6	0.75
1580	381.5	384.3	0.6	0.75
1585	376.6	379.3	0.65	0.75
1590	371.3	374.1	0.65	0.8
1595	366.6	369.4	0.7	0.8
1600	361.6	364.4	0.7	0.85
1605	356.7	359.4	0.75	0.85
1610	351.7	354.5	0.75	0.9
1615	346.7	349.5	0.8	0.9
1620	341.8	344.5	0.8	0.95
1625	336.8	339.5	0.85	0.95
1630	331.8	334.6	0.9	1
1635	326.9	329.6	0.9	1.05
1640	321.9	324.7	0.95	1.05
1645	316.9	319.7	0.95	1.1
1650	312	314.7	1	1.15
1655	307	309.8	1.05	1.15
1660	302.1	304.8	1.1	1.2
1665	297.1	299.9	1.15	1.25
1670	292.2	294.9	1.15	1.3
1675	287.2	289.9	1.2	1.35
1680	282.3	285	1.25	1.4
1685	277.3	280.1	1.3	1.45
1690	272.4	275.1	1.35	1.5
1695	267.4	270.2	1.4	1.55
1700	262.5	265.2	1.45	1.6
1705	257.5	260.3	1.5	1.7
1710	252.6	255.3	1.6	1.75
1715	247.7	250.4	1.65	1.8
1720	242.7	245.5	1.7	1.9
1725	237.8	240.6	1.75	1.95
1730	232.9	235.6	1.85	2
1735	228	230.7	1.9	2.1
1740	223.4	225.3	2	2.2
1745	218.5	220.4	2.1	2.25
1750	213.6	215.5	2.2	2.35
1755	208.7	210.6	2.3	2.45
1760	203.8	205.7	2.4	2.55
1765	198.9	200.8	2.5	2.65
1770	194	195.9	2.65	2.8
1775	189.2	191.1	2.75	2.9
1780	184.3	185.8	2.9	3.1
1785	179.4	180.9	3	3.2
1790	174.6	176.1	3.1	3.4
1795	169.7	171.2	3.3	3.6
1800	164.9	166.4	3.5	3.7
1805	160.1	161.6	3.7	3.9
1810	155.3	156.7	3.8	4.1
1815	150.5	152	4.1	4.3
1820	145.7	147.2	4.3	4.5
1825	140.9	142.4	4.5	4.8
1830	136.2	137.7	4.8	5
1835	131.5	132.9	5	5.3
1840	126.8	128.2	5.3	5.6
1845	122.1	123.5	5.6	5.9
1850	117.4	118.8	5.9	6.2
1855	112.8	114.2	6.3	6.6
1860	108.2	109.6	6.6	6.9
1865	103.6	105	7	7.3
1870	99	100.4	7.5	7.8
1875	94.5	95.9	8	8.3
1880	90	91.4	8.4	8.8
1885	85.5	86.9	9	9.4
1890	81.1	82.5	9.5	10
1895	76.8	78.1	10.2	10.6
1900	72.4	73.7	10.9	11.3
1905	68.2	69.4	11.6	12
1910	64	65.2	12.4	12.8
1915	59.8	61.1	13.2	13.7
1920	55.7	57	14.2	14.6
1925	51.7	53	15.2	15.6
1930	47.8	49.1	16.2	16.6
1935	44.6	45.1	17.4	17.8
1940	40.8	41.3	18.6	19
1945	37.2	37.7	20	20.4
1950	33.7	34.4	21.4	21.8
1955	30.3	30.9	23	23.4
1960	27	27.6	24.7	25.1
1965	23.8	24.5	26.5	27.3
1970	20.8	21.4	28.5	29.4
1975	18	18.6	30.5	31.6
1980	15.5	15.9	33	34
1985	13.1	13.5	35.5	36.6
1990	10.9	11.3	38.4	39.5
1995	9	9.3	41.3	42.5
2000	7.2	7.6	44.5	45.8
2005	5.7	6	48.1	49.3
2010	4.5	4.8	51.7	53
2015	3.4	3.7	55.8	57
2020	2.6	2.8	59.9	61.7
2025	1.95	2.15	64.1	66.1
2030	1.45	1.65	68.6	70.6
2035	1.05	1.25	73.3	75.2
2040	0.8	0.95	78	80
2045	0.6	0.75	82	84.8
2050	0.5	0.65	86.9	89.6
2060	0.3	0.4	96.6	99.4
2070	0.2	0.3	106.7	109.5
2075	0.15	0.25	111.7	114.5
2100	0.1	0.2	136.3	139.1
2125	0.05	0.15	161.5	164.3
2150	0.05	0.15	186.3	189
2175	0	0.1	211.3	214
2200	0.05	0.1	236.3	239
2225	0	0.1	261.3	264
2250	0	0.1	286.3	289];

n2 = size(T_2nd, 1);
CallData_2nd = array2table([repmat([date, exdate1, r2, TTM2, DTM_BUS2, isSTD2], n2, 1), T_2nd(:, 1:3)]);
PutData_2nd = array2table([repmat([date, exdate2, r2, TTM2, DTM_BUS2, isSTD2], n2, 1), T_2nd(:, [1,4,5])]);
CallData_2nd.Properties.VariableNames = {'date', 'exdate', 'r', 'TTM', 'DTM_BUS', 'isSTD', 'Kc', 'C_bid', 'C_ask'};
PutData_2nd.Properties.VariableNames = {'date', 'exdate', 'r', 'TTM', 'DTM_BUS', 'isSTD', 'Kp', 'P_bid', 'P_ask'};
clear T_2nd;
%%
T_1st_ = VIXrawVolCurve(PutData_1st, CallData_1st);
T_2nd_ = VIXrawVolCurve(PutData_2nd, CallData_2nd);
VarIX_1st_ = VIXConstruction(T_1st_);
VarIX_2nd_ = VIXConstruction(T_2nd_);
VIX = VIX_30Davg(CT, VarIX_1st_, VarIX_2nd_);

rmpath('E:\Dropbox\GitHub\ambiguity_premium\main_functions');